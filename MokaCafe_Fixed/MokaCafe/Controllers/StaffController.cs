using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MokaCafe.Data;
using OfficeOpenXml;
using MokaCafe.Models;
using System.Security.Claims;
namespace MokaCafe.Controllers
{
    [Authorize(Roles = "staff,admin")]
    public class StaffController : Controller
    {
        private readonly AppDbContext _db;
        public StaffController(AppDbContext db) => _db = db;

        public async Task<IActionResult> Index(DateTime? tuNgay, DateTime? denNgay)
        {
            // Nếu không chọn ngày, mặc định lấy 7 ngày gần nhất
            DateTime start = tuNgay ?? DateTime.Today.AddDays(-6);
            DateTime end = denNgay ?? DateTime.Today;

            ViewBag.TuNgay = start.ToString("yyyy-MM-dd");
            ViewBag.DenNgay = end.ToString("yyyy-MM-dd");

            // Lọc dữ liệu đơn hàng trong khoảng thời gian này
            var donHangs = await _db.DonHangs
                .Include(d => d.ChiTietDonHangs).ThenInclude(c => c.MonAn)
                .Where(d => d.NgayDat.Date >= start.Date && d.NgayDat.Date <= end.Date && d.TrangThai == "Đã giao")
                .ToListAsync();

            // Tính toán dữ liệu cho biểu đồ trong khoảng thời gian đã chọn
            // Thay vì cố định 7 ngày, hãy chia khoảng thời gian lọc ra làm các mốc thời gian
            // Tính toán dữ liệu cho biểu đồ
            var doanhThuTheoNgay = donHangs
                .GroupBy(d => d.NgayDat.Date)
                .OrderBy(g => g.Key)
                .Select(g => new {
                    Ngay = g.Key.ToString("dd/MM"),
                    DoanhThu = g.Sum(d => d.TongTien)
                })
                .ToList();

            var vm = new StaffDashboardVM
            {
                DoanhThuHomNay = donHangs.Sum(d => d.TongTien),
                TongDonHomNay = donHangs.Count,

                // Gán dữ liệu: đảm bảo chuyển đổi kiểu dữ liệu trùng khớp
                Nhan7Ngay = doanhThuTheoNgay.Select(x => x.Ngay).ToList(),
                DoanhThu7Ngay = doanhThuTheoNgay.Select(x => x.DoanhThu).ToList() // Bây giờ là List<decimal>
            };

            return View(vm);
        }

        public async Task<IActionResult> DonHang()
        {
            // Lấy đơn Online chờ xác nhận + Đơn tại quầy (nếu bạn muốn hiển thị)
            var cho = await _db.DonHangs
                .Include(d => d.KhachHang)
                .Include(d => d.ChiTietDonHangs).ThenInclude(c => c.MonAn)
                // Bỏ điều kiện LoaiDon == "Online" để thấy cả đơn tại quầy
                .Where(d => d.TrangThai == "Chờ xác nhận")
                .ToListAsync();

            ViewBag.LichSu = await _db.DonHangs
                .Include(d => d.KhachHang)
                .Include(d => d.ChiTietDonHangs).ThenInclude(c => c.MonAn)
                // Chỉ lấy những cái đã hoàn tất hoặc hủy
                .Where(d => d.TrangThai != "Chờ xác nhận")
                .OrderByDescending(d => d.NgayDat)
                .ToListAsync();

            return View(cho);
        }

        public async Task<IActionResult> LichSuTatCa(string search)
        {
            // SỬA Ở ĐÂY: Thêm .Include(d => d.KhachHang) và .Include(d => d.ChiTietDonHangs)
            var query = _db.DonHangs
                .AsNoTracking()
                .Include(d => d.KhachHang)
                .Include(d => d.ChiTietDonHangs)
                    .ThenInclude(c => c.MonAn)
                .Where(d => d.TrangThai != "Chờ xác nhận")
                .OrderByDescending(d => d.NgayDat)
                .AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(d => (d.KhachHang != null && d.KhachHang.HoTen.Contains(search))
                                      || d.SoDienThoaiGiao.Contains(search));
                ViewBag.Search = search;
            }

            return View(await query.ToListAsync());
        }

        // Các hàm khác giữ nguyên...
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> XacNhanDon(int id)
        {
            var don = await _db.DonHangs.FindAsync(id);
            if (don != null)
            {
                don.TrangThai = "Đang chế biến";
                don.NgayCapNhat = DateTime.Now;
                _db.CheBiens.Add(new CheBien { MaDonHang = id, MaNhanVien = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value), TrangThai = "Đang làm", ThoiGianBatDau = DateTime.Now });
                await _db.SaveChangesAsync();
            }
            TempData["ThanhCong"] = "Đã xác nhận đơn!";
            return RedirectToAction("DonHang");
        }

        public async Task<IActionResult> ThucDon(string? cat) { var dm = await _db.DanhMucs.OrderBy(d => d.ThuTu).ToListAsync(); var q = _db.MonAns.Include(m => m.DanhMuc).AsQueryable(); if (!string.IsNullOrEmpty(cat) && cat != "all") q = q.Where(m => m.DanhMuc!.MaDanhMucJS == cat); ViewBag.DanhMucs = dm; ViewBag.CatHienTai = cat ?? "all"; return View(await q.ToListAsync()); }
        public async Task<IActionResult> CheBien() { var o = await _db.DonHangs.Include(d => d.KhachHang).Include(d => d.ChiTietDonHangs).ThenInclude(c => c.MonAn).Include(d => d.CheBien).Where(d => d.TrangThai == "Đang chế biến").OrderBy(d => d.NgayDat).ToListAsync(); return View(o); }
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> HoanThanhCheBien(int id)
        {
            var don = await _db.DonHangs.Include(d => d.CheBien).FirstOrDefaultAsync(d => d.MaDonHang == id);
            if (don != null) { don.TrangThai = don.LoaiDon == "Online" ? "Đang giao" : "Đã giao"; don.NgayCapNhat = DateTime.Now; if (don.CheBien != null) { don.CheBien.TrangThai = "Hoàn thành"; don.CheBien.ThoiGianHoanThanh = DateTime.Now; } await _db.SaveChangesAsync(); }
            TempData["ThanhCong"] = "Đã hoàn thành chế biến!"; return RedirectToAction("CheBien");
        }
        public async Task<IActionResult> KhoHang() { return View(await _db.NguyenLieus.OrderBy(n => n.TenNguyenLieu).ToListAsync()); }
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> NhapKho(int maNguyenLieu, decimal soLuong, string lyDo)
        {
            var item = await _db.NguyenLieus.FindAsync(maNguyenLieu);
            if (item != null) { var tr = item.SoLuongHienTai; item.SoLuongHienTai += soLuong; item.NgayCapNhat = DateTime.Now; var pct = item.SoLuongToiDa > 0 ? (double)item.SoLuongHienTai / (double)item.SoLuongToiDa * 100 : 0; item.TrangThai = pct < 30 ? "Sắp hết" : pct < 60 ? "Trung bình" : "Đủ hàng"; _db.NhatKyKhos.Add(new NhatKyKho { MaNguyenLieu = maNguyenLieu, MaNhanVien = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value), LoaiGiaoDich = "Nhập", SoLuongTruoc = tr, SoLuongThayDoi = soLuong, SoLuongSau = item.SoLuongHienTai, LyDo = lyDo }); await _db.SaveChangesAsync(); }
            TempData["ThanhCong"] = "Đã nhập kho thành công!"; return RedirectToAction("KhoHang");
        }
        public async Task<IActionResult> CaiDat() { return View(await _db.CauHinhHeThongs.FirstOrDefaultAsync() ?? new CauHinhHeThong()); }
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> HuyDon(int id, string lyDoHuy)
        {
            var don = await _db.DonHangs.FindAsync(id);
            if (don != null && don.TrangThai == "Chờ xác nhận")
            {
                don.TrangThai = "Đã hủy";
                don.GhiChu = $"[Hủy bởi NV]: {lyDoHuy}";
                don.NgayCapNhat = DateTime.Now;
                await _db.SaveChangesAsync();
                TempData["ThanhCong"] = "Đã hủy đơn hàng thành công!";
            }
            return RedirectToAction("DonHang");
        }
        public async Task<IActionResult> TaoDon()
        {
            var monAn = await _db.MonAns.Where(m => m.TrangThai == "Còn hàng").ToListAsync();
            return View(monAn);
        }
        [HttpPost]
        public async Task<IActionResult> LuuDonOffline([FromBody] DonHangOfflineVM model)
        {
            var don = new DonHang
            {
                MaDonHangHienThi = "#OFF" + DateTime.Now.ToString("yyMMddHHmmss"),
                HoTenNguoiNhan = model.HoTen,
                SoDienThoaiGiao = model.SoDienThoai,
                TongTien = model.TongTien,
                TrangThai = "Đã giao", // Đơn tại quầy coi như hoàn tất ngay
                NgayDat = DateTime.Now,
                LoaiDon = "Tại quầy"
            };

            _db.DonHangs.Add(don);
            await _db.SaveChangesAsync();

            foreach (var item in model.ChiTiet)
            {
                _db.ChiTietDonHangs.Add(new ChiTietDonHang
                {
                    MaDonHang = don.MaDonHang,
                    MaMon = item.MaMon,
                    SoLuong = 1, // Bạn có thể sửa logic để tăng số lượng nếu chọn nhiều lần
                    DonGia = item.GiaBan
                });
            }

            await _db.SaveChangesAsync();
            return Json(new { ok = true });
        }
        [Authorize(Roles = "staff,admin")]
        public async Task<IActionResult> InHoaDon(int id)
        {
            var don = await _db.DonHangs
                .Include(d => d.KhachHang)
                .Include(d => d.ChiTietDonHangs).ThenInclude(c => c.MonAn)
                .FirstOrDefaultAsync(d => d.MaDonHang == id);

            if (don == null) return NotFound();
            return View(don);
        }
        public async Task<IActionResult> BaoCao(DateTime? tuNgay, DateTime? denNgay)
        {
            // Đặt mặc định là 7 ngày gần nhất nếu người dùng không chọn ngày
            tuNgay ??= DateTime.Today.AddDays(-7);
            denNgay ??= DateTime.Today;

            // Lưu lại giá trị ngày để hiển thị lại trên giao diện
            ViewBag.TuNgay = tuNgay?.ToString("yyyy-MM-dd");
            ViewBag.DenNgay = denNgay?.ToString("yyyy-MM-dd");

            // Lấy danh sách đơn hàng đã giao trong khoảng thời gian
            var donHangsDaGiao = await _db.DonHangs
                .Where(d => d.TrangThai == "Đã giao" &&
                            d.NgayDat.Date >= tuNgay.Value.Date &&
                            d.NgayDat.Date <= denNgay.Value.Date)
                .ToListAsync();

            // Tính toán các thông số
            decimal tongDoanhThu = donHangsDaGiao.Sum(d => d.TongTien);
            int tongDon = donHangsDaGiao.Count;
            decimal trungBinhDon = tongDon > 0 ? tongDoanhThu / tongDon : 0;

            // Truyền dữ liệu sang View
            ViewBag.DoanhThuBaoCao = tongDoanhThu;
            ViewBag.TongDon = tongDon;
            ViewBag.TrungBinhDon = trungBinhDon;

            return View(donHangsDaGiao);
        }
        public async Task<IActionResult> XuatBaoCao(DateTime tuNgay, DateTime denNgay)
        {
            var donHangs = await _db.DonHangs
                .Where(d => d.NgayDat.Date >= tuNgay.Date && d.NgayDat.Date <= denNgay.Date && d.TrangThai == "Đã giao")
                .ToListAsync();

            using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("BaoCaoDoanhThu");

                // --- ĐÂY LÀ ĐOẠN CODE BỊ THIẾU ---
                if (donHangs != null && donHangs.Any())
                {
                    // Tự động đổ dữ liệu từ danh sách donHangs vào trang tính
                    // 'true' ở đây có nghĩa là bạn muốn nó tự tạo dòng tiêu đề (Header)
                    worksheet.Cells["A1"].LoadFromCollection(donHangs, true);

                    // Tự động căn chỉnh độ rộng cột cho đẹp
                    worksheet.Cells.AutoFitColumns();
                }
                else
                {
                    // Nếu không có dữ liệu, ghi chú vào ô A1
                    worksheet.Cells["A1"].Value = "Không có đơn hàng nào trong khoảng thời gian này.";
                }
                // ---------------------------------

                var stream = new MemoryStream();
                package.SaveAs(stream);
                stream.Position = 0;
                return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "BaoCao.xlsx");
            }
        }
    }
}
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using MokaCafe.Data;
using MokaCafe.Models;
using OfficeOpenXml;
using System.Security.Claims;
namespace MokaCafe.Controllers {
    [Authorize(Roles="admin")]
    public class AdminController : Controller {
        private readonly AppDbContext _db;
        private readonly IWebHostEnvironment _env;
        public AdminController(AppDbContext db,IWebHostEnvironment env){_db=db;_env=env;}
        public async Task<IActionResult> Index() {
            var today=DateTime.Today;
            var dons=await _db.DonHangs.Where(d=>d.NgayDat.Date==today).ToListAsync();
            var vm=new AdminDashboardVM{TongDonHomNay=dons.Count,DoanhThuHomNay=dons.Where(d=>d.TrangThai=="Đã giao").Sum(d=>d.TongTien),TongKhachHang=await _db.NguoiDungs.CountAsync(u=>u.VaiTro!.MaVaiTroJS=="client"),KhachMoi=await _db.NguoiDungs.CountAsync(u=>u.VaiTro!.MaVaiTroJS=="client"&&u.NgayTao.Date==today),TongMonAn=await _db.MonAns.CountAsync(),MonConHang=await _db.MonAns.CountAsync(m=>m.TrangThai=="Còn hàng"),MonHetHang=await _db.MonAns.CountAsync(m=>m.TrangThai=="Hết hàng"),BestSellers=await _db.MonAns.Include(m=>m.DanhMuc).OrderByDescending(m=>m.ChiTietDonHangs.Sum(c=>c.SoLuong)).Take(4).ToListAsync(),DonGanDay=await _db.DonHangs.Include(d=>d.KhachHang).OrderByDescending(d=>d.NgayDat).Take(10).ToListAsync()};
            for(int i=6;i>=0;i--){var ngay=today.AddDays(-i);var dt=await _db.DonHangs.Where(d=>d.NgayDat.Date==ngay&&d.TrangThai=="Đã giao").SumAsync(d=>(decimal?)d.TongTien)??0;vm.DoanhThu7Ngay.Add(dt);vm.Nhan7Ngay.Add(ngay.ToString("dd/MM"));}
            return View(vm);
        }
        public async Task<IActionResult> DoanhThu(DateTime? tuNgay,DateTime? denNgay) {
            tuNgay??=DateTime.Today.AddDays(-30);denNgay??=DateTime.Today;
            ViewBag.TuNgay=tuNgay.Value.ToString("yyyy-MM-dd");ViewBag.DenNgay=denNgay.Value.ToString("yyyy-MM-dd");
            var o=await _db.DonHangs.Include(d=>d.KhachHang).Include(d=>d.ThanhToan).Where(d=>d.NgayDat.Date>=tuNgay.Value.Date&&d.NgayDat.Date<=denNgay.Value.Date).OrderByDescending(d=>d.NgayDat).ToListAsync();
            ViewBag.TongDoanhThu=o.Where(x=>x.TrangThai=="Đã giao").Sum(x=>x.TongTien);ViewBag.TongDon=o.Count;ViewBag.DonThanhCong=o.Count(x=>x.TrangThai=="Đã giao");ViewBag.DonHuy=o.Count(x=>x.TrangThai=="Đã hủy");
            return View(o);
        }
        public async Task<IActionResult> ThucDon(string? search) {
            var q=_db.MonAns.Include(m=>m.DanhMuc).AsQueryable();
            if (!string.IsNullOrEmpty(search)) q=q.Where(m=>m.TenMon.Contains(search));
            ViewBag.Search=search;ViewBag.Tong=await _db.MonAns.CountAsync();ViewBag.ConHang=await _db.MonAns.CountAsync(m=>m.TrangThai=="Còn hàng");ViewBag.HetHang=await _db.MonAns.CountAsync(m=>m.TrangThai=="Hết hàng");
            return View(await q.ToListAsync());
        }
        public async Task<IActionResult> ThemMon() { ViewBag.DanhMucs=new SelectList(await _db.DanhMucs.ToListAsync(),"MaDanhMuc","TenDanhMuc"); return View(); }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> ThemMon(MonAn model,IFormFile? hinh) {
            if (!ModelState.IsValid){ViewBag.DanhMucs=new SelectList(await _db.DanhMucs.ToListAsync(),"MaDanhMuc","TenDanhMuc");return View(model);}
            if (hinh!=null) model.HinhAnh=await LuuHinh(hinh);
            model.NgayTao=DateTime.Now;model.NgayCapNhat=DateTime.Now;
            _db.MonAns.Add(model);await _db.SaveChangesAsync();TempData["ThanhCong"]="Thêm món thành công!";return RedirectToAction("ThucDon");
        }
        public async Task<IActionResult> SuaMon(int id) { var m=await _db.MonAns.FindAsync(id);if(m==null)return NotFound();ViewBag.DanhMucs=new SelectList(await _db.DanhMucs.ToListAsync(),"MaDanhMuc","TenDanhMuc",m.MaDanhMuc);return View(m); }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> SuaMon(MonAn model,IFormFile? hinh) {
            if (!ModelState.IsValid){ViewBag.DanhMucs=new SelectList(await _db.DanhMucs.ToListAsync(),"MaDanhMuc","TenDanhMuc");return View(model);}
            if (hinh!=null) model.HinhAnh=await LuuHinh(hinh);
            model.NgayCapNhat=DateTime.Now;_db.MonAns.Update(model);await _db.SaveChangesAsync();TempData["ThanhCong"]="Cập nhật thành công!";return RedirectToAction("ThucDon");
        }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> XoaMon(int id) { var m=await _db.MonAns.FindAsync(id);if(m!=null){_db.MonAns.Remove(m);await _db.SaveChangesAsync();}TempData["ThanhCong"]="Đã xóa món!";return RedirectToAction("ThucDon"); }
        public async Task<IActionResult> NhanSu(string? search) {
            var q=_db.NguoiDungs.Include(u=>u.VaiTro).Include(u=>u.HoSoNhanVien).ThenInclude(h=>h!.ChucVuNhanVien).Where(u=>u.VaiTro!.MaVaiTroJS!="client").AsQueryable();
            if (!string.IsNullOrEmpty(search)) q=q.Where(u=>u.HoTen.Contains(search)||(u.SoDienThoai!=null&&u.SoDienThoai.Contains(search)));
            ViewBag.Tong=await q.CountAsync();ViewBag.DangLam=await q.CountAsync(u=>u.KichHoat);ViewBag.NghiViec=await q.CountAsync(u=>!u.KichHoat);
            return View(await q.ToListAsync());
        }
        public async Task<IActionResult> ThemNhanVien() { ViewBag.ChucVus=new SelectList(await _db.ChucVuNhanViens.ToListAsync(),"MaChucVu","TenChucVu");ViewBag.VaiTros=new SelectList(await _db.VaiTros.Where(v=>v.MaVaiTroJS!="client").ToListAsync(),"MaVaiTro","TenVaiTro");return View(); }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> ThemNhanVien(NguoiDung model,string matKhauMoi,int maChucVu,DateTime? ngayVao) {
            if (await _db.NguoiDungs.AnyAsync(u=>u.TenDangNhap==model.TenDangNhap)){ModelState.AddModelError("TenDangNhap","Tên đăng nhập đã tồn tại.");ViewBag.ChucVus=new SelectList(await _db.ChucVuNhanViens.ToListAsync(),"MaChucVu","TenChucVu");ViewBag.VaiTros=new SelectList(await _db.VaiTros.Where(v=>v.MaVaiTroJS!="client").ToListAsync(),"MaVaiTro","TenVaiTro");return View(model);}
            model.MatKhau=BCrypt.Net.BCrypt.HashPassword(matKhauMoi);model.NgayTao=DateTime.Now;_db.NguoiDungs.Add(model);await _db.SaveChangesAsync();
            _db.HoSoNhanViens.Add(new HoSoNhanVien{MaNguoiDung=model.MaNguoiDung,MaChucVu=maChucVu,NgayVaoLam=ngayVao,TrangThaiLamViec="Đang làm"});await _db.SaveChangesAsync();
            TempData["ThanhCong"]="Thêm nhân viên thành công!";return RedirectToAction("NhanSu");
        }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> DoiTrangThaiNV(int id) { var u=await _db.NguoiDungs.FindAsync(id);if(u!=null){u.KichHoat=!u.KichHoat;var h=await _db.HoSoNhanViens.FirstOrDefaultAsync(x=>x.MaNguoiDung==id);if(h!=null)h.TrangThaiLamViec=u.KichHoat?"Đang làm":"Nghỉ việc";await _db.SaveChangesAsync();}TempData["ThanhCong"]="Đã cập nhật!";return RedirectToAction("NhanSu"); }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> XoaNhanVien(int id) { var u=await _db.NguoiDungs.FindAsync(id);if(u!=null){_db.NguoiDungs.Remove(u);await _db.SaveChangesAsync();}TempData["ThanhCong"]="Đã xóa nhân viên!";return RedirectToAction("NhanSu"); }
        public async Task<IActionResult> KhachHang(string? search, string? hang)
        {
            var q = _db.NguoiDungs.Include(u => u.ThongTinKhachHang).Include(u => u.VaiTro)
                       .Where(u => u.VaiTro!.MaVaiTroJS == "client").AsQueryable();

            if (!string.IsNullOrEmpty(search))
                q = q.Where(u => u.HoTen.Contains(search) || (u.SoDienThoai != null && u.SoDienThoai.Contains(search)));

            // Lọc theo hạng (giả sử bạn có trường Hạng trong ThongTinKhachHang)
            if (!string.IsNullOrEmpty(hang))
                q = q.Where(u => u.ThongTinKhachHang != null &&
    (hang == "Vàng" ? u.ThongTinKhachHang.LaKhachThanThiet == true : u.ThongTinKhachHang.LaKhachThanThiet == false));
            return View(await q.ToListAsync());
        }

        public async Task<IActionResult> XuatExcelKhachHang()
        {
            var khach = await _db.NguoiDungs.Where(u => u.VaiTro!.MaVaiTroJS == "client").ToListAsync();
            using var package = new ExcelPackage();
            var ws = package.Workbook.Worksheets.Add("DanhSachKhach");
            ws.Cells["A1"].LoadFromCollection(khach, true);
            var stream = new MemoryStream();
            package.SaveAs(stream);
            stream.Position = 0;
            return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "KhachHang.xlsx");
        }
        public async Task<IActionResult> CaiDat() { var cfg=await _db.CauHinhHeThongs.FirstOrDefaultAsync()??new CauHinhHeThong();return View(cfg); }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> CaiDat(CauHinhHeThong model) {
            var ex=await _db.CauHinhHeThongs.FirstOrDefaultAsync();
            if (ex==null) _db.CauHinhHeThongs.Add(model);
            else{ex.TenQuan=model.TenQuan;ex.DiaChi=model.DiaChi;ex.SoDienThoai=model.SoDienThoai;ex.GioMoCua=model.GioMoCua;ex.PhiGiaoHangCoBan=model.PhiGiaoHangCoBan;ex.DonToiThieuMienPhi=model.DonToiThieuMienPhi;ex.PhamViGiaoHang_km=model.PhamViGiaoHang_km;ex.ThongBaoDonMoi=model.ThongBaoDonMoi;ex.CanhBaoHangHet=model.CanhBaoHangHet;ex.BaoCaoCuoiNgay=model.BaoCaoCuoiNgay;ex.SMSThongBaoKH=model.SMSThongBaoKH;ex.HoTroTienMat=model.HoTroTienMat;ex.HoTroMoMo=model.HoTroMoMo;ex.HoTroChuyenKhoan=model.HoTroChuyenKhoan;ex.HoTroTheTinDung=model.HoTroTheTinDung;ex.DangMoCua=model.DangMoCua;ex.NgayCapNhat=DateTime.Now;}
            await _db.SaveChangesAsync();TempData["ThanhCong"]="Đã lưu cấu hình!";return RedirectToAction("CaiDat");
        }
        private async Task<string> LuuHinh(IFormFile f) { var folder=Path.Combine(_env.WebRootPath,"images","products");Directory.CreateDirectory(folder);var fn=Guid.NewGuid()+Path.GetExtension(f.FileName);using var s=new FileStream(Path.Combine(folder,fn),FileMode.Create);await f.CopyToAsync(s);return "/images/products/"+fn; }
        public async Task<IActionResult> XuatBaoCaoAdmin(DateTime tuNgay, DateTime denNgay)
        {
            // Lấy tất cả đơn hàng trong khoảng thời gian, không lọc trạng thái
            var donHangs = await _db.DonHangs
                .Where(d => d.NgayDat.Date >= tuNgay.Date && d.NgayDat.Date <= denNgay.Date)
                .ToListAsync();

            using (var package = new OfficeOpenXml.ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("DoanhThuAdmin");

                if (donHangs.Any())
                {
                    // Đổ dữ liệu vào
                    worksheet.Cells["A1"].LoadFromCollection(donHangs, true);
                    worksheet.Cells.AutoFitColumns();
                }
                else
                {
                    worksheet.Cells["A1"].Value = "Không có dữ liệu trong khoảng thời gian này.";
                }

                var stream = new MemoryStream();
                package.SaveAs(stream);
                stream.Position = 0;

                return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"BaoCao_Admin_{DateTime.Now:yyyyMMdd}.xlsx");
            }
        }
        public IActionResult GetRevenueData(string type)
        {
            var labels = new List<string>();
            var dataValues = new List<decimal>();

            if (type == "day")
            {
                for (int i = 6; i >= 0; i--)
                {
                    var date = DateTime.Today.AddDays(-i);
                    labels.Add(date.ToString("dd/MM"));
                    dataValues.Add(_db.DonHangs.Where(d => d.NgayDat.Date == date.Date).Sum(d => (decimal?)d.TongTien) ?? 0);
                }
            }
            else if (type == "month")
            {
                for (int i = 5; i >= 0; i--)
                {
                    var date = DateTime.Today.AddMonths(-i);
                    labels.Add(date.ToString("MM/yyyy"));
                    dataValues.Add(_db.DonHangs.Where(d => d.NgayDat.Month == date.Month && d.NgayDat.Year == date.Year).Sum(d => (decimal?)d.TongTien) ?? 0);
                }
            }
            else
            {
                for (int i = 2; i >= 0; i--)
                {
                    var year = DateTime.Today.Year - i;
                    labels.Add(year.ToString());
                    dataValues.Add(_db.DonHangs.Where(d => d.NgayDat.Year == year).Sum(d => (decimal?)d.TongTien) ?? 0);
                }
            }
            return Json(new { labels = labels, data = dataValues });
        }
        // Trong AdminController
        public IActionResult QuanLyPhanHoi()
        {
            var list = _db.PhanHois.OrderByDescending(p => p.NgayGui).ToList();
            return View(list);
        }
    }
}

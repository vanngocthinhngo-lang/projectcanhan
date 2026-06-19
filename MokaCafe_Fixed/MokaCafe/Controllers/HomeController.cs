using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MokaCafe.Data;
using MokaCafe.Models;
using Newtonsoft.Json;
using System.Security.Claims;

namespace MokaCafe.Controllers
{
    public class HomeController : Controller
    {
        private readonly AppDbContext _db;
        private const string CartKey = "MokaCart";

        public HomeController(AppDbContext db) => _db = db;

        public async Task<IActionResult> Index()
        {
            var p = await _db.MonAns.Include(m => m.DanhMuc).Where(m => m.TrangThai == "Còn hàng").OrderByDescending(m => m.NgayTao).Take(8).ToListAsync();
            return View(p);
        }

        public async Task<IActionResult> Menu(string? cat, string? search)
        {
            var dm = await _db.DanhMucs.OrderBy(d => d.ThuTu).ToListAsync();
            var q = _db.MonAns.Include(m => m.DanhMuc).AsQueryable();
            if (!string.IsNullOrEmpty(cat) && cat != "all") q = q.Where(m => m.DanhMuc!.MaDanhMucJS == cat);
            if (!string.IsNullOrEmpty(search)) q = q.Where(m => m.TenMon.Contains(search));
            ViewBag.DanhMucs = dm; ViewBag.CatHienTai = cat ?? "all"; ViewBag.Search = search;
            return View(await q.ToListAsync());
        }

        // URL hiển thị: /Home/GioHang
        public IActionResult GioHang()
        {
            var c = LayGio();
            ViewBag.TamTinh = c.Sum(x => x.ThanhTien);
            return View(c);
        }

        // Hàm xử lý API thêm món (Đồng bộ chuẩn tên hàm ThemGioHang)
        [HttpPost]
        public IActionResult ThemGioHang(int maMon, int soLuong, string mucDuong, string mucDa, string? ghiChu)
        {
            var mon = _db.MonAns.Find(maMon);
            if (mon == null) return Json(new { ok = false, message = "Món ăn không tồn tại!" });

            var c = LayGio();
            var it = c.FirstOrDefault(x => x.MaMon == maMon && x.MucDuong == mucDuong && x.MucDa == mucDa);

            if (it != null)
            {
                it.SoLuong += soLuong;
            }
            else
            {
                c.Add(new CartItemVM
                {
                    MaMon = maMon,
                    TenMon = mon.TenMon,
                    DonGia = mon.GiaBan,
                    SoLuong = soLuong,
                    MucDuong = mucDuong,
                    MucDa = mucDa,
                    GhiChu = ghiChu,
                    Emoji = mon.Emoji
                });
            }

            LuuGio(c);
            // Trả về dữ liệu chữ thường đồng bộ hoàn toàn với JavaScript Front-end
            return Json(new { ok = true, soLuong = c.Sum(x => x.SoLuong) });
        }

        [HttpPost]
        public IActionResult CapNhatGioHang(int maMon, int soLuong)
        {
            var c = LayGio();
            var it = c.FirstOrDefault(x => x.MaMon == maMon);
            if (it != null)
            {
                if (soLuong <= 0) c.Remove(it);
                else it.SoLuong = soLuong;
            }
            LuuGio(c);
            return Json(new { ok = true, soLuong = c.Sum(x => x.SoLuong) });
        }

        [HttpPost]
        public IActionResult XoaGioHang(int maMon)
        {
            var c = LayGio();
            c.RemoveAll(x => x.MaMon == maMon);
            LuuGio(c);
            return Json(new { ok = true, soLuong = c.Sum(x => x.SoLuong) });
        }

        [HttpGet]
        public IActionResult SoLuongGioHang() => Json(new { soLuong = LayGio().Sum(x => x.SoLuong) });

        [Authorize]
        public async Task<IActionResult> ThanhToan()
        {
            var c = LayGio();
            if (!c.Any()) return RedirectToAction("GioHang");
            var cfg = await _db.CauHinhHeThongs.FirstOrDefaultAsync() ?? new CauHinhHeThong();
            var uid = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var user = await _db.NguoiDungs.FindAsync(uid);
            return View(new ThanhToanVM { HoTen = user?.HoTen ?? "", SoDienThoai = user?.SoDienThoai ?? "", Items = c, TamTinh = c.Sum(x => x.ThanhTien), PhiGiaoHang = cfg.PhiGiaoHangCoBan });
        }

        [HttpPost, Authorize, ValidateAntiForgeryToken]
        public async Task<IActionResult> ThanhToan(ThanhToanVM model)
        {
            
            var c = LayGio();
            var cfg = await _db.CauHinhHeThongs.FirstOrDefaultAsync() ?? new CauHinhHeThong();
            model.Items = c; model.TamTinh = c.Sum(x => x.ThanhTien); model.PhiGiaoHang = cfg.PhiGiaoHangCoBan;
            if (!ModelState.IsValid) return View(model);
            if (!c.Any()) return RedirectToAction("GioHang");
            var uid = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var ma = "ONL" + DateTime.Now.ToString("yyMMddHHmmss");
            var don = new DonHang { MaDonHangHienThi = "#" + ma, MaKhachHang = uid, LoaiDon = "Online", TrangThai = "Chờ xác nhận", TamTinh = model.TamTinh, PhiGiaoHang = model.PhiGiaoHang, TongTien = model.TongTien, HoTenNguoiNhan = model.HoTen, SoDienThoaiGiao = model.SoDienThoai, DiaChiGiao = model.DiaChi, GhiChu = model.GhiChu, ThoiGianDat = DateTime.Now.ToString("HH:mm") };
            foreach (var it in c) don.ChiTietDonHangs.Add(new ChiTietDonHang { MaMon = it.MaMon, SoLuong = it.SoLuong, DonGia = it.DonGia, MucDuong = it.MucDuong, MucDa = it.MucDa, GhiChuMon = it.GhiChu });
            _db.DonHangs.Add(don); await _db.SaveChangesAsync();
            _db.ThanhToans.Add(new ThanhToan { MaDonHang = don.MaDonHang, PhuongThuc = model.PhuongThucTT, SoTien = model.TongTien, TrangThai = "Chờ thanh toán" }); await _db.SaveChangesAsync();
            var tk = await _db.ThongTinKhachHangs.FirstOrDefaultAsync(t => t.MaNguoiDung == uid);
            if (tk != null) { tk.TongDonHang++; tk.TongChiTieu += model.TongTien; tk.NgayGheGanNhat = DateTime.Now; await _db.SaveChangesAsync(); }
            HttpContext.Session.Remove(CartKey);
            TempData["ThanhCong"] = $"Đặt hàng thành công! Mã đơn: #{ma}";
            return RedirectToAction("LichSuDonHang");
        }

        [Authorize]
        public async Task<IActionResult> LichSuDonHang()
        {
            var uid = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var o = await _db.DonHangs.Include(d => d.ChiTietDonHangs).ThenInclude(c => c.MonAn).Include(d => d.ThanhToan).Where(d => d.MaKhachHang == uid).OrderByDescending(d => d.NgayDat).ToListAsync();
            return View(o);
        }

        public IActionResult GioiThieu() => View();
        public IActionResult LienHe() => View();

        private List<CartItemVM> LayGio()
        {
            var j = HttpContext.Session.GetString(CartKey);
            return string.IsNullOrEmpty(j) ? new List<CartItemVM>() : JsonConvert.DeserializeObject<List<CartItemVM>>(j) ?? new();
        }

        private void LuuGio(List<CartItemVM> c) => HttpContext.Session.SetString(CartKey, JsonConvert.SerializeObject(c));
        public IActionResult ChiTietDonHang(int id)
        {
            // Dùng đúng thuộc tính MaDonHang từ Model của bạn
            var ct = _db.ChiTietDonHangs
                        .Include(c => c.MonAn)
                        .Where(c => c.MaDonHang == id)
                        .ToList();

            return PartialView("_ChiTietDonHang", ct);
        }
        [HttpPost]
        public async Task<IActionResult> GuiPhanHoi(MokaCafe.Models.PhanHoi model)
        {
            if (ModelState.IsValid)
            {
                model.NgayGui = DateTime.Now;
                model.DaDoc = false;
                _db.PhanHois.Add(model); // Đảm bảo bạn đã có DbSet<PhanHoi> trong DbContext
                await _db.SaveChangesAsync();

                // Dùng TempData để hiển thị thông báo sau khi gửi
                TempData["Message"] = "✅ Cảm ơn bạn, phản hồi đã được gửi thành công!";
                return RedirectToAction("LienHe");
            }
            return View("LienHe", model);
        }
    }
}
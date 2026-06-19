using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MokaCafe.Data;
using MokaCafe.Models;
using System.Security.Claims;
namespace MokaCafe.Controllers {
    public class AccountController : Controller {
        private readonly AppDbContext _db;
        public AccountController(AppDbContext db) => _db = db;
        public IActionResult Login() { if (User.Identity?.IsAuthenticated==true) return RedirectByRole(); return View(); }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(DangNhapVM model) {
            if (!ModelState.IsValid) return View(model);
            var user = await _db.NguoiDungs.Include(u=>u.VaiTro).FirstOrDefaultAsync(u=>u.TenDangNhap==model.TenDangNhap && u.KichHoat);
            if (user==null || !BCrypt.Net.BCrypt.Verify(model.MatKhau, user.MatKhau)) { ModelState.AddModelError("","Tên đăng nhập hoặc mật khẩu không đúng."); return View(model); }
            var vt = user.VaiTro?.MaVaiTroJS ?? "client";
            user.LanDangNhapCuoi = DateTime.Now; await _db.SaveChangesAsync();
            var claims = new List<Claim> { new(ClaimTypes.NameIdentifier,user.MaNguoiDung.ToString()), new(ClaimTypes.Name,user.HoTen), new("TenDangNhap",user.TenDangNhap), new(ClaimTypes.Role,vt) };
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(new ClaimsIdentity(claims,CookieAuthenticationDefaults.AuthenticationScheme)));
            return RedirectByRole(vt);
        }
        public IActionResult Register() => View();
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(DangKyVM model) {
            if (!ModelState.IsValid) return View(model);
            if (await _db.NguoiDungs.AnyAsync(u=>u.TenDangNhap==model.TenDangNhap)) { ModelState.AddModelError("TenDangNhap","Tên đăng nhập đã tồn tại."); return View(model); }
            var vt = await _db.VaiTros.FirstOrDefaultAsync(v=>v.MaVaiTroJS=="client");
            if (vt==null) return View(model);
            var user = new NguoiDung { TenDangNhap=model.TenDangNhap, HoTen=model.HoTen, Email=model.Email, SoDienThoai=model.SoDienThoai, MatKhau=BCrypt.Net.BCrypt.HashPassword(model.MatKhau), MaVaiTro=vt.MaVaiTro };
            _db.NguoiDungs.Add(user); await _db.SaveChangesAsync();
            _db.ThongTinKhachHangs.Add(new ThongTinKhachHang { MaNguoiDung=user.MaNguoiDung }); await _db.SaveChangesAsync();
            TempData["ThanhCong"]="Đăng ký thành công! Vui lòng đăng nhập."; return RedirectToAction("Login");
        }
        [HttpPost,ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout() { await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme); HttpContext.Session.Clear(); return RedirectToAction("Login"); }
        public IActionResult AccessDenied() => View();
        private IActionResult RedirectByRole(string? r=null) { r??=User.FindFirst(ClaimTypes.Role)?.Value; return r switch { "admin"=>RedirectToAction("Index","Admin"), "staff"=>RedirectToAction("Index","Staff"), _=>RedirectToAction("Index","Home") }; }
    }
}

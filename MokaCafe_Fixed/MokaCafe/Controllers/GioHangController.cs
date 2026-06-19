using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using MokaCafe.Data;
using MokaCafe.Models;
using System.Text.Json;
using System.Linq;
using System.Threading.Tasks;
using System;
using System.Collections.Generic;

namespace MokaCafe.Controllers
{
    public class GioHangController : Controller
    {
        private readonly AppDbContext _db;

        // Định cấu hình tùy chọn JSON toàn cục cho Controller này để giữ nguyên chữ HOA chữ thường
        private readonly JsonSerializerOptions _jsonOptions = new JsonSerializerOptions
        {
            PropertyNamingPolicy = null
        };

        public GioHangController(AppDbContext db)
        {
            _db = db;
        }

        [HttpPost]
        [Route("GioHang/ThemVaoGio")]
        public async Task<IActionResult> ThemVaoGio(int maMon, int soLuong, string mucDuong, string mucDa, string ghiChu)
        {
            try
            {
                // 1. Kiểm tra món ăn trong database
                var monAn = await _db.MonAns.FindAsync(maMon);
                if (monAn == null)
                {
                    return Json(new { success = false, message = "Món ăn không tồn tại!" }, _jsonOptions);
                }

                // 2. Lấy giỏ hàng từ Session
                var sessionData = HttpContext.Session.GetString("GioHang");
                List<CartItemVM> gioHang;

                if (string.IsNullOrEmpty(sessionData))
                {
                    gioHang = new List<CartItemVM>();
                }
                else
                {
                    gioHang = JsonSerializer.Deserialize<List<CartItemVM>>(sessionData, _jsonOptions) ?? new List<CartItemVM>();
                }

                // 3. Tìm món trùng dựa trên cả ID, Mức đường và Mức đá
                var itemTrung = gioHang.FirstOrDefault(x => x.MaMon == maMon && x.MucDuong == mucDuong && x.MucDa == mucDa);

                if (itemTrung != null)
                {
                    itemTrung.SoLuong += soLuong;
                }
                else
                {
                    gioHang.Add(new CartItemVM
                    {
                        MaMon = monAn.MaMon,
                        TenMon = monAn.TenMon,
                        DonGia = monAn.GiaBan,
                        Emoji = monAn.Emoji,
                        SoLuong = soLuong,
                        MucDuong = mucDuong,
                        MucDa = mucDa,
                        GhiChu = ghiChu
                    });
                }

                // 4. Lưu lại vào Session (Dùng chung bộ cấu hình giữ nguyên chữ Hoa/thường)
                HttpContext.Session.SetString("GioHang", JsonSerializer.Serialize(gioHang, _jsonOptions));

                // 5. Tính tổng số lượng hiển thị lên góc màn hình công cụ
                int tongSoLuong = gioHang.Sum(x => x.SoLuong);

                return Json(new { success = true, totalItems = tongSoLuong }, _jsonOptions);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi hệ thống: " + ex.Message }, _jsonOptions);
            }
        }

        [Route("GioHang")]
        [Route("GioHang/Index")]
        public IActionResult Index()
        {
            var sessionData = HttpContext.Session.GetString("GioHang");
            List<CartItemVM> gioHang;

            if (string.IsNullOrEmpty(sessionData))
            {
                gioHang = new List<CartItemVM>();
            }
            else
            {
                try
                {
                    gioHang = JsonSerializer.Deserialize<List<CartItemVM>>(sessionData, _jsonOptions) ?? new List<CartItemVM>();
                }
                catch
                {
                    gioHang = new List<CartItemVM>();
                }
            }

            return View(gioHang);
        }
    }
}
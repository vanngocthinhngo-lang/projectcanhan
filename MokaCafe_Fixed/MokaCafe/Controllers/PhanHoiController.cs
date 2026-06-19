using Microsoft.AspNetCore.Mvc;
using MokaCafe.Data;
using MokaCafe.Models;

public class PhanHoiController : Controller
{
    private readonly AppDbContext _context;

    public PhanHoiController(AppDbContext context)
    {
        _context = context;
    }

    // GET: Hiện form gửi phản hồi
    public IActionResult Create() => View();

    // POST: Lưu phản hồi vào DB
    [HttpPost]
    public async Task<IActionResult> Create(PhanHoi phanHoi)
    {
        if (ModelState.IsValid)
        {
            // Gán thời gian gửi nếu trong Model bạn chưa tự gán
            phanHoi.NgayGui = DateTime.Now;

            _context.Add(phanHoi);
            await _context.SaveChangesAsync();

            // Thay vì RedirectToAction("CamOn"), hãy quay về trang chủ
            return RedirectToAction("Index", "Home");
        }
        // Nếu lỗi, quay lại trang hiện tại (nếu dùng Partial View thì đây là nơi cần xử lý)
        return View(phanHoi);
    }
}
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using MokaCafe.Data;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

public class OrderAutoCompletionService : BackgroundService
{
    private readonly IServiceProvider _services;
    public OrderAutoCompletionService(IServiceProvider services) => _services = services;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        // Chạy kiểm tra mỗi 1 phút
        while (!stoppingToken.IsCancellationRequested)
        {
            using (var scope = _services.CreateScope())
            {
                var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                // Tìm đơn đã giao quá 30 phút (tùy bạn chỉnh thời gian)
                var threshold = DateTime.Now.AddMinutes(-30);
                var orders = db.DonHangs.Where(d => d.TrangThai == "Đang giao" && d.NgayCapNhat < threshold).ToList();

                foreach (var order in orders)
                {
                    order.TrangThai = "Đã giao";
                    order.NgayCapNhat = DateTime.Now;
                }
                await db.SaveChangesAsync();
            }
            await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
        }
    }
}
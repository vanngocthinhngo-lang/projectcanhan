using Microsoft.EntityFrameworkCore;
using MokaCafe.Models;
namespace MokaCafe.Data {
    public class AppDbContext : DbContext {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) {}
        public DbSet<VaiTro> VaiTros{get;set;}
        public DbSet<NguoiDung> NguoiDungs{get;set;}
        public DbSet<ThongTinKhachHang> ThongTinKhachHangs{get;set;}
        public DbSet<ChucVuNhanVien> ChucVuNhanViens{get;set;}
        public DbSet<HoSoNhanVien> HoSoNhanViens{get;set;}
        public DbSet<CauHinhHeThong> CauHinhHeThongs{get;set;}
        public DbSet<DanhMuc> DanhMucs{get;set;}
        public DbSet<MonAn> MonAns{get;set;}
        public DbSet<GioHang> GioHangs{get;set;}
        public DbSet<ChiTietGioHang> ChiTietGioHangs{get;set;}
        public DbSet<DonHang> DonHangs{get;set;}
        public DbSet<ChiTietDonHang> ChiTietDonHangs{get;set;}
        public DbSet<ThanhToan> ThanhToans{get;set;}
        public DbSet<NguyenLieu> NguyenLieus{get;set;}
        public DbSet<NhatKyKho> NhatKyKhos{get;set;}
        public DbSet<CheBien> CheBiens{get;set;}
        public DbSet<MonBanChay> MonBanChays{get;set;}
        public DbSet<MokaCafe.Models.PhanHoi> PhanHois { get; set; }
        public DbSet<NhatKyHoatDong> NhatKyHoatDongs{get;set;}
        protected override void OnModelCreating(ModelBuilder mb) {
            mb.Entity<NguoiDung>().HasIndex(u=>u.Email).IsUnique().HasFilter("[Email] IS NOT NULL");
            mb.Entity<NguoiDung>().HasIndex(u=>u.TenDangNhap).IsUnique();
            mb.Entity<DonHang>().HasOne(d=>d.KhachHang).WithMany(u=>u.DonHangKhach).HasForeignKey(d=>d.MaKhachHang).OnDelete(DeleteBehavior.Restrict);
            mb.Entity<DonHang>().HasOne(d=>d.NhanVien).WithMany(u=>u.DonHangNhanVien).HasForeignKey(d=>d.MaNhanVien).OnDelete(DeleteBehavior.Restrict);
            mb.Entity<ThanhToan>().HasOne(t=>t.DonHang).WithOne(d=>d.ThanhToan).HasForeignKey<ThanhToan>(t=>t.MaDonHang);
            mb.Entity<CheBien>().HasOne(c=>c.DonHang).WithOne(d=>d.CheBien).HasForeignKey<CheBien>(c=>c.MaDonHang);
            mb.Entity<ThongTinKhachHang>().HasOne(t=>t.NguoiDung).WithOne(u=>u.ThongTinKhachHang).HasForeignKey<ThongTinKhachHang>(t=>t.MaNguoiDung);
            mb.Entity<HoSoNhanVien>().HasOne(h=>h.NguoiDung).WithOne(u=>u.HoSoNhanVien).HasForeignKey<HoSoNhanVien>(h=>h.MaNguoiDung);
            mb.Entity<DonHang>().HasIndex(d=>d.MaDonHangHienThi).IsUnique();
            mb.Entity<NhatKyKho>().HasOne(n=>n.NhanVien).WithMany().HasForeignKey(n=>n.MaNhanVien).OnDelete(DeleteBehavior.Restrict);
            mb.Entity<CheBien>().HasOne(c=>c.NhanVien).WithMany().HasForeignKey(c=>c.MaNhanVien).OnDelete(DeleteBehavior.Restrict);
        }
    }
}

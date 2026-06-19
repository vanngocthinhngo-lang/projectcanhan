using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MokaCafe.Models
{
    [Table("VaiTro")]
    public class VaiTro
    {
        [Key] public int MaVaiTro { get; set; }
        [Required] public string TenVaiTro { get; set; } = "";
        public string MaVaiTroJS { get; set; } = "";
        public string? Icon { get; set; }
        public ICollection<NguoiDung> NguoiDungs { get; set; } = new List<NguoiDung>();
    }

    [Table("NguoiDung")]
    public class NguoiDung
    {
        [Key] public int MaNguoiDung { get; set; }
        [Required, Display(Name = "Tên đăng nhập")] public string TenDangNhap { get; set; } = "";
        [Required, Display(Name = "Họ tên")] public string HoTen { get; set; } = "";
        [EmailAddress] public string? Email { get; set; }
        public string? SoDienThoai { get; set; }
        [Required] public string MatKhau { get; set; } = "";
        public int MaVaiTro { get; set; }

        [ForeignKey("MaVaiTro")]
        public VaiTro? VaiTro { get; set; }

        public bool KichHoat { get; set; } = true;
        public DateTime NgayTao { get; set; } = DateTime.Now;
        public DateTime? LanDangNhapCuoi { get; set; }
        public ThongTinKhachHang? ThongTinKhachHang { get; set; }
        public HoSoNhanVien? HoSoNhanVien { get; set; }
        [InverseProperty("KhachHang")] public ICollection<DonHang> DonHangKhach { get; set; } = new List<DonHang>();
        [InverseProperty("NhanVien")] public ICollection<DonHang> DonHangNhanVien { get; set; } = new List<DonHang>();
        public ICollection<GioHang> GioHangs { get; set; } = new List<GioHang>();
    }

    [Table("ThongTinKhachHang")]
    public class ThongTinKhachHang
    {
        [Key] public int MaThongTin { get; set; }
        public int MaNguoiDung { get; set; }

        [ForeignKey("MaNguoiDung")]
        public NguoiDung? NguoiDung { get; set; }

        public int TongDonHang { get; set; } = 0;
        [Column(TypeName = "decimal(18,0)")] public decimal TongChiTieu { get; set; } = 0;
        public DateTime? NgayGheGanNhat { get; set; }
        public bool LaKhachThanThiet { get; set; } = false;
        public string? GhiChuNoiBo { get; set; }
    }

    [Table("ChucVuNhanVien")]
    public class ChucVuNhanVien
    {
        [Key] public int MaChucVu { get; set; }
        [Required] public string TenChucVu { get; set; } = "";
        [Column(TypeName = "decimal(18,0)")] public decimal LuongCoBan { get; set; } = 0;
        public ICollection<HoSoNhanVien> HoSoNhanViens { get; set; } = new List<HoSoNhanVien>();
    }

    [Table("HoSoNhanVien")]
    public class HoSoNhanVien
    {
        [Key] public int MaHoSo { get; set; }
        public int MaNguoiDung { get; set; }

        [ForeignKey("MaNguoiDung")]
        public NguoiDung? NguoiDung { get; set; }

        public int? MaChucVu { get; set; }

        [ForeignKey("MaChucVu")]
        public ChucVuNhanVien? ChucVuNhanVien { get; set; }

        public DateTime? NgayVaoLam { get; set; }
        public string TrangThaiLamViec { get; set; } = "Đang làm";
        public string? GhiChu { get; set; }
    }

    [Table("CauHinhHeThong")]
    public class CauHinhHeThong
    {
        [Key] public int MaCauHinh { get; set; }
        [Display(Name = "Tên quán")] public string TenQuan { get; set; } = "Moka Cafe";
        [Display(Name = "Địa chỉ")] public string? DiaChi { get; set; }
        [Display(Name = "Số điện thoại")] public string? SoDienThoai { get; set; }
        [Display(Name = "Giờ mở cửa")] public string GioMoCua { get; set; } = "07:00 - 22:00";
        [Column(TypeName = "decimal(18,0)"), Display(Name = "Phí giao hàng")] public decimal PhiGiaoHangCoBan { get; set; } = 15000;
        [Column(TypeName = "decimal(18,0)"), Display(Name = "Đơn tối thiểu")] public decimal DonToiThieuMienPhi { get; set; } = 200000;
        [Display(Name = "Phạm vi (km)")] public int PhamViGiaoHang_km { get; set; } = 10;
        public bool ThongBaoDonMoi { get; set; } = true;
        public bool CanhBaoHangHet { get; set; } = true;
        public bool BaoCaoCuoiNgay { get; set; } = false;
        public bool SMSThongBaoKH { get; set; } = true;
        public bool HoTroTienMat { get; set; } = true;
        public bool HoTroMoMo { get; set; } = true;
        public bool HoTroChuyenKhoan { get; set; } = true;
        public bool HoTroTheTinDung { get; set; } = false;
        public bool DangMoCua { get; set; } = true;
        public DateTime NgayCapNhat { get; set; } = DateTime.Now;
    }

    [Table("DanhMuc")]
    public class DanhMuc
    {
        [Key] public int MaDanhMuc { get; set; }
        [Required, Display(Name = "Tên danh mục")] public string TenDanhMuc { get; set; } = "";
        public string? MaDanhMucJS { get; set; }
        public int ThuTu { get; set; } = 0;
        public bool KichHoat { get; set; } = true;
        public ICollection<MonAn> MonAns { get; set; } = new List<MonAn>();
    }

    [Table("MonAn")]
    public class MonAn
    {
        [Key] public int MaMon { get; set; }
        public int? MaMonJS { get; set; }
        [Required, Display(Name = "Tên món")] public string TenMon { get; set; } = "";
        public string? MoTa { get; set; }
        [Required, Column(TypeName = "decimal(18,0)"), Display(Name = "Giá bán")] public decimal GiaBan { get; set; }
        public int MaDanhMuc { get; set; }

        [ForeignKey("MaDanhMuc")]
        public DanhMuc? DanhMuc { get; set; }

        public string? HinhAnh { get; set; }
        public string? Emoji { get; set; }
        [Display(Name = "Trạng thái")] public string TrangThai { get; set; } = "Còn hàng";
        public bool CoTuyChonDuong { get; set; } = true;
        public bool CoTuyChonDa { get; set; } = true;
        public int SoLuongTon { get; set; } = 0;
        public DateTime NgayTao { get; set; } = DateTime.Now;
        public DateTime NgayCapNhat { get; set; } = DateTime.Now;
        public ICollection<ChiTietDonHang> ChiTietDonHangs { get; set; } = new List<ChiTietDonHang>();
        public ICollection<ChiTietGioHang> ChiTietGioHangs { get; set; } = new List<ChiTietGioHang>();
    }

    [Table("GioHang")]
    public class GioHang
    {
        [Key] public int MaGioHang { get; set; }
        public int? MaNguoiDung { get; set; }

        [ForeignKey("MaNguoiDung")]
        public NguoiDung? NguoiDung { get; set; }

        public string? MaPhien { get; set; }
        public DateTime NgayTao { get; set; } = DateTime.Now;
        public DateTime NgayCapNhat { get; set; } = DateTime.Now;
        public ICollection<ChiTietGioHang> ChiTietGioHangs { get; set; } = new List<ChiTietGioHang>();
    }

    [Table("ChiTietGioHang")]
    public class ChiTietGioHang
    {
        [Key] public int MaChiTiet { get; set; }
        public int MaGioHang { get; set; }

        [ForeignKey("MaGioHang")]
        public GioHang? GioHang { get; set; }

        public int MaMon { get; set; }

        [ForeignKey("MaMon")]
        public MonAn? MonAn { get; set; }

        public int SoLuong { get; set; } = 1;
        [Column(TypeName = "decimal(18,0)")] public decimal DonGia { get; set; }
        public string MucDuong { get; set; } = "50%";
        public string MucDa { get; set; } = "Ít đá";
        public string? GhiChu { get; set; }
        public DateTime NgayThem { get; set; } = DateTime.Now;
        [NotMapped] public decimal ThanhTien => SoLuong * DonGia;
    }

    [Table("DonHang")]
    public class DonHang
    {
        [Key] public int MaDonHang { get; set; }
        public string MaDonHangHienThi { get; set; } = "";
        public int? MaKhachHang { get; set; }
        [ForeignKey("MaKhachHang")] public NguoiDung? KhachHang { get; set; }
        public int? MaNhanVien { get; set; }
        [ForeignKey("MaNhanVien")] public NguoiDung? NhanVien { get; set; }
        public string LoaiDon { get; set; } = "Online";
        public string TrangThai { get; set; } = "Chờ xác nhận";
        [Column(TypeName = "decimal(18,0)")] public decimal TamTinh { get; set; } = 0;
        [Column(TypeName = "decimal(18,0)")] public decimal PhiGiaoHang { get; set; } = 15000;
        [Column(TypeName = "decimal(18,0)")] public decimal TongTien { get; set; } = 0;
        public string? HoTenNguoiNhan { get; set; }
        public string? SoDienThoaiGiao { get; set; }
        public string? DiaChiGiao { get; set; }
        public string? GhiChu { get; set; }
        public string? MaVanChuyen { get; set; }
        public string? ThoiGianDat { get; set; }
        public DateTime NgayDat { get; set; } = DateTime.Now;
        public DateTime NgayCapNhat { get; set; } = DateTime.Now;
        public ICollection<ChiTietDonHang> ChiTietDonHangs { get; set; } = new List<ChiTietDonHang>();
        public ThanhToan? ThanhToan { get; set; }
        public CheBien? CheBien { get; set; }
    }

    [Table("ChiTietDonHang")]
    public class ChiTietDonHang
    {
        [Key] public int MaChiTiet { get; set; }
        public int MaDonHang { get; set; }

        [ForeignKey("MaDonHang")]
        public DonHang? DonHang { get; set; }

        public int MaMon { get; set; }

        [ForeignKey("MaMon")]
        public MonAn? MonAn { get; set; }

        public int SoLuong { get; set; } = 1;
        [Column(TypeName = "decimal(18,0)")] public decimal DonGia { get; set; }
        public string MucDuong { get; set; } = "50%";
        public string MucDa { get; set; } = "Ít đá";
        public string? GhiChuMon { get; set; }
        [NotMapped] public decimal ThanhTien => SoLuong * DonGia;
    }

    [Table("ThanhToan")]
    public class ThanhToan
    {
        [Key] public int MaThanhToan { get; set; }
        public int MaDonHang { get; set; }

        [ForeignKey("MaDonHang")]
        public DonHang? DonHang { get; set; }

        public string PhuongThuc { get; set; } = "Tiền mặt";
        [Column(TypeName = "decimal(18,0)")] public decimal SoTien { get; set; }
        public string TrangThai { get; set; } = "Chờ thanh toán";
        public string? MaGiaoDich { get; set; }
        public DateTime? NgayThanhToan { get; set; }
    }

    [Table("NguyenLieu")]
    public class NguyenLieu
    {
        [Key] public int MaNguyenLieu { get; set; }
        [Required, Display(Name = "Tên nguyên liệu")] public string TenNguyenLieu { get; set; } = "";
        [Column(TypeName = "decimal(18,2)")] public decimal SoLuongHienTai { get; set; } = 0;
        [Column(TypeName = "decimal(18,2)")] public decimal SoLuongToiDa { get; set; } = 0;
        public string? DonVi { get; set; }
        public string TrangThai { get; set; } = "Đủ hàng";
        public DateTime NgayCapNhat { get; set; } = DateTime.Now;
        public ICollection<NhatKyKho> NhatKyKhos { get; set; } = new List<NhatKyKho>();
        [NotMapped] public int PhanTramTon => SoLuongToiDa > 0 ? (int)Math.Round((double)SoLuongHienTai / (double)SoLuongToiDa * 100) : 0;
    }

    [Table("NhatKyKho")]
    public class NhatKyKho
    {
        [Key] public int MaNhatKy { get; set; }
        public int MaNguyenLieu { get; set; }

        [ForeignKey("MaNguyenLieu")]
        public NguyenLieu? NguyenLieu { get; set; }

        public int? MaNhanVien { get; set; }

        [ForeignKey("MaNhanVien")]
        public NguoiDung? NhanVien { get; set; }

        public string LoaiGiaoDich { get; set; } = "Nhập";
        [Column(TypeName = "decimal(18,2)")] public decimal SoLuongTruoc { get; set; } = 0;
        [Column(TypeName = "decimal(18,2)")] public decimal SoLuongThayDoi { get; set; }
        [Column(TypeName = "decimal(18,2)")] public decimal SoLuongSau { get; set; } = 0;
        public string? LyDo { get; set; }
        public DateTime NgayGhiNhan { get; set; } = DateTime.Now;
    }

    [Table("CheBien")]
    public class CheBien
    {
        [Key] public int MaCheBien { get; set; }
        public int MaDonHang { get; set; }

        [ForeignKey("MaDonHang")]
        public DonHang? DonHang { get; set; }

        public int? MaNhanVien { get; set; }

        [ForeignKey("MaNhanVien")]
        public NguoiDung? NhanVien { get; set; }

        public string TrangThai { get; set; } = "Đang làm";
        public DateTime ThoiGianBatDau { get; set; } = DateTime.Now;
        public DateTime? ThoiGianHoanThanh { get; set; }
    }

    [Table("MonBanChay")]
    public class MonBanChay
    {
        [Key] public int MaMonBanChay { get; set; }
        public int MaMon { get; set; }

        [ForeignKey("MaMon")]
        public MonAn? MonAn { get; set; }

        public DateTime Ngay { get; set; }
        public int SoLuongBan { get; set; } = 0;
        [Column(TypeName = "decimal(18,0)")] public decimal DoanhThu { get; set; } = 0;
        public int XepHang { get; set; } = 1;
    }

    [Table("NhatKyHoatDong")]
    public class NhatKyHoatDong
    {
        [Key] public int MaNhatKy { get; set; }
        public int? MaNguoiDung { get; set; }

        [ForeignKey("MaNguoiDung")]
        public NguoiDung? NguoiDung { get; set; }

        public string? LoaiHanhDong { get; set; }
        public string? NoiDung { get; set; }
        public string? DuLieuLienQuan { get; set; }
        public DateTime ThoiGian { get; set; } = DateTime.Now;
    }

    public class DangNhapVM { [Required(ErrorMessage = "Vui lòng nhập tên đăng nhập")][Display(Name = "Tên đăng nhập")] public string TenDangNhap { get; set; } = ""; [Required(ErrorMessage = "Vui lòng nhập mật khẩu")][DataType(DataType.Password), Display(Name = "Mật khẩu")] public string MatKhau { get; set; } = ""; public string VaiTroChon { get; set; } = "client"; }
    public class DangKyVM { [Required(ErrorMessage = "Vui lòng nhập tên đăng nhập")][Display(Name = "Tên đăng nhập")] public string TenDangNhap { get; set; } = ""; [Required(ErrorMessage = "Vui lòng nhập họ tên")][Display(Name = "Họ tên")] public string HoTen { get; set; } = ""; [EmailAddress] public string? Email { get; set; } public string? SoDienThoai { get; set; } [Required(ErrorMessage = "Vui lòng nhập mật khẩu")][DataType(DataType.Password), Display(Name = "Mật khẩu")] public string MatKhau { get; set; } = ""; [Compare("MatKhau", ErrorMessage = "Mật khẩu xác nhận không khớp")][DataType(DataType.Password), Display(Name = "Xác nhận mật khẩu")] public string XacNhanMatKhau { get; set; } = ""; }
    public class ThanhToanVM { [Required(ErrorMessage = "Vui lòng nhập họ tên")][Display(Name = "Họ và tên")] public string HoTen { get; set; } = ""; [Required(ErrorMessage = "Vui lòng nhập số điện thoại")][Display(Name = "Số điện thoại")] public string SoDienThoai { get; set; } = ""; [Required(ErrorMessage = "Vui lòng nhập địa chỉ")][Display(Name = "Địa chỉ giao hàng")] public string DiaChi { get; set; } = ""; [Display(Name = "Ghi chú")] public string? GhiChu { get; set; } public string PhuongThucTT { get; set; } = "Tiền mặt"; public List<CartItemVM> Items { get; set; } = new(); public decimal TamTinh { get; set; } public decimal PhiGiaoHang { get; set; } = 15000; public decimal TongTien => TamTinh + PhiGiaoHang; }

    // ĐÃ CỐ ĐỊNH: Thay đổi cách tính Khóa chính để tránh lỗi trùng lặp dữ liệu Đường/Đá khi lưu trữ Session
    public class CartItemVM
    {
        public int MaMon { get; set; }
        public string TenMon { get; set; } = "";
        public decimal DonGia { get; set; }
        public int SoLuong { get; set; } = 1;
        public string MucDuong { get; set; } = "50%";
        public string MucDa { get; set; } = "Ít đá";
        public string? GhiChu { get; set; }
        public string? Emoji { get; set; }
        public decimal ThanhTien => DonGia * SoLuong;
    }

    public class AdminDashboardVM { [Key] public int TongDonHomNay { get; set; } public decimal DoanhThuHomNay { get; set; } public int KhachMoi { get; set; } public int TongKhachHang { get; set; } public int TongMonAn { get; set; } public int MonConHang { get; set; } public int MonHetHang { get; set; } public List<MonAn> BestSellers { get; set; } = new(); public List<DonHang> DonGanDay { get; set; } = new(); public List<decimal> DoanhThu7Ngay { get; set; } = new(); public List<string> Nhan7Ngay { get; set; } = new(); public int TyLeTrucTuyen { get; set; } = 65; public int TyLeTaiQuan { get; set; } = 35; }
    public class StaffDashboardVM { [Key] public decimal DoanhThuHomNay { get; set; } public int TongDonHomNay { get; set; } public int KhachMoi { get; set; } public int SanPhamBanChay { get; set; } public decimal TyLeTangTruong { get; set; } public int SoLuongTangThem { get; set; } public List<MonBanChay> BestSellers { get; set; } = new(); public List<decimal> DoanhThu7Ngay { get; set; } = new(); public List<string> Nhan7Ngay { get; set; } = new(); }
    public class DonHangOfflineVM
    {
        public string HoTen { get; set; }
        public string SoDienThoai { get; set; }
        public decimal TongTien { get; set; }
        public List<ChiTietDonOffline> ChiTiet { get; set; }
    }

    public class ChiTietDonOffline
    {
        public int MaMon { get; set; }
        public string TenMon { get; set; }
        public decimal GiaBan { get; set; }
    }
    [Table("PhanHoi")]
    public class PhanHoi
    {
        [Key] public int MaPhanHoi { get; set; }
        public string HoTen { get; set; }
        public string Email { get; set; }
        public string ChuDe { get; set; }
        public string NoiDung { get; set; }
        public DateTime NgayGui { get; set; } = DateTime.Now;
        public bool DaDoc { get; set; } = false; // Để Admin biết là mới hay cũ
    }
}
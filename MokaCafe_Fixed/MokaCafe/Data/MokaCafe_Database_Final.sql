-- ================================================================
-- MOKA CAFE DATABASE - SCRIPT HOAN CHINH
-- Chay bang SSMS voi tai khoan sa/123456
-- ================================================================
USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'MokaCafeDB')
    DROP DATABASE MokaCafeDB;
GO
CREATE DATABASE MokaCafeDB COLLATE Vietnamese_CI_AS;
GO
USE MokaCafeDB;
GO

CREATE TABLE VaiTro (
    MaVaiTro   INT IDENTITY(1,1) PRIMARY KEY,
    TenVaiTro  NVARCHAR(50) NOT NULL,
    MaVaiTroJS NVARCHAR(20) NOT NULL,
    Icon       NVARCHAR(10),
    MoTa       NVARCHAR(255)
);

CREATE TABLE NguoiDung (
    MaNguoiDung     INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap     NVARCHAR(50) NOT NULL,
    HoTen           NVARCHAR(100) NOT NULL,
    Email           NVARCHAR(100) NULL,
    SoDienThoai     NVARCHAR(20),
    MatKhau         NVARCHAR(256) NOT NULL,
    MaVaiTro        INT NOT NULL REFERENCES VaiTro(MaVaiTro),
    KichHoat        BIT DEFAULT 1,
    NgayTao         DATETIME DEFAULT GETDATE(),
    LanDangNhapCuoi DATETIME NULL,
    CONSTRAINT UQ_TenDangNhap UNIQUE(TenDangNhap)
);
CREATE UNIQUE INDEX UX_Email ON NguoiDung(Email) WHERE Email IS NOT NULL;

CREATE TABLE ThongTinKhachHang (
    MaThongTin       INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung      INT NOT NULL UNIQUE REFERENCES NguoiDung(MaNguoiDung),
    TongDonHang      INT DEFAULT 0,
    TongChiTieu      DECIMAL(18,0) DEFAULT 0,
    NgayGheGanNhat   DATETIME NULL,
    LaKhachThanThiet BIT DEFAULT 0,
    GhiChuNoiBo      NTEXT
);

CREATE TABLE ChucVuNhanVien (
    MaChucVu  INT IDENTITY(1,1) PRIMARY KEY,
    TenChucVu NVARCHAR(100) NOT NULL,
    LuongCoBan DECIMAL(18,0) DEFAULT 0
);

CREATE TABLE HoSoNhanVien (
    MaHoSo          INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung     INT NOT NULL UNIQUE REFERENCES NguoiDung(MaNguoiDung),
    MaChucVu        INT NULL REFERENCES ChucVuNhanVien(MaChucVu),
    NgayVaoLam      DATE NULL,
    TrangThaiLamViec NVARCHAR(20) DEFAULT N'Đang làm',
    GhiChu          NTEXT
);

CREATE TABLE CauHinhHeThong (
    MaCauHinh          INT IDENTITY(1,1) PRIMARY KEY,
    TenQuan            NVARCHAR(150) DEFAULT N'Moka Cafe',
    DiaChi             NVARCHAR(255),
    SoDienThoai        NVARCHAR(20),
    GioMoCua           NVARCHAR(20) DEFAULT N'07:00 - 22:00',
    PhiGiaoHangCoBan   DECIMAL(18,0) DEFAULT 15000,
    DonToiThieuMienPhi DECIMAL(18,0) DEFAULT 200000,
    PhamViGiaoHang_km  INT DEFAULT 10,
    ThongBaoDonMoi     BIT DEFAULT 1,
    CanhBaoHangHet     BIT DEFAULT 1,
    BaoCaoCuoiNgay     BIT DEFAULT 0,
    SMSThongBaoKH      BIT DEFAULT 1,
    HoTroTienMat       BIT DEFAULT 1,
    HoTroMoMo          BIT DEFAULT 1,
    HoTroChuyenKhoan   BIT DEFAULT 1,
    HoTroTheTinDung    BIT DEFAULT 0,
    DangMoCua          BIT DEFAULT 1,
    NgayCapNhat        DATETIME DEFAULT GETDATE()
);

CREATE TABLE DanhMuc (
    MaDanhMuc  INT IDENTITY(1,1) PRIMARY KEY,
    TenDanhMuc NVARCHAR(100) NOT NULL,
    MaDanhMucJS NVARCHAR(20),
    ThuTu      INT DEFAULT 0,
    KichHoat   BIT DEFAULT 1
);

CREATE TABLE MonAn (
    MaMon          INT IDENTITY(1,1) PRIMARY KEY,
    MaMonJS        INT,
    TenMon         NVARCHAR(150) NOT NULL,
    MoTa           NTEXT,
    GiaBan         DECIMAL(18,0) NOT NULL,
    MaDanhMuc      INT NOT NULL REFERENCES DanhMuc(MaDanhMuc),
    HinhAnh        NVARCHAR(255),
    Emoji          NVARCHAR(10),
    TrangThai      NVARCHAR(20) DEFAULT N'Còn hàng',
    CoTuyChonDuong BIT DEFAULT 1,
    CoTuyChonDa    BIT DEFAULT 1,
    SoLuongTon     INT DEFAULT 0,
    NgayTao        DATETIME DEFAULT GETDATE(),
    NgayCapNhat    DATETIME DEFAULT GETDATE()
);

CREATE TABLE GioHang (
    MaGioHang   INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung INT NULL REFERENCES NguoiDung(MaNguoiDung),
    MaPhien     NVARCHAR(128),
    NgayTao     DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE TABLE ChiTietGioHang (
    MaChiTiet INT IDENTITY(1,1) PRIMARY KEY,
    MaGioHang INT NOT NULL REFERENCES GioHang(MaGioHang) ON DELETE CASCADE,
    MaMon     INT NOT NULL REFERENCES MonAn(MaMon),
    SoLuong   INT NOT NULL DEFAULT 1,
    DonGia    DECIMAL(18,0) NOT NULL,
    MucDuong  NVARCHAR(20) DEFAULT N'50%',
    MucDa     NVARCHAR(20) DEFAULT N'Ít đá',
    GhiChu    NTEXT,
    NgayThem  DATETIME DEFAULT GETDATE()
);

CREATE TABLE DonHang (
    MaDonHang           INT IDENTITY(1,1) PRIMARY KEY,
    MaDonHangHienThi    NVARCHAR(20) NOT NULL,
    MaKhachHang         INT NULL,
    MaNhanVien          INT NULL,
    LoaiDon             NVARCHAR(20) DEFAULT N'Online',
    TrangThai           NVARCHAR(30) DEFAULT N'Chờ xác nhận',
    TamTinh             DECIMAL(18,0) DEFAULT 0,
    PhiGiaoHang         DECIMAL(18,0) DEFAULT 15000,
    TongTien            DECIMAL(18,0) DEFAULT 0,
    HoTenNguoiNhan      NVARCHAR(100),
    SoDienThoaiGiao     NVARCHAR(20),
    DiaChiGiao          NVARCHAR(255),
    GhiChu              NVARCHAR(500),
    MaVanChuyen         NVARCHAR(50),
    ThoiGianDat         NVARCHAR(10),
    NgayDat             DATETIME DEFAULT GETDATE(),
    NgayCapNhat         DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_MaDonHang UNIQUE(MaDonHangHienThi),
    CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY(MaKhachHang) REFERENCES NguoiDung(MaNguoiDung),
    CONSTRAINT FK_DonHang_NhanVien  FOREIGN KEY(MaNhanVien)  REFERENCES NguoiDung(MaNguoiDung)
);

CREATE TABLE ChiTietDonHang (
    MaChiTiet INT IDENTITY(1,1) PRIMARY KEY,
    MaDonHang INT NOT NULL REFERENCES DonHang(MaDonHang) ON DELETE CASCADE,
    MaMon     INT NOT NULL REFERENCES MonAn(MaMon),
    SoLuong   INT NOT NULL DEFAULT 1,
    DonGia    DECIMAL(18,0) NOT NULL,
    MucDuong  NVARCHAR(20) DEFAULT N'50%',
    MucDa     NVARCHAR(20) DEFAULT N'Ít đá',
    GhiChuMon NTEXT
);

CREATE TABLE ThanhToan (
    MaThanhToan   INT IDENTITY(1,1) PRIMARY KEY,
    MaDonHang     INT NOT NULL UNIQUE REFERENCES DonHang(MaDonHang),
    PhuongThuc    NVARCHAR(50) DEFAULT N'Tiền mặt',
    SoTien        DECIMAL(18,0) NOT NULL,
    TrangThai     NVARCHAR(30) DEFAULT N'Chờ thanh toán',
    MaGiaoDich    NVARCHAR(100),
    NgayThanhToan DATETIME NULL
);

CREATE TABLE NguyenLieu (
    MaNguyenLieu   INT IDENTITY(1,1) PRIMARY KEY,
    TenNguyenLieu  NVARCHAR(150) NOT NULL,
    SoLuongHienTai DECIMAL(18,2) DEFAULT 0,
    SoLuongToiDa   DECIMAL(18,2) DEFAULT 0,
    DonVi          NVARCHAR(30),
    TrangThai      NVARCHAR(20) DEFAULT N'Đủ hàng',
    NgayCapNhat    DATETIME DEFAULT GETDATE()
);

CREATE TABLE NhatKyKho (
    MaNhatKy       INT IDENTITY(1,1) PRIMARY KEY,
    MaNguyenLieu   INT NOT NULL REFERENCES NguyenLieu(MaNguyenLieu),
    MaNhanVien     INT NULL REFERENCES NguoiDung(MaNguoiDung),
    LoaiGiaoDich   NVARCHAR(20) NOT NULL,
    SoLuongTruoc   DECIMAL(18,2) DEFAULT 0,
    SoLuongThayDoi DECIMAL(18,2) NOT NULL,
    SoLuongSau     DECIMAL(18,2) DEFAULT 0,
    LyDo           NVARCHAR(255),
    NgayGhiNhan    DATETIME DEFAULT GETDATE()
);

CREATE TABLE CheBien (
    MaCheBien         INT IDENTITY(1,1) PRIMARY KEY,
    MaDonHang         INT NOT NULL UNIQUE REFERENCES DonHang(MaDonHang),
    MaNhanVien        INT NULL REFERENCES NguoiDung(MaNguoiDung),
    TrangThai         NVARCHAR(30) DEFAULT N'Đang làm',
    ThoiGianBatDau    DATETIME DEFAULT GETDATE(),
    ThoiGianHoanThanh DATETIME NULL
);

CREATE TABLE MonBanChay (
    MaMonBanChay INT IDENTITY(1,1) PRIMARY KEY,
    MaMon        INT NOT NULL REFERENCES MonAn(MaMon),
    Ngay         DATE NOT NULL,
    SoLuongBan   INT DEFAULT 0,
    DoanhThu     DECIMAL(18,0) DEFAULT 0,
    XepHang      INT DEFAULT 1,
    CONSTRAINT UQ_MonBanChay UNIQUE(MaMon, Ngay)
);

CREATE TABLE NhatKyHoatDong (
    MaNhatKy       INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung    INT NULL REFERENCES NguoiDung(MaNguoiDung),
    LoaiHanhDong   NVARCHAR(50),
    NoiDung        NVARCHAR(500),
    DuLieuLienQuan NVARCHAR(100),
    ThoiGian       DATETIME DEFAULT GETDATE()
);

-- INDEXES
CREATE INDEX IX_NguoiDung_VaiTro ON NguoiDung(MaVaiTro);
CREATE INDEX IX_MonAn_DanhMuc    ON MonAn(MaDanhMuc);
CREATE INDEX IX_MonAn_TrangThai  ON MonAn(TrangThai);
CREATE INDEX IX_DonHang_KhachHang ON DonHang(MaKhachHang);
CREATE INDEX IX_DonHang_TrangThai ON DonHang(TrangThai);
CREATE INDEX IX_DonHang_NgayDat   ON DonHang(NgayDat);
CREATE INDEX IX_ChiTietDon_MaDon  ON ChiTietDonHang(MaDonHang);
GO

-- ================================================================
-- DU LIEU MAU - Mat khau "123456" da BCrypt hash chinh xac
-- ================================================================
DECLARE @HASH NVARCHAR(256) = N'$2a$11$8DkmRuKnSf2djov10TQNk.zEzcUIN9y764uJEqjZcEJe0kaF0eUW.';

INSERT INTO VaiTro (TenVaiTro, MaVaiTroJS, Icon, MoTa) VALUES
(N'Chủ quán',   N'admin',  N'👑', N'Toàn quyền quản lý hệ thống'),
(N'Nhân viên',  N'staff',  N'🧑', N'Xử lý đơn hàng, kho, chế biến'),
(N'Khách hàng', N'client', N'👤', N'Đặt hàng online');

INSERT INTO NguoiDung (TenDangNhap, HoTen, Email, SoDienThoai, MatKhau, MaVaiTro) VALUES
(N'admin',      N'Admin',          N'admin@moka.vn',   NULL,             @HASH, 1),
(N'nhanvien',   N'Nhân Viên',      N'nv@moka.vn',      NULL,             @HASH, 2),
(N'khachhang',  N'Khách Hàng',     N'kh@moka.vn',      NULL,             @HASH, 3),
(N'nguyenvana', N'Nguyễn Văn A',   NULL, N'0901 234 567', @HASH, 2),
(N'tranthib',   N'Trần Thị B',     NULL, N'0912 345 678', @HASH, 2),
(N'levanc',     N'Lê Văn C',       NULL, N'0923 456 789', @HASH, 2),
(N'phamthid',   N'Phạm Thị D',     NULL, N'0934 567 890', @HASH, 2),
(N'nguyenthia', N'Nguyễn Thị A',   NULL, N'0901 111 222', @HASH, 3),
(N'tranvanb',   N'Trần Văn B',     NULL, N'0912 222 333', @HASH, 3),
(N'lethic',     N'Lê Thị C',       NULL, N'0923 333 444', @HASH, 3),
(N'phamvand',   N'Phạm Văn D',     NULL, N'0934 444 555', @HASH, 3);

INSERT INTO ThongTinKhachHang (MaNguoiDung, TongDonHang, TongChiTieu, LaKhachThanThiet) VALUES
(3, 0, 0, 0),
(8, 24, 1200000, 1),
(9, 18,  900000, 1),
(10,35, 1750000, 1),
(11,12,  600000, 0);

INSERT INTO ChucVuNhanVien (TenChucVu, LuongCoBan) VALUES
(N'Barista',  5000000),
(N'Thu ngân', 4500000),
(N'Phục vụ',  4000000),
(N'Quản lý',  8000000);

INSERT INTO HoSoNhanVien (MaNguoiDung, MaChucVu, NgayVaoLam, TrangThaiLamViec) VALUES
(2, 1, '2023-01-01', N'Đang làm'),
(4, 1, '2022-01-01', N'Đang làm'),
(5, 2, '2022-03-15', N'Đang làm'),
(6, 3, '2023-06-10', N'Nghỉ việc'),
(7, 1, '2023-09-20', N'Đang làm');

INSERT INTO CauHinhHeThong (TenQuan, DiaChi, SoDienThoai, GioMoCua, PhiGiaoHangCoBan, DonToiThieuMienPhi, PhamViGiaoHang_km, ThongBaoDonMoi, CanhBaoHangHet, BaoCaoCuoiNgay, SMSThongBaoKH, HoTroTienMat, HoTroMoMo, HoTroChuyenKhoan, HoTroTheTinDung, DangMoCua)
VALUES (N'Moka Cafe', N'123 Lê Duẩn, Đà Nẵng', N'0901 234 567', N'07:00 - 22:00', 15000, 200000, 10, 1, 1, 0, 1, 1, 1, 1, 0, 1);

INSERT INTO DanhMuc (TenDanhMuc, MaDanhMucJS, ThuTu) VALUES
(N'Cà phê',       N'coffee',    1),
(N'Trà sữa',      N'tea',       2),
(N'Trà trái cây', N'fruit-tea', 3),
(N'Bánh ngọt',    N'cake',      4);

INSERT INTO MonAn (MaMonJS, TenMon, GiaBan, MaDanhMuc, Emoji, TrangThai, SoLuongTon) VALUES
(1,  N'Cà phê sữa đá',          45000, 1, N'☕', N'Còn hàng', 100),
(2,  N'Espresso',                35000, 1, N'🫘', N'Còn hàng', 100),
(3,  N'Cappuccino',              35000, 1, N'☕', N'Còn hàng', 100),
(4,  N'Coffee mà rán',           35000, 1, N'☕', N'Còn hàng', 100),
(5,  N'Cà phê sữa đá Premium',  70000, 1, N'☕', N'Còn hàng',  50),
(6,  N'Matcha Latte',            55000, 2, N'🍵', N'Hết hàng',   0),
(7,  N'Trà sữa trân châu',       45000, 2, N'🧋', N'Còn hàng',  80),
(8,  N'Trà Đào Cam Sả',          45000, 3, N'🍑', N'Còn hàng',  60),
(9,  N'Trà vải thiều',            45000, 3, N'🍇', N'Còn hàng',  60),
(10, N'Bánh Tiramisu',           55000, 4, N'🍰', N'Còn hàng',  30),
(11, N'Bánh Croissant',          35000, 4, N'🥐', N'Còn hàng',  40),
(12, N'Bánh muffin',             30000, 4, N'🧁', N'Còn hàng',  50);

INSERT INTO NguyenLieu (TenNguyenLieu, SoLuongHienTai, SoLuongToiDa, DonVi, TrangThai) VALUES
(N'Cà phê hạt', 12, 20,  N'kg',    N'Trung bình'),
(N'Sữa tươi',    8, 30,  N'lít',   N'Sắp hết'),
(N'Matcha bột',  2, 10,  N'kg',    N'Sắp hết'),
(N'Đường',      18, 25,  N'kg',    N'Đủ hàng'),
(N'Trà Đào',     1, 15,  N'kg',    N'Sắp hết'),
(N'Kem tươi',    5, 10,  N'lít',   N'Trung bình'),
(N'Bánh mì',    40, 100, N'chiếc', N'Trung bình'),
(N'Ly giấy',   320, 500, N'cái',   N'Đủ hàng');

-- Don hang mau
DECLARE @D1 INT, @D2 INT, @D3 INT;
INSERT INTO DonHang (MaDonHangHienThi, MaKhachHang, MaNhanVien, LoaiDon, TrangThai, TamTinh, PhiGiaoHang, TongTien, HoTenNguoiNhan, SoDienThoaiGiao, DiaChiGiao, GhiChu, ThoiGianDat, MaVanChuyen)
VALUES (N'#ONL001', 3, 2, N'Online', N'Đã giao', 120000, 15000, 135000, N'Khách Hàng', N'0934567890', N'123 Lê Duẩn, Đà Nẵng', N'Giao tầng 3', N'10:30', N'VN123456');
SET @D1 = SCOPE_IDENTITY();

INSERT INTO DonHang (MaDonHangHienThi, MaKhachHang, MaNhanVien, LoaiDon, TrangThai, TamTinh, PhiGiaoHang, TongTien, HoTenNguoiNhan, SoDienThoaiGiao, DiaChiGiao, ThoiGianDat, MaVanChuyen)
VALUES (N'#ONL002', 8, 2, N'Online', N'Đang giao', 85000, 15000, 100000, N'Nguyễn Thị A', N'0901111222', N'45 Trần Phú, Đà Nẵng', N'11:15', N'VN123457');
SET @D2 = SCOPE_IDENTITY();

INSERT INTO DonHang (MaDonHangHienThi, MaKhachHang, MaNhanVien, LoaiDon, TrangThai, TamTinh, PhiGiaoHang, TongTien, HoTenNguoiNhan, SoDienThoaiGiao, ThoiGianDat)
VALUES (N'#ONL003', 9, 2, N'Online', N'Chờ xác nhận', 135000, 15000, 150000, N'Trần Văn B', N'0912222333', N'11:45');
SET @D3 = SCOPE_IDENTITY();

INSERT INTO ChiTietDonHang (MaDonHang, MaMon, SoLuong, DonGia, MucDuong, MucDa, GhiChuMon) VALUES
(@D1, 1, 2, 45000, N'50%', N'Ít đá', NULL),
(@D1, 10, 1, 45000, N'50%', N'Không đá', N'Thêm sốt socola'),
(@D2, 8, 1, 45000, N'0%', N'Ít đá', NULL),
(@D3, 1, 1, 45000, N'50%', N'Ít đá', N'Không lấy ống hút'),
(@D3, 3, 1, 35000, N'50%', N'Ít đá', NULL),
(@D3, 2, 1, 45000, N'50%', N'Ít đá', NULL);

INSERT INTO ThanhToan (MaDonHang, PhuongThuc, SoTien, TrangThai, NgayThanhToan) VALUES
(@D1, N'Tiền mặt',              135000, N'Đã thanh toán', GETDATE()),
(@D2, N'Chuyển khoản ngân hàng', 100000, N'Chờ thanh toán', NULL),
(@D3, N'MoMo',                   150000, N'Chờ thanh toán', NULL);

INSERT INTO CheBien (MaDonHang, MaNhanVien, TrangThai) VALUES (@D3, 4, N'Đang làm');

INSERT INTO MonBanChay (MaMon, Ngay, SoLuongBan, DoanhThu, XepHang) VALUES
(1,  CAST(GETDATE() AS DATE), 50, 2250000, 1),
(11, CAST(GETDATE() AS DATE), 25,  875000, 2),
(8,  CAST(GETDATE() AS DATE), 25, 1125000, 3),
(10, CAST(GETDATE() AS DATE), 10,  550000, 4);
GO

PRINT N'=== DATABASE MOKCAFEDB TAO THANH CONG ===';
PRINT N'Mat khau demo tat ca: 123456';
PRINT N'admin / nhanvien / khachhang';
GO

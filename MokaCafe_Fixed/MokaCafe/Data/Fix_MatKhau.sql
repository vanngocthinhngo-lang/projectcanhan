-- ================================================================
-- MOKA CAFE - SQL FIX: Hash dung + Du lieu mau day du
-- Chay file nay neu dang nhap bi loi
-- ================================================================
USE MokaCafeDB;
GO

-- Xoa va tao lai mat khau dung
UPDATE NguoiDung SET MatKhau = N'$2a$11$lgl7nhZlp8D7MG1I1bN2iu3xP0ssgAwv2X9QDyNImQiIEtakWjN7m' WHERE TenDangNhap IN (
    'admin','nhanvien','khachhang',
    'nguyenvana','tranthib','levanc','phamthid',
    'nguyenthia','tranvanb','lethic','phamvand',
    'levandd','phamthie','hoangvanf','nguyenthibb','tranvancc'
);
GO
PRINT 'Da cap nhat mat khau thanh cong!';
GO

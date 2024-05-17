CREATE DATABASE QL_KHACHSAN2;
GO
USE QL_KHACHSAN2;
GO

-- Create the TAIKHOAN table
CREATE TABLE TAIKHOAN (
    TENTK NVARCHAR(50) PRIMARY KEY,
    MATKHAU NVARCHAR(50),
    PHANQUYEN NVARCHAR(50)
);
GO

-- Create the NHANVIEN table
CREATE TABLE NHANVIEN (
    MANV NVARCHAR(50) PRIMARY KEY,
    TENNV NVARCHAR(50),
    SDT NVARCHAR(15),
    CCCD NVARCHAR(20),
    TUOI INT,
    TENTK NVARCHAR(50) REFERENCES TAIKHOAN(TENTK)
);
GO

-- Create the PHONG table
CREATE TABLE PHONG (
    MAPHONG NVARCHAR(50) PRIMARY KEY,
    LOAIPHONG NVARCHAR(50),
    GIAPHONG VARCHAR(30),
    TINHTRANG NVARCHAR(50)
);
GO

-- Create the DICHVU table
CREATE TABLE DICHVU (
    MADV NVARCHAR(50) PRIMARY KEY,
    TENDV NVARCHAR(50),
    GIADV VARCHAR(30)
);
GO

-- Create the KHACHHANG table
CREATE TABLE KHACHHANG (
    MAKH NVARCHAR(50) PRIMARY KEY,
    TENKH NVARCHAR(50),
    CCCD NVARCHAR(20),
    GIOTINH NVARCHAR(5),
    SDT NVARCHAR(15),
    MAPHONG NVARCHAR(50) REFERENCES PHONG(MAPHONG)
);
GO

-- Create the HOADON table
CREATE TABLE HOADON (
    MAHD NVARCHAR(50) PRIMARY KEY,
    MANV NVARCHAR(50) REFERENCES NHANVIEN(MANV),
    MAKH NVARCHAR(50) REFERENCES KHACHHANG(MAKH),
    NGAY DATE
);
GO

-- Create the CTHOADON table
CREATE TABLE CTHOADON (
    MAHD NVARCHAR(50) REFERENCES HOADON(MAHD),
    MADV NVARCHAR(50) REFERENCES DICHVU(MADV),
    MAPHONG NVARCHAR(50) REFERENCES PHONG(MAPHONG),
    SOLUONG INT,
    GIADV VARCHAR(30),
    THANHTIEN FLOAT
);
GO

-- Nhập dữ liệu cho bảng TAIKHOAN
INSERT INTO TAIKHOAN (TENTK, MATKHAU, PHANQUYEN)
VALUES
    ('admin', '12345', 'admin'),
    ('ABC', '09876', 'user'),
    ('BCD', '12345', 'user'),
    ('ERF', '12345', 'user');
GO

-- Nhập dữ liệu cho bảng NHANVIEN
INSERT INTO NHANVIEN (MANV, TENNV, SDT, CCCD, TUOI, TENTK)
VALUES
    ('NV001', N'le quang huy', N'123456789', 'CCCD001', 18, 'admin'),
    ('NV002', N'Tran Thi A', N'987654321', 'CCCD002', 19, 'ABC'),
    ('NV003', N'Le Van B', N'555555555', 'CCCD003', 20, 'BCD'),
    ('NV004', N'Pham Thi C', N'444444444', 'CCCD004', 21, 'ERF');
GO

-- Nhập dữ liệu cho bảng PHONG
INSERT INTO PHONG (MAPHONG, LOAIPHONG, GIAPHONG, TINHTRANG)
VALUES
    ('P001', 'Deluxe', '1000000', 'Trống'),
    ('P002', 'Standard', '500000', 'Trống'),
    ('P003', 'VIP', '2000000', 'Đã đặt'),
    ('P004', 'Suite', '3000000', 'Trống');
GO

-- Nhập dữ liệu cho bảng DICHVU
INSERT INTO DICHVU (MADV, TENDV, GIADV)
VALUES
    ('DV001', 'Massage', '50000'),
    ('DV002', 'Spa', '100000'),
    ('DV003', 'Gym', '150000'),
    ('DV004', 'Breakfast', '200000');
GO

-- Nhập dữ liệu cho bảng KHACHHANG
INSERT INTO KHACHHANG (MAKH, TENKH, CCCD, GIOTINH, SDT, MAPHONG)
VALUES
    ('KH001', 'Tran Van X', 'CCCD005', 'nam', '111111111', 'P001'),
    ('KH002', 'Le Thi Y', 'CCCD006', 'nữ', '222222222', 'P002'),
    ('KH003', 'Nguyen Van Z', 'CCCD007', 'nam', '333333333', 'P003'),
    ('KH004', 'Pham Thi W', 'CCCD008', 'nữ', '444444444', 'P004');
GO

-- Nhập dữ liệu cho bảng HOADON
INSERT INTO HOADON (MAHD, MANV, MAKH, NGAY)
VALUES
    ('HD001', 'NV001', 'KH001', '2023-01-01'),
    ('HD002', 'NV002', 'KH002', '2023-02-01'),
    ('HD003', 'NV003', 'KH003', '2023-03-01'),
    ('HD004', 'NV004', 'KH004', '2023-04-01');
GO

-- Nhập dữ liệu cho bảng CTHOADON
INSERT INTO CTHOADON (MAHD, MADV, MAPHONG, SOLUONG, GIADV, THANHTIEN)
VALUES
    ('HD001', 'DV001', 'P001', 2, '50000', NULL),
    ('HD002', 'DV002', 'P002', 3, '100000', NULL),
    ('HD003', 'DV001', 'P003', 1, '50000', NULL),
    ('HD004', 'DV002', 'P004', 2, '100000', NULL);
GO

-- Tạo trigger để kiểm tra tuổi của nhân viên
CREATE TRIGGER CheckAgeTrigger
ON NHANVIEN
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra tuổi khi chèn hoặc cập nhật
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE DATEDIFF(YEAR, TUOI, GETDATE()) < 18
    )
    BEGIN
        PRINT 'TUỔI NHÂN VIÊN PHẢI TỪ 18 TUỔI TRỞ LÊN'
        ROLLBACK; -- Hủy bỏ thao tác chèn hoặc cập nhật
    END
    ELSE
    BEGIN
        -- Nếu không có vấn đề, thực hiện thao tác chèn hoặc cập nhật
        INSERT INTO NHANVIEN (MANV, TENNV, SDT, CCCD, TUOI, TENTK)
        SELECT MANV, TENNV, SDT, CCCD, TUOI, TENTK
        FROM inserted;
    END
END
GO

-- Thực hiện các truy vấn khác
SELECT * FROM TAIKHOAN;
SELECT * FROM HOADON;
SELECT * FROM CTHOADON;
SELECT * FROM DICHVU;
GO

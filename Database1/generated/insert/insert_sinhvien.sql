DELIMITER $$
CREATE PROCEDURE Insertsinhvien(
    IN p_MaSV char(20),
    IN p_HoTen varchar(100),
    IN p_NgaySinh date,
    IN p_GioiTinh varchar(10),
    IN p_DiaChi varchar(200),
    IN p_Email varchar(100),
    IN p_SDT varchar(15),
    IN p_MaLopSV char(20),
    IN p_TrangThaiSV varchar(50),
    IN p_maLopModule char(20),
    IN p_CPA decimal(4,2),
    IN p_MaCTDT char(20)
)
BEGIN
    INSERT INTO sinhvien (
        MaSV, HoTen, NgaySinh, GioiTinh, DiaChi, Email, SDT, MaLopSV, TrangThaiSV, maLopModule, CPA, MaCTDT
    ) VALUES (
        p_MaSV, p_HoTen, p_NgaySinh, p_GioiTinh, p_DiaChi, p_Email, p_SDT, p_MaLopSV, p_TrangThaiSV, p_maLopModule, p_CPA, p_MaCTDT
    );
END$$
DELIMITER ;

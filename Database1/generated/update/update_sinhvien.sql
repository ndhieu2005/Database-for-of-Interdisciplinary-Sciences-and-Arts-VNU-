DELIMITER $$
CREATE PROCEDURE Updatesinhvien(
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
    UPDATE sinhvien
    SET
    HoTen = p_HoTen,
    NgaySinh = p_NgaySinh,
    GioiTinh = p_GioiTinh,
    DiaChi = p_DiaChi,
    Email = p_Email,
    SDT = p_SDT,
    MaLopSV = p_MaLopSV,
    TrangThaiSV = p_TrangThaiSV,
    maLopModule = p_maLopModule,
    CPA = p_CPA,
    MaCTDT = p_MaCTDT
    WHERE
        MaSV = p_MaSV;
END$$
DELIMITER ;

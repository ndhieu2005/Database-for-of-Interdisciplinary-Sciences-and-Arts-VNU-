DELIMITER $$
CREATE PROCEDURE Updatedoanhnghiep(
    IN p_MaDN char(20),
    IN p_TenDN varchar(150),
    IN p_LinhVucHD varchar(100),
    IN p_DiaChi varchar(200),
    IN p_Email varchar(100),
    IN p_NguoiDaiDien varchar(100),
    IN p_SDT varchar(15)
)
BEGIN
    UPDATE doanhnghiep
    SET
    TenDN = p_TenDN,
    LinhVucHD = p_LinhVucHD,
    DiaChi = p_DiaChi,
    Email = p_Email,
    NguoiDaiDien = p_NguoiDaiDien,
    SDT = p_SDT
    WHERE
        MaDN = p_MaDN;
END$$
DELIMITER ;

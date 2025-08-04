DELIMITER $$
CREATE PROCEDURE Insertdoanhnghiep(
    IN p_MaDN char(20),
    IN p_TenDN varchar(150),
    IN p_LinhVucHD varchar(100),
    IN p_DiaChi varchar(200),
    IN p_Email varchar(100),
    IN p_NguoiDaiDien varchar(100),
    IN p_SDT varchar(15)
)
BEGIN
    INSERT INTO doanhnghiep (
        MaDN, TenDN, LinhVucHD, DiaChi, Email, NguoiDaiDien, SDT
    ) VALUES (
        p_MaDN, p_TenDN, p_LinhVucHD, p_DiaChi, p_Email, p_NguoiDaiDien, p_SDT
    );
END$$
DELIMITER ;

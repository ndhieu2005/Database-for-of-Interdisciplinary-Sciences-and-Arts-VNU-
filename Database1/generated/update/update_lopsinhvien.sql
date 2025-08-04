DELIMITER $$
CREATE PROCEDURE Updatelopsinhvien(
    IN p_MaLopSV char(20),
    IN p_TenLopSV varchar(100),
    IN p_MaCTDT char(20),
    IN p_MaGVQL char(20),
    IN p_SiSo smallint,
    IN p_GhiChu text
)
BEGIN
    UPDATE lopsinhvien
    SET
    TenLopSV = p_TenLopSV,
    MaCTDT = p_MaCTDT,
    MaGVQL = p_MaGVQL,
    SiSo = p_SiSo,
    GhiChu = p_GhiChu
    WHERE
        MaLopSV = p_MaLopSV;
END$$
DELIMITER ;

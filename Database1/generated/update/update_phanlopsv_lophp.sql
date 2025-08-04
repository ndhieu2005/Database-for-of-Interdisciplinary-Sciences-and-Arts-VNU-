DELIMITER $$
CREATE PROCEDURE Updatephanlopsv_lophp(
    IN p_MaLopSV char(20),
    IN p_MaLopHP char(20),
    IN p_PhongHoc varchar(50),
    IN p_Thu tinyint,
    IN p_GioBD time,
    IN p_GioKT time,
    IN p_GhiChu text
)
BEGIN
    UPDATE phanlopsv_lophp
    SET
    PhongHoc = p_PhongHoc,
    Thu = p_Thu,
    GioBD = p_GioBD,
    GioKT = p_GioKT,
    GhiChu = p_GhiChu
    WHERE
        MaLopSV = p_MaLopSV AND
        MaLopHP = p_MaLopHP;
END$$
DELIMITER ;

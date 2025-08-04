DELIMITER $$
CREATE PROCEDURE Insertphanlopsv_lophp(
    IN p_MaLopSV char(20),
    IN p_MaLopHP char(20),
    IN p_PhongHoc varchar(50),
    IN p_Thu tinyint,
    IN p_GioBD time,
    IN p_GioKT time,
    IN p_GhiChu text
)
BEGIN
    INSERT INTO phanlopsv_lophp (
        MaLopSV, MaLopHP, PhongHoc, Thu, GioBD, GioKT, GhiChu
    ) VALUES (
        p_MaLopSV, p_MaLopHP, p_PhongHoc, p_Thu, p_GioBD, p_GioKT, p_GhiChu
    );
END$$
DELIMITER ;

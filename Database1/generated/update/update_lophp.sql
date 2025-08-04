DELIMITER $$
CREATE PROCEDURE Updatelophp(
    IN p_MaLopHP char(20),
    IN p_MaHP char(20),
    IN p_MaGV char(20),
    IN p_SiSo smallint,
    IN p_MaHK char(20),
    IN p_maLopModule char(20)
)
BEGIN
    UPDATE lophp
    SET
    MaHP = p_MaHP,
    MaGV = p_MaGV,
    SiSo = p_SiSo,
    MaHK = p_MaHK,
    maLopModule = p_maLopModule
    WHERE
        MaLopHP = p_MaLopHP;
END$$
DELIMITER ;

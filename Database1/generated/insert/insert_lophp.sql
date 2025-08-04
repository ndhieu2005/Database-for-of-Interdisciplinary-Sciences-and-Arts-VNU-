DELIMITER $$
CREATE PROCEDURE Insertlophp(
    IN p_MaLopHP char(20),
    IN p_MaHP char(20),
    IN p_MaGV char(20),
    IN p_SiSo smallint,
    IN p_MaHK char(20),
    IN p_maLopModule char(20)
)
BEGIN
    INSERT INTO lophp (
        MaLopHP, MaHP, MaGV, SiSo, MaHK, maLopModule
    ) VALUES (
        p_MaLopHP, p_MaHP, p_MaGV, p_SiSo, p_MaHK, p_maLopModule
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Deletephanlopsv_lophp(
    IN p_MaLopSV char(20),
    IN p_MaLopHP char(20)
)
BEGIN
    DELETE FROM phanlopsv_lophp
    WHERE
        MaLopSV = p_MaLopSV AND
        MaLopHP = p_MaLopHP;
END$$
DELIMITER ;

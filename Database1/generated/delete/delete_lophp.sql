DELIMITER $$
CREATE PROCEDURE Deletelophp(
    IN p_MaLopHP char(20)
)
BEGIN
    DELETE FROM lophp
    WHERE
        MaLopHP = p_MaLopHP;
END$$
DELIMITER ;

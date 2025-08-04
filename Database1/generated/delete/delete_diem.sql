DELIMITER $$
CREATE PROCEDURE Deletediem(
    IN p_MaSV char(20),
    IN p_MaLopHP char(20)
)
BEGIN
    DELETE FROM diem
    WHERE
        MaSV = p_MaSV AND
        MaLopHP = p_MaLopHP;
END$$
DELIMITER ;

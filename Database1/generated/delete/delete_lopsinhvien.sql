DELIMITER $$
CREATE PROCEDURE Deletelopsinhvien(
    IN p_MaLopSV char(20)
)
BEGIN
    DELETE FROM lopsinhvien
    WHERE
        MaLopSV = p_MaLopSV;
END$$
DELIMITER ;

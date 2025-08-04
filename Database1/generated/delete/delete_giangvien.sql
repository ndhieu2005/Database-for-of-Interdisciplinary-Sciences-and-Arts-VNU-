DELIMITER $$
CREATE PROCEDURE Deletegiangvien(
    IN p_MaGV char(20)
)
BEGIN
    DELETE FROM giangvien
    WHERE
        MaGV = p_MaGV;
END$$
DELIMITER ;

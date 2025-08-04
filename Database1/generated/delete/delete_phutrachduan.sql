DELIMITER $$
CREATE PROCEDURE Deletephutrachduan(
    IN p_MaDA char(20),
    IN p_MaGV char(20)
)
BEGIN
    DELETE FROM phutrachduan
    WHERE
        MaDA = p_MaDA AND
        MaGV = p_MaGV;
END$$
DELIMITER ;

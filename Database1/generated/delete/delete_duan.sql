DELIMITER $$
CREATE PROCEDURE Deleteduan(
    IN p_MaDA char(20)
)
BEGIN
    DELETE FROM duan
    WHERE
        MaDA = p_MaDA;
END$$
DELIMITER ;

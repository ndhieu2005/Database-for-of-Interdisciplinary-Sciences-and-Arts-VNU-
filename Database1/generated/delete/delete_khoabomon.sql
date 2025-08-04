DELIMITER $$
CREATE PROCEDURE Deletekhoabomon(
    IN p_MaKhoa char(20)
)
BEGIN
    DELETE FROM khoabomon
    WHERE
        MaKhoa = p_MaKhoa;
END$$
DELIMITER ;

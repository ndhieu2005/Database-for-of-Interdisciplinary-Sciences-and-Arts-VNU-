DELIMITER $$
CREATE PROCEDURE Deletethamgiaduan(
    IN p_MaDA char(20),
    IN p_MaSV char(20)
)
BEGIN
    DELETE FROM thamgiaduan
    WHERE
        MaDA = p_MaDA AND
        MaSV = p_MaSV;
END$$
DELIMITER ;

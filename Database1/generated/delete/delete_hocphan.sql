DELIMITER $$
CREATE PROCEDURE Deletehocphan(
    IN p_MaHP char(20)
)
BEGIN
    DELETE FROM hocphan
    WHERE
        MaHP = p_MaHP;
END$$
DELIMITER ;

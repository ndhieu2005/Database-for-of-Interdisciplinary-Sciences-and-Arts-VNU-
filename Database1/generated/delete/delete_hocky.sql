DELIMITER $$
CREATE PROCEDURE Deletehocky(
    IN p_MaHK char(20)
)
BEGIN
    DELETE FROM hocky
    WHERE
        MaHK = p_MaHK;
END$$
DELIMITER ;

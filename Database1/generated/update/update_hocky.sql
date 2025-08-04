DELIMITER $$
CREATE PROCEDURE Updatehocky(
    IN p_MaHK char(20),
    IN p_NgayBD date,
    IN p_NgayKT date
)
BEGIN
    UPDATE hocky
    SET
    NgayBD = p_NgayBD,
    NgayKT = p_NgayKT
    WHERE
        MaHK = p_MaHK;
END$$
DELIMITER ;

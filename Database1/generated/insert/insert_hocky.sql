DELIMITER $$
CREATE PROCEDURE Inserthocky(
    IN p_MaHK char(20),
    IN p_NgayBD date,
    IN p_NgayKT date
)
BEGIN
    INSERT INTO hocky (
        MaHK, NgayBD, NgayKT
    ) VALUES (
        p_MaHK, p_NgayBD, p_NgayKT
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Deletesinhvien(
    IN p_MaSV char(20)
)
BEGIN
    DELETE FROM sinhvien
    WHERE
        MaSV = p_MaSV;
END$$
DELIMITER ;

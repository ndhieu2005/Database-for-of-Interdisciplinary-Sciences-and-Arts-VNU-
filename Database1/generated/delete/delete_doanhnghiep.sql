DELIMITER $$
CREATE PROCEDURE Deletedoanhnghiep(
    IN p_MaDN char(20)
)
BEGIN
    DELETE FROM doanhnghiep
    WHERE
        MaDN = p_MaDN;
END$$
DELIMITER ;

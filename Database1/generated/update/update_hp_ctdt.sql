DELIMITER $$
CREATE PROCEDURE Updatehp_ctdt(
    IN p_MaHP char(20),
    IN p_MaCTDT char(20)
)
BEGIN
    UPDATE hp_ctdt
    SET
    
    WHERE
        MaHP = p_MaHP AND
        MaCTDT = p_MaCTDT;
END$$
DELIMITER ;

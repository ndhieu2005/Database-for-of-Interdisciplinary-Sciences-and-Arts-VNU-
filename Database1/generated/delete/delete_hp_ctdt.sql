DELIMITER $$
CREATE PROCEDURE Deletehp_ctdt(
    IN p_MaHP char(20),
    IN p_MaCTDT char(20)
)
BEGIN
    DELETE FROM hp_ctdt
    WHERE
        MaHP = p_MaHP AND
        MaCTDT = p_MaCTDT;
END$$
DELIMITER ;

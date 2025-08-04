DELIMITER $$
CREATE PROCEDURE Inserthp_ctdt(
    IN p_MaHP char(20),
    IN p_MaCTDT char(20)
)
BEGIN
    INSERT INTO hp_ctdt (
        MaHP, MaCTDT
    ) VALUES (
        p_MaHP, p_MaCTDT
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Deletelop_module(
    IN p_maLopModule char(20)
)
BEGIN
    DELETE FROM lop_module
    WHERE
        maLopModule = p_maLopModule;
END$$
DELIMITER ;

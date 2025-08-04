DELIMITER $$
CREATE PROCEDURE Updatelop_module(
    IN p_maLopModule char(20),
    IN p_tenLopModule varchar(100),
    IN p_MaCTDT char(20),
    IN p_ghichu text
)
BEGIN
    UPDATE lop_module
    SET
    tenLopModule = p_tenLopModule,
    MaCTDT = p_MaCTDT,
    ghichu = p_ghichu
    WHERE
        maLopModule = p_maLopModule;
END$$
DELIMITER ;

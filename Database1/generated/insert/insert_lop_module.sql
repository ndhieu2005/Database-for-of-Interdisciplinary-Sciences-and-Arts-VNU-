DELIMITER $$
CREATE PROCEDURE Insertlop_module(
    IN p_maLopModule char(20),
    IN p_tenLopModule varchar(100),
    IN p_MaCTDT char(20),
    IN p_ghichu text
)
BEGIN
    INSERT INTO lop_module (
        maLopModule, tenLopModule, MaCTDT, ghichu
    ) VALUES (
        p_maLopModule, p_tenLopModule, p_MaCTDT, p_ghichu
    );
END$$
DELIMITER ;

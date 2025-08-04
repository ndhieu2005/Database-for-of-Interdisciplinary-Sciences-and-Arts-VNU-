DELIMITER $$
CREATE PROCEDURE Inserthocphan(
    IN p_MaHP char(20),
    IN p_TenHP varchar(150),
    IN p_SoTC tinyint,
    IN p_LoaiHP varchar(50),
    IN p_MoTa text
)
BEGIN
    INSERT INTO hocphan (
        MaHP, TenHP, SoTC, LoaiHP, MoTa
    ) VALUES (
        p_MaHP, p_TenHP, p_SoTC, p_LoaiHP, p_MoTa
    );
END$$
DELIMITER ;

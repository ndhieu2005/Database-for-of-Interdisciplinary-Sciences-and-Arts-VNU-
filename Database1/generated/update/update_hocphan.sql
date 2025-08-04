DELIMITER $$
CREATE PROCEDURE Updatehocphan(
    IN p_MaHP char(20),
    IN p_TenHP varchar(150),
    IN p_SoTC tinyint,
    IN p_LoaiHP varchar(50),
    IN p_MoTa text
)
BEGIN
    UPDATE hocphan
    SET
    TenHP = p_TenHP,
    SoTC = p_SoTC,
    LoaiHP = p_LoaiHP,
    MoTa = p_MoTa
    WHERE
        MaHP = p_MaHP;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Insertlopsinhvien(
    IN p_MaLopSV char(20),
    IN p_TenLopSV varchar(100),
    IN p_MaCTDT char(20),
    IN p_MaGVQL char(20),
    IN p_SiSo smallint,
    IN p_GhiChu text
)
BEGIN
    INSERT INTO lopsinhvien (
        MaLopSV, TenLopSV, MaCTDT, MaGVQL, SiSo, GhiChu
    ) VALUES (
        p_MaLopSV, p_TenLopSV, p_MaCTDT, p_MaGVQL, p_SiSo, p_GhiChu
    );
END$$
DELIMITER ;

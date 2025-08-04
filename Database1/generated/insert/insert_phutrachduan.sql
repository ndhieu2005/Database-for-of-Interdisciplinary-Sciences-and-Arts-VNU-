DELIMITER $$
CREATE PROCEDURE Insertphutrachduan(
    IN p_MaDA char(20),
    IN p_MaGV char(20),
    IN p_VaiTro varchar(50),
    IN p_NgayPhanCong date
)
BEGIN
    INSERT INTO phutrachduan (
        MaDA, MaGV, VaiTro, NgayPhanCong
    ) VALUES (
        p_MaDA, p_MaGV, p_VaiTro, p_NgayPhanCong
    );
END$$
DELIMITER ;

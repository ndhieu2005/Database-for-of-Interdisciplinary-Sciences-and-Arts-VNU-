DELIMITER $$
CREATE PROCEDURE Updatephutrachduan(
    IN p_MaDA char(20),
    IN p_MaGV char(20),
    IN p_VaiTro varchar(50),
    IN p_NgayPhanCong date
)
BEGIN
    UPDATE phutrachduan
    SET
    VaiTro = p_VaiTro,
    NgayPhanCong = p_NgayPhanCong
    WHERE
        MaDA = p_MaDA AND
        MaGV = p_MaGV;
END$$
DELIMITER ;

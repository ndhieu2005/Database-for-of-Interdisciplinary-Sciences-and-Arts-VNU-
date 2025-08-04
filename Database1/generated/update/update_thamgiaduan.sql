DELIMITER $$
CREATE PROCEDURE Updatethamgiaduan(
    IN p_MaDA char(20),
    IN p_MaSV char(20),
    IN p_VaiTro varchar(50),
    IN p_NgayBD date,
    IN p_NgayKT date,
    IN p_TrangThai varchar(50)
)
BEGIN
    UPDATE thamgiaduan
    SET
    VaiTro = p_VaiTro,
    NgayBD = p_NgayBD,
    NgayKT = p_NgayKT,
    TrangThai = p_TrangThai
    WHERE
        MaDA = p_MaDA AND
        MaSV = p_MaSV;
END$$
DELIMITER ;

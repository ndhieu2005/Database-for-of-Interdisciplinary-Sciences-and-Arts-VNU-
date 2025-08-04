DELIMITER $$
CREATE PROCEDURE Insertthamgiaduan(
    IN p_MaDA char(20),
    IN p_MaSV char(20),
    IN p_VaiTro varchar(50),
    IN p_NgayBD date,
    IN p_NgayKT date,
    IN p_TrangThai varchar(50)
)
BEGIN
    INSERT INTO thamgiaduan (
        MaDA, MaSV, VaiTro, NgayBD, NgayKT, TrangThai
    ) VALUES (
        p_MaDA, p_MaSV, p_VaiTro, p_NgayBD, p_NgayKT, p_TrangThai
    );
END$$
DELIMITER ;

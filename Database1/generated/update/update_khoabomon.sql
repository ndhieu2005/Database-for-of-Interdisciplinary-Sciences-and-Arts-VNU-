DELIMITER $$
CREATE PROCEDURE Updatekhoabomon(
    IN p_MaKhoa char(20),
    IN p_TenKhoa varchar(100),
    IN p_TruongKhoa varchar(100),
    IN p_PhoKhoa varchar(100),
    IN p_DiaChi varchar(200),
    IN p_SDT varchar(15)
)
BEGIN
    UPDATE khoabomon
    SET
    TenKhoa = p_TenKhoa,
    TruongKhoa = p_TruongKhoa,
    PhoKhoa = p_PhoKhoa,
    DiaChi = p_DiaChi,
    SDT = p_SDT
    WHERE
        MaKhoa = p_MaKhoa;
END$$
DELIMITER ;

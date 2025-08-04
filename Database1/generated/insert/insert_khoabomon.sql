DELIMITER $$
CREATE PROCEDURE Insertkhoabomon(
    IN p_MaKhoa char(20),
    IN p_TenKhoa varchar(100),
    IN p_TruongKhoa varchar(100),
    IN p_PhoKhoa varchar(100),
    IN p_DiaChi varchar(200),
    IN p_SDT varchar(15)
)
BEGIN
    INSERT INTO khoabomon (
        MaKhoa, TenKhoa, TruongKhoa, PhoKhoa, DiaChi, SDT
    ) VALUES (
        p_MaKhoa, p_TenKhoa, p_TruongKhoa, p_PhoKhoa, p_DiaChi, p_SDT
    );
END$$
DELIMITER ;

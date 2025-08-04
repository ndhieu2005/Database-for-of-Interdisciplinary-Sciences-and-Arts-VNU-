DELIMITER $$
CREATE PROCEDURE Insertgiangvien(
    IN p_MaGV char(20),
    IN p_HoTen varchar(100),
    IN p_SDT varchar(15),
    IN p_Email varchar(100),
    IN p_NgayVaoLam date,
    IN p_HocHam varchar(50),
    IN p_HocVi varchar(50),
    IN p_ChuyenMon varchar(1000),
    IN p_MaKhoa char(20)
)
BEGIN
    INSERT INTO giangvien (
        MaGV, HoTen, SDT, Email, NgayVaoLam, HocHam, HocVi, ChuyenMon, MaKhoa
    ) VALUES (
        p_MaGV, p_HoTen, p_SDT, p_Email, p_NgayVaoLam, p_HocHam, p_HocVi, p_ChuyenMon, p_MaKhoa
    );
END$$
DELIMITER ;

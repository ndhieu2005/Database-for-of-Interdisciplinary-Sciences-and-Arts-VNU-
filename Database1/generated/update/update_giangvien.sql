DELIMITER $$
CREATE PROCEDURE Updategiangvien(
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
    UPDATE giangvien
    SET
    HoTen = p_HoTen,
    SDT = p_SDT,
    Email = p_Email,
    NgayVaoLam = p_NgayVaoLam,
    HocHam = p_HocHam,
    HocVi = p_HocVi,
    ChuyenMon = p_ChuyenMon,
    MaKhoa = p_MaKhoa
    WHERE
        MaGV = p_MaGV;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Insertduan(
    IN p_MaDA char(20),
    IN p_TenDuAn varchar(150),
    IN p_MaKhoa char(20),
    IN p_MaDN char(20),
    IN p_LinhVuc varchar(100),
    IN p_TinhTrang varchar(50),
    IN p_NgayBatDau date,
    IN p_NgayKetThuc date,
    IN p_MoTa text,
    IN p_GhiChu text
)
BEGIN
    INSERT INTO duan (
        MaDA, TenDuAn, MaKhoa, MaDN, LinhVuc, TinhTrang, NgayBatDau, NgayKetThuc, MoTa, GhiChu
    ) VALUES (
        p_MaDA, p_TenDuAn, p_MaKhoa, p_MaDN, p_LinhVuc, p_TinhTrang, p_NgayBatDau, p_NgayKetThuc, p_MoTa, p_GhiChu
    );
END$$
DELIMITER ;

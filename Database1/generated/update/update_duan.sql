DELIMITER $$
CREATE PROCEDURE Updateduan(
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
    UPDATE duan
    SET
    TenDuAn = p_TenDuAn,
    MaKhoa = p_MaKhoa,
    MaDN = p_MaDN,
    LinhVuc = p_LinhVuc,
    TinhTrang = p_TinhTrang,
    NgayBatDau = p_NgayBatDau,
    NgayKetThuc = p_NgayKetThuc,
    MoTa = p_MoTa,
    GhiChu = p_GhiChu
    WHERE
        MaDA = p_MaDA;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Updatechuongtrinhdaotao(
    IN p_MaCTDT char(20),
    IN p_TenCTDT varchar(150),
    IN p_HeDaoTao varchar(50),
    IN p_TongTinChi smallint,
    IN p_MoTa text,
    IN p_MaKhoa char(20)
)
BEGIN
    UPDATE chuongtrinhdaotao
    SET
    TenCTDT = p_TenCTDT,
    HeDaoTao = p_HeDaoTao,
    TongTinChi = p_TongTinChi,
    MoTa = p_MoTa,
    MaKhoa = p_MaKhoa
    WHERE
        MaCTDT = p_MaCTDT;
END$$
DELIMITER ;

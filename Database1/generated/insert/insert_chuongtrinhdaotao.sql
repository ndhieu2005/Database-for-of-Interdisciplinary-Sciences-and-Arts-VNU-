DELIMITER $$
CREATE PROCEDURE Insertchuongtrinhdaotao(
    IN p_MaCTDT char(20),
    IN p_TenCTDT varchar(150),
    IN p_HeDaoTao varchar(50),
    IN p_TongTinChi smallint,
    IN p_MoTa text,
    IN p_MaKhoa char(20)
)
BEGIN
    INSERT INTO chuongtrinhdaotao (
        MaCTDT, TenCTDT, HeDaoTao, TongTinChi, MoTa, MaKhoa
    ) VALUES (
        p_MaCTDT, p_TenCTDT, p_HeDaoTao, p_TongTinChi, p_MoTa, p_MaKhoa
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Deletechuongtrinhdaotao(
    IN p_MaCTDT char(20)
)
BEGIN
    DELETE FROM chuongtrinhdaotao
    WHERE
        MaCTDT = p_MaCTDT;
END$$
DELIMITER ;

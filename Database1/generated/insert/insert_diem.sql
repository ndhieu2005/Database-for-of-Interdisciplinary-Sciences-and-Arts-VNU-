DELIMITER $$
CREATE PROCEDURE Insertdiem(
    IN p_MaSV char(20),
    IN p_MaLopHP char(20),
    IN p_DiemQT decimal(4,2),
    IN p_DiemGK decimal(4,2),
    IN p_DiemCK decimal(4,2),
    IN p_DiemHP decimal(4,2),
    IN p_XepLoai varchar(2)
)
BEGIN
    INSERT INTO diem (
        MaSV, MaLopHP, DiemQT, DiemGK, DiemCK, DiemHP, XepLoai
    ) VALUES (
        p_MaSV, p_MaLopHP, p_DiemQT, p_DiemGK, p_DiemCK, p_DiemHP, p_XepLoai
    );
END$$
DELIMITER ;

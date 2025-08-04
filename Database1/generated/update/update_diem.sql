DELIMITER $$
CREATE PROCEDURE Updatediem(
    IN p_MaSV char(20),
    IN p_MaLopHP char(20),
    IN p_DiemQT decimal(4,2),
    IN p_DiemGK decimal(4,2),
    IN p_DiemCK decimal(4,2),
    IN p_DiemHP decimal(4,2),
    IN p_XepLoai varchar(2)
)
BEGIN
    UPDATE diem
    SET
    DiemQT = p_DiemQT,
    DiemGK = p_DiemGK,
    DiemCK = p_DiemCK,
    DiemHP = p_DiemHP,
    XepLoai = p_XepLoai
    WHERE
        MaSV = p_MaSV AND
        MaLopHP = p_MaLopHP;
END$$
DELIMITER ;

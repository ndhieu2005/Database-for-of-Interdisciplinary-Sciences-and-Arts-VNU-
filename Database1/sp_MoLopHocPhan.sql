CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MoLopHocPhan`(
			IN p_MaHP CHAR(20),
			IN p_MaGV CHAR(20),
			IN p_MaHK CHAR(20),
			IN p_maLopModule CHAR(20),
			IN p_SiSoToiDA SMALLINT,
			
			OUT p_MaLopHP_TaoRa VARCHAR(50) -- Tham số OUT để trả về kết quả
)
BEGIN
		-- ..(Toàn bộ phần khai báo biển và kiểm tra nghiệm vụ giữ nguyên)...
		DECLARE v_SoThuTu INT;
		DECLARE v_SoThuTuFormatted CHAR(2);
		DECLARE v_MalopHP_Generated VARCHAR(50);
		-- Khai báo biến kiểm soát lỗi
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
				ROLLBACK;
				RESIGNAL;
		END;
		
		START TRANSACTION;
		-- ===VALIDATION: KIỂM TRA TOÀN BỘ NGHIỆP VỤ ===

		IF NOT EXISTS(SELECT 1 FROM hocphan WHERE MaHP = p_MaHP) THEN
				ROLLBACK;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma hoc phan khong ton tai.';
		ELSEIF NOT EXISTS(SELECT 1 FROM giangvien WHERE MaGV = p_MaGV) THEN
				ROLLBACK;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma giang vien khong ton tai.';
		ELSEIF NOT EXISTS(SELECT 1 FROM hocky WHERE MaHK = p_MaHK) THEN
				ROLLBACK;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma hoc ky khong ton tai.';
		ELSEIF NOT EXISTS(SELECT 1 FROM lop_module WHERE maLopModule = p_maLopModule) THEN
				ROLLBACK;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma lop module khong ton tai.';
		ELSEIF p_SiSoToiDa <= 0 THEN
				ROLLBACK;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Si so toi da phai la so duong.';
		-- Logic THỰC THI
		ELSE
				-- Logic sinh mã
        SELECT COUNT(*) + 1 INTO v_SoThuTu 
        FROM lophp 
        WHERE MaLopHP LIKE CONCAT(p_MaHP, '_', p_MaHK, '_%');
        
        SET v_SoThuTuFormatted = LPAD(v_SoThuTu, 2, '0');
        SET v_MaLopHP_Generated = CONCAT(p_MaHP, '_', p_MaHK, '_', v_SoThuTuFormatted);

        -- Thực thi INSERT
        INSERT INTO lophp (
            MaLopHP, MaHP, MaGV, SiSo, maLopModule
        ) VALUES (
            v_MaLopHP_Generated, p_MaHP, p_MaGV, p_SiSoToiDa, p_maLopModule
        );
        -- Gán mã vừa tạo vào tham số OUT
        SET p_MaLopHP_TaoRa = v_MaLopHP_Generated;       
        -- Chỉ COMMIT khi mọi thứ thành công
        COMMIT;
    END IF;
END
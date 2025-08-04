CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TaoLopSinhVien`(
		IN p_NamHoc INT,
		IN p_MaCTDT CHAR(20),
		IN p_MaGVQL CHAR(20),
		IN p_SiSo INT,
		IN p_SoThuTuLop TINYINT,
		IN p_GhiChu TEXT
)
BEGIN 
	-- Khai báo biến cục bộ để lưu mã và tên lớp được sinh ra
	DECLARE v_MaLopSVGenerated CHAR(20);
	DECLARE v_TenLopSVGenerated VARCHAR(100);
	DECLARE v_SoThuTuFormatted CHAR (02);
	-- Khai báo biến để xứ lý lỗi,nếu có lỗi SQL xảy ra, hủy bỏ tất cả thay đổi
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
			ROLLBACK;
			RESIGNAL;
	END;
	
	START TRANSACTION;
	-- Sinh mã lớp sinh viên và tên lớp sinh viên theo format 
	SET v_SoThuTuFormatted = LPAD (p_SoThuTuLop, 2, '0');
	SET v_MaLopSVGenerated = CONCAT('LSV', p_NamHoc, p_MaCTDT, v_SoThuTuFormatted);
	SET v_TenLopSVGenerated = CONCAT('Lớp ', p_MaCTDT, ' - Khóa ', p_NamHoc , ' - Lớp số ', p_SoThuTuLop);	

    -- Kiểm tra nghiệp vụ 
		-- 1. Kiểm tra xem Mã lớp sinh viên vừa sinh ra đã tồn tại hay chưa
			IF EXISTS(SELECT 1 FROM lopsinhvien WHERE MaLopSV = v_MaLopSVGenerated) THEN
				ROLLBACK;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Loi: Ma lop sinh vien nay da ton tai trong he thong.";
		-- 2. Kiểm tra tính hợp lệ của Mã chương trình đào tạo 
			ELSEIF NOT EXISTS(SELECT 1 FROM chuongtrinhdaotao WHERE MaCTDT = p_MaCTDT) THEN
			ROLLBACK;
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma chuong trinh dao tao khong hop le.';
  -- 3. Kiểm tra tính hợp lệ của Mã giảng viên chủ nhiệm
	  ElSEIF NOT EXISTS(SELECT 1 FROM giangvien WHERE MaGV = p_MaGVQL) THEN
				ROLLBACK;
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma giang vien khong hop le.';
	  -- 4. Kiểm tra xem Sí số phải là một số dương không
			ELSEIF p_SiSo <= 0 THEN
					ROLLBACK;
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Si so phai la mot so nguyen duong.';
		-- 5. Kiểm tra số thứ tự lớp có trong khoảng cho phép không
		ELSEIF p_SoThuTuLop NOT BETWEEN 1 AND 10 THEN
				ROLLBACK;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: So thu tu lop chi duoc phep tu 01 den 04.';
		
		-- Thực thi thêm mới --
		ELSE 
				-- Nếu tất cả điều kiện đều hợp lệ , tiến hành chèn dữ liệu
				INSERT INTO LopSinhVien(MaLopSV, TenLopSV, MaCTDT, MaGVQL, SiSo, GhiChu)
				VALUES (v_MaLopSVGenerated, v_TenLopSVGenerated, p_MaCTDT, p_MaGVQL, p_SiSo, p_GhiChu);
				
				COMMIT;
		END IF;
		
END
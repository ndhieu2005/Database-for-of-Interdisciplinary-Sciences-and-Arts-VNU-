CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_PhanBoTanSinhVien`(
		IN p_MaCTDT CHAR(20)
)
proc_main_label:BEGIN	-- Đặt một nhãn cho khối BEGIN chính của procedure		
-- Khai báo biến cục bộ
    DECLARE v_so_tan_sinh_vien INT DEFAULT 0;
    DECLARE v_so_lop_trong INT DEFAULT 0;
    DECLARE v_tong_suc_chua INT DEFAULT 0;
    DECLARE v_student_index INT DEFAULT 0;
    DECLARE v_target_class_id INT;
    DECLARE v_target_malopsv CHAR(20);
    
    -- Biến cho con trỏ --
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_current_masv CHAR(20);
    
    -- Con trò để lặp qua danh sách tân sinh viên đã được sắp xếp
    DECLARE cur_students CURSOR FOR
		    SELECT MaSV
		    FROM sinhvien
		    WHERE MaCTDT = p_MaCTDT AND (MaLopSV IS NULL OR MaLopSV = '')
			ORDER BY SUBSTRING_INDEX(HoTen, ' ', -1), HoTen; -- Sắp xếp theo Tên, sau đó đến cả họ tên
        
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN 
				ROLLBACK;
				DROP TEMPORARY TABLE IF EXISTS TempEmptyClasses;
				RESIGNAL;
		END;
		
		-- Kiểm tra điều kiện ban đầu -- 
		SELECT COUNT(*) INTO v_so_tan_sinh_vien
		FROM sinhvien
		WHERE MaCTDT = p_MaCTDT AND (MaLopSV IS NULL OR MaLopSV = '');
		
		IF v_so_tan_sinh_vien = 0 THEN
				SELECT 'Khong co tan sinh vien nao can phan lop' AS ThongBao;
				LEAVE proc_main_label;
		END IF;
		
		-- Tạo và chèn dữ liệu vào bảng tạm
		CREATE TEMPORARY TABLE TempEmptyClasses(
				id INT AUTO_INCREMENT PRIMARY KEY,
				MaLopSV CHAR(20),
				SiSo INT
		);
		
		INSERT INTO TempEmptyClasses (MaLopSV, SiSo)
		SELECT lsv.MaLopSV, lsv.SiSo
		FROM lopsinhvien lsv
		LEFT JOIN sinhvien sv ON lsv.MaLopSV = sv.MaLopSV
		WHERE lsv.MaCTDT = p_MaCTDT
		GROUP BY lsv.MaLopSV, lsv.SiSo
		HAVING COUNT(sv.MaSV) = 0;
    
	  -- Kiểm tra số lớp trống và sức chứa
		SELECT COUNT(*), IFNULL(SUM(SiSo),0) INTO v_so_lop_trong, v_tong_suc_chua
		FROM TempEmptyClasses;
	  
		IF v_so_lop_trong = 0 THEN
			DROP TEMPORARY TABLE TempEmptyClasses;
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Khong tim thay lop trong nao.';
		END IF;
		IF v_so_tan_sinh_vien > v_tong_suc_chua THEN
			DROP TEMPORARY TABLE TempEmptyClasses;
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Suc chua khong du.';
		END IF;
    
    -- Bắt đầu TRANSACTIONS và phân bổ:
		START TRANSACTION;
    /*Thuật toán hoạt động như cách chia một bộ bài một cách công bằng:

	Gom và Sắp xếp: Gom tất cả sinh viên chưa có lớp thành một cỗ bài, rồi sắp xếp 
	cỗ bài này theo thứ tự tên từ A đến Z.
	Xếp lớp: Xếp tất cả các lớp học còn trống thành một hàng.
	Chia bài: Lần lượt chia từng sinh viên cho từng lớp trong hàng. Khi đến lớp cuối
	cùng, nó quay lại lớp đầu tiên và tiếp tục chia cho đến khi hết sinh viên.
	Kết quả: Mỗi lớp nhận được một lượng sinh viên gần bằng nhau với tên được phân bổ đều
	,tránh tình trạng một lớp toàn tên bắt đầu bằng chữ A, lớp khác toàn tên bắt đầu bằng 
	chữ Z.*/
		
		OPEN cur_students;
    -- Tạo 1 vòng lặp để thêm từng sinh viên vào các lớp
		student_loop: LOOP
		    FETCH cur_students INTO v_current_masv;
		    IF v_done THEN
				LEAVE student_loop;
			END IF;
				
			SET v_target_class_id = (v_student_index % v_so_lop_trong) + 1;
			SELECT MaLopSV INTO v_target_malopsv FROM TempEmptyClasses WHERE id = v_target_class_id;
			UPDATE sinhvien 
			SET MaLopSV = v_target_malopsv 
			WHERE MaSV = v_current_masv;
        
			SET v_student_index = v_student_index + 1;  
    END LOOP;
    
    CLOSE cur_students;
    
    COMMIT;
    
    DROP TEMPORARY TABLE TempEmptyClasses;
    
    SELECT CONCAT('Da phan bo thanh cong ', v_so_tan_sinh_vien, ' sinh vien vao ', v_so_lop_trong, ' lop.') AS KetQua;

END
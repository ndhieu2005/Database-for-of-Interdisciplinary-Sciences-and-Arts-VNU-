CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TuDongMoVaPhanBoLopHP`(
    IN p_MaHP CHAR(20),
    IN p_MaHK CHAR(20),
    IN p_maLopModule CHAR(20),
    IN p_DanhSachMaLopSV TEXT,
    IN p_SiSoToiDa_MoiLopHP SMALLINT,
    IN p_MaGV_PhuTrach CHAR(20)
)
proc_main_label: BEGIN
    -- Khai báo biến
    DECLARE v_tong_siso_canhoc INT DEFAULT 0;
    DECLARE v_so_lophp_canmo INT DEFAULT 0;
    DECLARE v_loop_counter INT DEFAULT 0;
    DECLARE v_ma_lophp_moi VARCHAR(50);
    
    DECLARE v_remaining_list TEXT;
    DECLARE v_current_malopsv VARCHAR(255);
    DECLARE v_lopsv_index INT DEFAULT 0;
    DECLARE v_target_lophp_id INT;
    
    -- Khai báo trình xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS TempNewLopHP;
        RESIGNAL;
    END;
    
    -- Bắt đầu Transaction lớn
    START TRANSACTION;
    
    -- Bước 1: Tính toán số lượng
    SET v_remaining_list = p_DanhSachMaLopSV;
    temp_loop: WHILE CHAR_LENGTH(v_remaining_list) > 0 DO
        SET v_current_malopsv = SUBSTRING_INDEX(v_remaining_list, ',', 1);
        -- Sửa lại tên bảng thành `lopsinhvien`
        SELECT v_tong_siso_canhoc + SiSo INTO v_tong_siso_canhoc
        FROM lopsinhvien WHERE MaLopSV = v_current_malopsv;
        
        IF LOCATE(',', v_remaining_list) > 0 THEN
            SET v_remaining_list = SUBSTRING(v_remaining_list, LOCATE(',', v_remaining_list) + 1);
        ELSE
            SET v_remaining_list = '';
        END IF;
    END WHILE temp_loop;
    
    IF v_tong_siso_canhoc = 0 THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khong co sinh vien nao trong danh sach lop da cung cap.';
    END IF;
    
    SET v_so_lophp_canmo = CEIL(v_tong_siso_canhoc / p_SiSoToiDa_MoiLopHP);
    
    IF v_so_lophp_canmo = 0 THEN
        SELECT 'Khong can mo lop hoc phan nao.' as ThongBao;
        COMMIT;
        -- Sửa lại lệnh LEAVE để thoát khỏi khối lệnh có nhãn
        LEAVE proc_main_label;
    END IF;
    
    -- Bước 2: Tự động mở lớp học phần
    CREATE TEMPORARY TABLE TempNewLopHP(
        id INT AUTO_INCREMENT PRIMARY KEY,
        MaLopHP VARCHAR(50)
    );
    
    SET v_loop_counter = 0;
    -- Sửa lại lỗi chính tả tên biến
    open_loop: WHILE v_loop_counter < v_so_lophp_canmo DO
        CALL sp_MoLopHocPhan(
            p_MaHP, p_MaGV_PhuTrach, p_MaHK, p_maLopModule, p_SiSoToiDa_MoiLopHP, 
            v_ma_lophp_moi
        );
        INSERT INTO TempNewLopHP (MaLopHP) VALUES (v_ma_lophp_moi);
        SET v_loop_counter = v_loop_counter + 1;
    END WHILE open_loop;
    
    -- Bước 3: Tự động phân bổ lớp sinh viên
    SET v_remaining_list = p_DanhSachMaLopSV;
    distribution_loop: WHILE CHAR_LENGTH(v_remaining_list) > 0 DO
        SET v_current_malopsv = SUBSTRING_INDEX(v_remaining_list, ',', 1);
        
        -- Thêm lại logic tính toán bị thiếu
        SET v_target_lophp_id = (v_lopsv_index % v_so_lophp_canmo) + 1;
        
        SELECT MaLopHP INTO v_ma_lophp_moi FROM TempNewLopHP WHERE id = v_target_lophp_id;

        INSERT INTO phanlopsv_lophp(MaLopHP, MaLopSV) VALUES (v_ma_lophp_moi, v_current_malopsv);

        SET v_lopsv_index = v_lopsv_index + 1;

        IF LOCATE(',', v_remaining_list) > 0 THEN
            SET v_remaining_list = SUBSTRING(v_remaining_list, LOCATE(',', v_remaining_list) + 1);
        ELSE
            SET v_remaining_list = '';
        END IF;
    END WHILE distribution_loop;

    -- Dọn dẹp
    DROP TEMPORARY TABLE TempNewLopHP;
    COMMIT;

    SELECT CONCAT('Da tu dong mo thanh cong ', v_so_lophp_canmo, ' lop hoc phan va phan bo cac lop sinh vien.') AS KetQua;
    
END proc_main_label
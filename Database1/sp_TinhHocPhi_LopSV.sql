CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TinhHocPhi_LopSV`(
		IN p_MaLopSV CHAR(20),
		IN p_MaHK CHAR(20)
)
BEGIN
	-- Khai báo các biến
	DECLARE v_TongSoTinChi INT DEFAULT 0;
	DECLARE v_DonGiaTinChi DECIMAL (15,2) DEFAULT 550000.00;
 	DECLARE v_HocPhi_MotSV DECIMAL(15, 2);
 	DECLARE v_SiSo_Lop INT;
 	DECLARE v_TongHocPhi_CaLop DECIMAL(15, 2);
 	DECLARE v_TenLopSV VARCHAR(100);

 	-- Lấy sĩ số và tên lớp sinh viên
 	SELECT SiSo, TenLopSV INTO v_SiSo_Lop, v_TenLopSV
 	FROM lopsinhvien
 	WHERE MaLopSV = p_MaLopSV;

 	-- Kiểm tra lớp sinh viên có tồn tại không
 	IF v_SiSo_Lop IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma lop sinh vien khong ton tai.';
	END IF;

	-- Kiểm tra học kỳ có tồn tại không
	IF NOT EXISTS(SELECT 1 FROM hocky WHERE MaHK = p_MaHK) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma hoc ky khong ton tai.';
	END IF;

	-- Tính toán tổng số tín chỉ mà lớp sinh viên này học trong học kỳ
	-- Lọc theo MaHK trực tiếp từ bảng lophp
	SELECT IFNULL(SUM(hp.SoTC),0) INTO v_TongSoTinChi
	FROM phanlopsv_lophp AS pl
	INNER JOIN lophp ON pl.MaLopHP = lophp.MaLopHP
	INNER JOIN hocphan AS hp ON lophp.MaHP = hp.MaHP
	WHERE
		pl.MaLopSV = p_MaLopSV -- Lọc theo lớp sinh viên
 		AND lophp.MaHK = p_MaHK; -- Lọc trực tiếp theo mã học kỳ (giả định cột MaHK tồn tại trong bảng lophp)

 	-- Tính học phí cho một sinh viên
 	SET v_HocPhi_MotSV = v_TongSoTinChi * v_DonGiaTinChi;

	-- Tính tổng học phí dự kiến cho cả lớp
	SET v_TongHocPhi_CaLop = v_HocPhi_MotSV * v_SiSo_Lop;

	-- TRẢ VỀ KẾT QUẢ BÁO CÁO
	SELECT
		p_MaLopSV AS Ma_Lop_Sinh_Vien,
		v_TenLopSV AS Ten_Lop,
		p_MaHK AS Hoc_Ky,
		v_SiSo_Lop AS Si_So,
		v_TongSoTinChi AS Tong_Tin_Chi_Moi_SV,
		v_DonGiaTinChi AS Don_Gia_Tin_Chi,
		v_HocPhi_MotSV AS Hoc_Phi_Moi_SV,
		v_TongHocPhi_CaLop AS Tong_Hoc_Phi_Ca_Lop;
END
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_XuatBangDiemGPA_HocKy`(
    IN p_MaLopSV CHAR(20),
    IN p_MaHK CHAR(20)
)
BEGIN
IF NOT EXISTS(SELECT 1 FROM lopsinhvien WHERE MaLopSV = p_MaLopSV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma lop sinh vien khong ton tai.';
    END IF;

    -- Kiểm tra học kỳ có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM hocky WHERE MaHK = p_MaHK) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Ma hoc ky khong ton tai.';
    END IF;

    SELECT
        sv.MaSV AS 'Mã Sinh Viên',
        sv.HoTen AS 'Họ và Tên',

        -- Tính tổng số tín chỉ trong học kỳ
        IFNULL(SUM(hp.SoTC), 0) AS 'Tổng Tín Chỉ HK',

        -- Tính điểm GPA của học kỳ
        -- Công thức: SUM(Điểm hệ 4 * Tín chỉ) / SUM(Tín chỉ)
        -- Dùng NULLIF để tránh lỗi chia cho 0 nếu sinh viên không có tín chỉ nào
        ROUND(
            SUM(
                CASE
                    WHEN d.DiemHP >= 8.5 THEN 4.0
                    WHEN d.DiemHP >= 8.0 THEN 3.5
                    WHEN d.DiemHP >= 7.0 THEN 3.0
                    WHEN d.DiemHP >= 6.5 THEN 2.5
                    WHEN d.DiemHP >= 5.5 THEN 2.0
                    WHEN d.DiemHP >= 5.0 THEN 1.5
                    WHEN d.DiemHP >= 4.0 THEN 1.0
                    ELSE 0.0
                END * hp.SoTC
            ) / NULLIF(SUM(hp.SoTC), 0)
        , 2) AS 'GPA Học Kỳ',

        -- Xếp loại học lực dựa trên GPA học kỳ
        CASE
            WHEN ROUND(
                     SUM(
                         CASE
                             WHEN d.DiemHP >= 8.5 THEN 4.0
                             WHEN d.DiemHP >= 8.0 THEN 3.5
                             WHEN d.DiemHP >= 7.0 THEN 3.0
                             WHEN d.DiemHP >= 6.5 THEN 2.5
                             WHEN d.DiemHP >= 5.5 THEN 2.0
                             WHEN d.DiemHP >= 5.0 THEN 1.5
                             WHEN d.DiemHP >= 4.0 THEN 1.0
                             ELSE 0.0
                         END * hp.SoTC
                     ) / NULLIF(SUM(hp.SoTC), 0)
                 , 2) >= 3.6 THEN 'Xuất sắc'
            WHEN ROUND(
                     SUM(
                         CASE
                             WHEN d.DiemHP >= 8.5 THEN 4.0
                             WHEN d.DiemHP >= 8.0 THEN 3.5
                             WHEN d.DiemHP >= 7.0 THEN 3.0
                             WHEN d.DiemHP >= 6.5 THEN 2.5
                             WHEN d.DiemHP >= 5.5 THEN 2.0
                             WHEN d.DiemHP >= 5.0 THEN 1.5
                             WHEN d.DiemHP >= 4.0 THEN 1.0
                             ELSE 0.0
                         END * hp.SoTC
                     ) / NULLIF(SUM(hp.SoTC), 0)
                 , 2) >= 3.2 THEN 'Giỏi'
            WHEN ROUND(
                     SUM(
                         CASE
                             WHEN d.DiemHP >= 8.5 THEN 4.0
                             WHEN d.DiemHP >= 8.0 THEN 3.5
                             WHEN d.DiemHP >= 7.0 THEN 3.0
                             WHEN d.DiemHP >= 6.5 THEN 2.5
                             WHEN d.DiemHP >= 5.5 THEN 2.0
                             WHEN d.DiemHP >= 5.0 THEN 1.5
                             WHEN d.DiemHP >= 4.0 THEN 1.0
                             ELSE 0.0
                         END * hp.SoTC
                     ) / NULLIF(SUM(hp.SoTC), 0)
                 , 2) >= 2.5 THEN 'Khá'
            WHEN ROUND(
                     SUM(
                         CASE
                             WHEN d.DiemHP >= 8.5 THEN 4.0
                             WHEN d.DiemHP >= 8.0 THEN 3.5
                             WHEN d.DiemHP >= 7.0 THEN 3.0
                             WHEN d.DiemHP >= 6.5 THEN 2.5
                             WHEN d.DiemHP >= 5.5 THEN 2.0
                             WHEN d.DiemHP >= 5.0 THEN 1.5
                             WHEN d.DiemHP >= 4.0 THEN 1.0
                             ELSE 0.0
                         END * hp.SoTC
                     ) / NULLIF(SUM(hp.SoTC), 0)
                 , 2) >= 2.0 THEN 'Trung bình'
            WHEN ROUND(
                     SUM(
                         CASE
                             WHEN d.DiemHP >= 8.5 THEN 4.0
                             WHEN d.DiemHP >= 8.0 THEN 3.5
                             WHEN d.DiemHP >= 7.0 THEN 3.0
                             WHEN d.DiemHP >= 6.5 THEN 2.5
                             WHEN d.DiemHP >= 5.5 THEN 2.0
                             WHEN d.DiemHP >= 5.0 THEN 1.5
                             WHEN d.DiemHP >= 4.0 THEN 1.0
                             ELSE 0.0
                         END * hp.SoTC
                     ) / NULLIF(SUM(hp.SoTC), 0)
                 , 2) >= 1.0 THEN 'Yếu'
            ELSE 'Kém'
        END AS 'Xếp Loại'

    FROM sinhvien sv

    -- Dùng LEFT JOIN để đảm bảo sinh viên nào trong lớp cũng xuất hiện, kể cả khi chưa có điểm
    LEFT JOIN diem d ON sv.MaSV = d.MaSV
    LEFT JOIN lophp lp ON d.MaLopHP = lp.MaLopHP
        -- Sửa lỗi: Lọc các lớp học phần thuộc đúng học kỳ ngay tại điều kiện JOIN
        AND lp.MaHK = p_MaHK -- Lọc trực tiếp theo mã học kỳ (giả định cột MaHK tồn tại trong bảng lophp)
    LEFT JOIN hocphan hp ON lp.MaHP = hp.MaHP

    WHERE sv.MaLopSV = p_MaLopSV

    -- Gom nhóm theo từng sinh viên để các hàm SUM hoạt động đúng
    GROUP BY sv.MaSV, sv.HoTen

    -- Sắp xếp kết quả theo tên cho dễ nhìn
    ORDER BY sv.HoTen;
END
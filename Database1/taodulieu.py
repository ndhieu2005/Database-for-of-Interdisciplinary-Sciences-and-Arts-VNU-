import mysql.connector
import random
from datetime import date, timedelta
import sys

# ==============================================================================
# BƯỚC QUAN TRỌNG: ĐIỀN THÔNG TIN KẾT NỐI DATABASE CỦA BẠN
# ==============================================================================
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '2005',
    'database': 'sis_db'
}

# ==============================================================================
# CẤU HÌNH SỐ LƯỢNG DỮ LIỆU CẦN TẠO
# ==============================================================================
SO_DONG_PHANLOP = 5000      # Số lượng phân lớp cho sinh viên vào lớp học phần
SO_DONG_THAMGIA_DA = 10000  # Số lượng sinh viên tham gia dự án
SO_DONG_MOI_INSERT = 1000   # Chia thành nhiều lệnh INSERT nhỏ để tránh lỗi

# ==============================================================================
# PHẦN LOGIC (Đã sửa lỗi)
# ==============================================================================

def lay_du_lieu_tu_db(config, query, ten_bang):
    """Hàm để kết nối DB, chạy query và trả về danh sách kết quả."""
    print(f"Đang lấy dữ liệu bảng {ten_bang}...")
    try:
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        flat_list = [item[0] for item in results]
        print(f"-> OK: Tìm thấy {len(flat_list)} bản ghi.")
        return flat_list
    except mysql.connector.Error as err:
        print(f"-> LỖI: Không thể kết nối hoặc truy vấn bảng {ten_bang}. Lỗi: {err}")
        return None
    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()

def tao_du_lieu_phanlop(so_dong, ds_lop_sv, ds_lop_hp):
    """Tạo dữ liệu cho bảng PhanLopSV_LopHP."""
    print(f"\nBắt đầu tạo {so_dong} dòng dữ liệu cho PhanLopSV_LopHP...")
    generated_pairs = set()
    data_rows = []
    phong_hoc_list = [f'P{random.randint(101, 505)}' for _ in range(20)] + ['Online']
    ca_hoc_list = [('07:00:00', '09:00:00'), ('09:15:00', '11:15:00'), ('13:00:00', '15:00:00'), ('15:15:00', '17:15:00')]

    while len(data_rows) < so_dong and len(generated_pairs) < len(ds_lop_sv) * len(ds_lop_hp):
        ma_lop_sv = random.choice(ds_lop_sv)
        ma_lop_hp = random.choice(ds_lop_hp)

        if (ma_lop_sv, ma_lop_hp) in generated_pairs:
            continue
        generated_pairs.add((ma_lop_sv, ma_lop_hp))

        phong_hoc = random.choice(phong_hoc_list)
        thu = random.randint(2, 7) # Thứ 2 đến Thứ 7
        gio_bd, gio_kt = random.choice(ca_hoc_list)
        
        data_rows.append({
            'MaLopSV': ma_lop_sv, 'MaLopHP': ma_lop_hp, 'PhongHoc': phong_hoc,
            'Thu': thu, 'GioBD': gio_bd, 'GioKT': gio_kt, 'GhiChu': None
        })
    return data_rows

def tao_du_lieu_thamgia_da(so_dong, ds_sv, ds_da):
    """Tạo dữ liệu cho bảng ThamGiaDuAn."""
    print(f"\nBắt đầu tạo {so_dong} dòng dữ liệu cho ThamGiaDuAn...")
    generated_pairs = set()
    data_rows = []
    vai_tro_list = ['Thành viên nghiên cứu', 'Trợ lý', 'Thực tập sinh', 'Nhóm trưởng']
    trang_thai_list = ['Đang thực hiện', 'Hoàn thành', 'Đã hủy']
    
    start_date_range = date(2023, 1, 1)
    end_date_range = date(2025, 1, 1)
    time_delta = end_date_range - start_date_range
    total_days = time_delta.days

    while len(data_rows) < so_dong and len(generated_pairs) < len(ds_sv) * len(ds_da):
        ma_sv = random.choice(ds_sv)
        ma_da = random.choice(ds_da)

        if (ma_da, ma_sv) in generated_pairs:
            continue
        generated_pairs.add((ma_da, ma_sv))

        vai_tro = random.choice(vai_tro_list)
        trang_thai = random.choices(trang_thai_list, weights=[7, 12, 1], k=1)[0]
        
        ngay_bd = start_date_range + timedelta(days=random.randint(0, total_days))
        ngay_kt = ngay_bd + timedelta(days=random.randint(90, 365))

        data_rows.append({
            'MaDA': ma_da, 'MaSV': ma_sv, 'VaiTro': vai_tro,
            'NgayBD': ngay_bd.strftime('%Y-%m-%d'), 'NgayKT': ngay_kt.strftime('%Y-%m-%d'), 'TrangThai': trang_thai
        })
    return data_rows

def ghi_ra_file_sql(ten_bang, ten_file, ds_cot, ds_dong):
    """Ghi dữ liệu ra file .sql với các lệnh INSERT theo lô."""
    print(f"\nBắt đầu ghi ra file {ten_file}...")
    cot_str = ", ".join(ds_cot)
    with open(ten_file, 'w', encoding='utf-8') as f:
        for i in range(0, len(ds_dong), SO_DONG_MOI_INSERT):
            batch = ds_dong[i:i + SO_DONG_MOI_INSERT]
            f.write(f"INSERT INTO {ten_bang}({cot_str}) VALUES\n")
            
            values_list = []
            for row in batch:
                row_values = []
                for cot in ds_cot:
                    val = row.get(cot)
                    if val is None:
                        row_values.append("NULL")
                    elif isinstance(val, (int, float)):
                        row_values.append(str(val))
                    else:
                        # DÒNG ĐÃ SỬA LỖI
                        row_values.append(f"'{str(val).replace("'", "''")}'")
                values_list.append(f"({', '.join(row_values)})")
            
            f.write(",\n".join(values_list))
            f.write(";\n\n")
    print(f"-> OK: Đã tạo file '{ten_file}' với {len(ds_dong)} dòng dữ liệu.")

# --- CHƯƠNG TRÌNH CHÍNH ---
if __name__ == "__main__":
    # Lấy dữ liệu khóa ngoại từ DB
    ds_lop_sv = lay_du_lieu_tu_db(db_config, "SELECT MaLopSV FROM LopSinhVien", "LopSinhVien")
    ds_lop_hp = lay_du_lieu_tu_db(db_config, "SELECT MaLopHP FROM LopHP", "LopHP")
    ds_sv = lay_du_lieu_tu_db(db_config, "SELECT MaSV FROM SinhVien", "SinhVien")
    ds_da = lay_du_lieu_tu_db(db_config, "SELECT MaDA FROM DuAn", "DuAn")

    if not all([ds_lop_sv, ds_lop_hp, ds_sv, ds_da]):
        print("\nKhông thể tiếp tục vì thiếu dữ liệu đầu vào từ một hoặc nhiều bảng. Hãy đảm bảo các bảng đó có dữ liệu.")
        sys.exit()

    # Tạo dữ liệu fake
    data_phanlop = tao_du_lieu_phanlop(SO_DONG_PHANLOP, ds_lop_sv, ds_lop_hp)
    data_thamgia_da = tao_du_lieu_thamgia_da(SO_DONG_THAMGIA_DA, ds_sv, ds_da)

    # Ghi ra file SQL
    ghi_ra_file_sql(
        'PhanLopSV_LopHP', 
        'du_lieu_phanlopsv_lophp.sql',
        ['MaLopSV', 'MaLopHP', 'PhongHoc', 'Thu', 'GioBD', 'GioKT', 'GhiChu'],
        data_phanlop
    )
    ghi_ra_file_sql(
        'ThamGiaDuAn',
        'du_lieu_thamgiaduan.sql',
        ['MaDA', 'MaSV', 'VaiTro', 'NgayBD', 'NgayKT', 'TrangThai'],
        data_thamgia_da
    )

    print("\nHoàn tất cả hai file!")
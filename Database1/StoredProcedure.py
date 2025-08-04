# -*- coding: utf-8 -*-
import os
import pymysql
from jinja2 import Environment, BaseLoader

# ==========================
# 1. Cấu hình kết nối MySQL
# ==========================
MYSQL_HOST = 'localhost'       # Địa chỉ máy chủ MySQL
MYSQL_USER = 'root'            # Tên user
MYSQL_PASS = '2005'            # Mật khẩu
MYSQL_DB   = 'sis_db'          # Tên database

# ============================================
# 2. Kết nối vào MySQL và khởi tạo con trỏ (cursor)
# ============================================
conn = pymysql.connect(
    host=MYSQL_HOST,
    user=MYSQL_USER,
    password=MYSQL_PASS,
    database=MYSQL_DB,
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor
)
cursor = conn.cursor()

# ===================================
# 3. Định nghĩa template CRUD với Jinja2
# ===================================
# Bật tiện ích mở rộng 'do' cho Jinja2
env = Environment(loader=BaseLoader(), extensions=['jinja2.ext.do'])
# Filter để thêm tiền tố vào tên biến
env.filters['prepend'] = lambda value, prefix: prefix + value

# Template cho Insert, Update, Delete (không tạo Select ở đây)
templates = {
    'insert': """
DELIMITER $$
CREATE PROCEDURE Insert{{table_name}}(
{%- for col in columns %}
    IN p_{{col.name}} {{col.type}}{{ "," if not loop.last }}
{%- endfor %}
)
BEGIN
    INSERT INTO {{table_name}} (
        {{ columns|map(attribute='name')|join(', ') }}
    ) VALUES (
        {{ columns|map(attribute='name')|map('prepend','p_')|join(', ') }}
    );
END$$
DELIMITER ;
""",
    'update': """
DELIMITER $$
CREATE PROCEDURE Update{{table_name}}(
{%- for col in columns %}
    IN p_{{col.name}} {{col.type}}{{ "," if not loop.last }}
{%- endfor %}
)
BEGIN
    UPDATE {{table_name}}
    SET
    {%- set set_clause_cols = [] %}
    {%- for col in columns if col.name not in pk_names %}
        {%- do set_clause_cols.append(col.name ~ ' = p_' ~ col.name) %}
    {%- endfor %}
    {{ set_clause_cols | join(',\n    ') }}
    WHERE
    {%- for pk_col in pks %}
        {{pk_col.name}} = p_{{pk_col.name}}{{ " AND" if not loop.last }}
    {%- endfor %};
END$$
DELIMITER ;
""",
    'delete': """
DELIMITER $$
CREATE PROCEDURE Delete{{table_name}}(
{%- for pk_col in pks %}
    IN p_{{pk_col.name}} {{pk_col.type}}{{ "," if not loop.last }}
{%- endfor %}
)
BEGIN
    DELETE FROM {{table_name}}
    WHERE
    {%- for pk_col in pks %}
        {{pk_col.name}} = p_{{pk_col.name}}{{ " AND" if not loop.last }}
    {%- endfor %};
END$$
DELIMITER ;
"""
}

# ====================================
# 4. Tạo thư mục đầu ra cho từng loại
# ====================================
base_dir = 'generated'
for action in templates.keys():
    dir_path = os.path.join(base_dir, action)
    os.makedirs(dir_path, exist_ok=True)

# ====================================
# 5. Đọc danh sách bảng trong database
# ====================================
cursor.execute("""
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = %s
      AND table_type = 'BASE TABLE';
""", (MYSQL_DB,))
tables = [row['TABLE_NAME'] for row in cursor.fetchall()]


# ====================================
# 6. Với mỗi bảng, lấy metadata và sinh file
# ====================================
for tbl in tables:
    # Lấy cột, kiểu, và xác định khóa chính
    cursor.execute("""
        SELECT column_name, column_type, column_key
        FROM information_schema.columns
        WHERE table_schema = %s
          AND table_name = %s
        ORDER BY ordinal_position;
    """, (MYSQL_DB, tbl))
    cols = []
    pks = [] # Thay đổi: pk bây giờ là một danh sách (list)
    pk_names = set() # Để lưu trữ tên các cột khóa chính nhanh chóng

    for row in cursor.fetchall():
        cols.append({'name': row['COLUMN_NAME'], 'type': row['COLUMN_TYPE']})
        if row['COLUMN_KEY'] == 'PRI':
            pks.append({'name': row['COLUMN_NAME'], 'type': row['COLUMN_TYPE']})
            pk_names.add(row['COLUMN_NAME']) # Thêm tên vào set

    # Bỏ qua bảng không có primary key (hoặc composite primary key)
    if not pks:
        print(f"Bỏ qua bảng '{tbl}' vì không có khóa chính.")
        continue

    # Chuẩn bị context cho template
    context = {
        'table_name': tbl,
        'columns': cols,
        'pks': pks, # Thay đổi: truyền danh sách pks
        'pk_names': pk_names # Truyền tập hợp tên khóa chính
    }

    # Render và ghi file cho từng action
    for action, tpl in templates.items():
        # Đảm bảo chỉ tạo update/delete nếu có PK(s)
        if (action == 'update' or action == 'delete') and not pks:
            continue

        sql = env.from_string(tpl).render(**context).strip() + "\n"
        file_path = os.path.join(base_dir, action, f"{action}_{tbl}.sql")
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(sql)
        print(f"Đã tạo: {file_path}")

# ====================================
# 7. Đóng kết nối
# ====================================
cursor.close()
conn.close()

print("Hoàn thành sinh CRUD procedures!")
CREATE VIEW v_sinh_vien_ca_nhan AS
SELECT
    ma_sv, ho_ten, email, ten_lop, diem_trung_binh
FROM v_bao_cao_diem
WHERE email = CURRENT_USER;

CREATE VIEW v_giang_vien AS
SELECT
    ma_sv, ho_ten, ten_lop, diem_trung_binh
FROM v_bao_cao_diem;
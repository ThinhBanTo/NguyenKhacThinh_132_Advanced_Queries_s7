--2.1
create view v_bao_cao_diem as
select ma_sv,ho_ten,email,gioi_tinh,que_quan,ten_lop,count(bd.id) as so_mon_hoc,avg(bd.diem_so) as diem_trung_binh
from sinhvien sv
    join lophoc l on sv.lop_id=l.id
    join bangdiem bd on sv.id=bd.sinh_vien_id
group by sv.id,sv.ma_sv,sv.ho_ten,sv.email,l.ten_lop;
--2.2
--a
create view v_siso_lop as
select lophoc.id,ma_lop,ten_lop,count(sinhvien.id)
from sinhvien join lophoc on sinhvien.lop_id=lophoc.id
group by lophoc.id;
--b
create view v_diem_tb_lop as
select lophoc.id,ma_lop,ten_lop,avg(diem_so)
from sinhvien join lophoc on sinhvien.lop_id=lophoc.id
            join bangdiem on bangdiem.sinh_vien_id=sinhvien.id
group by lophoc.id;
--c: chia theo lop hoc roi phan loai xuatsac,gioi,kha,trung binh, yeu
create view v_lop_hoc_luc as
select ten_lop,
       case
           when avg(bangdiem)>=9.0 then 'Xuất sắc'
           when avg(bangdiem)>=8.0 then 'Giỏi'
           when avg(bangdiem)>=6.5 then 'Khá'
           when avg(bangdiem)>=5.0 then 'Trung bình'
            else 'Yếu'
        end hoc_luc
from sinhvien join lophoc on lop_id=lophoc.id
            join bangdiem on sinh_vien_id=sinhvien.id
group by lophoc.id;

--2.3
CREATE MATERIALIZED VIEW mv_thong_ke_toan_truong AS
SELECT
    que_quan,
    gioi_tinh,
    COUNT(*) as so_luong,
    AVG(diem_trung_binh) as diem_tb_tinh
FROM v_bao_cao_diem
GROUP BY que_quan, gioi_tinh;

--1.1
explain analyse
select *
from SinhVien
where email='nam.nguyen@techmaster.edu.vn';
--1.2
create index idx_sv_email on sinhvien(email);
create index idx_sv_lop_id on sinhvien(lop_id);
create index idx_sv_quequan on sinhvien(que_quan);
create index idx_sv_gt_quequan on sinhvien(gioi_tinh,que_quan);
--1.3
explain analyse
select *
from SinhVien
where email='nam.nguyen@techmaster.edu.vn';


create table patients(
    patient_id serial primary key ,
    full_name varchar(100),
    phone varchar(20),
    city varchar(50),
    symptoms text[]
);

create table doctors(
    doctor_id serial primary key ,
    full_name varchar(100),
    department varchar(50)
);

create table appointments(
    appointment_id serial primary key ,
    patient_id int references patients(patient_id),
    doctor_id int references doctors(doctor_id),
    appointment_date date,
    diagnosis varchar(200),
    fee numeric(10,2)
);

--1
INSERT INTO patients (full_name, phone, city, symptoms) VALUES
                                                            ('Nguyen Van A', '0912345678', 'Hanoi', ARRAY['ho', 'sot']),
                                                            ('Tran Thi B', '0987654321', 'Hanoi', ARRAY['dau dau']),
                                                            ('Le Van C', '0911223344', 'Danang', ARRAY['dau bung', 'buon non']),
                                                            ('Pham Thi D', '0944556677', 'HCM', ARRAY['phat ban']),
                                                            ('Hoang Van E', '0922334455', 'Hanoi', ARRAY['dau lung', 'moi co']);

INSERT INTO doctors (full_name, department) VALUES
                                                ('Dr. Chien', 'Noi tiet'),
                                                ('Dr. Nam', 'Nhi khoa'),
                                                ('Dr. Huong', 'Phu khoa'),
                                                ('Dr. Tuan', 'Chinh hinh'),
                                                ('Dr. Lan', 'Da lieu');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, diagnosis, fee) VALUES
                                                                                       (1, 1, '2026-01-10', 'Cam cum', 200000),
                                                                                       (1, 2, '2026-02-15', 'Viêm họng', 150000),
                                                                                       (2, 1, '2026-01-12', 'Suy nhuoc', 300000),
                                                                                       (3, 3, '2026-01-20', 'Roi loan tieu hoa', 250000),
                                                                                       (4, 5, '2026-02-01', 'Di ung thời tiết', 100000),
                                                                                       (5, 4, '2026-02-10', 'Thoai hoa dot song', 500000),
                                                                                       (2, 2, '2026-03-01', 'Kiem tra định kỳ', 150000),
                                                                                       (3, 3, '2026-03-05', 'Ngo doc thuc an', 400000),
                                                                                       (1, 5, '2026-03-10', 'Tai kham', 100000),
                                                                                       (5, 4, '2026-03-15', 'Vat ly tri lieu', 600000);
--2
create index idx_patient_phone on patients(phone);
create index idx_patient_city on patients using hash(city);
create index idx_patient_symptom on patients using gin(symptoms);

create extension if not exists btree_gist; --numeric phai cai ext btree_gist
create index idx_appointment_fee on appointments using gist(fee);
--3
create index idx_appointment_date on appointments(appointment_date);
cluster appointments using idx_appointment_date;
--4
create view v_patient_fee as
select full_name,sum(fee)
from appointments join patients on appointments.patient_id = patients.patient_id
group by patients.patient_id,full_name
order by sum(fee) desc limit 3;

create view v_count_doctor as
select full_name,count(appointment_id)
from appointments left join doctors on appointments.doctor_id = doctors.doctor_id
group by doctors.doctor_id,full_name;
--5
create view v_patient_city as
select patient_id,full_name,city
from patients
with check option; --neu sua thi ma khong thoa man dieu kien thi se bao loi

update v_patient_city
set city='HoiAn'
where patient_id=1;


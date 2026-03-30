create table customer(
    customer_id serial primary key ,
    full_name varchar(100),
    email varchar(100),
    phone varchar(15)
);

create table orders(
    order_id serial primary key ,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date
);

--1
create or replace view v_order_summary as
select full_name,total_amount,order_date
from orders join customer on orders.customer_id = customer.customer_id
--2
select * from v_order_summary;
--3
create view v_order_amount as
select *
from orders
where total_amount>1000000;

update v_order_amount set total_amount=5000000, order_date='2026-03-29'
where order_id=1 and v_order_amount.customer_id=1;

--4
create view v_monthly_sales as
select extract(month from order_date) stt_month,sum(total_amount) month_amount
from orders
group by stt_month;
--5
drop view v_order_amount;   --xoa du lieu bang ao, moi lan goi la truy van tu dau
drop materialized view v_order_amount;  --xoa du lieu da luu o bang vat ly --> ton dung luong




create table customers(
    customer_id serial primary key ,
    full_name varchar(100),
    email varchar(100) unique,
    city varchar(50)
);

create table products(
    product_id serial primary key ,
    product_name varchar(100),
    category text[],
    price numeric(10,2)
);

create table orders(
    order_id serial primary key ,
    customer_id int references customers(customer_id),
    product_id int references products(product_id),
    order_date date,
    quantity int
);

--1
INSERT INTO customers (full_name, email, city) VALUES
                                                   ('Nguyen Khac Thinh', 'thinh.ptit@email.com', 'Ha Noi'),
                                                   ('Tran Van A', 'vana@email.com', 'Ha Noi'),
                                                   ('Le Thi B', 'thib@email.com', 'Da Nang'),
                                                   ('Pham Van C', 'vanc@email.com', 'TP HCM'),
                                                   ('Hoang Thi D', 'thid@email.com', 'TP HCM');
INSERT INTO products (product_name, category, price) VALUES
                                                         ('Laptop Dell XPS', ARRAY['Electronics', 'Laptop'], 1500.00),
                                                         ('iPhone 15 Pro', ARRAY['Electronics', 'Mobile'], 1200.00),
                                                         ('Ban phim co', ARRAY['Accessories', 'Tech'], 100.00),
                                                         ('Chuot Logitech', ARRAY['Accessories', 'Tech'], 50.00),
                                                         ('Tai nghe Sony', ARRAY['Electronics', 'Audio'], 300.00);
INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES
         (1, 1, '2026-03-01', 1),
         (1, 3, '2026-03-05', 2),
         (2, 2, '2026-03-10', 1),
         (3, 5, '2026-03-12', 1),
         (4, 4, '2026-03-15', 5),
         (5, 1, '2026-03-18', 1),
         (2, 4, '2026-03-20', 2),
         (3, 3, '2026-03-22', 1),
         (1, 5, '2026-03-25', 1),
         (4, 2, '2026-03-28', 1);
--2
explain analyse select * from customers where email='vana@gmail.com';
explain analyse select * from products where category @> array['Electronics'];
explain analyse select * from products where price between 500 and 1000;

create index idx_customer_email on customers(email);
create index idx_customer_city_hash on customers using hash(city);
create index idx_product_category_gin on products using gin(category);
create index idx_product_price on products(price);
--3
explain analyse select * from customers where email='vana@gmail.com';
explain analyse select * from products where category @> array['Electronics'];
explain analyse select * from products where price between 500 and 1000;
--4
create index idx_order_date on orders(order_date);
cluster orders using idx_order_date;
--5a
create view v_customer_top_buy as
select full_name
from customers join orders on customers.customer_id = orders.customer_id
    join products on orders.product_id = products.product_id
group by customers.customer_id
order by sum(quantity*price) desc;

select * from v_customer_top_buy
limit 3;
--5b
create view v_product_revenue as
select product_name,sum(quantity*price)
from products join orders on products.product_id = orders.product_id
group by products.product_id;
--6a
create view v_customer_city as
select customer_id,full_name,city
from customers
with check option;
--6b
update v_customer_city
set city='Thanh Hoa'
where customer_id=1;


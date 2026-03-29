create table book(
    book_id serial primary key ,
    title varchar(255),
    author varchar(100),
    genre varchar(50),
    price decimal(10,2),
    description text,
    created_at timestamp default current_timestamp
);

--1+2
explain analyse select *from book where author ilike '%Rowling%';
explain analyse select * from book where genre='Fantasy';

--gin
create index idx_book_author_gin on book using gin(to_tsvector('english',author));
explain analyse
    select * from book
    where to_tsvector('english',author) @@ to_tsquery('english','Rowling');
--btree
create index idx_book_genre on book(genre);
explain analyse
    select * from book
    where genre='Fantasy';

--3.a: lam o cau 1+2 roi
--3.b:
create index idx_book_title on book using gin(to_tsvector('english',title));
create index idx_book_des on book using gin(to_tsvector('english',book.description));
--4
explain analyse select * from book where genre='Fantasy';

cluster book using idx_book_genre;
explain analyse select * from book where genre='Fantasy';
--5:Báo cáo kết quả tối ưu hóa Index
-- Hiệu quả chỉ mục:
--     +Với các truy vấn tìm kiếm chính xác (=), B-Tree Index là hiệu quả nhất nhờ cấu trúc cây cân bằng giúp tìm kiếm cực nhanh.
--     +Đối với tìm kiếm nội dung văn bản (ILIKE hoặc @@), GIN Index kết hợp với to_tsvector (Full Text Search) vượt trội hơn hẳn vì nó cho phép tra cứu từ khóa thay vì quét từng ký tự.
--     +Clustered Index giúp tăng tốc đột biến các truy vấn lấy nhiều dòng cùng loại nhờ việc sắp xếp dữ liệu vật lý cạnh nhau trên ổ đĩa
-- Hạn chế của Hash Index:
--     +Hash Index trong PostgreSQL không được khuyến khích khi cần thực hiện các truy vấn lọc theo khoảng (như >, <) hoặc sắp xếp dữ liệu (ORDER BY) vì nó chỉ hỗ trợ duy nhất phép so sánh bằng (=).
--     +Ngoài ra, trước các phiên bản PostgreSQL gần đây, Hash Index không được ghi vào log (WAL) nên dễ mất dữ liệu khi hệ thống gặp sự cố, khiến nó kém an toàn hơn B-Tree



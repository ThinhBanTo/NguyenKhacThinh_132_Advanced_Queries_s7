create schema b3
create table post(
    post_id serial primary key ,
    user_id int not null ,
    content text,
    tags text[],
    created_at timestamp default current_timestamp,
    is_public boolean default true
);

create table post_like (
    user_id int not null ,
    post_id int not null ,
    liked_at timestamp default current_timestamp,
    primary key (user_id,post_id)
);

--1
--truoc khi tao index:
explain analyse
select * from post
where is_public = true and content ilike '%du lịch%';
--tao index:
create index idx_post_content on post(lower(post.content));
--sau khi tao index:
explain analyse
select * from post
where is_public=true and content like lower(content);

--2
--explain trc khi tao index
explain analyse
select * from post
where tags @> array['travel'];
--tao gin index
create index idx_post_tag_gin on post using gin(tags);
--explain sau khi tao index
explain analyse
select * from post
where tags @> array['travel'];
/* array:
   @> (Chứa): Kiểm tra mảng có chứa phần tử này không.
tags @> ARRAY['travel'] (Tìm bài có tag travel).
&& (Giao nhau): Kiểm tra hai mảng có phần tử nào chung không.
tags && ARRAY['travel', 'food'] (Tìm bài có tag travel HOẶC food).
ANY: Kiểm tra một giá trị có nằm trong mảng không.
'travel' = ANY(tags).
 */


--3: chi muc 1 phan (tao chi muc cho created_at giam dan --> binary la dc)
create index idx_post_recent_public
on post(created_at desc)
where is_public=true;

select * from post
where is_public=true and created_at >= now()-interval '7 days';
--lay thoi diem hien tai(now) - interval(7 day)= thoi diem 7 ngay truoc

--4 (sap xep theo nguoi dung va thoi gian som nhat)
create index idx_user_post_recent
on post(user_id,created_at desc );

explain analyse
select *
from post
where user_id in (101,102,103)
order by created_at desc
limit 10;



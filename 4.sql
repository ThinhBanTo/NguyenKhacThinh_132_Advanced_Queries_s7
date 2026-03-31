--1
create view v_revenue_by_region as
select c.region,sum(o.total_amount) as total_revenue
from customer c join orders o on c.customer_id = o.customer_id
group by c.region;

select * from v_revenue_by_region
order by total_revenue desc
limit 3;

--2
create view v_revenue_above_avg as
select *
from v_revenue_by_region
where total_revenue> (
    select avg(total_revenue)
    from v_revenue_by_region
    );

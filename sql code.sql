-- Data Prepration and understanding ;
select top 1 * from Customer;
select top 1 * from prod_cat_info;
select top 1 * from transactions;
--1.
select count(*) as count_d from Customer
union
select count(*) as count_d from Transactions
union
select count(*) as count_d from prod_cat_info;

--2.
select * from Transactions;
select count(distinct(transaction_id)) as tot_trans
from Transactions
where Qty < 0 ;

--3.
select CONVERT(date,tran_date,105) as trans_date from Transactions

--4.
select DATEDIFF(year,min(CONVERT(date,tran_date,105)),MAX(CONVERT(date,tran_date,105))) as diff_year,
DATEDIFF(month,min(CONVERT(date,tran_date,105)),MAX(CONVERT(date,tran_date,105))) as diff_month,
DATEDIFF(DAY,min(CONVERT(date,tran_date,105)),MAX(CONVERT(date,tran_date,105))) as diff_day
from Transactions

--5.
select prod_cat,prod_subcat from prod_cat_info
where prod_subcat= 'diy'

--Data Analysis
select top 1 * from Customer;
select top 1 * from prod_cat_info;
select top 1 * from transactions;
--1.
select top 1 store_type,count(*) as count_t from Transactions
group by Store_type
order by count_t desc

--2.
select * from Customer
select count(Gender) from Customer;

--3.
select top 1 count(customer_id) as cust_count , city_code from Customer
group by city_code 
order by cust_count desc

--4.
select * from prod_cat_info;

select count(prod_subcat)as sub_coun from prod_cat_info
where prod_cat = 'books'

--5.
select top 1  Qty from Transactions
order by Qty desc

--6.
select sum(cast(total_amt as float))as net_revenue from prod_cat_info as p1
join Transactions as t1 
on p1.prod_cat_code= t1.prod_cat_code and p1.prod_sub_cat_code=t1.prod_subcat_code
where prod_cat IN ('BOOKS' , 'ELECTRONICS')

--7.
select count(*) as totl_cust from (
select cust_id,  count(distinct(transaction_id)) as ttl_count from Transactions
where Qty>0
group by cust_id
having count(distinct(transaction_id))>10
)as t5
--8.
select sum(cast(total_amt as float)) as combined_revenue  from prod_cat_info as p1
join Transactions as t1 
on p1.prod_cat_code= t1.prod_cat_code and p1.prod_sub_cat_code=t1.prod_subcat_code
where prod_cat in ( 'electronics' , 'clothing') and Store_type='flagship store' and Qty>0

--9.
select prod_subcat, sum(cast(total_amt as float)) as total_revenue from Customer as cu
join Transactions as tr
on cu.customer_Id= tr.cust_id
join prod_cat_info as pr
on pr.prod_cat_code=tr.prod_cat_code and pr.prod_sub_cat_code=tr.prod_subcat_code
where Gender = 'm' and prod_cat= 'electronics'
group by prod_subcat

--10.
--percentage sales
select t5.prod_subcat,percentage_sales,percentage_return from (
select top 5 prod_subcat, (sum(cast(total_amt as float))/(select sum(cast(total_amt as float)) as total_sales from Transactions where Qty>0)) as percentage_sales from prod_cat_info as p1
join Transactions as t1 
on p1.prod_cat_code= t1.prod_cat_code and p1.prod_sub_cat_code=t1.prod_subcat_code
where Qty>0
group by prod_subcat
order by percentage_sales desc)as t5
join
--percentage return
(select  prod_subcat, (sum(cast(total_amt as float))/(select sum(cast(total_amt as float)) as total_sales from Transactions where Qty<0)) as percentage_return from prod_cat_info as p1
join Transactions as t1 
on p1.prod_cat_code= t1.prod_cat_code and p1.prod_sub_cat_code=t1.prod_subcat_code
where Qty<0
group by prod_subcat) as t6
on t5.prod_subcat = t6.prod_subcat 

--11.


select*from(
select * from(
select cust_id, DATEDIFF(year,dob ,max_date )as age , revenue from (
select cust_id ,dob,max(convert(date,tran_date,105)) as max_date,sum(cast(total_amt as float)) as revenue from Customer as t1
join Transactions as t2
on t1.customer_Id=t2.cust_id
where Qty>0
GROUP BY cust_id , dob 
) as A
     ) as B 
where age between 25 and 35 ) as C
join (
-- last 30 days of transaction 
select cust_id ,convert(date,tran_date,105) as trans_date
from Transactions
group by cust_id,convert(date,tran_date,105)
having convert(date,tran_date,105) >=(select DATEADD(day, -30, max(convert(date,tran_date,105))) as cutoff_date from Transactions
)) as D
on c.cust_id=d.cust_id






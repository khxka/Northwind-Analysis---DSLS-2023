--no 1
select count(distinct customerid) customers, count(*) orders, month(orderdate) as month_order, min(orderdate)min_date, max(orderdate) max_date
from orders where orderdate >= '1997-01-01 00:00:00.000' and orderdate < '1998-01-01 00:00:00.000'
group by month(orderdate);

-- no 2
select * from employees
where Title = 'Sales Representative';

--no 3 
with base as(
select 
productname, sum(quantity) quantity
from orders a
join order_details b on a.orderid = b.orderid
join products c on b.productid = c.productid
where orderdate >= '1997-01-01 00:00:00.000' and orderdate < '1997-02-01 00:00:00.000'
group by productname
)
select top 5* from base
order by quantity desc
;

--no 4
select companyname from products a
join order_details b on a.productid = b.productid
join orders c on b.orderid = c.orderid
join customers d on c.customerid = d.customerid
where orderdate >= '1997-06-01 00:00:00.000' and orderdate < '1997-07-01 00:00:00.000'
and productname = 'Chai';

--no 5
with base as (
select orderid, 
case when unitprice*quantity <= 100 then '<=100'
 when unitprice*quantity <= 250 then '<=250'
  when unitprice*quantity <= 500 then '<=500'
   when unitprice*quantity > 500 then '>500'
   end as buy_range
from order_details
)
select count(*) orderid, buy_range from base
group by buy_range
;

--no 6
with base as (
select orderid, 
case when unitprice*quantity <= 100 then '<=100'
 when unitprice*quantity <= 250 then '<=250'
  when unitprice*quantity <= 500 then '<=500'
   when unitprice*quantity > 500 then '>500'
   end as buy_range
from order_details
)
select 
distinct companyname 
from customers a 
join orders b on a.customerid = b.customerid
join base c on b.orderid = c.orderid
where orderdate >= '1997-01-01 00:00:00.000' and orderdate < '1998-01-01 00:00:00.000'
and buy_range = '>500';

--no 7
with base as(
select
productname, sum(b.unitprice*quantity) as sales, month(orderdate) month_order
from products a
join order_details b on a.productid = b.productid
join orders c on c.orderid = b.orderid
where orderdate >= '1997-01-01 00:00:00.000' and orderdate < '1998-01-01 00:00:00.000'
group by productname, month(orderdate)
)
, base2 as(
select base.*, row_number () over (partition by month_order order by Sales desc) rn from base
)
select 
productname, sales, month_order 
from base2
where rn <= 5;

--no 8
create view orderdetails as
select b.productname, a.*, a.unitprice*(1-discount) as discounted_price from order_details a
join products b on a.productid = b.productid;

--no 9
CREATE PROCEDURE Invoice @CustomerID nvarchar(30)
AS
select a.CustomerID, companyname, OrderID, OrderDate, RequiredDate, ShippedDate from customers a
join orders b on a.CustomerID = b.CustomerID
WHERE a.CustomerID = @CustomerID;

exec Invoice @CustomerID = 'VINET'

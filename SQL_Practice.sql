use classicmodels;


#------------------------- question 1(a) -----------------------------
# fetch the employee number, first name and last name of those employees
# who are working as sales rep reporting to employee with employeenumber 1102 (refer employee table)

select employeenumber, firstname, lastname 
from employees
where reportsto = 1102;

#------------------------- question 1(b) -----------------------------
# show the unique productline values containing the word cars at the end from the products table

select distinct productline 
from productlines
where productline like '%cars';

#------------------------- question 2 -----------------------------
# using a case statement, segment customers into three categories based on their country:
# "north america" for customers from usa or canada
# "europe" for customers from uk, france, or germany
# "other" for all remaining countries

select customernumber, customername,
case
    when country in ('usa', 'canada') then 'north america'
    when country in ('uk', 'france', 'germany') then 'europe'
    else 'other'
end as customersegment
from customers;

#------------------------- question 3(a) -----------------------------
# using the orderdetails table, identify the top 10 products (by productcode)
# with the highest total order quantity across all orders

select productcode, sum(quantityordered) as total_ordered
from orderdetails
group by productcode
order by total_ordered desc
limit 10;

#------------------------- question 3(b) -----------------------------
# company wants to analyse payment frequency by month. extract the month name from the 
# payment date to count the total number of payments for each month and include only
# those months with a payment count exceeding 20. sort the results by total number of
# payments in descending order.

select monthname(paymentdate) as payment_month,
       count(customernumber) as num_payments
from payments
group by payment_month
having num_payments > 20
order by num_payments desc;

#------------------------- question 4(a) -----------------------------
# create a database customers_orders and table customers

create database customers_orders;
use customers_orders;

create table customers (
    customer_id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(255) unique,
    phone_number varchar(20)
);

#------------------------- question 4(b) -----------------------------
# create table orders with constraints

create table orders (
    order_id int primary key auto_increment,
    customer_id int,
    order_date date,
    total_amount decimal(10,2) check (total_amount > 0),
    foreign key (customer_id) references customers(customer_id)
) engine=innodb;

#------------------------- question 5 -----------------------------
# list the top 5 countries (by order count) that classic models ships to

use classicmodels;

select c.country, count(o.customernumber) as order_count
from customers c
join orders o on c.customernumber = o.customernumber
group by c.country
order by order_count desc
limit 5;

#------------------------- question 6 -----------------------------
# create project table and find out the names of employees and their related managers

create table project (
    emp_id int primary key auto_increment,
    fullname varchar(50) not null,
    gender varchar(10) check (gender in ('male','female')),
    manager_id int
);

insert into project values
(1,'pranaya','male',3),
(2,'priyanka','female',1),
(3,'preety','female',null),
(4,'anurag','male',1),
(5,'sambit','male',1),
(6,'rajesh','male',3),
(7,'hina','female',3);

select a.fullname as manager_name, b.fullname as emp_name
from project a
join project b on b.manager_id = a.emp_id
order by manager_name;

#------------------------- question 7 -----------------------------
# create table facility, alter table and add new column

create table facility (
    facility_id int,
    name varchar(50),
    state varchar(10),
    country varchar(20)
);

alter table facility modify facility_id int primary key auto_increment;
alter table facility add column city varchar(20) not null after name;

#------------------------- question 8 -----------------------------
# create a view named product_category_sales

create view product_category_sales as
select 
    p.productline as productline,
    sum(od.quantityordered * od.priceeach) as total_sales,
    count(distinct o.ordernumber) as number_of_orders
from products p
join orderdetails od on p.productcode = od.productcode
join orders o on od.ordernumber = o.ordernumber
group by p.productline;

select * from product_category_sales;

#------------------------- question 9 -----------------------------
# stored procedure get_country_payments

delimiter $$

create procedure get_country_payments (
    in input_year int,
    in input_country varchar(50)
)
begin
    select year(a.paymentdate) as year,
           b.country,
           concat(round(sum(a.amount)/1000,0),'k') as total_amount
    from customers b
    join payments a on a.customernumber = b.customernumber
    where year(a.paymentdate) = input_year
      and b.country = input_country;
end $$

delimiter ;

call get_country_payments(2003,'france');

#------------------------- question 10(a) -----------------------------
# rank customers based on their order frequency

select *, dense_rank() over(order by order_count desc) as order_freq_rank
from (
    select c.customername, count(o.customernumber) as order_count
    from customers c
    join orders o on c.customernumber = o.customernumber
    group by c.customername
) abc;

#------------------------- question 10(b) -----------------------------
# calculate year wise, month wise count of orders and yoy percentage change

select year, m_name, total_orders,
       concat(round((cy-py)/py*100),'%') as `% yoy change`
from (
    select year(orderdate) as year,
           monthname(orderdate) as m_name,
           month(orderdate) as mno,
           count(customernumber) as total_orders,
           count(customernumber) as cy,
           lag(count(customernumber)) over (order by year(orderdate) asc) as py
    from orders
    group by year, m_name, mno
) abc;

#------------------------- question 11 -----------------------------
# find product lines where buyprice is greater than average buyprice

select productline, count(productline) as total
from products
where buyprice > (select avg(buyprice) from products)
group by productline;

#------------------------- question 12 -----------------------------
# procedure with error handling for emp_eh

create table emp_eh (
    empid int primary key,
    empname varchar(50),
    emailaddress varchar(100)
);

delimiter $$

create procedure insertemployee (
    in empid int,
    in empname varchar(50),
    in emailaddress varchar(100)
)
begin
    declare exit handler for sqlexception
    begin
        select 'error occurred';
    end;
    insert into emp_eh (empid, empname, emailaddress)
    values (empid, empname, emailaddress);
    select 'record inserted successfully';
end $$

delimiter ;

call insertemployee(3,'usha','ushabureddy@gmail.com');
call insertemployee(3,'sweety','sweety@gmail.com');

#------------------------- question 13 -----------------------------
# create trigger on emp_bit to ensure working_hours is positive

create table emp_bit (
    name varchar(20),
    occupation varchar(30),
    working_date date,
    working_hours decimal
);

insert into emp_bit values
('robin','scientist','2020-10-04',12),
('warner','engineer','2020-10-04',10),
('peter','actor','2020-10-04',13),
('marco','doctor','2020-10-04',14),
('brayden','teacher','2020-10-04',12),
('antonio','business','2020-10-04',11);

delimiter $$

create trigger trg_before
before insert on emp_bit
for each row
begin
    if new.working_hours < 0 then
        set new.working_hours = abs(new.working_hours);
    end if;
end $$

delimiter ;

insert into emp_bit values ('john','designer','2020-10-05',-8);
insert into emp_bit values ('jon','artist','2021-11-05',-9);

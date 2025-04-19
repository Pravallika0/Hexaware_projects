create database techshop1;
use techshop1

create table customers (
  customerid int primary key,
  firstname varchar(50),
  lastname varchar(50),
  email varchar(100),
  phone varchar(20),
  address varchar(255)
);

create table products (
  productid int primary key,
  productname varchar(100),
  description text,
  price decimal(10, 2)
);

create table orders (
  orderid int primary key,
  customerid int,
  orderdate date,
  totalamount decimal(10, 2),
  foreign key (customerid) references customers(customerid)
);

create table orderdetails (
  orderdetailid int primary key,
  orderid int,
  productid int,
  quantity int,
  foreign key (orderid) references orders(orderid),
  foreign key (productid) references products(productid)
);

create table inventory (
  inventoryid int primary key,
  productid int,
  quantityinstock int,
  laststockupdate date,
  foreign key (productid) references products(productid)
);

insert into customers (customerid, firstname, lastname, email, phone, address) values
(1, 'john', 'doe', 'john.doe@example.com', '1234567890', '123 main street'),
(2, 'jane', 'smith', 'jane.smith@example.com', '9876543210', '456 elm avenue'),
(3, 'alice', 'johnson', 'alice.j@example.com', '1112223333', '789 maple drive'),
(4, 'bob', 'brown', 'bob.b@example.com', '4445556666', '321 oak street'),
(5, 'charlie', 'davis', 'charlie.d@example.com', '9998887777', '654 pine lane'),
(6, 'diana', 'martin', 'diana.m@example.com', '5556667777', '987 birch road'),
(7, 'edward', 'wilson', 'ed.w@example.com', '8889990000', '147 cedar street'),
(8, 'fiona', 'lee', 'fiona.lee@example.com', '2223334444', '258 spruce avenue'),
(9, 'george', 'clark', 'george.c@example.com', '6667778888', '369 walnut lane'),
(10, 'hannah', 'wright', 'hannah.w@example.com', '1119998888', '159 ash boulevard');

insert into products (productid, productname, description, price) values
(1, 'smartphone', 'android smartphone with 128gb storage', 599.99),
(2, 'laptop', '15-inch laptop with 8gb ram', 849.50),
(3, 'tablet', '10-inch tablet with stylus support', 299.99),
(4, 'smartwatch', 'smartwatch with health tracking', 149.99),
(5, 'bluetooth speaker', 'portable bluetooth speaker', 79.99),
(6, 'earbuds', 'wireless bluetooth earbuds', 49.99),
(7, 'monitor', '24-inch full hd monitor', 129.99),
(8, 'keyboard', 'mechanical keyboard with rgb', 89.99),
(9, 'mouse', 'wireless optical mouse', 39.99),
(10, 'printer', 'all-in-one inkjet printer', 159.99);

insert into orders (orderid, customerid, orderdate, totalamount) values
(1, 1, '2025-04-01', 649.98),
(2, 2, '2025-04-02', 129.98),
(3, 3, '2025-04-03', 299.99),
(4, 4, '2025-04-04', 79.99),
(5, 5, '2025-04-05', 599.99),
(6, 6, '2025-04-06', 109.98),
(7, 7, '2025-04-07', 159.99),
(8, 8, '2025-04-08', 849.50),
(9, 9, '2025-04-09', 89.98),
(10, 10, '2025-04-10', 189.98);

insert into orderdetails (orderdetailid, orderid, productid, quantity) values
(1, 1, 1, 1),
(2, 1, 6, 1),
(3, 2, 4, 1),
(4, 2, 9, 1),
(5, 3, 3, 1),
(6, 4, 5, 1),
(7, 5, 1, 1),
(8, 6, 6, 2),
(9, 7, 10, 1),
(10, 8, 2, 1),
(11, 9, 8, 1),
(12, 9, 9, 1),
(13, 10, 7, 1),
(14, 10, 4, 1);

insert into inventory (inventoryid, productid, quantityinstock, laststockupdate) values
(1, 1, 50, '2025-04-01'),
(2, 2, 30, '2025-04-01'),
(3, 3, 40, '2025-04-01'),
(4, 4, 60, '2025-04-01'),
(5, 5, 70, '2025-04-01'),
(6, 6, 100, '2025-04-01'),
(7, 7, 25, '2025-04-01'),
(8, 8, 45, '2025-04-01'),
(9, 9, 80, '2025-04-01'),
(10, 10, 35, '2025-04-01');


---TASK-2---
---q.2.1 retrieve the names and emails of all customers.--
select firstname, lastname, email 
from customers
group by firstname, lastname, email;

---q.2.2//list all orders with their order dates and corresponding customer names.
select orderdate,firstname,lastname
from orders o
join customers c on c.customerid = o.customerid

---q.2.3//insert a new customer record into the "Customers" table. Include 
---customer information such as name, email, and address.
insert into customers (customerid, firstname, lastname, email, phone, address)
values (11, 'Laura', 'Anderson', 'laura.anderson@example.com', '7776665555', '753 Poplar Street');

select * from customers

---q.2.4//update the prices of all electronic gadgets in the "Products" table by 
---increasing them by 10%.
select * from products;

update products
set price =price+price*0.10;

---q.2.5// delete a specific order and its associated order details from the 
---"Orders" and "OrderDetails" tables. Allow users to input the order ID as a parameter.
create procedure DeleteOrderAndDetails @orderid int
as
begin
    
delete from orderdetails
where orderid = @orderid;

delete from orders
where orderid = @orderid;
end;
go

exec DeleteOrderAndDetails @orderid = 1;

select * from orders where orderid = 1;
select * from orderdetails where orderid = 1;

---q.2.6//insert a new order into the "Orders" table. Include the customer ID, 
---order date, and any other necessary information.
insert into orders (orderid, customerid, orderdate, totalamount) values
(11, 11 , '2025-04-10' , 1234.56);

---q.2.7//update the contact information (e.g., email and address) of a specific 
---customer in the "Customers" table. Allow users to input the customer ID and new contact 
---information.
create procedure UpdateCustomerInfo 
@newemail varchar(100),
@newaddres varchar(100),
@customerid int

as 
begin

update customers
set email=@newemail,
    address=@newaddres
where customerid=@customerid;

end;
go

exec UpdateCustomerInfo
@customerid = 3,
@newemail = 'pravi@gmail.com',
@newaddres = 'ABC Balcony';

select * from customers where customerid=3;

---q.2.8//recalculate and update the total cost of each order in the "Orders" 
---table based on the prices and quantities in the "OrderDetails" table.

update o
set o.totalamount=totals.total
from orders o
join
(select od.orderid,SUM(p.price*od.quantity)as total
from orderdetails od
join products p on od.productid=p.productid
group by od.orderid)
totals on o.orderid=totals.orderid

select * from orders

---q.2.9//delete all orders and their associated order details for a specific 
---customer from the "Orders" and "OrderDetails" tables. Allow users to input the customer ID 
---as a parameter.

-- stored procedure to delete all orders and order details for a specific customer

use techshop1;
go

if object_id('deleteordersbycustomer', 'p') is not null
    drop procedure deleteordersbycustomer;
go

create procedure deleteordersbycustomer
    @customerid int
as
begin
    declare @orderids table (orderid int);

    insert into @orderids (orderid)
    select orderid from orders where customerid = @customerid;

    delete from orderdetails
    where orderid in (select orderid from @orderids);

    delete from orders
    where orderid in (select orderid from @orderids);
end;
go

exec deleteordersbycustomer @customerid = 3;

select * from orderdetails
select * from orders

---2.10// insert a new electronic gadget product into the "Products" table, 
---including product name, category, price, and any other relevant details.

alter table products
add category varchar(50);

insert into products (productid, productname, description, price, category)
values (11, 'VR Headset', 'Virtual reality headset with motion tracking', 399.99, 'Electronics');

---2.11//update the status of a specific order in the "Orders" table (e.g., from 
---"Pending" to "Shipped"). Allow users to input the order ID and the new status.

alter table orders
add status varchar(20);

create procedure updateorderstatus
  @orderid int,
  @newstatus varchar(20)
as
begin
  update orders
  set status = @newstatus
  where orderid = @orderid;
end;
go

exec updateorderstatus @orderid = 2, @newstatus = 'Shipped';

---2.12//calculate and update the number of orders placed by each customer 
---in the "Customers" table based on the data in the "Orders" table.

alter table customers
add numorders int default 0;

update customers
set numorders = orderscount.total
from (
  select customerid, count(*) as total
  from orders
  group by customerid
) orderscount
where customers.customerid = orderscount.customerid;


----Task-3----

---3.1//retrieve a list of all orders along with customer information (e.g., 
---customer name) for each order.

select o.orderid, o.orderdate, o.totalamount,
       c.firstname, c.lastname, c.email
from orders o
join customers c on o.customerid = c.customerid;

---3.2//to find the total revenue generated by each electronic gadget product. 
---Include the product name and the total revenue.

select p.productname, sum(od.quantity * p.price) as total_revenue
from orderdetails od
join products p on od.productid = p.productid
group by p.productname
order by total_revenue desc;

select * from products

---3.3//o list all customers who have made at least one purchase. Include their 
---names and contact information.

select distinct c.firstname, c.lastname, c.email, c.phone
from customers c
join orders o on c.customerid = o.customerid;

---3.4//find the most popular electronic gadget, which is the one with the highest 
---total quantity ordered. Include the product name and the total quantity ordered.

select top 1 p.productname, sum(od.quantity) as total_quantity_ordered
from orderdetails od
join products p on od.productid = p.productid
group by p.productname
order by total_quantity_ordered desc;

---3.5//retrieve a list of electronic gadgets along with their corresponding categories.

select productname, category
from products

---3.6//calculate the average order value for each customer. Include the 
---customer's name and their average order value.

select c.firstname, c.lastname, avg(o.totalamount) as average_order_value
from orders o
join customers c on o.customerid = c.customerid
group by c.firstname, c.lastname;

---3.7//find the order with the highest total revenue. Include the order ID, 
---customer information, and the total revenue.

select top 1 o.orderid, o.totalamount, o.orderdate,c.firstname, c.lastname, c.email
from orders o
join customers c on o.customerid = c.customerid
order by o.totalamount desc;

---3.8//list electronic gadgets and the number of times each product has been ordered.
select p.productname, count(od.orderdetailid) as times_ordered
from orderdetails od
join products p on od.productid = p.productid
group by p.productname;

---3.9//find customers who have purchased a specific electronic gadget product. 
---Allow users to input the product name as a parameter.

declare @productname varchar(100) = 'Smartphone';

select distinct c.firstname, c.lastname, c.email
from customers c
join orders o on c.customerid = o.customerid
join orderdetails od on o.orderid = od.orderid
join products p on od.productid = p.productid
where p.productname = @productname;

---3.10//calculate the total revenue generated by all orders placed within a 
---specific time period. Allow users to input the start and end dates as parameters.

declare @startdate date = '2025-04-01';
declare @enddate date = '2025-04-05';

select sum(totalamount) as total_revenue
from orders
where orderdate between @startdate and @enddate;


---Task-4---

---4.1//find out which customers have not placed any orders.

select customerid, firstname,lastname
from customers
where customerid not in (
    select distinct customerid
    from orders
);
select * from customers

---4.2//find the total number of products available for sale.

select count(*) as total_products
from products;

---4.3//calculate the total revenue generated by TechShop

select sum(od.quantity * p.price) as total_revenue
from orderdetails od
join products p on od.productid = p.productid;

select * from orderdetails

---4.4//calculate the average quantity ordered for products in a specific category. 
---Allow users to input the category name as a parameter.

select avg(od.quantity) as average_quantity
from orderdetails od
join products p on od.productid = p.productid
where p.category = 'electronics';

---4.5//calculate the total revenue generated by a specific customer. Allow users 
---to input the customer ID as a parameter.
select sum(oi.quantity * p.price) as customer_revenue
from orders o
join orderdetails oi on o.orderid = oi.orderid
join products p on oi.productid = p.productid
where o.customerid = 101;


---4.6//find the customers who have placed the most orders. List their names 
---and the number of orders they've placed.

select customerid, count(*) as order_count
from orders
group by customerid
having count(*) = (
    select max(order_count)
    from (
        select customerid, count(*) as order_count
        from orders
        group by customerid
    ) as sub
);

---4.7//find the most popular product category, which is the one with the highest 
---total quantity ordered across all orders.
select top 1 
    o.orderid, 
    o.totalamount, 
    c.firstname, 
    c.lastname, 
    c.email
from orders o
join customers c on o.customerid = c.customerid
order by o.totalamount desc;

---4.8//find the customer who has spent the most money (highest total revenue) 
---on electronic gadgets. List their name and total spending.
select p.productname, count(od.orderdetailid) as times_ordered
from products p
join orderdetails od on p.productid = od.productid
group by p.productname;


---4.9//calculate the average order value (total revenue divided by the number of 
---orders) for all customers.
declare @productname varchar(100) = 'smartphone';

select distinct 
    c.firstname, 
    c.lastname, 
    c.email
from customers c
join orders o on c.customerid = o.customerid
join orderdetails od on o.orderid = od.orderid
join products p on od.productid = p.productid
where p.productname = @productname;


---4.10//find the total number of orders placed by each customer and list their 
---names along with the order count.
declare @startdate date = '2025-04-01';
declare @enddate date = '2025-04-05';

select sum(totalamount) as total_revenue
from orders
where orderdate between @startdate and @enddate;


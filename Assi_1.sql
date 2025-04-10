---//Task-1//---
create database HMBank;
use HMBank;
create table Customers(
customerid int primary key identity(1,1),
first_name varchar(50) not null,
last_name varchar(50) not null,
DOB date not null,
email varchar(100) not null,
phone_num varchar(15),
address text);

alter table Customers
alter column address varchar(255);

create table Accounts(
accountid int primary key identity(1,1),
customerid int not null,
account_type varchar(20) check 
(account_type in ('savings','current','zero_balance')),
balance decimal(15,2) default 0.00,
foreign key(customerid) references Customers(customerid)
);

create table Transactions(
transactionid int primary key identity(1,1),
accountid int not null,
transaction_type varchar(20) check 
(transaction_type in ('deposit','withdrawal','transfer')),
amount decimal(15,2) check (amount > 0),
transaction_date datetime,
foreign key(accountid) references Accounts(accountid));

---//Task-2//---

insert into Customers (first_name, last_name, DOB, email, phone_num, address) values
('pravi','Sompi','2000-03-10','pravi.sompi@gmail.com','1234567890','123 pammal'),
('swathi','selvam','2001-07-25','swathi.selvam@gmail.com','2345678901','456 gandhi nagar'),
('Charu','Latha','2002-12-05','charu.latha@gmail.com','3456789012','789 Pallavaram'),
('Dhanu','Arya','2003-01-15','dhanu.arya.a@gmail.com','4567890123','321 leo nagar'),
('Ekam','Wan','2004-11-23','ekam.wan.@gmail.com', '5678901234','654 kanchipuram'),
('ganga','yamuna','2005-08-17','ganga.yamuna@gmail.com', '6789012345','987 doctor street'),
('harry','harish','2006-05-09','harry.harish@gmail.com','7890123456','159 level gate'),
('arun','ice','2007-04-18','arun.ice@gmail.com', '8901234567','753 Apple road'),
('kavya','ganesh','2008-09-30','kavya.ganesh@gmail.com','2345678','852 redvelvet st'),
('Jam','Bread','2009-06-12','jam.bread.b@gmail.com','0123456789','951 Cyber Rd');

insert into Accounts(customerid, account_type, balance) values
(1, 'savings', 1500.00),
(2, 'current', 3200.50),
(3, 'zero_balance', 0.00),
(4, 'savings', 500.75),
(5, 'current', 7800.00),
(6, 'savings', 420.00),
(7, 'current', 920.90),
(8, 'zero_balance', 0.00),
(9, 'savings', 3050.60),
(10, 'current', 150.00);

select * from Accounts

insert into Transactions (accountid, transaction_type, amount, transaction_date) values
(1, 'deposit', 500.00, '2025-04-01 10:30:00'),
(2, 'withdrawal', 200.00, '2025-04-01 11:00:00'),
(3, 'deposit', 300.00, '2025-04-02 09:45:00'),
(4, 'deposit', 100.50, '2025-04-02 14:20:00'),
(5, 'withdrawal', 250.00, '2025-04-03 16:10:00'),
(6, 'deposit', 150.00, '2025-04-03 17:00:00'),
(7, 'transfer', 50.00, '2025-04-04 12:00:00'),
(8, 'deposit', 100.00, '2025-04-05 08:30:00'),
(9, 'withdrawal', 75.25, '2025-04-05 10:15:00'),
(10, 'deposit', 200.00, '2025-04-06 13:45:00');
select distinct * from Transactions

---//q2.1//retrieve the name, account type and email of all customers. ---
select 
c.first_name+' '+c.last_name as full_name,
a.Account_type,
c.email
from Customers c
join
Accounts a on c.customerid = a.customerid;

---//q2.2//list all transaction corresponding customer.//---
select distinct c.first_name+' '+c.last_name as full_name,
t.transaction_type,
t.amount,
t.transaction_date
from Transactions t 
join Accounts a on t.accountid=a.accountid
join Customers c on c.customerid=a.customerid;

---//q2.3//increase the balance of a specific account//---
update Accounts
set balance = balance+1000
where accountid=3;

---//q2.4//Combine first and last names of customers as a full_name.//---
select c.first_name+' '+c.last_name as full_name
from Customers c;

---q2.5// remove accounts with a balance of zero where the account type is savings.//---
delete from Accounts
where balance = 0 and account_type='savings';

---q2.6// Find customers living in a specific city. 
select * from Customers where 
address like '%kanchipuram%';

---q2.7// Get the account balance for a specific account.
select a.balance,a.accountid
from Accounts a
where accountid = 3;

---q2.8//List all current accounts with a balance greater than $1,000.---
select * from Accounts
where balance > 1000;

---q2.9//Retrieve all transactions for a specific account. 
select distinct * from Transactions 
where accountid = 3;

---q.2.10// Calculate the interest accrued on savings accounts based on a given interest rate.//---
---interest incured -> the bank pay u interest for keeping your money---
select accountid,customerid,balance,
balance * 0.04 as interest_accrued
from Accounts
where account_type = 'savings';

---//q.2.11//o Identify accounts where the balance is less than a specified 
---overdraft limit.//---
select * from Accounts
where balance<1000;

---q.2.12//Find customers not living in a specific city---
---% symbols are wildcards that mean "anything before or after".---
select * from customers 
where address not like '%kanchipuram%;'

---Task-3---

---q.3.1//Find the average account balance for all customers.---
select avg(balance) as acc_balance from Accounts
---where account_type='savings'

---q3.2--//Retrieve the top 10 highest account balances.
select top 10 * from Accounts order by balance desc;

---q3.3--//Calculate Total Deposits for All Customers in specific date.
select sum(amount) as total_deposits,transaction_date
from Transactions
where transaction_type='deposit' 
and transaction_date ='2025-04-01 10:30:00.000'
group by transaction_date;

---q3.4--//Find the Oldest and Newest Customers.---
select top 1 * from Customers order by DOB asc;
select top 1 * from Customers order by DOB desc;

---q.3.5--//Retrieve transaction details along with the account type.---
select t.transactionid,
t.accountid,
t.transaction_type,
t.amount,
t.transaction_date,
a.account_type,
a.balance
from Transactions t
join Accounts a on t.accountid=a.accountid;


---q3.6//Get a list of customers along with their account details.---
select  c.customerid,c.first_name,c.last_name,c.email,c.phone_num,a.accountid,
a.account_type,a.balance from Customers c join Accounts a on c.customerid=a.customerid;

---q3.7//Retrieve transaction details along with customer information for a 
---specific account.
select t.accountid, t.transaction_type, t.amount, t.transaction_date, c.first_name, c.last_name, c.DOB, c.email, c.phone_num, c.address
from Transactions t
join Accounts a on t.accountid=a.accountid
join Customers c  on a.customerid=c.customerid
where account_type='savings';

---q.3.8//Identify customers who have more than one account.
select c.customerid,c.first_name,c.last_name,
count(a.accountid) as num_of_acc
from Customers c
join Accounts a on c.customerid=a.customerid
group by  c.customerid,c.first_name,c.last_name
having count(a.accountid)>1;

---q.3.9//Calculate the difference in transaction amounts between deposits and 
---withdrawals.
select 
sum(case when transaction_type='deposit' then amount else 0 end)-sum(case when transaction_type='withdrawal' then amount else 0 end)
as diff_in_transaction
from Transactions;

---q.3.10//Calculate the average daily balance for each account over a specified 
---period.
select a.accountid,avg(a.balance) as avg_bal from Accounts a
join Transactions t on a.accountid=t.accountid
where a.account_type in ('savings','withdrawal','zero_balance')
and t.transaction_date between '2025-04-03' and '2025-04-05' group by a.accountid;

---q.3.11//total balance for each account type.---
select a.account_type , sum(a.balance) as tot_balance from Accounts a
join Transactions t on a.accountid=t.accountid
where a.account_type in ('savings','withdrawal','zero_balance')
group by a.account_type;

---q.3.12//Identify accounts with the highest number of transactions order by descending order.
select t.accountid,
count(t.transactionid) as transaction_count
from Transactions t
group by t.accountid
order by transaction_count desc;


---q.3.13//List customers with high aggregate account balances, along with their account types.---
select c.customerid,c.first_name+' '+c.last_name as full_name,a.account_type,
sum(a.balance) as total_balance 
from Customers c
join Accounts a on c.customerid = a.customerid
group by c.customerid ,c.first_name+' '+c.last_name,a.account_type
having sum(a.balance)>5000 
order by total_balance desc;

---q3.14//Identify and list duplicate transactions based on transaction amount, date, and account.
select t.accountid,t.transaction_type,t.amount,t.transaction_date,
count(*) as duplicate_count
from Transactions t
group by t.accountid,t.transaction_type,t.amount,t.transaction_date
having count(*) > 1;

---Task-4//---
---q4.1//Retrieve the customer(s) with the highest account balance.---
select top 1 * from Customers c
join Accounts a on c.customerid=a.customerid
order by a.balance desc;

---q4.2//Calculate the average account balance for customers who have more than one account.
select avg(a.balance) as avg_bal from Accounts a
where a.customerid in 
(select customerid from Accounts
group by customerid having count(accountid)>1);

---q.4.3//Retrieve accounts with transactions whose amounts 
---exceed the average transaction amount.
select * from Transactions t
where t.amount >
(select avg(amount) from Transactions);

---q.4.4//Identify customers who have no recorded transactions.
select distinct c.customerid,c.first_name,c.last_name,c.email
from Customers c
left join Accounts a on c.customerid = a.customerid
left join Transactions t on a.accountid = t.accountid
where t.transactionid is NULL;


---q.4.5//Calculate the total balance of accounts 
---with no recorded transactions.
select sum(a.balance) as total_balance
from Accounts a
join Transactions t on a.accountid=t.accountid
where t.transactionid is null;

---q.4.6//Retrieve transactions for accounts with the lowest balance.
select * from Transactions t
join Accounts a on t.accountid=a.accountid
where a.balance = (select min(balance) from Accounts);

---q.4.7//Identify customers who have accounts of multiple types.---

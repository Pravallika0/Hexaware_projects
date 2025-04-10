--Task-1--

create database SISDB2;
use SISDB2;

create table Students(student_id int Primary Key,
first_name varchar(100),
last_name varchar(200),
date_of_birth date,
email varchar(100),
phone_number int
);
alter table Students
drop column date_of_birth ;
alter table Students
add date_of_birth date;

create table Teachers(teacher_id int Primary Key,first_name varchar(100),
last_name varchar(100),email varchar(100));

create table Courses(course_id int Primary Key,
course_name varchar(100),
credits varchar(100),
teacher_id int foreign key(teacher_id) references Teachers(teacher_id) 
);

create table Enrollments(enrollment_id int Primary Key,
student_id int Foreign Key references Students(student_id),
course_id int Foreign Key references Courses(course_id),
enrollment_date date 
);

create table Payments(payment_id int Primary Key,
student_id int Foreign Key references Students(student_id), 
amount int,
payment_date date);

INSERT INTO Teachers (teacher_id, first_name, last_name, email) VALUES
(101, 'Sarah', 'Adams', 'sarah.adams@gmail.com'),
(102, 'Tom', 'Baker', 'tom.baker@gmail.com'),
(103, 'Nina', 'Collins', 'nina.collins@gmail.com'),
(104, 'Oscar', 'Dixon', 'oscar.dixon@gmail.com'),
(105, 'Paula', 'Evans', 'paula.evans@gmail.com'),
(106, 'Ryan', 'Foster', 'ryan.foster@gmail.com'),
(107, 'Sophie', 'Green', 'sophie.green@gmail.com'),
(108, 'Tim', 'Harris', 'tim.harris@gmail.com'),
(109, 'Uma', 'Irwin', 'uma.irwin@gmail.com'),
(110, 'Victor', 'Jones', 'victor.jones@gmail.com');

INSERT INTO Courses (course_id, course_name, credits, teacher_id) VALUES
(201, 'Mathematics I', '3', 101),
(202, 'Physics I', '4', 102),
(203, 'Chemistry I', '4', 103),
(204, 'Biology I', '3', 104),
(205, 'Programming Basics', '3', 105),
(206, 'Data Structures', '4', 106),
(207, 'Database Systems', '3', 107),
(208, 'Operating Systems', '4', 108),
(209, 'Web Development', '3', 109),
(210, 'Artificial Intelligence', '4', 110);

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES
(1, 1, 201, '2024-01-10'),
(2, 2, 202, '2024-01-11'),
(3, 3, 203, '2024-01-12'),
(4, 4, 204, '2024-01-13'),
(5, 5, 205, '2024-01-14'),
(6, 6, 206, '2024-01-15'),
(7, 7, 207, '2024-01-16'),
(8, 8, 208, '2024-01-17'),
(9, 9, 209, '2024-01-18'),
(10, 10, 210, '2024-01-19');

INSERT INTO Payments (payment_id, student_id, amount, payment_date) VALUES
(1, 1, 5000, '2024-02-01'),
(2, 2, 4800, '2024-02-02'),
(3, 3, 5300, '2024-02-03'),
(4, 4, 4700, '2024-02-04'),
(5, 5, 5100, '2024-02-05'),
(6, 6, 5200, '2024-02-06'),
(7, 7, 4950, '2024-02-07'),
(8, 8, 5000, '2024-02-08'),
(9, 9, 5050, '2024-02-09'),
(10, 10, 5150, '2024-02-10');

INSERT INTO Students (student_id, first_name, last_name, date_of_birth, email, phone_number) VALUES
(1, 'Pravi', 'sompi', '2000-05-14', 'pravi.sompi@gmail.com', 9876543210),
(2, 'selva', 'mary', '1999-08-21', 'selva.mary@gmail.com', 9876543211),
(3, 'cutie', 'pie', '2001-03-03', 'cutie.pie@gmail.com', 9876543212),
(4, 'pravi', 'pavan', '2002-07-18', 'pravi.pavan@gmail.com', 9876543213),
(5, 'arun', 'raj', '2000-12-25', 'arun.raj@gmail.com', 9876543214),
(6, 'red', 'velvet', '1998-11-30', 'red.velvet@gmail.com', 9876543215),
(7, 'brown', 'cake', '2001-09-09', 'brown.cake@gmail.com', 9876543216),
(8, 'Harry', 'shinchan', '2003-01-17','harry.shinchan@gmail.com', 9876543217),
(9, 'Iron', 'man', '1999-04-10', 'iron.man@gmail.com', 9876543218),
(10, 'Jacky', 'chan', '2000-06-06', 'jacky.chan@gmail.com', 9876543219);

ALTER TABLE Students
ALTER COLUMN phone_number BIGINT;

--Task -4--
---q.4.1//calculate the average number of students enrolled in each course.---

select avg(Student_count) as Avg_stu_count_per_course
from
(select course_id , count(student_id) as Student_count
from Enrollments group by course_id) as course_enroll_count;

---q.4.2//Identify the student(s) who made the highest payment.---
select top 1 student_id, amount
from Payments
order by amount desc;

--using subquery--
select student_id,amount from Payments 
where amount = (select max(amount) from Payments);

---q.4.3//Retrieve a list of courses with the highest number of enrollments.
select course_id,count(student_id) as Student_count from Enrollments
group by course_id having count(student_id)
=(select max(Student_count)
from(select course_id , count(student_id) as Student_count
from Enrollments group by course_id) as enroll_count);


---q.4.4//Calculate the total payments made to courses taught by each teacher.--
select t.teacher_id,t.first_name,t.last_name, sum(p.amount) as total_payment
from Payments p 
join Enrollments e on p.student_id = e.student_id
join Courses c on e.course_id=c.course_id
join Teachers t on c.teacher_id=t.teacher_id
group by t.teacher_id,t.first_name,t.last_name;

---q.4.5//Identify students who are enrolled in all available courses.---
select student_id
from enrollments
group by student_id
having count(distinct course_id) = (
    select count(*) from courses
);

---q.4.6//Retrieve the names of teachers who have not been assigned to any courses. Use subqueries to 
---find teachers with no course assignments.
select teacher_id, first_name, last_name
from teachers
where teacher_id not in (
  select teacher_id from courses where teacher_id is not null
);

---q.4.7//Calculate the average age of all students. Use subqueries to calculate the age of each student 
--based on their date of birth.
select avg(datediff(year, date_of_birth, getdate())) as average_age
from students;

---q.4.8//Identify courses with no enrollments. Use subqueries to find courses without enrollment 
---records.
select course_id, course_name
from courses
where course_id not in (
  select course_id from enrollments
);

---q.4.9//Calculate the total payments made by each student for each course they are enrolled in. Use 
--subqueries and aggregate functions to sum payments
select s.student_id, s.first_name, s.last_name, c.course_name, sum(p.amount) as total_payment
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
join payments p on s.student_id = p.student_id
group by s.student_id, s.first_name, s.last_name, c.course_name;

---q.4.10//Identify students who have made more than one payment. Use subqueries and aggregate 
--functions to count payments per student and filter for those with counts greater than one.

select student_id
from payments
group by student_id
having count(payment_id) > 1;

---q.4.11//Write an SQL query to calculate the total payments made by each student. Join the "Students" 
--table with the "Payments" table and use GROUP BY to calculate the sum of payments for each 
--student.
select s.student_id, s.first_name, s.last_name, sum(p.amount) as total_payment
from students s
join payments p on s.student_id = p.student_id
group by s.student_id, s.first_name, s.last_name;


--q.4.12//Retrieve a list of course names along with the count of students enrolled in each course. Use 
--JOIN operations between the "Courses" table and the "Enrollments" table and GROUP BY to 
--count enrollments.
select c.course_name, count(e.student_id) as student_count
from courses c
left join enrollments e on c.course_id = e.course_id
group by c.course_name;

---q.4.13//Calculate the average payment amount made by students. Use JOIN operations between the 
--"Students" table and the "Payments" table and GROUP BY to calculate the average.
select s.student_id, s.first_name, s.last_name, avg(p.amount) as average_payment
from students s
join payments p on s.student_id = p.student_id
group by s.student_id, s.first_name, s.last_name;

---Task 2---
---q.2.1//Write an SQL query to insert a new student into the "Students" table with the following details:
---a. First Name: John
---b. Last Name: Doe
---c. Date of Birth: 1995-08-15
---d. Email: john.doe@example.com
---e. Phone Number: 1234567890
insert into Students(student_id, first_name, last_name, date_of_birth, email, phone_number)values
(11,'John','Doe','1995-08-15',': john.doe@example.com',1234567890)
select * from Students

---q.2.2//Write an SQL query to enroll a student in a course. Choose an existing student and course and 
---insert a record into the "Enrollments" table with the enrollment date.
insert into Enrollments(enrollment_id, student_id, course_id, enrollment_date)values
(11,1,210,'2025-04-10');
select * from Enrollments;

---q.2.3//Update the email address of a specific teacher in the "Teacher" table. Choose any teacher and 
---modify their email address.
update Teachers
set email='pravi@gmail.com'
where teacher_id=101;
select * from Teachers

---q.2.4//Write an SQL query to delete a specific enrollment record from the "Enrollments" table. Select 
---an enrollment record based on the student and course.
delete from Enrollments
where student_id = 1 and course_id = 1;

---q.2.5//Update the "Courses" table to assign a specific teacher to a course. Choose any course and 
---teacher from the respective tables
update Courses
set teacher_id = 201
where course_id = 101;

---q.2.6//Delete a specific student from the "Students" table and remove all their enrollment records 
--from the "Enrollments" table. Be sure to maintain referential integrity.

delete from Enrollments
where student_id = 2;


delete from Students
where student_id = 2;

---q.2.7//Update the payment amount for a specific payment record in the "Payments" table. Choose any 
--payment record and modify the payment amount.
update Payments
set amount = 1500
where payment_id = 5;

---Task-3---

---q.3.1//Write an SQL query to calculate the total payments made by a specific student. You will need to 
--join the "Payments" table with the "Students" table based on the student's ID.
select s.student_id, s.first_name, s.last_name, sum(p.amount) as total_payments
from students s
join payments p on s.student_id = p.student_id
where s.student_id = 1
group by s.student_id, s.first_name, s.last_name;

---q.3.2//Write an SQL query to retrieve a list of courses along with the count of students enrolled in each 
--course. Use a JOIN operation between the "Courses" table and the "Enrollments" table
select c.course_id, c.course_name, count(e.student_id) as student_count
from courses c
left join enrollments e on c.course_id = e.course_id
group by c.course_id, c.course_name;


--q.3.3//Write an SQL query to find the names of students who have not enrolled in any course. Use a 
--LEFT JOIN between the "Students" table and the "Enrollments" table to identify students 
--without enrollments.
select s.student_id, s.first_name, s.last_name
from students s
left join enrollments e on s.student_id = e.student_id
where e.enrollment_id is null;


--q.3.4//Write an SQL query to retrieve the first name, last name of students, and the names of the 
--courses they are enrolled in. Use JOIN operations between the "Students" table and the 
--"Enrollments" and "Courses" tables.
select s.first_name, s.last_name, c.course_name
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id;

---q.3.5//Create a query to list the names of teachers and the courses they are assigned to. Join the 
--"Teacher" table with the "Courses" table.
select t.first_name, t.last_name, c.course_name
from teachers t
join courses c on t.teacher_id = c.teacher_id;

--q.3.6//Retrieve a list of students and their enrollment dates for a specific course. You'll need to join the 
--"Students" table with the "Enrollments" and "Courses" tables.
select s.first_name, s.last_name, e.enrollment_date
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
where c.course_id = 1;

---q.3.7//Find the names of students who have not made any payments. Use a LEFT JOIN between the 
--"Students" table and the "Payments" table and filter for students with NULL payment records.
select s.student_id, s.first_name, s.last_name
from students s
left join payments p on s.student_id = p.student_id
where p.payment_id is null;

--3.8//Write a query to identify courses that have no enrollments. You'll need to use a LEFT JOIN 
--between the "Courses" table and the "Enrollments" table and filter for courses with NULL 
--enrollment records.
select c.course_id, c.course_name
from courses c
left join enrollments e on c.course_id = e.course_id
where e.enrollment_id is null;


--3.9//Identify students who are enrolled in more than one course. Use a self-join on the "Enrollments" 
--table to find students with multiple enrollment records.
select s.student_id, s.first_name, s.last_name, count(e.course_id) as course_count
from students s
join enrollments e on s.student_id = e.student_id
group by s.student_id, s.first_name, s.last_name
having count(e.course_id) > 1;


--3.10//Find teachers who are not assigned to any courses. Use a LEFT JOIN between the "Teacher" 
--table and the "Courses" table and filter for teachers with NULL course assignments.
select t.teacher_id, t.first_name, t.last_name
from teachers t
left join courses c on t.teacher_id = c.teacher_id
where c.course_id is null;


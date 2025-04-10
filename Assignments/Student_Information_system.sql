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

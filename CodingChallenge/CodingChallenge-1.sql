---q.1//Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”. 
---q.4//Ensure the script handles potential errors, such as if the database or tables already exist.

if not exists (select * from sys.databases where name =  'CareerHub') 
begin
create database CareerHub;
end;
go
use CareerHub;
go


---q.2//Create tables for Companies, Jobs, Applicants and Applications
---q.3//Define appropriate primary keys, foreign keys, and constraints

create table Companies(
CompanyID int identity(1,1) primary key,
CompanyName varchar(100),
Location varchar(100)
);

create table Jobs(
JobID int identity(1,1) primary key,
CompanyID int foreign key references Companies(CompanyID),
JobTitle varchar(100),
JobDescription text,
JobLocation varchar(100),
Salary decimal(10,2),
JobType varchar(100),
PostedDate datetime
);

create table Applicants(
ApplicantID int identity(1,1) primary key,
FirstName varchar(100),
LastName varchar(100),
Email varchar(100),
Phone varchar(100),
Resume text
);

create table Applications(
ApplicationID int identity(1,1) primary key,
JobID int foreign key references Jobs(JobID),
ApplicantID int foreign key references Applicants(ApplicantID),
ApplicationDate datetime,
CoverLetter text
);

insert into Companies(CompanyName , Location) values
('A', 'Chennai'),
('B', 'Hyderabad'),
('C', 'Bangalore'),
('D', 'Pune'),
('E', 'Mumbai');

insert into Jobs(CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate)values
(1, 'Data analyst','Analyses the company data','Bangalore',65000.00,'Full-Time','2024-02-10 10:00:00'),
(2, 'Cybersecurity Engineer', 'Test software for bugs.', 'Chennai', 50000.00, 'Contract', '2024-03-05 11:45:00'),
(3, 'DevOps Engineer', 'Maintain CI/CD pipelines.', 'Hyderabad', 80000.00, 'Full-time', '2024-04-01 08:15:00'),
(4, 'UI/UX Designer', 'Design user interfaces.', 'Pune', 60000.00, 'Part-time', '2024-05-20 14:00:00'),
(5, 'Software Engineer', 'Develop web applications.', 'Mumbai', 75000.00, 'Full-time', '2024-01-15 09:30:00');

insert into Applicants (FirstName, LastName, Email, Phone, Resume) values
('pravi', 'sompi', 'pravi@gmail.com', '9876543210', 'Expert in data visualization.'),
('pavan', 'suresh', 'pavan@gmail.com', '9876512345', 'Proficient in Cybersecurity.'),
('likita', 'santhoshi', 'likita@gmail.com', '9876509876', 'Skilled in DevOps tools.'),
('aron', 'sanura', 'aron@gmail.com', '9876598765', 'Creative UI designer.'),
('nandhu', 'nandy', 'nandy@gmail.com', '9876587654', 'Experienced Python developer.');

insert into Applications (JobID, ApplicantID, ApplicationDate, CoverLetter) values
(1, 1, '2024-02-15 09:30:00', 'Eager to apply my data skills to your projects.'),
(2, 2, '2024-03-08 10:20:00', 'Cybersecurity is my core expertise.'),
(3, 3, '2024-04-03 14:00:00', 'I can optimize your DevOps pipelines.'),
(4, 4, '2024-05-25 13:15:00', 'Designing intuitive UI is my passion.'),
(5, 5, '2024-01-20 10:45:00', 'I enjoy building scalable software.');


---q.5//Write an SQL query to count the number of applications received for each job listing in the
-------"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all
--------jobs, even if they have no applications.

select j.JobTitle , count(a.ApplicantID) as number_of_applications_received
from Jobs j
left join Applications a on a.JobID = j.JobID
group by j.JobTitle;


---q.6//Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary
--------range. Allow parameters for the minimum and maximum salary values. Display the job title,
--------company name, location, and salary for each matching job.

select j.JobTitle,c.CompanyName,c.Location,j.Salary 
from Jobs j 
join Companies c on c.CompanyID = j.CompanyID
where j.Salary between 50000 and 80000


---q.7//Write an SQL query that retrieves the job application history for a specific applicant. Allow a
--------parameter for the ApplicantID, and return a result set with the job titles, company names, and
--------application dates for all the jobs the applicant has applied to.

select j.JobTitle,c.CompanyName,a.ApplicationDate
from Applicants ap 
join Applications a on ap.ApplicantID= a.ApplicantID
join Jobs j on a.JobID=j.JobID
join Companies c on j.CompanyID=c.CompanyID
where FirstName = 'Pravi'


---q.8//Create an SQL query that calculates and displays the average salary offered by all companies for
--------job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero.

select AVG(Salary) as average_salary,CompanyName,JobTitle
from Jobs j
join Companies c on j.CompanyID=c.CompanyID
group by JobTitle,CompanyName


---q.9//Write an SQL query to identify the company that has posted the most job listings. Display the
--------company name along with the count of job listings they have posted. Handle ties if multiple
--------companies have the same maximum count.

with job_counts as (
select c.CompanyName , count(j.JobID) as job_lists 
from Companies c
join Jobs j on c.CompanyID = j.CompanyID
group by c.CompanyName
)
select CompanyName , job_lists
from  job_counts
where job_lists=(select max(job_lists) from job_counts);


---q.10//Find the applicants who have applied for positions in companies located in 'CityX' and have at
---least 3 years of experience.

alter table Applicants
add Experience int;

update Applicants
set Experience = 2
where ApplicantID = 1;

update Applicants
set Experience = 3
where ApplicantID = 2;

update Applicants
set Experience = 1
where ApplicantID = 3;

update Applicants
set Experience = 4
where ApplicantID = 4;

update Applicants
set Experience = 5
where ApplicantID = 5;

select * from Applicants

with position as (
select j.JobTitle, a.ApplicantID
from Applications a
join Jobs j on a.JobID = j.JobID
)
select a.FirstName, a.LastName, a.Experience, p.JobTitle
from Applicants a
join position p on a.ApplicantID = p.ApplicantID
where a.Experience = 3;


---q.11//. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000.--

select JobTitle,Salary
from Jobs j
where j.Salary between 60000 and 80000


---q.12//Find the jobs that have not received any applications.

select JobTitle
from Jobs j
left join Applications a on a.JobID=j.JobID
where ApplicationID is null


---q.13//Retrieve a list of job applicants along with the companies they have applied to and the positions
---they have applied for.

select ap.FirstName, ap.LastName, c.CompanyName, j.JobTitle
from Applications a
join Applicants ap on a.ApplicantID = ap.ApplicantID
join Jobs j on a.JobID = j.JobID
join Companies c on j.CompanyID = c.CompanyID;


---q.14//Retrieve a list of companies along with the count of jobs they have posted, even if they have not
---received any applications.

select c.CompanyName, count(j.JobID) as JobCount
from Companies c
left join Jobs j on c.CompanyID = j.CompanyID
group by c.CompanyName;


---q.15//List all applicants along with the companies and positions they have applied for, including those
---who have not applied.

select ap.FirstName, ap.LastName, c.CompanyName, j.JobTitle
from Applicants ap
left join Applications a on ap.ApplicantID = a.ApplicantID
left join Jobs j on a.JobID = j.JobID
left join Companies c on j.CompanyID = c.CompanyID;


---q.16//Find companies that have posted jobs with a salary higher than the average salary of all jobs.

select c.CompanyName , avg_sal
from Companies c
join Jobs j on c.CompanyID = j.CompanyID
where j.Salary > (
    select avg(Salary) as avg_sal
    from Jobs
    where Salary > 0
);


---q.17//Display a list of applicants with their names and a concatenated string of their city and state.

alter table Applicants
add City varchar(100), State varchar(100);

update Applicants set City = 'Chennai', State = 'TN' where ApplicantID = 1;
update Applicants set City = 'Hyderabad', State = 'TS' where ApplicantID = 2;
update Applicants set City = 'Bangalore', State = 'KA' where ApplicantID = 3;
update Applicants set City = 'Pune', State = 'MH' where ApplicantID = 4;
update Applicants set City = 'Mumbai', State = 'MH' where ApplicantID = 5;

select FirstName, LastName, City + ', ' + State as FullLocation
from Applicants;


---q.18//Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.

select JobTitle
from Jobs
where JobTitle like '%Developer%' or JobTitle like '%Engineer%';


---q.19//Retrieve a list of applicants and the jobs they have applied for, including those who have not applied and *jobs without applicants*.

select ap.FirstName, ap.LastName, j.JobTitle
from Applicants ap
full outer join Applications a on ap.ApplicantID = a.ApplicantID
full outer join Jobs j on a.JobID = j.JobID;


---q.20// List all combinations of applicants and companies where the company is in a specific city and the applicant has more than 2 years of experience. Example: Chennai

select ap.FirstName, ap.LastName, c.CompanyName, c.Location
from Applicants ap
join Applications a on ap.ApplicantID = a.ApplicantID
join Jobs j on a.JobID = j.JobID
join Companies c on j.CompanyID = c.CompanyID
where ap.Experience > 2 and c.Location = 'Chennai';




select * from Employees
CREATE TABLE emplo (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Department VARCHAR(50)
);

INSERT INTO emplo VALUES
(1, 'John', 'Doe', 25, 'IT'),
(2, 'Jane', 'Smith', 30, 'HR'),
(3, 'Bob', 'Johnson', 28, 'Finance'),
(4, 'Alice', 'Williams', 35, 'Marketing'),
(5, 'Charlie', 'Brown', 22, 'IT');

INSERT INTO emplo VALUES
(6, 'Eva', 'Green', 28, 'Marketing'),
(7, 'Michael', 'Johnson', 35, 'IT'),
(8, 'Sophia', 'Miller', 30, 'Finance'),
(9, 'Daniel', 'Clark', 22, 'HR'),
(10, 'Emma', 'Davis', 32, 'Marketing');

--Retrieve the EmployeeID and FirstName for employees who are in the 'IT' department and are older than 30.
select employeeid, firstname
from emplo
where department = 'IT' and age > 30;

--Find the average age of employees in the 'Marketing' department.
select department, round(avg(age),0) as avg_age
from emplo
group by department
having department = 'Marketing';

--List the departments where the total number of employees is greater than 2.
select department, count(*)
from emplo
group by department
having count(*) > 2;
select * from emplo
--Retrieve the names of employees who have the same last name and are in the same department.
select e1.employeeid as employeeid1,
       e1.firstname as firstname1,
       e1.lastname as lastname1,
       e1.department as department1,
       e2.employeeid as employeeid2,
       e2.firstname as firstname2,
       e2.lastname as lastname2,
       e2.department as department2
from emplo e1
join emplo e2
on e1.lastname = e2.lastname
   and e1.department = e2.department
   and e1.employeeid <> e2.employeeid;

--Find the department(s) with the highest average age.
select department, round(avg(age),0) as avg_age
from emplo
group by department
order by avg_age desc
limit 1;

--List the departments with more than two employees and order the result by department name.
select department, count(*)
from emplo
group by department 
having count(*) >2
order by department;
select * from emplo
--Retrieve the employee(s) with the highest age in each department.
select e.firstname, e.lastname, e.age, e.department
from emplo e
join (select department, max(age) as maxage
      from emplo
      group by department) max_age
on 
    e.department = max_age.department
    and e.age = max_age.maxage;

--Calculate the total number of employees in each department, including those with no employees.
select department, count(*)
from emplo
group by department;

select d.department, 
       coalesce(count(e.employeeid),0)
from emplo e
right join
      (select distinct department from emplo) d
on 
      d.department = e.department
group by 
      d.department;

--Find the average age of employees who work in departments with at least one employee older than 30.
select e.department, round(avg(e.age),0) avg_age
from emplo e
join (select distinct department, age from emplo
where age > 30) d
on d.department = e.department
group by e.department;

--List the departments where the average age is below the overall average age of all employees.
select department, round(avg(age),2) as Avgage
from emplo
group by department
having round(avg(age),2)> (select round(avg(age),2) from emplo);

--Retrieve the employee(s) with the lowest age in the 'Finance' department.
select department, min(age) as Minage
from emplo
group by department
having department = 'Finance';

--Count the number of employees who have the same first name.
select firstname, count(*) as Namecount
from emplo
group by firstname;

--Find the department with the highest total age of employees.
select department, sum(age) as Totalage
from emplo
group by department
order by totalage desc
limit 1;
--Retrieve employees who have the same age and are in different departments.
SELECT firstname, lastname, age, department
FROM (
    SELECT firstname, lastname, age, department, COUNT(*) OVER (PARTITION BY age) AS agecount
    FROM emplo
) AS subquery
WHERE agecount > 1
ORDER BY age;
 
select e.firstname, e.lastname, e.age, e.department from emplo e
join (select age, count(*) from emplo
group by age
having count(*) >1) a
on e.age = a.age
order by e.age;
--Calculate the total number of employees for each combination of department and age.
select department, age, count(*) as Employeecount from emplo
group by department, age

--List the employees who have the same age as at least one other employee.
select firstname, lastname, age, department
from 
     (select firstname, lastname, age, department, count(*) over (partition by age) Agecount
     from emplo
) as subquery 
where Agecount >1     
order by age;

select e.firstname,e.lastname, e.age, e.department
from emplo e
join 
     (select age, count(*)
      from emplo 
      group by age 
      having count(*) >1
      ) a
on a.age = e.age
order by e.age;
--Retrieve the employee(s) with the highest age who work in departments with at least three employees.

select e.firstname, e.lastname, e.department, e.age 
from emplo e
join 
        (select department, max(age)
        from emplo
        group by department
        having count(*) >= 3) d
on e.department = d.department and e.age = d.max



--Find the departments where the total number of employees is odd.
select department 
from emplo
group by department
having count(*) % 2 =1;

--Retrieve the department(s) with the highest total age but exclude 'Marketing' from the result.
select department, sum(age) as Totalage
from emplo
group by department
having department <> 'Marketing'
order by Totalage desc
limit 1;

--List the departments where the average age is above the overall average age of all employees.
select department, round(avg(age),2)
from emplo
group by department
having round(avg(age),2) >(select round(avg(age),2) from emplo);
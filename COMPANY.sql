--50 QUESTIONS PROJECT--

-- Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO Departments (department_id, department_name) VALUES
(101, 'Engineering'),
(102, 'Data Science'),
(103, 'Human Resources');

-- Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT REFERENCES Departments(department_id),
    hire_date DATE,
    job_title VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT NULL
);

INSERT INTO Employees VALUES
(1, 'John', 'Smith', 101, '2018-03-15', 'Software Engineer', 60000, 5),
(2, 'Sarah', 'Johnson', 102, '2019-07-01', 'Data Analyst', 55000, 6),
(3, 'Michael', 'Brown', 101, '2017-11-20', 'Senior Engineer', 80000, 5),
(4, 'Emily', 'Davis', 103, '2020-05-18', 'HR Specialist', 50000, 7),
(5, 'David', 'Wilson', 101, '2015-01-10', 'Engineering Mgr', 95000, NULL),
(6, 'Linda', 'Martinez', 102, '2016-02-25', 'Data Science Mgr', 105000, NULL),
(7, 'James', 'Anderson', 103, '2014-09-12', 'HR Manager', 90000, NULL),
(8, 'Robert', 'Taylor', 101, '2021-08-09', 'Intern', 30000, 5);

-- Projects table
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    department_id INT REFERENCES Departments(department_id),
    budget DECIMAL(10,2),
    start_date DATE,
    end_date DATE
);

INSERT INTO Projects VALUES
(201, 'AI Chatbot', 102, 200000, '2021-01-01', '2021-12-31'),
(202, 'Mobile App', 101, 150000, '2020-06-01', '2021-06-01'),
(203, 'Recruitment Drive', 103, 80000, '2021-03-01', '2021-09-01'),
(204, 'Cloud Migration', 101, 300000, '2019-04-01', '2022-04-01');

SELECT *FROM Departments;
SELECT *FROM Employees;
SELECT *FROM Projects;

--Questions 1–20--
--1. Select all employees from Engineering department.--

SELECT e.first_name,d.department_name from Employees e
join Departments d
on e.department_id=d.department_id
where department_name='Engineering';
--or--
SELECT *FROM Employees where department_id=101;

--2. Find employees who joined after 2018.--

SELECT *
FROM Employees
WHERE EXTRACT(YEAR FROM hire_date) > 2018;

--3. List employees with salary greater than 70,000.--

SELECT first_name,last_name,salary
from Employees
where salary>70000;

--4. Show distinct job titles in the company.--

SELECT DISTINCT job_title from Employees;

--5. Sort employees by hire_date (earliest first).--

SELECT first_name,last_name,hire_date
from Employees
order by hire_date ASC;

--6. Find the average salary of each department.--

SELECT d.department_name,AVG(e.salary) AS AVG_SALARY
FROM Employees e
join Departments d
on e.department_id=d.department_id
group by d.department_name;

--7. List employees along with their department name.--

SELECT e.first_name,e.last_name,d.department_name
FROM Employees e
join Departments d
on e.department_id=d.department_id;

--8. Find the highest paid employee in Data Science.--

SELECT e.first_name,e.last_name,e.salary AS HIGH_SALARY
FROM Employees e
join Departments d
on e.department_id=d.department_id
WHERE d.department_name= 'Data Science'
ORDER BY HIGH_SALARY DESC
limit 1;

SELECT first_name,last_name,salary
FROM (SELECT e.*, DENSE_RANK() over(order by salary desc) as RANK FROM Employees e
join Departments d
on e.department_id=d.department_id)t
where RANK<=2;


--9. Count how many employees each manager supervises.--

SELECT m.manager_id as MANAGER_ID,
m.first_name|| ' '||m.last_name as name,count(e.employee_id)
from Employees m
LEFT join Employees e
on m.employee_id=e.manager_id
group by m.employee_id, name;

SELECT manager_id, COUNT(*) AS num_employees FROM Employees WHERE manager_id IS 
NOT NULL GROUP BY manager_id;

SELECT 
    m.employee_id AS manager_id,
    m.first_name || ' ' || m.last_name AS manager_name,
    COUNT(e.employee_id) AS employees_under_manager
FROM Employees m
LEFT JOIN Employees e
    ON m.employee_id = e.manager_id   -- match employees to this manager
GROUP BY m.employee_id, m.first_name, m.last_name
having COUNT(e.employee_id)>0;


--10. Show employees working in projects with a budget over 200,000.--

SELECT e.first_name,e.last_name,p.budget
from Employees e
join Projects p
on e.department_id=p.department_id
WHERE p.budget>200000;

--11. Find employees whose salary is above the company average.--

SELECT first_name,last_name,salary
from Employees
WHERE salary>(SELECT AVG(salary)  from Employees);

--12. List departments that have more than 2 employees.--

SELECT department_id,COUNT(first_name)
from Employees
group by department_id
HAVING COUNT(first_name)>2;

--13. Show employees who do not manage anyone.--

SELECT first_name,last_name
from Employees
where manager_id is NOT NULL;

SELECT employee_id, first_name, last_name FROM Employees  WHERE employee_id 
NOT IN (SELECT DISTINCT manager_id FROM Employees WHERE manager_id IS NOT 
NULL); 

--14. Find employees who are not assigned to any project.--

SELECT first_name,last_name
from Employees e
where e.department_id not in 
(select department_id from Projects);

SELECT e.first_name, e.last_name
FROM Employees e 
LEFT JOIN Projects p
ON e.department_id = p.department_id
WHERE p.project_id IS NULL; 

--15. Get the 2nd highest salary in the company.--

SELECT DISTINCT salary
from Employees
ORDER BY salary DESC
limit 1
offset 1;

--16. Rank employees within each department by salary.--

SELECT e.first_name,e.last_name,e.salary,d.department_name,RANK() OVER
(PARTITION BY d.department_name order by e.salary desc) as dept_rank
FROM Employees e
join Departments d
on e.department_id=d.department_id;

--17. Find the top 3 highest paid employees in the company.--

SELECT first_name,last_name,salary
FROM Employees
order by salary desc limit 3;

SELECT first_name, last_name, salary FROM (SELECT e.*, DENSE_RANK() OVER (ORDER BY 
salary DESC) AS rnk FROM Employees e) t WHERE rnk <= 3; 

--18. Show cumulative salary expense ordered by hire_date.--

SELECT first_name,last_name,hire_date,salary,sum(salary) over(ORDER BY hire_date) 
as RUNNING_SALARY
FROM Employees;

--19. Find departments where average salary is higher than the overall company average.-- 

WITH company_avg as(SELECT AVG(salary) as avg_company from Employees)
SELECT d.department_name,AVG(e.salary) as AVG_SALARY_DEPT
FROM Employees e
join Departments d
on e.department_id=d.department_id
group by d.department_name
HAVING AVG(e.salary) > (SELECT avg_company from company_avg);

--20. List employees with their manager’s name.--

SELECT e.first_name AS employee, m.first_name AS manager FROM Employees e LEFT JOIN 
Employees m ON e.manager_id = m.employee_id;

--21. Retrieve the total salary paid by each department.--

SELECT d.department_name,sum(e.salary)
from Employees e
join Departments d
on e.department_id=d.department_id
group by d.department_name;

--22. Find employees hired in the year 2020.--

SELECT first_name||' '||last_name as NAME,hire_date
from Employees
where EXTRACT(YEAR FROM hire_date)=2020;

--23. List employees whose name starts with 'J'.--

SELECT first_name from Employees
where first_name LIKE 'J%';

--24. Get employees who earn between 50,000 and 90,000.--

SELECT first_name||' '||last_name AS NAME
FROM Employees
where salary BETWEEN '50000' AND '90000';

--25. Show department name and number of projects handled by each.--

SELECT d.department_name,count(p.project_name)
from Departments d
LEFT join Projects p
on d.department_id=p.department_id
group by d.department_name;

--26. Find projects that ended before 2021.--

SELECT project_name FROM Projects
where extract(year from end_date)<2021;

--27. Show employees who joined before their manager.--

SELECT e.first_name||' '||e.last_name as EMP_name
from Employees e
left join Employees m
on e.manager_id=m.employee_id
where e.hire_date<m.hire_date;

--28. Find the minimum and maximum salary in each department.--

SELECT d.department_name,max(e.salary),min(e.salary)
from Departments d
join Employees e
on d.department_id=e.department_id
group by d.department_name;

--29. Show employees with the same job title.--
UPDATE Employees
set job_title='Data Analyst'
where employee_id=1;

SELECT e1.employee_id, e1.first_name,e2.first_name as e2, e1.last_name, e1.job_title
FROM Employees e1
JOIN Employees e2
    ON e1.job_title = e2.job_title
   AND e1.employee_id <> e2.employee_id
ORDER BY e1.job_title, e1.first_name;

--30. Retrieve employees hired in the last 6 years.--

SELECT first_name||' '||last_name, hire_date 
FROM Employees
WHERE hire_date >= CURRENT_DATE-INTERVAL '6 years';

--31. Find employees working on projects starting in 2021.--

SELECT e.first_name||' '||e.last_name AS NAME,EXTRACT(YEAR FROM p.start_date) as START_DATE
FROM Employees e
left join Projects p
on e.department_id=p.department_id
where EXTRACT(YEAR FROM p.start_date)=2021; 

--32. Show managers who earn less than some of their team members.--

SELECT DISTINCT m.first_name, m.last_name, m.salary 
FROM Employees m 
JOIN Employees e ON m.employee_id = e.manager_id 
WHERE m.salary > e.salary;

--33. Find departments that don’t have any projects.--

SELECT d.department_name 
FROM Departments d 
LEFT JOIN Projects p ON d.department_id = p.department_id 
WHERE p.project_id IS NULL; 

--34. Show employees who work in more than one project (if project assignments--
--were tracked by department).--

SELECT e.first_name, e.last_name, COUNT(p.project_id) AS project_count 
FROM Employees e 
JOIN Projects p ON e.department_id = p.department_id 
GROUP BY e.employee_id
having COUNT(p.project_id)>1; 

35. Get employees whose salary is equal to the department average. 

SELECT e.first_name, e.last_name, e.salary, d.department_name 
FROM Employees e 
JOIN Departments d 
ON e.department_id = d.department_id 
WHERE e.salary > ( SELECT AVG(salary) FROM Employees
WHERE department_id = e.department_id); 

--36.Find the project with the largest budget.--

SELECT project_name,budget FROM Projects
order by budget DESC
LIMIT 1;

--37.Show departments and their highest paid employee.--

SELECT d.department_name, e.first_name, e.last_name, e.salary 
FROM Employees e 
JOIN Departments d ON e.department_id = d.department_id
WHERE e.salary = ( 
SELECT MAX(salary) FROM Employees 
WHERE department_id = d.department_id 
);

WITH dept_max AS (
    SELECT department_id, MAX(salary) AS max_salary
    FROM Employees
    GROUP BY department_id
)
SELECT d.department_name, e.first_name, e.last_name, e.salary
FROM Employees e
JOIN Departments d 
    ON e.department_id = d.department_id
JOIN dept_max dm
    ON e.department_id = dm.department_id
   AND e.salary = dm.max_salary;

--38.Find employees who joined in the same year as their manager--

SELECT e.first_name, e.last_name,e.hire_date, m.first_name AS manager,m.hire_date 
FROM Employees e
JOIN Employees m ON e.manager_id = m.employee_id 
WHERE EXTRACT(YEAR FROM e.hire_date) <> EXTRACT(YEAR FROM m.hire_date);

--39. Get the average project budget by year.--

WITH daily_budget AS (
    SELECT
        generate_series(start_date, end_date, '1 day'::interval)::date AS day_date,
        budget / (end_date - start_date + 1) AS daily_cost
    FROM Projects
)
SELECT
    EXTRACT(YEAR FROM day_date) AS year,
    SUM(daily_cost) AS AVG_budget
FROM daily_budget
GROUP BY year
ORDER BY year;

SELECT EXTRACT(YEAR FROM start_date),AVG(budget) AS avg_budget 
FROM Projects 
GROUP BY EXTRACT(YEAR FROM start_date);

--40.List all employees and indicate whether they are a manager or not.--

SELECT *FROM 
(
SELECT e.first_name, e.last_name, 
CASE
     WHEN EXISTS (SELECT  *from Employees WHERE manager_id = e.employee_id) 
THEN 'Manager' ELSE 'Employee' END AS role 
FROM Employees e)t
where role ='Manager';

--41.Show the longest running project.--

SELECT project_name,(end_date-start_date) as project_duration
from Projects
ORDER BY project_duration desc limit 1;

--42.Get departments sorted by average salary (descending)--

SELECT d.department_name,avg(e.salary) as AVG_SALARY
from Departments d
join Employees e
on d.department_id=e.department_id
group by d.department_name
order by AVG_SALARY DESC;

--43.Find employees who earn more than their manager--

SELECT distinct e.first_name||' '||e.last_name,e.salary
from Employees e
join Employees m
on e.manager_id=m.employee_id
where e.salary>m.salary;

--44.List projects with no end date (ongoing projects)--

SELECT project_name from Projects where end_date is null;

--45.Show total salary expense per year based on hire_date--

SELECT EXTRACT(YEAR FROM hire_date) as YEAR,sum(salary)
from Employees
GROUP BY YEAR
ORDER BY YEAR;

--46.Find the difference between highest and lowest salary in the company-- 

SELECT MAX(salary)-MIN(salary) as SALARY_DIFF
from Employees;

--47.Retrieve employees ranked by salary across the company--

SELECT first_name||' '||last_name as NAME,salary,Dense_rank()OVER(ORDER BY salary desc)
from Employees;

--48.Show employees hired in each department, ordered by hire_date--

SELECT e.first_name||' '||e.last_name as NAME,d.department_name,e.hire_date,Dense_rank()OVER(partition by d.department_name ORDER BY hire_date)
from Employees e
join Departments d
on e.department_id=d.department_id;

--49.Find the project with the smallest budget--

select project_name,budget from Projects
order by budget limit 1;

--50.Get employees with salaries above their department’s average--

SELECT e.first_name,d.department_name,e.salary
from Employees e
join Departments d
on e.department_id=d.department_id
where e.salary>(SELECT AVG(SALARY) FROM
Employees where department_id=e.department_id);



SELECT *FROM Departments;
SELECT *FROM Employees;
SELECT *FROM Projects;

























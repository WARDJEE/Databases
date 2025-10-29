-- ************************************************************
-- SLIDE DECK : Inner_NonEqui_Join
-- ************************************************************
-- ************************************************************
-- Preparation
-- ************************************************************
-- _PG_CRE_ENTERPRISE_EN.sql
-- _PG_FILL_ENTERPRISE_EN.sql

-- Slide 4 & 5
-- Preparation
-- These are all the employees and the ID of their department
SELECT employee_id, last_name, first_name, department_id
FROM EMPLOYEES;

-- These are all the departments with their name
SELECT department_id, department_name
FROM DEPARTMENTS;

-- Slide 7
SELECT employee_id,last_name,first_name,department_name  
FROM departments,employees;

-- Slide 9
-- How can we show the employees and the NAME of their department?
SELECT EMPLOYEES.employee_id
	,EMPLOYEES.last_name
	,EMPLOYEES.first_name
	,EMPLOYEES.department_id
	,DEPARTMENTS.department_name
FROM EMPLOYEES
	INNER JOIN DEPARTMENTS ON EMPLOYEES.department_id=DEPARTMENTS.department_id;
-- INNER JOIN is default => we can drop the 'INNER'


-- Slide 10
-- Why do we need to prefix the attributes with TABLENAME? Let's try to remove them.
SELECT employee_id
	,last_name
	,first_name
	,department_id
	,department_name
FROM EMPLOYEES
	JOIN DEPARTMENTS ON EMPLOYEES.department_id=DEPARTMENTS.department_id;

-- ERROR : not clear from which table to display the department_id    (it's in both table)

-- Slide 11
-- Correct notation
SELECT employee_id
	,last_name
	,first_name
	,EMPLOYEES.department_id
	,department_name
FROM EMPLOYEES
	JOIN DEPARTMENTS ON EMPLOYEES.department_id=DEPARTMENTS.department_id;

-- Make it shorter using Aliasing
SELECT e.employee_id,e. last_name, e. first_name,
       e.department_id, d.department_name
FROM EMPLOYEES e
JOIN DEPARTMENTS d
ON (e.department_id= d.department_id);

-- And in some cases (identical attribute names) - even shorter
-- note : now we can drop the table PREFIX
SELECT employee_id
	,last_name
	,first_name
	,department_id
	,department_name
FROM EMPLOYEES JOIN DEPARTMENTS USING(department_id);

-- Slide 12
-- We can still use WHERE clause
--enkel vrouwelijke employees:(met aliassen)
SELECT employee_id,last_name,first_name,e.department_id,department_name
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON (e.department_id=d.department_id)
WHERE UPPER(gender)='F';

--Enkel EMPLOYEES uit de afdeling productie (notatie USING):
SELECT employee_id,last_name,first_name,department_id,department_name
FROM EMPLOYEES 
JOIN DEPARTMENTS USING (department_id)
WHERE UPPER(department_name)='PRODUCTION';

-- Slide 13
-- eg. Give EMPLOYEES that COLLABORATE on PROJECTS:
SELECT * FROM EMPLOYEES;
SELECT * FROM PROJECTS;
SELECT * FROM TASKS;


-- 3 tabellen
SELECT  e.employee_id,e.last_name,p.project_name,
		   t.project_id,t.hours
FROM EMPLOYEES e
JOIN TASKS t ON e.employee_id=t.employee_id
JOIN PROJECTS  p ON t.project_id=p.project_id;







--zou deze query ook werken?
SELECT  e.employee_id,e.last_name,p.project_name,
		   t.project_id,t.hours
FROM EMPLOYEES e
JOIN PROJECTS  p ON t.project_id=p.project_id
JOIN TASKS t ON (e.employee_id=t.employee_id);


-- does not work, TASKS t is not yet known in first join
-- We need the table TASKS to join EMPLOYEES with PROJECTS

-- Slide 16
-- Composite keys
-- What are the grades and grade typed for student 271?

-- Slide 17
-- Switch to Student DB to run query
SELECT e.student_id, grade_type_code,numeric_grade
FROM enrollments e
JOIN grades g ON (      e.student_id=g.student_id
			        AND e.section_id=g.section_id)
WHERE e.student_id=271;

-- Switch back to Enterprise DB

-- Slide 20
-- Natural JOIN
SELECT employee_id
	,last_name
	,first_name
	,department_id
	,department_name
FROM EMPLOYEES
	NATURAL JOIN DEPARTMENTS;

-- Disadvantage: if the tables have other common names, they are also part of the join condition.
-- This could lead to incorrect results!
-- eg. in previous example => manager_id has been incorrectly used in the JOIN

-- Slide 21
-- Better to explicitely list the keys with USING
SELECT employee_id
	,last_name
	,first_name
	,department_id
	,department_name
FROM EMPLOYEES
	JOIN DEPARTMENTS USING (department_id);

-- Slide 19
-- Preparation
DROP TABLE IF EXISTS SCALES CASCADE;
CREATE TABLE SCALES (
    scale_id              numeric(2)
		CONSTRAINT pk_scales PRIMARY KEY,
    limit_lower            numeric(7,2),
    limit_upper            numeric(7,2)
);
INSERT INTO SCALES VALUES
	 (1, 0,    1000 )
	,(2, 1001, 2000 )
 	,(3, 2001, 3000 )
 	,(4, 3001, 4000 )
 	,(5, 4001, 5000 )
;
SELECT * FROM SCALES;

SELECT employee_id, salary, salary/12 from employees;



-- I want to know the pay scale for each employee
SELECT first_name
	,last_name
	,salary
	,scale_id
FROM EMPLOYEES
	JOIN SCALES ON (salary/12 BETWEEN limit_lower AND limit_upper);

DROP TABLE SCALES;

-- I want to find duplicate pairs - WARNING ..  JOINING with same table
INSERT INTO employees (employee_id,last_name,first_name,city)
VALUES ( '999999999', 'Jackson', 'Samuel L', 'Eindhoven');

SELECT employee_id, e1.location, e1.first_name from employees e1;

SELECT e1.location, e1.first_name, e2.first_name
FROM employees e1
JOIN employees e2 ON ( e1.location=e2.location
	                    AND e1.employee_id <> e2.employee_id)
ORDER BY e1.location;

-- remove the doubles
SELECT e1.location, e1.first_name, e2.first_name
FROM employees e1
	JOIN employees e2 ON (      e1.location=e2.location
	                        AND e1.employee_id < e2.employee_id)
ORDER BY e1.location;

DELETE FROM EMPLOYEES where employee_id='999999999';

-- ************************************************************
-- SLIDE DECK : SELF JOIN
-- ************************************************************
-- ************************************************************
-- Preparation
-- ************************************************************
-- _PG_CRE_ENTERPRISE_EN.sql
-- _PG_FILL_ENTERPRISE_EN.sql

--Slide 30
-- What is the last_name of the boss of the employee with employee_id 999444444?

-- Step 1 : find manager_id for employee with id 999444444
SELECT e.manager_id from EMPLOYEES e where e.employee_id='999444444';
-- Result = 999666666
-- Step 2 : find name for employee (the manager) with id 999666666
SELECT m.last_name from EMPLOYEES m where m.employee_id='999666666';

--Slide 31
-- in One step
SELECT mgr.last_name
FROM employees e
         JOIN employees mgr
              ON (e.manager_id=mgr.employee_id)
WHERE e.employee_id='999444444';


-- Slide 32
--	Whose boss is Bordoloi?
-- Step 1 : what is the id for Bordoloi
SELECT e.employee_id from EMPLOYEES e where e.last_name='Bordoloi';
-- Result = 999666666
-- Step 2 : find names of employees with manager_id 999666666
SELECT e.last_name from EMPLOYEES e where e.manager_id='999666666';

--Slide 33
-- in One step
SELECT e.last_name
FROM employees e
JOIN employees mgr ON (mgr.employee_id=e.manager_id)
WHERE UPPER(mgr.last_name)='BORDOLOI';








--Slide 34
-- show Employees names + the Name of their boss?
-- Step 1 : get employees first, last name + manager_id
SELECT e.first_name, e.last_name,e.manager_id from EMPLOYEES e;
-- Result = list with manager_ids -> 44, 55 and 66
-- Step 2 : find names of employees with employee_id equal to the list of ids above
SELECT e.last_name from EMPLOYEES e where employee_id in ('999666666','999555555','999444444');


--medewerkers en hun baas
SELECT e.last_name last_name,
	e.first_name first_name,
	mgr.last_name last_name_baas,
	mgr.first_name first_name_baas
FROM employees e
JOIN employees mgr ON (e.manager_id=mgr.employee_id);



--Slide 37
-- Who works in the same department as employee Bock?
-- Step 1 : in which department does employee Bock work?
SELECT b.department_id from EMPLOYEES b where last_name='Bock';
-- Result = id= 7
-- Step 2 : who works in that same department?
SELECT e.last_name from EMPLOYEES e where e.department_id = 7;

--Slide 38
-- in One step
SELECT e.last_name
	,e.department_id
FROM employees b
	JOIN employees e ON (e.department_id=b.department_id)
WHERE UPPER(b.last_name)='BOCK';



--zonder naam bock
SELECT e.last_name,e.department_id
FROM employees bock
JOIN employees e
     ON (bock.department_id=e.department_id)
WHERE UPPER(bock.last_name)='BOCK'
 	AND UPPER(e.last_name)!='BOCK';


--Slide 40
-- Who is paid more than employee Bock?
-- Step 1 : how much does employee Bock earn?
SELECT b.salary from EMPLOYEES b where last_name='Bock';
-- Result = id= 30000
-- Step 2 : who is paid more?
SELECT e.last_name, e.salary from EMPLOYEES e where e.salary > 30000;

--Slide 41
-- in One step
SELECT e.last_name
	, e.salary
FROM employees e
JOIN employees bock 
  ON (bock.salary < e.salary)
WHERE UPPER(bock.last_name)='BOCK';
--waarom bock er nu niet uitfilteren?





--Slide 42
-- Which employees (give employee_id + hours) worked more hours on project 2 than employee 999111111?
-- Step 1 : how many hours did employee 999111111 work on project 2?
SELECT t11.hours from TASKS t11 where t11.employee_id='999111111' AND project_id=2;
-- Result = id= 8.5
-- Step 2 : Who worked more hours on THAT project?
SELECT t.employee_id, t.project_id, t.hours from TASKS t where t.hours > 8.5 AND project_id=2;

--Slide 43
-- in One step
SELECT t.employee_id,t.hours
FROM tasks t11
JOIN tasks t
ON (t11.project_id=t.project_id)
WHERE t11.employee_id='999111111'
AND t11.project_id=2
AND t11.hours<t.hours;

--OF extra join contitie
SELECT t.employee_id, t.hours
FROM tasks t11
JOIN tasks t
ON (    t11.project_id=t.project_id
    AND t11.hours < t.hours)
WHERE t11.employee_id='999111111'
AND t11.project_id=2;




--Slide 44
-- Which employees (give name + hours) worked more hours on project 2 than employee 999111111?
-- Step 1 : how many hours did employee 999111111 work on project 2?
SELECT t11.hours from TASKS t11 where employee_id='999111111' AND project_id=2;
-- Result = id= 8.5
-- Step 2 : Who worked more hours on THAT project=2?
SELECT t.employee_id from TASKS t where t.hours > 8.5 AND project_id=2;
-- Result = id= 44 & 88
-- Step 3 : What are the names of those employees?
SELECT e.last_name from EMPLOYEES e where e.employee_id in ('999888888','999444444');
-- Result = id= 44 & 88

--Slide 45
-- in One step
SELECT e.last_name
     ,t.hours
FROM tasks t11
         JOIN tasks t ON (t11.project_id=t.project_id)
         JOIN employees e ON (t.employee_id=e.employee_id)
WHERE t11.employee_id='999111111'
  AND t11.project_id=2
  AND t.hours>t11.hours;

-- OR JOIN FILTERS ALSO IN THE ON
SELECT last_name, t.hours
FROM tasks t11
         JOIN tasks t ON (		t11.project_id=t.project_id
    AND 	t.hours>t11.hours )
         JOIN employees e ON (t.employee_id=e.employee_id)
WHERE t11.employee_id='999111111’
AND t11.project_id=2;


--Slide 46
-- Which employees (give name + hours) worked more hours on project 2 than employee Bock?
-- Step 1 : What is the employee_id of employee Bock?
SELECT b.employee_id from EMPLOYEES b where last_name='Bock';
-- Result = id= 999111111
-- Step 2 : how many hours did employee 999111111 work on project 2?
SELECT tb.hours from TASKS tb where employee_id='999111111' AND project_id=2;
-- Result = id= 8.5
-- Step 3 : Who worked more hours on THAT project=2?
SELECT t.employee_id from TASKS t where t.hours > 8.5 AND project_id=2;
-- Result = id= 44 & 88
-- Step 4 : What are the names of those employees?
SELECT e.last_name from EMPLOYEES e where e.employee_id in ('999888888','999444444');
-- Result = id= 44 & 88

--Slide 47
-- in One step
SELECT e.last_name
	,t.hours
FROM employees b
	JOIN tasks tb 		ON (b.employee_id=tb.employee_id)
	JOIN tasks t 		ON (tb.project_id=t.project_id)
	JOIN employees e	ON (t.employee_id=e.employee_id)
WHERE UPPER(b.last_name)='BOCK'
	AND tb.project_id=2
	AND t.hours> tb.hours;


-- 

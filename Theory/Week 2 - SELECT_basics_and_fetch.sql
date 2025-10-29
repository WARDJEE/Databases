-- ************************************************************
-- Voer dit script uit als 'theorie'
-- ************************************************************


-- ************************************************************
-- Voorbereiding
-- ************************************************************
-- _PG_CRE_ENTERPRISE_EN.sql 
-- _PG_FILL_ENTERPRISE_EN.sql

-- ************************************************************
-- Inleiding
-- ************************************************************
--examples
-- Single line statement
SELECT employee_id ,last_name,first_name,department_id 
FROM employees 
WHERE department_id=7 
ORDER BY employee_id;

-- Multi line statement(s)
SELECT  employee_id,last_name,first_name, department_id
FROM employees
WHERE department_id=7
ORDER BY employee_id;

SELECT  employee_id,
        last_name,
        first_name,
        department_id
FROM employees
WHERE department_id=7
ORDER BY employee_id;

SELECT   employee_id
        ,last_name
        ,first_name
FROM employees
WHERE department_id=7
ORDER BY employee_id;

-- ************************************************************
-- FROM
-- ************************************************************
--slide 19
SELECT employee_id,last_name,first_name,department_id
FROM employees;
--WHERE department_id=7
--ORDER BY employee_id;

SELECT *
FROM "tasks" ;

select *
From TaSkS ;

select *
From tasks ;

select *
FROM tasks,projects ;

select * from tasks;

select * from projects;

--slide 20
-- uitzondering: SELECT zonder FROM
-- see also https://modern-sql.com/use-case/select-without-from 
SELECT 2+2;
SELECT CURRENT_DATE;
SELECT 	CURRENT_DATE , 3*2;

-- ************************************************************
-- SELECT
-- ************************************************************
--slide 23
-- alle kolommen
SELECT *
FROM departments;

--slide 24
-- specifieke kolommen
SELECT "employee_id", "last_name",salary
FROM employees;

--slide 25
-- concatenate
SELECT employee_id
	,last_name || ' - - - ' || first_name
FROM employees;

--slide 26
-- concatenate & kolom alias
SELECT employee_id
	,last_name || ' ' || fiRst_NamE as FulL_namE
FROM employees;

--slide 27
-- kolom alias (converted to lower case)
SELECT  employee_id AS EmployeeNumber,
        last_name AS FamilyName,
        first_name AS FirstName
FROM employees;

--slide 28
-- kolom alias (gebruik spaties, cases en eender welke symbool)
SELECT  employee_id AS "Employee {number}"
		,last_name AS "Employee {Family name}"
		,first_name  AS "Employee {First name}"
FROM employees;

--slide 29
-- wiskundige bewerkingen
SELECT employee_id, last_name, salary, salary*1.1 AS raise
FROM employees;

--slide 30
-- functies
SELECT SUM(salary) AS total_labor_cost
FROM employees;

--
-- DISTINCT
--
-- Voorbeeld 1

--slide 32
SELECT department_id
FROM employees;

SELECT DISTINCT department_id
FROM employees;

-- Voorbeeld 2
--Slide 33
SELECT department_id dept, salary
FROM employees;

SELECT DISTINCT department_id dept, salary
FROM employees;

-- ************************************************************
-- WHERE
-- ************************************************************
--
-- Vergelijkingen
--
--slide 36
-- Voorbeeld 1
SELECT employee_id,last_name,first_name,department_id
FROM employees
WHERE department_id=3;


-- Voorbeeld 2
SELECT employee_id,last_name,first_name,birth_date
FROM employees
WHERE birth_date < '31-12-1980';

SELECT employee_id,last_name,first_name,birth_date
FROM employees
WHERE birth_date='20-JuN-1981';

--
-- BETWEEN...AND
--

--slide 39
-- Voorbeeld 1
SELECT employee_id,last_name,first_name,salary
FROM employees
WHERE salary BETWEEN 25000 AND 40000;

SELECT employee_id,last_name,first_name,salary
FROM employees
WHERE salary>=25000 AND salary<=40000;

--slide 40
-- Voorbeeld 2
SELECT employee_id,last_name,first_name,birth_date
FROM employees
WHERE birth_date BETWEEN '1-JAN-1980' AND '31-DEC-1989';

-- Voorbeeld 3
SELECT employee_id,last_name,first_name
FROM employees
WHERE last_name BETWEEN 'A' AND 'k';

--slide 41 ev
-- 
-- Upper/Lowercase
-- 
SELECT employee_id, first_name FROM employees;

SELECT employee_id, first_name FROM employees WHERE first_name='WILLEM';
SELECT employee_id, first_name FROM employees WHERE first_name='Willem';
SELECT employee_id, first_name FROM employees WHERE UPPER(first_name)='WILLEM';
SELECT employee_id, first_name FROM employees WHERE LOWER(first_name)='willem';
SELECT employee_id, first_name FROM employees WHERE INITCAP(first_name)='Willem';

--
-- LIKE
--

--slide 47
SELECT employee_id,last_name
FROM employees
WHERE LOWER(last_name) LIKE '%m%';

SELECT employee_id,last_name
FROM employees
WHERE UPPER(last_name) LIKE '_M%';

--
-- AND OR NOT
--
--slide 48
SELECT employee_id, department_id, salary
FROM employees
WHERE department_id=3
AND salary>30000;

--slide 49
SELECT employee_id, department_id, salary
FROM employees
WHERE NOT(department_id=3 AND salary>30000);

--slide 50
SELECT employee_id, department_id, salary
FROM employees
WHERE department_id=3 OR salary>30000;

--slide 51
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE salary>30000 AND department_id=1 OR department_id=3;

--slide 52
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE salary>30000 AND (department_id=1 OR department_id=3);

--
-- IN
--

--slide 53
SELECT employee_id,first_name,salary
FROM employees
WHERE salary=25000
OR    salary=30000
OR    salary=43000;


--slide 54
SELECT employee_id, first_name, salary
FROM employees
WHERE salary IN(25000 , 30000 ,43000);

SELECT employee_id, first_name, salary
FROM employees
WHERE first_name IN('Suzan','Martina');

--slide 55
SELECT employee_id, first_name, birth_date
FROM employees
WHERE birth_date IN ('10-NOV-1977','1-SEP-1965');

--
-- IS NULL en IS NOT NULL
--
--slide 56
SELECT employee_id, last_name, manager_id
FROM employees
WHERE manager_id IS NULL;

--slide 57
SELECT employee_id, manager_id
	,UPPER(last_name) || ' ' || first_name as name
FROM employees
WHERE manager_id IS NOT NULL;

--slide 58
SELECT *
FROM tasks;

SELECT *
FROM tasks
WHERE hours IS NULL;

SELECT *
FROM tasks
WHERE hours = 0;

SELECT *
FROM tasks
WHERE hours=NULL;        -- Nope!

SELECT *
FROM tasks
WHERE hours IS NOT NULL;

SELECT *
FROM tasks
WHERE hours!=NULL;       -- Nope!

SELECT *
FROM tasks
WHERE NOT hours=NULL;    -- Nope!

--
-- Quotes
--
--slide 59 
SELECT  employee_id, last_name, salary, birth_date,
        manager_id "Manager"
FROM    "employees"
WHERE   salary < 30000
AND     last_name = 'Muiden'
AND     birth_date < '31-JAN-2000';

-- ************************************************************
-- ORDER BY
-- ************************************************************
--slide 62 ev
SELECT * FROM departments ORDER BY department_id ASC;


SELECT * FROM departments ORDER BY department_id DESC;


SELECT employee_id, last_name, first_name, department_id
FROM employees
ORDER BY department_id, last_name;


SELECT employee_id ,last_name AS "a very very long column name", first_name fname
		,department_id AS department
FROM employees
ORDER BY department DESC, "a very very long column name" ASC;


SELECT employee_id
	, last_name "a very long column name"
	,first_name fname
	, department_id department
FROM employees
ORDER BY department DESC, "a very long column name" ASC;

SELECT employee_id
	, last_name "a very long column name"
	,first_name fname
	, department_id department
FROM employees
ORDER BY 4 DESC, 2 ASC;

--
-- ORDER BY en NULL
--
--slide 68 
SELECT *
FROM tasks
ORDER BY hours;

SELECT *
FROM tasks
ORDER BY hours NULLS FIRST;

-- ************************************************************
-- SELECT FETCH 
-- ************************************************************
-- ************************************************************
-- FETCH - NEXT
-- ************************************************************
--slide 73
SELECT last_name FROM employees ORDER BY last_name;
SELECT last_name FROM employees ORDER BY last_name FETCH NEXT 3 ROWS ONLY;

-- ************************************************************
-- FETCH - OFFSET
-- ************************************************************
--slide 76
SELECT last_name FROM employees ORDER BY last_name;
SELECT last_name FROM employees ORDER BY last_name OFFSET 3 ROWS;

SELECT last_name FROM employees ORDER BY last_name OFFSET 2*2 ROWS;

-- ************************************************************
-- FETCH - OFFSET - NEXT
-- ************************************************************
--slide 77
SELECT last_name FROM employees ORDER BY last_name;
SELECT last_name FROM employees ORDER BY last_name OFFSET 3 ROWS FETCH NEXT 4 ROWS ONLY;

-- Pagination
SELECT last_name FROM employees ORDER BY last_name OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY;
SELECT last_name FROM employees ORDER BY last_name OFFSET 2 ROWS FETCH NEXT 2 ROWS ONLY;
SELECT last_name FROM employees ORDER BY last_name OFFSET 4 ROWS FETCH NEXT 2 ROWS ONLY;
SELECT last_name FROM employees ORDER BY last_name OFFSET 6 ROWS FETCH NEXT 2 ROWS ONLY;

-- ************************************************************
-- FETCH - WITH TIES
-- ************************************************************
--slide 79
SELECT last_name, salary FROM employees ORDER BY salary DESC;
SELECT last_name, salary FROM employees ORDER BY salary DESC FETCH NEXT 2 ROWS ONLY;

SELECT last_name, salary FROM employees ORDER BY salary DESC FETCH NEXT 2 ROWS WITH TIES;


-- ************************************************************
-- FETCH - syntax
-- ************************************************************
--slide 81
SELECT last_name FROM employees ORDER BY last_name FETCH NEXT 1 ROWS ONLY;
SELECT last_name FROM employees ORDER BY last_name FETCH FIRST 1 ROW ONLY;

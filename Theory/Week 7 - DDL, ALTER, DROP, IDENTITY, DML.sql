--*******************************
--DML: DATA MANIPULATION LANGUAGE
--*******************************
--INSERT
----------------------------
SELECT * FROM departments;

--6
INSERT INTO departments
VALUES (5,'Sales','999444444', TO_DATE('22-05-2024', 'DD-MM-YYYY'));

--7
INSERT INTO departments (department_id, department_name, manager_id, mgr_start_date)
VALUES (5, 'Sales', '999444444', TO_DATE('22-05-2024', 'DD-MM-YYYY'));
-- ERROR: PRIMARY KEY 5 exists

--8
INSERT INTO departments
(department_id, department_name)
VALUES  (5, 'Sales');

INSERT INTO departments
(department_id, department_name)
VALUES  (99, 'Sales');

--9
INSERT INTO departments (	department_id,  	department_name,
                             manager_id,  	mgr_start_date)
VALUES
    (12, 	'Sales',    '999444444',	to_date('22-05-2024', 'DD-MM-YYYY')),
    (13, 	'HR',       '999555555',	to_date('23-05-2024', 'DD-MM-YYYY')),
    (14, 	'AfterCare','999666666',	to_date('24-05-2024', 'DD-MM-YYYY'));


--Select *
SELECT * FROM departments
ORDER BY department_id;

--UPDATE
---------
SELECT * FROM departments
ORDER BY department_id;

--11
----
UPDATE departments
SET mgr_start_date = now()
WHERE department_id >8 ;

SELECT * FROM departments
ORDER BY department_id;

-- 12
-- Update  2 tables
------------------------
-- update where dept_id > 8
-- and parkingspot = 3 (in employees table)

SELECT * FROM employees;

SELECT * FROM departments
ORDER BY department_id;

UPDATE departments d
SET mgr_start_date = current_date - interval '1 day'
FROM employees e
WHERE d.manager_id = e.employee_id
AND d.department_id > 8
AND e.parking_spot = 3;

--YOU CANNOT USE THE ON clause (!!!)

SELECT * FROM departments
ORDER BY department_id;



--13
-- Update 3 tables
-----------------------
--Update on manager_start date where department_id
--greater than 7 and at the manager who
--has a relationship 'SON'.

SELECT * FROM departments
ORDER BY department_id;

SELECT *
FROM family_members;
--departments --> employees --> family_members  --> 3 tables!
UPDATE departments d
SET mgr_start_date = current_date - interval '2 day'
FROM employees e
JOIN family_members fm ON e.employee_id = fm.employee_id
WHERE d.manager_id = e.employee_id
AND d.department_id > 7
AND fm.relationship = 'SON';
--only the join clauses of the updated table are now included in the where

SELECT * FROM departments
ORDER BY department_id;

-- 15
-- DELETE -  1 or more records.
-------------------------------
DELETE FROM departments
WHERE department_id = 5;

DELETE FROM departments
WHERE department_id IN (10, 11, 12, 13, 14, 99);

--All rows that meet the condition are removed

--12 Delete using multiple tables
---------------------------------------------
--Suppose you want to remove departments for which employee Suzan works.
--For which department does Suzan work?

SELECT department_id
FROM employees
WHERE lower(first_name) = 'suzan';

--If you look it up first, you can try this:
DELETE FROM departments
WHERE department_id = 3;
--ERROR!! Referenced rows!

--Or you can try it in 1 instruction
--The dependent rows in table employees are not deleted.
DELETE FROM departments d
USING employees e
WHERE d.department_id = e.department_id
AND lower(first_name) = 'suzan';

--A DEPARTMENT CAN THUS BE DELETED ONLY IF THERE ARE NO LONGER ANY EMPLOYEES WORKING FOR IT!

--17
DELETE
FROM departments
WHERE department_id > 9;

--20
INSERT INTO departments (department_id, department_name)
VALUES(3, 'Research');

--******************************************
--TRUNCATE tabel - Completely empty a table!
--******************************************
-- ************
-- DROP Tables
-- ************

-- 31 Dropping table that exists
DROP TABLE projects;

--Projects has dependencies!

--Dropping a table that does not exist = error message
DROP TABLE consumer;


--Dropped non-existent table with addition IF EXISTS = nothing
--deleted but successful query
DROP TABLE IF EXISTS consumer;

--Dropping a table that exists with CASCADE
DROP TABLE departments CASCADE;

--Dropping table without CASCADE
DROP TABLE IF EXISTS employees;

--Drop All tables
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS familymembers CASCADE;

--*******************************************
--ALTER TABLE
--*******************************************

-- Aangezien tabellen gewist zijn in vorige sectie, is het aangewezen om de 
-- databank volledig opnieuw aan te maken via volgende scripts:
--
-- _pg_CRE_ENTERPRISE_EN.sql
-- _pg_FILL_ENTERPRISE_EN.sql



-- kolommen toevoegen/verwijderen aan/van de tabel
--------------------------------------------------

--42
-- Add 1 column
ALTER TABLE employees
    ADD COLUMN food_allergy VARCHAR(30);
-- Delete 1 column
ALTER TABLE employees
    DROP COLUMN food_allergy;

-- Adding multiple columns
ALTER TABLE employees
    ADD COLUMN food_allergy VARCHAR(30),
    ADD COLUMN diet VARCHAR(30);

-- Delete multiple columns
ALTER TABLE employees
    DROP food_allergy,
    DROP diet;

-- slide 45:
-- Add 1 column with constraint
ALTER TABLE employees
    ADD COLUMN food_allergy VARCHAR(30)
        CONSTRAINT ch_emp_food_all
            CHECK(food_allergy = UPPER(food_allergy));

--Delete 1 column and constraint separately
ALTER TABLE employees
    DROP CONSTRAINT IF EXISTS ch_emp_food_all,
    DROP COLUMN IF EXISTS food_allergy CASCADE;

--slide 48
ALTER TABLE employees
    ALTER COLUMN parking_spot
    SET DATA TYPE NUMERIC(5);

ALTER TABLE employees
    ALTER COLUMN salary
        SET DEFAULT 0;

-----------EXTRA EXAMPLES WITH DEFAULTS:-------------------
ALTER TABLE departments
    ALTER COLUMN mgr_start_date
        SET DEFAULT TO_DATE('01-01-2021', 'DD-MM-YYYY');

ALTER TABLE departments
    ALTER COLUMN manager_id
        SET DEFAULT '999666666';
--What happens next after this query?
INSERT INTO departments (department_id, department_name)
VALUES (8, 'IT')

SELECT * FROM departments;

--Dropping default values

ALTER TABLE departments
    ALTER COLUMN mgr_start_date
        DROP DEFAULT;

ALTER TABLE departments
    ALTER COLUMN manager_id
        DROP DEFAULT;

DELETE FROM departments
WHERE department_id = '8';
-----------------------EXTRA DEFAULTS-----------------------------

--slide 50
--Customize not null (drop or set)
--First look at the properties in the table
ALTER TABLE employees
    ALTER COLUMN last_name
        DROP NOT NULL;

ALTER TABLE employees
    ALTER COLUMN last_name
        SET NOT NULL;


-- 51 SET / DROP NOT NULL
ALTER TABLE employees
    ALTER COLUMN last_name
        DROP NOT NULL;

ALTER TABLE employees
    ALTER COLUMN last_name
        SET NOT NULL;

--54
ALTER TABLE employees
    ALTER COLUMN parking_spot
        SET NOT NULL;

--You want to add a constraint to an existing table
--E.g., to enforce that the last_name is always capitalized
---BUT the current data may not yet meet the constraint....
ALTER TABLE employees
    ADD CONSTRAINT ch_emp_lastname
        CHECK(last_name=UPPER(last_name)) NOT VALID;

--Validate = activate the constraint
ALTER TABLE employees
    VALIDATE CONSTRAINT ch_emp_lastname;
--Error message because last_name now just start with a capital letter.
--First modify, then validate constraint.

---------------EXTRA - RENAME ---------------
--Renaming a table
ALTER TABLE IF EXISTS departments
    RENAME TO department;

-- Return to original name
ALTER TABLE IF EXISTS department
    RENAME TO departments;

--Renaming an attribute
ALTER TABLE IF EXISTS departments
    RENAME COLUMN department_id TO banana;

ALTER TABLE employees
    RENAME COLUMN department_id TO apple;

--Renaming a constraint
ALTER TABLE projects
    RENAME CONSTRAINT pk_projects TO pk_sleutel_projects;
---------------EXTRA - RENAME ---------------

--56
ALTER TABLE employees
    DROP CONSTRAINT ch_emp_lastname,
    ADD CONSTRAINT ch_emp_lastname
        CHECK(last_name=INITCAP(last_name)) ;


-- REFRESH DATABASE
--
-- _pg_CRE_ENTERPRISE_EN.sql
-- _pg_FILL_ENTERPRISE_EN.sql

--58 PRACTICAL USE IDENTITY
----------------------------

CREATE TABLE employees3 (
    employee_id NUMERIC(9)
        CONSTRAINT pk_emp3 PRIMARY KEY ,
    last_name VARCHAR(25)
        CONSTRAINT nn_last_name NOT NULL
                        );

CREATE TABLE family_members3 (
    family_id NUMERIC(9)
        CONSTRAINT pk_fam_mem3 PRIMARY KEY ,
    name VARCHAR(50),
    employee_id NUMERIC(9)
        CONSTRAINT fk_fam3_emp_id REFERENCES employees3(employee_id)
);

DROP TABLE employees3;
DROP TABLE IF EXISTS employees3 CASCADE;

--62
CREATE TABLE employees3 (
                            employee_id INTEGER
                                GENERATED ALWAYS AS IDENTITY
                                CONSTRAINT pk_emp3 PRIMARY KEY ,
                            last_name VARCHAR(25)
                                CONSTRAINT nn_last_name NOT NULL
);

INSERT INTO employees3 (last_name) VALUES('Johnson');

INSERT INTO employees3 (employee_id, last_name) VALUES(100, 'Johnson');

SELECT * FROM employees3;

DROP TABLE IF EXISTS employees3 CASCADE;

--64
CREATE TABLE employees3 (
                            employee_id INTEGER
                                GENERATED BY DEFAULT AS IDENTITY
                                CONSTRAINT pk_emp3 PRIMARY KEY ,
                            last_name VARCHAR(25) CONSTRAINT nn_last_name NOT NULL
);

INSERT INTO employees3 (last_name) VALUES('Johnson');

INSERT INTO employees3 (employee_id, last_name) VALUES(100, 'Johnson');

SELECT * FROM employees3;

INSERT INTO employees3 (employee_id, last_name) VALUES(NULL, 'Johnson');

--67
DROP TABLE IF EXISTS family_members3;
--OLD
CREATE TABLE family_members3 (
     family_id NUMERIC(9)
         CONSTRAINT pk_fam_mem3 PRIMARY KEY ,
     name VARCHAR(50),
     employee_id NUMERIC(9)
         CONSTRAINT fk_fam3_emp_id REFERENCES employees3(employee_id)
);
--IT SHOULD become this, but it already exists
CREATE TABLE family_members3 (
                                 family_id INTEGER
                                     GENERATED BY DEFAULT AS IDENTITY
                                     CONSTRAINT pk_fam_mem3 PRIMARY KEY ,
                                 name VARCHAR(50),
                                 employee_id INTEGER
                                     CONSTRAINT fk_fam3_emp_id REFERENCES employees3(employee_id)
);

--Look at the data types! from NUMBER to INTEGER above
--change one column to an identity column
ALTER TABLE IF EXISTS family_members3
    ALTER COLUMN family_id SET DATA TYPE INTEGER,
    ALTER COLUMN family_id
        SET NOT NULL,
    ALTER COLUMN family_id
        ADD GENERATED ALWAYS AS IDENTITY (START WITH 5);

-- 69 change the options of an identity column
ALTER TABLE IF EXISTS family_members3
    ALTER COLUMN family_id
        SET GENERATED BY DEFAULT
        RESTART WITH 10;

--71 -modify an identity column into a normal column
ALTER TABLE IF EXISTS family_members3
    ALTER COLUMN family_id
        DROP IDENTITY IF EXISTS;
-- at IF EXISTS no adjustment
ALTER TABLE IF EXISTS family_members3
    ALTER COLUMN employee_id
        DROP IDENTITY;


-- ************************************************************
-- Voer dit script uit in Entreprise (normaal, niet BIG)
-- ************************************************************
SELECT USER;

-- ************************************************************
-- 1. Analytische functies
-- ************************************************************
-- ******************************
-- AVG
-- ******************************
SELECT AVG(salary) "Average Salary"
FROM employees;

SELECT ROUND(AVG(salary)) "Average Salary"
FROM employees;

SELECT ROUND(AVG(DISTINCT salary)) "Average Salary"
FROM employees;

-- ******************************
-- SUM
-- ******************************
SELECT SUM(salary) total
FROM employees;

SELECT SUM(DISTINCT salary) total
FROM employees;

-- ******************************
-- MIN MAX
-- ******************************
SELECT MIN(salary) "lowest salary",
       MAX(salary) "highest salary"
FROM employees;

SELECT MIN(last_name) "first",
       MAX(last_name) "last"
FROM employees;

SELECT MIN(birth_date) "oldest",
       MAX(birth_date) "youngest"
FROM employees;

-- ******************************
-- COUNT
-- ******************************
SELECT employee_id, last_name, manager_id
FROM employees;

SELECT COUNT(*) employee_count
FROM employees;

SELECT COUNT(manager_id) manager_count
FROM employees;

-- ******************************
-- Algemeen
-- ******************************
SELECT last_name, department_id, salary
FROM employees
ORDER BY department_id;

SELECT ROUND(AVG(salary), 1) avg_sal_dep3
FROM employees
WHERE department_id = 3;

SELECT SUM(salary) tot_sal_dep7
FROM employees
WHERE department_id = 7;

SELECT MIN(last_name) "first in alphabet (dep3)",
       MAX(last_name) "last in alphabet (dep3)"
FROM employees
WHERE department_id = 3;

SELECT COUNT(*) emp_count
FROM employees;
SELECT COUNT(*) count_dep3
FROM employees
WHERE department_id = 3;

-- ************************************************************
-- 2. GROUP BY
-- ************************************************************
--
-- Selecteer het aantal employees per afdeling
--
-- Overzicht (data set)
SELECT employee_id, first_name, last_name, department_id
FROM employees
ORDER BY department_id;

-- Oplossing?
SELECT COUNT(*) "count dep 1"
FROM employees
WHERE department_id = 1;

SELECT COUNT(*) "count dep 3"
FROM employees
WHERE department_id = 3;

SELECT COUNT(*) "count dep 7"
FROM employees
WHERE department_id = 7;

SELECT first_name
FROM employees
WHERE department_id = 7;

-- Oplossing
SELECT department_id, COUNT(*) count_emp
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- SELECT list (!!)
SELECT department_id, COUNT(*) count_emp, first_name -- Nope!
FROM employees
GROUP BY department_id
ORDER BY department_id;

--
-- Bereken per afdeling de jaarlijkse loonkost voor vrouwen
--
SELECT department_id, salary
FROM employees
WHERE LOWER(gender) = 'f';

SELECT department_id, SUM(salary) "yearly salary cost"
FROM employees
WHERE LOWER(gender) = 'f'
GROUP BY department_id;

--
-- Bereken per afdeling de gemiddelde loonkost. 
-- Sorteer in stijgende volgorde van gemiddelde
--
SELECT department_id, ROUND(AVG(salary)) "average salary"
FROM employees
GROUP BY department_id
ORDER BY 2;

--
-- Bereken per afdeling de totale loonkost voor mannen! 
-- Sorteer in dalende volgorde van loonkost:
--
SELECT department_id, SUM(salary) "totale salary cost"
FROM employees
WHERE LOWER(gender) = 'm'
GROUP BY department_id
ORDER BY 2 DESC;

-- ******************************
-- Nesting van analytische functies
-- ******************************
--
-- Geef het gemiddelde van het highest salary:
--

SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary)>33000;

-- Overzicht (data set)
SELECT last_name, salary
FROM employees;

-- Wat is het highest salary?
SELECT MAX(salary) MAX_SAL
FROM employees;

-- Zinloos: Geef het gemiddelde van het highest salary
-- ORA-00978: "nested group function without GROUP BY"
SELECT AVG(MAX(salary)) MAX_SAL
FROM employees;

SELECT ROUND(AVG(max_sal.max)) avg_max_sal
FROM (SELECT MAX(salary) as max
      FROM employees
      GROUP BY department_id) as max_sal;

SELECT department_id, ROUND(AVG(max_sal.max)) avg_max_sal
FROM (SELECT department_id, MAX(salary) as max
      FROM employees
      GROUP BY department_id) as max_sal
GROUP BY department_id;



--> herdefinieer:
-- Geef het gemiddelde van het hoogste salarissen per afdeling
SELECT department_id, MAX(salary) MAX_SAL
FROM employees
GROUP BY department_id
ORDER BY department_id;

SELECT AVG(MAX(salary)) GEM_MAX_SAL
FROM employees
GROUP BY department_id;

-- Geef het gemiddelde van de highest salarysen per afdeling:
-- ORA-00937: "not a single-group group function"
SELECT department_id, AVG(MAX(salary)) "gem_max_sal/afdeling"
FROM employees
GROUP BY department_id;
--> Welk afdeling nummer zou er gegeven moeten worden?

SELECT x.department_id, ROUND(AVG(x.max)) gem_max_sal
FROM (SELECT MAX(salary) as max, department_id
      FROM employees
      GROUP BY department_id) as x
GROUP BY department_id;

--
-- Geef het highest salary, per afdeling 
--
SELECT department_id, MAX(salary) "max_sal/afdeling"
FROM employees
GROUP BY department_id
ORDER BY department_id;
--> Je kan op de verzameling van deze 3 rijen opnieuw een analytische functie uitvoeren

-- ************************************************************
-- 3. HAVING
-- ************************************************************
--
-- Geef het highest salary per afdeling. 
-- Toon enkel de waarden die kleiner zijn dan 45000.
--
SELECT department_id, MAX(salary) "max_sal/department"
FROM employees
GROUP BY department_id
HAVING MAX(salary) < 45000
ORDER BY department_id;

--
-- Geef een overzicht van de afdelingen met een gemiddeld salary dat boven 33000 gelegen is
--
-- Overzicht (data set)
SELECT department_id, employee_id, salary
FROM employees
ORDER BY salary;

-- Nope
--SELECT department_id, employee_id, salary
--FROM employees
--WHERE salary>33000
--ORDER BY salary;

-- ORA-00934: "group function is not allowed here"
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) > 33000
ORDER BY department_id;

-- Stap 1
SELECT department_id, ROUND(AVG(salary)) Average_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;
-- Stap 2
SELECT department_id, ROUND(AVG(salary)) Average_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 33000
ORDER BY department_id;

-- Nope
--SELECT department_id, AVG(salary) Gemiddeld_salary
--FROM employees
--GROUP BY department_id
--HAVING Gemiddeld_salary> 33000    --> Nope
--ORDER BY department_id;

--
-- Geef per afdeling het gemiddeld salary. 
-- We zijn alleen geïnteresseerd in afdelingen met meer dan 2 employees.
--
SELECT department_id, ROUND(AVG(salary)) avg_salary, COUNT(*)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

--
-- Extra
--
SELECT last_name || ' ' || first_name "Naam", department_id, salary
FROM employees
ORDER BY department_id, salary;

SELECT department_id, salary, COUNT(*)
FROM employees
GROUP BY department_id, salary
ORDER BY department_id;



-- **************************************
-- 4. OUTER JOINS
-- **************************************

-- ******************************
-- Vraag 1: probleem
-- Geef voor elke medewerker de gezinssamen-stelling  (employee_id, last_name, first_name, name, relation).
-- ******************************


SELECT e.employee_id, e.last_name, e.first_name, f.name, f.relationship
FROM employees e
         JOIN family_members f ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e;

SELECT f.employee_id, f.name, f.relationship
FROM employees e
         JOIN family_members f ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;

-- LEFT OUTER JOIN

SELECT e.employee_id, e.first_name, f.name, f.relationship
FROM employees e
         LEFT JOIN family_members f
                   ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;

-- RIGHT OUTER JOIN

SELECT e.employee_id, e.first_name, f.name, f.relationship
FROM family_members f
         RIGHT JOIN employees e
                    ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;

-- ******************************
-- Vraag 2
-- Kan men voorgaande query als volgt schrijven?
-- ******************************
--slide 53
--change e.employee_id into f.employee_id
SELECT e.employee_id, e.last_name, f.name, f.relationship
FROM employees e
         LEFT JOIN family_members f
                   ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;


-- ******************************
-- Vraag 3 - voorbereiding
-- ******************************
--slide 54
INSERT INTO family_members (employee_id, name, gender, relationship)
VALUES ('999111111', 'Anke', 'F', 'DAUGHTER');
-- error  ==>   null value in column "birth_date"

ALTER TABLE family_members
    ALTER COLUMN birth_date DROP NOT NULL;

-- try again
INSERT INTO family_members (employee_id, name, gender, relationship)
VALUES ('999111111', 'Anke', 'F', 'DAUGHTER');

-- OK ?
SELECT f.employee_id, f.name, f.gender, f.birth_date, f.relationship
FROM family_members f;

-- ******************************
-- Vraag 3
-- Welke medewerkers hebben geen gezinsleden?
-- ******************************
--slide 56

-- LEFT Join -> provides ALL employees,
-- Next use a WHERE clause to filter to only necessary employees
SELECT f.employee_id, e.last_name, f.name, f.birth_date
FROM employees e
         LEFT JOIN family_members f
                   ON (e.employee_id = f.employee_id)
--WHERE f.name IS NULL
ORDER BY e.employee_id;

-- Vraag 3bis
-- Could we get to same result using other NULL columns ?
SELECT f.employee_id, e.last_name, f.name, f.birth_date
FROM employees e
         LEFT JOIN family_members f
                   ON (e.employee_id = f.employee_id)
WHERE f.birth_date IS NULL
ORDER BY e.employee_id;

-- -> This is NOT the result we expected


-- ******************************
-- PREPARATION : FULL OUTER JOIN
-- ******************************
--slide 60
INSERT INTO departments
VALUES (4, 'Research', '999444444', NOW());

INSERT INTO employees (employee_id, last_name, first_name)
VALUES (999999999, 'Janssens', 'Jan');

SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
         LEFT OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;

-- ******************************
-- FULL OUTER JOIN
-- ******************************
--slide 61
SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
         LEFT OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;

SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
         RIGHT OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;

--slide 62
SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
         FULL OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;

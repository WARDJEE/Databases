-- Nested SELECT
-- stap 1:

SELECT MIN(salary)
FROM EMPLOYEES;

-- stap 2:
SELECT first_name, last_name
FROM EMPLOYEES
WHERE salary = 25000;

-- Oplossing
SELECT first_name, last_name
FROM EMPLOYEES
WHERE salary = (SELECT MIN(salary)
                FROM EMPLOYEES);


-- Subqueries
-- Oefening 1
-- Geef een overzicht van projecten waaraan minstens 3 medewerkers
-- meewerken. Let op de sortering. Los deze oefening op in 2 stappen.

-- Stap 1: Bereken de projecten waaraan minstens 3 medewerkers aan
-- werken dus enkel indien hours zijn ingevuld (tabel tasks):
SELECT COUNT(employee_id), project_id
FROM tasks
WHERE hours IS NOT NULL
GROUP BY project_id
HAVING COUNT(employee_id) >= 3
ORDER BY project_id;

-- Stap 2: Geef de informatie van die projecten (tabel projects):
SELECT project_id, project_name
FROM projects
WHERE project_id IN
      (SELECT project_id
       FROM tasks
       WHERE hours IS NOT NULL
       GROUP BY project_id
       HAVING COUNT(employee_id) >= 3)
ORDER BY project_id;

-- Zoek ook de oplossing met een join.
SELECT p.project_id, p.project_name
FROM projects p
         JOIN tasks t ON p.project_id = t.project_id
WHERE t.hours IS NOT NULL
GROUP BY p.project_id, p.project_name
HAVING COUNT(t.employee_id) >= 3
ORDER BY p.project_id;


-- Oefening 2
-- Geef een overzicht van medewerkers die aan projecten werken
-- gelokaliseerd in Eindhoven. Sorteer dalend op employee_id.

-- Stap 1: Bepaal de employee_id van de medewerkers die meewerken aan
-- projecten in Eindhoven. (tabel tasks- projects) � SUBQUERY
SELECT employee_id, last_name
FROM employees
WHERE employee_id IN (SELECT DISTINCT (t.employee_id)
                      FROM tasks t
                               JOIN projects p ON t.project_id = p.project_id
                      WHERE LOWER(p.location) = 'eindhoven')
ORDER BY employee_id DESC;

-- Stap 2: Geef de gegevens van de medewerkers met die employee_id.
-- Geef een oplossing met uitsluitend subqueries en 2 oplossingen met
-- telkens 1 join.

-- Enkel joins:
SELECT DISTINCT (t.employee_id), e.last_name
FROM tasks t
         JOIN projects p ON t.project_id = p.project_id
         JOIN employees e ON t.employee_id = e.employee_id
WHERE LOWER(p.location) = 'eindhoven'
ORDER BY t.employee_id DESC;

-- Enkel subqueries:
SELECT employee_id, last_name
FROM employees
WHERE employee_id IN (SELECT DISTINCT (t.employee_id)
                      FROM tasks t
                      WHERE t.project_id IN (SELECT p.project_id
                                             FROM projects p
                                             WHERE LOWER(p.location) = 'eindhoven'))
ORDER BY employee_id DESC;

-- 1 join, 1 subquery:
SELECT DISTINCT (e.employee_id), e.last_name
FROM employees e
         JOIN tasks t ON e.employee_id = t.employee_id
WHERE t.project_id IN (SELECT p.project_id
                       FROM projects p
                       WHERE LOWER(p.location) = 'eindhoven')
ORDER BY employee_id DESC;

-- Oefening 3
-- Geef een overzicht van de medewerkers die meer dan 10 uur aan het
-- project ORDERMANAGEMENT werkten. Geef voornaam en achternaam.

-- a) Werk uit met uitsluitend gebruik van subqueries.
SELECT first_name, last_name
FROM employees
WHERE employee_id IN (SELECT employee_id
                      FROM tasks
                      WHERE hours > 10
                        AND project_id IN (SELECT project_id
                                           FROM projects
                                           WHERE LOWER(project_name) = 'ordermanagement'))
ORDER BY 1, 2;

-- b) Werk uit met gebruik van subqueries in combinatie met join.
SELECT first_name, last_name
FROM employees
WHERE employee_id IN (SELECT t.employee_id
                      FROM tasks t
                               JOIN projects p ON t.project_id = p.project_id
                      WHERE t.hours > 10
                        AND LOWER(p.project_name) = 'ordermanagement')
ORDER BY 1, 2;

-- Oefening 4
-- Geef een overzicht van medewerkers die minstens 2 kinderen hebben.
SELECT employee_id, last_name
FROM employees
WHERE employee_id IN (SELECT employee_id
                      FROM family_members
                      WHERE LOWER(relationship) IN ('son', 'daughter')
                      GROUP BY employee_id
                      HAVING COUNT(*) >= 2)
ORDER BY 1 DESC;

-- Oefening 5
-- Welke afdeling heeft de hoogste loonkost?

-- Stap 1: Zoek het departement met de hoogste loonkost.
-- Stap 2: Geef de nummer + naam van die afdeling waarvan de totale loonkost = het gevonden maximum
SELECT department_id, department_name
FROM departments
WHERE department_id =
      (SELECT department_id
       FROM employees
       GROUP BY department_id
       HAVING SUM(salary) =
              (SELECT MAX(loontabel.loonkost)
               FROM (SELECT SUM(salary) loonkost
                     FROM employees
                     GROUP BY department_id) loontabel));

-- Order optie
SELECT department_id, department_name
FROM departments
WHERE department_id =
      (SELECT department_id
       FROM employees
       GROUP BY department_id
       ORDER BY SUM(salary) DESC
           FETCH FIRST 1 ROW
       WITH TIES);

-- Oefening 6
--Op welke vraag geeft de onderstaande select een antwoord?
-- Employees die geen managers zijn --
SELECT *
FROM employees
WHERE employee_id NOT IN (SELECT manager_id
                          FROM employees);

-- Waarom geeft de query toch geen rijen terug indien je hem uitvoert?
-- Er is een NULL waarde --

-- Hoe kan je dit oplossen?
-- 1) Gebruik van de COALESCE-functie
SELECT *
FROM employees
WHERE employee_id NOT IN (SELECT COALESCE(manager_id, 'Geen manager')
                          FROM employees);

-- 2) Gebruik NOT NULL
SELECT *
FROM employees
WHERE employee_id NOT IN (SELECT manager_id
                          FROM employees
                          WHERE manager_id IS NOT NULL);

-- 3) Gebruik van OUTER JOIN:
SELECT man.*
FROM employees e
         RIGHT JOIN employees man ON e.manager_id = man.employee_id
WHERE e.employee_id IS NULL;

-- 4) Gebruik van EXISTS:


-- Oefening 7
-- Wie heeft er evenveel kinderen als medewerker 'BOCK'?
SELECT e.employee_id, e.last_name, COUNT(*) aantal
FROM employees e
         JOIN family_members f ON e.employee_id = f.employee_id
WHERE LOWER(f.relationship) IN ('son', 'daughter')
  AND LOWER(e.last_name) != 'bock'
GROUP BY e.employee_id, e.last_name
HAVING COUNT(*) = (SELECT COUNT(*)
                   FROM employees e
                            JOIN family_members f ON e.employee_id = f.employee_id
                   WHERE LOWER(f.relationship) IN ('son', 'daughter')
                     AND LOWER(e.last_name) = 'bock');


-- Views
-- Oefening 8
-- De dienst salarisadministratie wil een view waarin ze in één oogopslag kunnen zien wat de
-- totale loonkost is voor elke afdeling. Maak een view v_emp_sal_dep die deze informatie geeft.
CREATE OR REPLACE VIEW v_emp_sal_dep
AS
SELECT department_id, SUM(salary) "Totale salary cost per department"
FROM employees
GROUP BY department_id
ORDER BY 1;

SELECT *
FROM v_emp_sal_dep;

-- Oefening 9
-- De personeelsdienst wil een overzicht van de medewerkers en hun kinderen. In de view
-- v_emp_child komt het employee_id van het personeelslid, zijn voornaam en volledige
-- achternaam, zijn geboortedatum en de voornaam van zijn/haar kinderen.
CREATE OR REPLACE VIEW v_emp_child
AS
SELECT e.employee_id,
       CONCAT_WS(' ', e.first_name, e.infix, e.last_name) name_emp,
       TO_CHAR(e.birth_date, 'YYYY-MM-DD')                birth_date,
       fm.name
FROM employees e
         JOIN family_members fm
              ON (e.employee_id = fm.employee_id)
WHERE LOWER(relationship) IN ('son', 'daughter')
ORDER BY 1, fm.name;

SELECT *
FROM v_emp_child;

-- Oefening 10
-- a) De dienst salarisadministratie is enkel geïnteresseerd in de employee_ids, voor- en
-- achternaam en het salaris van een medewerker gesorteerd op salaris. Schrijf de view v_emp_salary.
CREATE OR REPLACE VIEW v_emp_salary
AS
SELECT employee_id, first_name, last_name, salary
FROM employees
ORDER BY salary DESC;

SELECT *
FROM v_emp_salary;

-- b) Salarisadministratie vindt het toch gemakkelijker als in de voorgaande view de
-- department_id ook vermeld staat. Pas de view aan zonder hem te droppen en opnieuw te creëren.
CREATE OR REPLACE VIEW department_id
AS
SELECT employee_id, first_name, last_name, salary, department_id
FROM employees
ORDER BY salary DESC;

SELECT *
FROM v_emp_salary;

-- Kan je nu de view nog eens aanpassen zonder department_id?
DROP VIEW v_emp_salary;

-- Oefening 11
-- a) Maak een view v_department die alle kolommen van de tabel afdelingen toont.
CREATE OR REPLACE VIEW v_department
AS
SELECT *
FROM departments;

SELECT *
FROM v_department;

-- b) Voeg aan de tabel departments de kolom dept_telnr toe (9 alfanumeriek).
ALTER TABLE departments
    ADD COLUMN dept_telnr VARCHAR(9);

-- c) Selecteer op de in a. gemaakte view. Wat merk je?
CREATE OR REPLACE VIEW v_department
AS
SELECT *
FROM departments;

SELECT *
FROM v_department;

-- Selecteer het veld view_definition uit de dictionary tabel.
SELECT view_definition
FROM INFORMATION_SCHEMA.views
WHERE table_name = 'v_department';

-- d) Pas de view definitie aan zodat het telnr mee geselecteerd wordt door de view. Staat
-- de telefoonnummer erbij?
ALTER TABLE departments
    DROP COLUMN dept_telnr;

-- Oefening 12
-- Pas de view v_emp_salary aan zodat enkel medewerkers uit de afdeling 7 geselecteerd
-- worden. Selecteer daarna ter controle op de view.
CREATE OR REPLACE VIEW v_emp_salary
AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE department_id = 7
ORDER BY salary DESC
WITH CHECK OPTION;

SELECT *
FROM v_emp_salary;

-- Oefening 13
-- Welke DML instructies zijn er via de view v_emp_salary mogelijk op de onderliggende tabel EMPLOYEES?


-- Oefening 14
-- Voer de volgende instructie uit:
-- a)
INSERT INTO v_emp_salary
VALUES ('999999999', 'Jan', 'Janssens', 35000);


-- b) Controleer achteraf de wijziging via de view. Wat merk je en hoe los je dat probleem op?


-- Oefening 15
-- Wat is het procentueel aandeel van een medewerker in de projecten waaraan hij/zij
-- meewerkt. Zorg ervoor dat deze informatie kan verkregen worden door een eenvoudige
-- SELECT op een view v_percentage_proportion
CREATE OR REPLACE VIEW v_percentage_proportion
AS
SELECT employee_id, t.project_id, COALESCE(ROUND(t.hours / totalhours.projecthours * 100), 0) AS "PROC proportion"
FROM tasks t
         JOIN
     (SELECT project_id, SUM(hours) projecthours
      FROM tasks
      GROUP BY project_id) AS totalhours
     ON t.project_id = totalhours.project_id
ORDER BY 2, 1;

SELECT *
FROM v_percentage_proportion;

-- Combo oefening
-- Creëer een view v_familieleden_projecten_maastricht die het volgende resultaat oplevert.
-- Geef employee_id, de naam en de leeftijd (in jaren) van de familieleden van de medewerkers die aan een project werken met locatie Maastricht.
-- Los op met 2 subqueries en 1 join.
-- Let op de gevraagde output. Je zal verschillende tekstfuncties moeten gebruiken om dit op te lossen.
-- Plak exact 5 * achter de naam van het familielid.

--EMPLOYEE_ID | "naam familielid"                      |"leeftijd familielid"
---------------------------------------------------------------------------
--999555555   |Alex***** PARTNER of S. JOCHEMS         |44 jaar oud vandaag
--999444444   |Andrew***** SON of W. ZUIDERWEG         |14 jaar oud vandaag
--999444444   |Josefine***** DAUGHTER of W. ZUIDERWEG  |16 jaar oud vandaag
--999444444   |Suzan***** PARTNER of W. ZUIDERWEG      |37 jaar oud vandaag

CREATE OR REPLACE VIEW v_familieleden_projecten_maastricht
AS
SELECT e.employee_id,
       CONCAT(fm.name, '***** ', fm.relationship, ' of ', SUBSTRING(e.first_name FOR 1), '. ', UPPER(e.last_name)) "naam familielid",
       CONCAT(DATE_PART('year', AGE(fm.birth_date)), ' jaar oud vandaag')
FROM employees e
         JOIN family_members fm ON e.employee_id = fm.employee_id
WHERE e.employee_id IN (SELECT employee_id
                        FROM tasks
                        WHERE project_id IN (SELECT project_id
                                             FROM projects
                                             WHERE LOWER(location) = 'maastricht'))
ORDER BY 2;

SELECT *
FROM v_familieleden_projecten_maastricht;

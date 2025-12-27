SELECT employee_id, CTID
FROM employees
WHERE CTID = '(0,1)';



-- Oefening 1

-- Oefening 2

-- Oefening 3

-- Oefening 4
-- Voer de volgende select uit en bekijk daarna de performantie-analyse voor deze instructie:
SELECT *
FROM employees
WHERE department_id = 3;
-- A. Welk statement kan ik gebruiken om de performantie van de query te
-- analyseren?
EXPLAIN ANALYSE -- ANALYZE kan ook
SELECT *
FROM employees
WHERE department_id = 3;
-- B. Hoe worden de gevraagde rijen opgehaald?
-- C. Wat gebeurt er met de execution time als ik de query meermaals na elkaar laat
-- lopen?
-- D. Test voorgaande ook eens op de Enterprise BIG DB.

-- Oefening 5
-- Creëer een index op het attribuut department_id uit de tabel employees.
CREATE INDEX ind_empoyees_department_id ON employees(department_id);
-- Voer nu de instructie uit vraag 4 opnieuw uit en bekijk daarna de performantie-analyse.
SELECT *
FROM employees
WHERE department_id=3;
-- Hoe worden de gevraagde rijen opgehaald?
-- TIP: Je kan ook sequentieel scannen (= full range scan) ook uitzetten door gebruik te
-- maken van volgende statement: SET enable_seqscan TO off;


-- Oefening 8
-- Geef voor elk project de employee_id’s van diegenen die minder uren aan dat project besteedden
-- dan wat er gemiddeld in uren aan het project werd besteed.
SELECT t.project_id, t.employee_id, t.hours
FROM tasks t
WHERE t.hours < (SELECT AVG(hours)
                 FROM tasks
                 WHERE project_id = t.project_id);

-- Oefening 9
-- Wie is de best betaalde ondergeschikte van elke manager?
-- Gewone subquery, dus met GROUP BY
SELECT e.manager_id, e.employee_id, e.salary
FROM employees e
WHERE (e.manager_id, e.salary) IN
      (SELECT manager_id, MAX(salary)
       FROM employees
       GROUP BY manager_id)
ORDER BY 1, 2 DESC;

-- Met correlated subquery
SELECT e.manager_id, e.employee_id, e.salary
FROM employees e
WHERE e.salary =
      (SELECT MAX(salary)
       FROM employees
       WHERE manager_id = e.manager_id)
ORDER BY 1, 2 DESC;

-- Oefening 10
-- Welke personen hebben ondergeschikten? Gebruik (NOT) EXISTS
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE EXISTS (SELECT
              FROM employees
              WHERE manager_id = e.employee_id);

-- Oefening 11
-- Welke afdelingen ondersteunen geen projecten? Gebruik (NOT) EXISTS.
SELECT d.department_id, d.department_name
FROM departments d
WHERE NOT EXISTS(SELECT
                 FROM projects
                 WHERE department_id = d.department_id);

-- Oefening 12
-- First, give the following instruction:
UPDATE employees
SET parking_spot=NULL
WHERE employee_id in ('999666666', '999887777');

-- Zijn er afdelingen waar niemand een parkeerplaats heeft?
-- Een afdeling zonder medewerkers hoort hier ook bij.
-- A. Los dit op met (NOT) EXISTS (NO GROUP BY OR SET OPERATORS)
SELECT d.department_id, d.department_name
FROM departments d
WHERE NOT EXISTS(SELECT
                 FROM employees
                 WHERE department_id = d.department_id
                   AND parking_spot IS NOT NULL)
ORDER BY 1;

-- B. Los dit op met GROUP BY (NO EXISITS OR SET OPERATORS)
SELECT d.department_id, d.department_name
FROM departments d
         LEFT JOIN employees e ON (e.department_id = d.department_id)
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.parking_spot) = 0
ORDER BY 1;

-- C. Los dit op met SET OPERATORS (NO GROUP BY OR EXISTS)
SELECT d.department_id, d.department_name
FROM departments d
EXCEPT
SELECT d.department_id, d.department_name
FROM departments d
         JOIN employees e ON e.department_id = d.department_id
WHERE parking_spot IS NOT NULL
ORDER BY 1;

-- Oefening 13
-- Refresh de enterprise databank met de CREATE en FILL scripts

-- VOORBEREIDING:
-- Het zou mooi zijn als department_id en project_id automatisch gegenereerd worden met identity columns.
-- CHANGING department_id to IDENTITY COLUMN
ALTER TABLE departments
    DROP CONSTRAINT pk_departments CASCADE,
    ALTER COLUMN department_id SET DATA TYPE INTEGER,
    ALTER COLUMN department_id
        ADD GENERATED ALWAYS
        AS IDENTITY (START WITH 8);
ALTER TABLE departments
    ADD CONSTRAINT pk_departments PRIMARY KEY (department_id);
ALTER TABLE employees
    ALTER COLUMN department_id SET DATA TYPE INTEGER,
    ADD CONSTRAINT fk_employees_department_id
        FOREIGN KEY (department_id)
            REFERENCES departments (department_id);
ALTER TABLE projects
    ALTER COLUMN department_id SET DATA TYPE INTEGER,
    ADD CONSTRAINT fk_projects_department_id
        FOREIGN KEY (department_id)
            REFERENCES departments (department_id);
ALTER TABLE locations
    ALTER COLUMN department_id SET DATA TYPE INTEGER,
    ADD CONSTRAINT fk_location_department_id
        FOREIGN KEY (department_id)
            REFERENCES departments (department_id);

-- CHANGING project_id to IDENTITY COLUMN
-- (SELECT max(project_id)+10 FROM projects);
ALTER TABLE projects
    DROP CONSTRAINT pk_projects CASCADE,
    ALTER COLUMN project_id SET DATA TYPE INTEGER,
    ALTER COLUMN project_id
        ADD GENERATED ALWAYS
        AS IDENTITY (START WITH 40 INCREMENT BY 10);
ALTER TABLE projects
    ADD CONSTRAINT pk_projects PRIMARY KEY (project_id);
ALTER TABLE tasks
    ALTER COLUMN project_id SET DATA TYPE INTEGER,
    ADD CONSTRAINT fk_tasks_project_id
        FOREIGN KEY (project_id)
            REFERENCES projects (project_id);


----- OPLOSSING vorige opgave
INSERT INTO employees(employee_id, last_name, first_name)
VALUES ('999999999', 'Janssens', 'Jan');

INSERT INTO departments(department_name, manager_id)
VALUES ('Human Resources', (SELECT employee_id
                            FROM employees
                            WHERE LOWER(first_name) = 'jan'
                              AND LOWER(last_name) = 'jansens'));

UPDATE employees
SET department_id=(SELECT department_id
                   FROM departments
                   WHERE LOWER(department_name) = 'human resources')
Where employee_id = (SELECT employee_id
                     FROM employees
                     WHERE LOWER(first_name) = 'jan'
                       AND LOWER(last_name) = 'jansens');

INSERT INTO locations
VALUES ((SELECT employee_id
         FROM employees
         WHERE LOWER(first_name) = 'jan'
           AND LOWER(last_name) = 'jansens'), 'Antwerp');

INSERT INTO projects (project_name, location, department_id)
VALUES ('Courses', 'Antwerp', (SELECT department_id
                               FROM departments
                               WHERE LOWER(department_name) = 'human resources'));

UPDATE employees
SET department_id=(SELECT department_id
                   FROM departments
                   WHERE LOWER(department_name) = 'human resources'),
    manager_id=(SELECT employee_id
                FROM employees
                WHERE LOWER(first_name) = 'jan'
                  AND LOWER(last_name) = 'jansens')
WHERE employee_id = (SELECT employee_id
                     FROM employees
                     WHERE LOWER(first_name) = 'dennis'
                       AND LOWER(last_name) = 'joosten');

UPDATE employees
SET department_id=(SELECT department_id
                   FROM departments
                   WHERE LOWER(department_name) = 'human resources'),
    manager_id=(SELECT employee_id
                FROM employees
                WHERE LOWER(first_name) = 'jan'
                  AND LOWER(last_name) = 'jansens')
WHERE employee_id = (SELECT employee_id
                     FROM employees
                     WHERE LOWER(first_name) = 'douglas'
                       AND LOWER(last_name) = 'bock');

INSERT INTO tasks
VALUES ((SELECT employee_id
         FROM employees
         WHERE LOWER(first_name) = 'dennis'
           AND LOWER(last_name) = 'joosten'), (SELECT project_id
                                               FROM projects
                                               WHERE LOWER(project_name) = 'courses'), 20);

INSERT INTO tasks
VALUES ('999111111', (SELECT project_id
                      FROM projects
                      WHERE LOWER(project_name) = 'courses'), 10);

-- Oefening 14
-- Alle employees die aan project 20 meer dan 10 uur werkten krijgen een loonsverhoging van 5%.
UPDATE employees e
SET salary = e.salary * 1.05
FROM tasks t
WHERE e.employee_id = t.employee_id
  AND t.hours > 10
  AND t.project_id = 20;

-- Of
UPDATE employees
SET salary = salary * 1.05
WHERE employee_id IN (SELECT t.employee_id
                      FROM tasks t
                      WHERE t.hours > 10
                        AND t.project_id = 20);

-- Oefening 15 (Enterprise_BIG)
-- Zorg dat salarissen kleiner dan 100.000 euro worden toegelaten.
-- Employees met kinderen krijgen per kind een loonsverhoging van 50 euro/maand.
-- (opgelet : salaris bevat het jaarinkomen van een medewerker).
ALTER TABLE employees
    DROP CONSTRAINT IF EXISTS ck_salary,
    DROP CONSTRAINT IF EXISTS ch_employees_salary,
    ADD CONSTRAINT ch_employees_salary
        CHECK (salary < 1000000);

UPDATE employees e
SET salary = e.salary + 50 * 12 * (SELECT COUNT(*)
                                   FROM family_members
                                   WHERE LOWER(relationship) IN ('son', 'daughter')
                                     AND employee_id = e.employee_id)
FROM family_members fm
WHERE e.employee_id = fm.employee_id
  AND LOWER(fm.relationship) IN ('son', 'daughter');

-- Oefening 16 (Enterprise)
-- Voeg een nieuw project toe aan de tabel PROJECTEN:
-- Projectnaam: ‘Saneringen’
-- Locatie: Maastricht
-- Ondersteunende afdeling: de afdeling die tot nog toe het meest aantal projecten ondersteunde.
INSERT INTO projects (project_name, location, department_id)
VALUES ('Saneringen', 'Maastricht',
        (SELECT department_id
         FROM projects
         GROUP BY department_id
         HAVING COUNT(project_id) = (SELECT MAX(cnt_proj.cntproj)
                                     FROM (SELECT COUNT(project_id) cntproj
                                           FROM projects
                                           GROUP BY department_id) AS cnt_proj)));

-- Makkelijke oplossing
INSERT INTO projects (project_name, location, department_id)
VALUES ('Saneringen', 'Maastricht',
        (SELECT department_id
         FROM projects
         GROUP BY department_id
         ORDER BY COUNT(project_id) DESC FETCH NEXT 1 ROW ONLY));
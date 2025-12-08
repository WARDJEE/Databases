-- DQL
-- Data ophalen -> SELECT


-- DML (data in tabel)
-- Toevoegen -> INSERT
-- Wijzigen -> UPDATE
-- Verwijderen -> DELETE

--DDL (objecten in tabel)
-- Toevoegen -> CREATE
-- Wijzigen -> ALTER (Table)
-- Weggooien -> DROP
-- Leegmaken -> TRUNCATE

-- Oefening 1a
INSERT INTO employees
    (employee_id, last_name, first_name)
VALUES ('999999999', 'De Ridder', 'Martine');

-- Oefening 1b
UPDATE employees
SET parking_spot = 2
WHERE employee_id = '999888888';

-- Oefening 1c
INSERT INTO employees(employee_id, last_name, salary, first_name)
VALUES ('999999999', 'De Ridder', 85000, 'Martine');

-- Oefening 1d
DELETE
FROM departments
WHERE department_id = 3;

-- Oefening 1e
UPDATE employees
SET department_id=15
WHERE department_id = 7;

INSERT INTO departments(department_id, department_name)
VALUES (15, 'ICT');

-- Oefening 2
-- Er wordt een nieuwe afdeling (department_id=15) ‘Human Resources’ opgericht in Antwerpen.
INSERT INTO departments(department_id, department_name)
VALUES (15, 'Human Resources');

INSERT INTO locations
VALUES (15, 'Antwerpen');

-- Er wordt een nieuwe medewerker aangeworven. Zijn naam is Jan Janssens; hij heeft employee_id
-- 999999999 en wordt toegewezen aan de nieuwe afdeling en wordt tevens hoofd van die afdeling. Er
-- is nog niet exact geweten wanneer Janssens zijn manager functie opneemt in de nieuwe afdeling (departments).
INSERT INTO employees(employee_id, first_name, last_name, department_id)
VALUES ('999999999', 'Jan', 'Janssens', 15);

UPDATE departments
SET manager_id = '999999999'
WHERE department_id = 15;

-- Er wordt een nieuw project opgezet met project_id 40 en naam ‘Opleidingen’. Het project zal
-- uitgevoerd worden in Antwerpen en zal ondersteund worden door de nieuwe afdeling.
INSERT INTO projects
VALUES (40, 'Opleidingen', 'Antwerpen', 15);

-- In de afdeling zullen voorlopig 2 medewerkers tewerkgesteld worden nl. Joosten (employee_id
-- 999333333) en Bock (((employee_id 999111111))). Joosten krijgt Janssens als directe baas, Bock krijgt
-- Joosten als directe baas.

UPDATE employees
SET department_id = 15,
    manager_id    = '999111111'
WHERE employee_id = '999999999';


UPDATE employees
SET department_id = 15,
    manager_id    = '999999999'
WHERE lower(last_name) = 'bock';

-- Joosten presteerde reeds 20 u aan het nieuwe project, Bock 10 u.
INSERT INTO tasks
VALUES ('999333333', 40, 20),
       ('999111111', 40, 10);

-- Oefening 3
-- In de tabel departments moet het attribuut department_name verbreed worden naar 25 karakters.
ALTER TABLE departments
    ALTER COLUMN department_name
        SET DATA TYPE VARCHAR(25);

-- Oefening 4
-- In de tabel projects moet afgedwongen worden dat de projectnaam in hoofdletters wordt ingegeven.
ALTER TABLE projects
    ADD CONSTRAINT ch_projects_project_name
        CHECK (project_name = UPPER(project_name)) NOT VALID;

-- Indien de data niet klopt, pas deze aan NA het toevoegen van de constraint.
UPDATE projects
SET project_name = UPPER(project_name);

-- Zorg er achteraf voor dat de constraint gevalideerd wordt.
ALTER TABLE projects
    VALIDATE CONSTRAINT ch_projects_project_name;

-- Oefening 5
-- In de tabel employees moet het attribuut email toegevoegd worden (20 karaktertekens).
-- Het attribuut moet verplicht ingevuld worden. Zorg ervoor dat het veld wordt ingevuld met de string
-- ‘unknown’ bij de bestaande rijen.

ALTER TABLE employees
    ADD COLUMN email VARCHAR(20);

UPDATE employees
SET email = 'UNKNOWN';

ALTER TABLE employees
    ALTER COLUMN email
        SET NOT NULL;

/*ALTER TABLE employees
    ADD CONSTRAINT ch_employees_email
CHECK ( email IS NOT NULL );*/

-- Bonuspunten als je dit kan oplossen in 1 statement!
ALTER TABLE employees
    ADD COLUMN email VARCHAR(20) NOT NULL DEFAULT 'UNKNOWN';

-- Oefening 6
-- In de tabel departments moet de NOT NULL constraint op de afdelingnaam verwijderd worden
ALTER TABLE departments
    ALTER COLUMN department_name
        DROP NOT NULL;

-- Oefening 7
-- In de tabel employees moet het attribuut email opnieuw verwijderd worden.
ALTER TABLE employees
    DROP COLUMN email;

-- Oefening 8
-- In de tabel projects moet men de check constraint op projectnaam verwijderen.
SELECT *
FROM pg_constraint
WHERE contype = 'c'; -- Zoek naar check constraint

ALTER TABLE projects
    DROP CONSTRAINT ch_projects_project_name;

-- Oefening 9
-- In de tabel family_members moet men voor het attribuut gender ook de waarden f en m toelaten
-- (dus bijkomend met kleine letters).
ALTER TABLE family_members
    DROP CONSTRAINT c_gender,
    ADD CONSTRAINT ch_family_members_gender
        CHECK (lower(gender) IN ('f', 'm'));

-- Oefening 10
-- Plaats op de tabel departments een vreemde sleutel naar de tabel employees;
-- (indien deze nog niet zou bestaan)


-- Oefening 11
-- Verwijder alle tabellen die je hierboven maakte. Maak geen gebruik van CASCADE dus denk aan de volgorde!
DROP TABLE locations;
DROP TABLE family_members;
DROP TABLE tasks;
DROP TABLE projects;
ALTER TABLE departments
    DROP CONSTRAINT fk_dep_emp;
DROP TABLE departments;

-- Oefening 12
-- Met welke query kan je het hoogste afdelingsnummer van departments opvragen.
-- (gebruik FETCH…)
Select MAX(department_id)
FROM departments;

Select department_id
FROM departments
ORDER BY department_id
    FETCH FIRST 1 ROW ONLY;

-- Oefening 13
-- Wijzig de kolom department_id van de tabel departments naar een identity-kolom die
-- automatisch ophoogt vanaf de volgende beschikbare department_id.

-- a)
-- Zorg ervoor dat het datatype van de kolom INTEGER is. Laat de foreign keys (vreemde
-- sleutels) intact; ze mogen niet worden verwijderd of gewijzigd.
ALTER TABLE employees
    ALTER COLUMN department_id
        SET DATA TYPE INTEGER;

ALTER TABLE projects
    ALTER COLUMN department_id
        SET DATA TYPE INTEGER;

ALTER TABLE locations
    ALTER COLUMN department_id
        SET DATA TYPE INTEGER;

ALTER TABLE departments
    ALTER COLUMN department_id
        SET DATA TYPE INTEGER;

-- b)
-- Maak van department_id een identity-kolom.
ALTER TABLE departments
ALTER COLUMN department_id
ADD GENERATED ALWAYS AS IDENTITY (START WITH 8);

-- Oefening 14
-- Voeg de nieuwe afdeling 'ICT' toe aan de tabel departments.
-- Controleer of de identity-kolom de verwachte department_id heeft toegewezen.
INSERT INTO departments (department_name)
VALUES ('ICT');

-- Oefening 15
-- Wijzig de identity-kolom van de tabel departments zodat we de volgende afdeling
-- handmatig kunnen invoegen:
-- • Department_id: 100
-- • Department_name: 'HR'
ALTER TABLE departments
    ALTER COLUMN department_id
        SET GENERATED BY DEFAULT;

INSERT INTO departments (department_id, department_name)
VALUES ('100','HR');

-- Oefening 16
-- Verwijder de identity-kolom van de tabel departments.
-- Probeer een nieuwe afdeling 'Research' in te voegen zonder een department_id mee te
-- geven.
-- Leg de fout uit die optreedt.
ALTER TABLE departments
    ALTER COLUMN department_id
        DROP IDENTITY ;

INSERT INTO departments (department_name)
VALUES ('Research');
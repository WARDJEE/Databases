-- Oefening 1
-- Het attribuut NUMERIC_GRADE uit de tabel GRADES moet als standaard waarde 0 krijgen.
ALTER TABLE grades
    ALTER COLUMN numeric_grade SET DEFAULT 0;

-- Oefening 2
-- Het attribuut GRADE_POINT uit de tabel GRADE_CONVERSIONS moet als standaard waarde 0 krijgen.
ALTER TABLE grade_conversions
    ALTER COLUMN grade_point SET DEFAULT 0;

-- Oefening 3
-- Het attribuut FINAL_GRADE uit de tabel ENROLLMENTS mag enkel waarden tussen 0 en 100 aanvaarden.
-- A. Zet de constraint erop
ALTER TABLE enrollments
    ADD CONSTRAINT ch_enrollements_final_grade
        CHECK (final_grade BETWEEN 0 AND 100) NOT VALID;

-- B. Update alle waarde buiten deze range naar 0.
UPDATE enrollments
SET final_grade = 0
WHERE final_grade NOT BETWEEN 0 AND 100;

-- C. Valideer de constraint
ALTER TABLE enrollments
    VALIDATE CONSTRAINT ch_enrollements_final_grade;

-- D. Het attribuut COST van de tabel COURSES mag geen waarden aanvaarden die groter zijn dan 2000.
ALTER TABLE courses
    ADD CONSTRAINT ch_courses_cost CHECK (cost <= 2000);

-- Oefening 4
-- In de tabellen STUDENTS en INSTRUCTORS zijn de toegelaten waarden voor het attribuut SALUTATION: Rev Ms. Dr. Mr. of een null waarde.
ALTER TABLE students
    ADD constraint ch_students_salutation CHECK (salutation IN ('Rev', 'Ms.', 'Dr.', 'Mr.'));

-- Voor de instructor tabel moet dit enkel voor nieuwe rijen.
ALTER TABLE instructors
    ADD constraint ch_instructors_salutation CHECK (salutation IN ('Rev', 'Ms.', 'Dr.', 'Mr.')) NOT VALID;

-- Test dit uit door een update van een bestaande rij te doen naar een waarde die niet is toegelaten.
UPDATE instructors
SET salutation = 'Iets'
WHERE salutation = 'Hon';

SELECT salutation
from instructors
where salutation NOT IN ('Rev', 'Ms.', 'Dr.', 'Mr.');
-- Dwing dit af via constraints !!!

-- Oefening 5
-- Maak in de tabel SECTIONS een constraint op het attribuut CAPACITY. CAPACITY mag enkel waarden hebben tussen 10 en 25.
ALTER TABLE sections
    ADD CONSTRAINT ch_sections_capacity CHECK (capacity BETWEEN 10 AND 25);

-- Optioneel: Zorg ervoor dat enkel waarden die deelbaar zijn door 5 aanvaard worden.
ALTER TABLE sections
    ADD CONSTRAINT ch_sections_capacity CHECK (capacity BETWEEN 10 AND 25 AND MOD(capacity, 5) = 0);

-- Oefening 6
-- In de tabel STUDENTS moet het attribuut EMAIL (VARCHAR (30)) toegevoegd worden.
ALTER TABLE students
    ADD COLUMN email VARCHAR(30);

-- Oefening 7
-- Wanneer een instructor het vormingscentrum verlaat, moet alle informatie aangaande die docent automatisch
-- vervangen worden door een NULL waarde. De tabel sections bevat FKs naar de instructors tabel.
ALTER TABLE sections
    DROP CONSTRAINT sect_inst_fk;

ALTER TABLE sections
    ADD CONSTRAINT sect_inst_fk
        FOREIGN KEY (instructor_id) REFERENCES instructors ON DELETE SET NULL;

-- Oefening 8
-- Wanneer een student uit de administratie wordt verwijderd, moet alle informatie in verband met die student automatisch mee verwijderd worden.
ALTER TABLE enrollments
    DROP CONSTRAINT enr_stu_fk;

ALTER TABLE enrollments
    ADD CONSTRAINT enr_stu_fk
        FOREIGN KEY (student_id) REFERENCES students ON DELETE CASCADE;

ALTER TABLE grades
    DROP CONSTRAINT gr_enr_fk;

ALTER TABLE grades
    ADD CONSTRAINT gr_enr_fk
        FOREIGN KEY (student_id, section_id) REFERENCES enrollments ON DELETE CASCADE;

-- Test met de volgende query:
DELETE
FROM students
where student_id = 139;

-- Oefening 9
-- In de tabel GRADE_TYPE_WEIGHTS moet de kolomnaam PERCENT_OF_FINAL_GRADE veranderd worden in PERCENT_OF_FINAL.
-- Voer deze wijziging uit en controleer of de wijziging werd doorgevoerd
ALTER TABLE grade_type_weights
    RENAME percent_of_final_grade TO percent_of_final;

-- Oefening 10
-- In diezelfde tabel GRADE_TYPE_WEIGHTS moet de kolom DROP_LOWEST verwijderd worden. Controleer de wijziging
ALTER TABLE grade_type_weights
    DROP COLUMN drop_lowest;

-- Oefening 11
-- Controleer welke constraints er staan op de tabel INSTRUCTORS TIP: check in je tool (IntelliJ  database tab)
-- Onderstaande Query geeft je de foreign keys naar een bepaalde tabel: (Niet te kennen voor examen)
SELECT conname, pg_catalog.pg_get_constraintdef(r.oid, true) as condef
FROM pg_catalog.pg_constraint r
WHERE r.confrelid = 'public.instructors'::regclass;

-- Controleer welke constraints er staan op de tabel SECTIONS
-- Verwijder uit de tabel INSTRUCTORS de kolom INSTRUCTOR_ID.
ALTER TABLE instructors
    DROP COLUMN instructor_id;
-- Dit verloopt niet zonder problemen. Waarom?

-- Hoe los je het op?
ALTER TABLE instructors
    DROP COLUMN instructor_id CASCADE;
-- Controleer achteraf terug de constraints op INSTRUCTORS en SECTIONS. Wat merk je?

-- Oefening 12
-- Wanneer je de tabellen moet verwijderen, in welke volgorde zou je ze dan verwijderen? Doe dit maar let op: doe dit zonder gebruik te maken van CASCADE!
DROP TABLE grade_conversions;
DROP TABLE grade_type_weights;
DROP TABLE grades;
DROP TABLE enrollments;
DROP TABLE sections;
DROP TABLE courses;
DROP TABLE instructors;
DROP table students;
DROP TABLE zipcodes;

-- DML instructies:
-- Voorbereidend werk:
-- VOER het CREATE en FILL SCRIPT voor Student administration terug opnieuw uit.
-- Plaats opnieuw een vreemde sleutel van SECTIONS naar INSTRUCTORS, Als een instructor
-- geschrapt wordt moet zijn id in deze tabel NULL worden, Verwijder de NOT NULL constraint op instructor_id uit SECTIONS.
ALTER TABLE sections
    DROP CONSTRAINT sect_inst_fk,
    ADD CONSTRAINT sect_inst_fk FOREIGN KEY (instructor_id)
        REFERENCES instructors (instructor_id) ON DELETE SET NULL,
    ALTER COLUMN instructor_id DROP NOT NULL;
-- Voer daarna onderstaande inhoudelijke wijzigingen door op de databank

-- Oefening 13
-- Voer in de tabel ZIPCODES de volgende rij toe: Zip 2000, City: Antwerpen State: BE
INSERT INTO zipcodes(zip, city, state, created_by, created_date)
VALUES (2000, 'Antwerpen', 'BE', USER, CURRENT_DATE);

-- Oefening 14
-- Er wordt in het vormingsinstituut een cursus toegevoegd:
-- In te vullen attributen: course_no (=1), Description: ‘ SQL voor beginners', Cost 500
INSERT INTO courses(course_no, description, cost, created_by, created_date)
VALUES (1, 'SQL voor beginners', 500, USER, CURRENT_DATE);

-- Oefening 15
-- Er wordt een eerste sessie van die cursus ingericht
-- In te vullen attributen: section_id (=1), section_no: 1, Instructor : Gert Verhulst (instructor_id 1), Startdatum: 4 maart 2023, Locatie: GR504
-- De informatie wordt toegevoegd op de datum van vandaag
INSERT INTO instructors(instructor_id, salutation, first_name, last_name, created_by, created_date)
VALUES (1, 'Mr.', 'Gert', 'Verhulst', USER, CURRENT_DATE);

INSERT INTO sections(section_id, course_no, section_no, instructor_id, start_date_time, location, created_by,
                     created_date)
VALUES (1, 1, 1, 1, to_date(04 - 03 - 2023, 'dd-mm-yyyy'), 'GR504', USER, CURRENT_DATE);

-- Oefening 16
-- Zet de registration date van students default op de huidige dag
ALTER TABLE students
    ALTER COLUMN registration_date SET DEFAULT CURRENT_DATE;

-- Oefening 17
-- James Cooke laat zich registreren als nieuwe student in het vormingsinstituut. Zijn Zip code is 2000 en zijn werkgever is VIER.
-- Jij bent degene die de rij aanmaakt op datum van vandaag.
-- In te vullen attributen: student_id (=1), First_name, Last_name, Zip, Employer, Created_by, Created_date
-- Kijk daarna de inhoud van de tabel STUDENTS na. Hoe komt het dat het attribuut
-- REGISTRATION_DATE is ingevuld?
INSERT INTO students(student_id, first_name, last_name, zip, employer, created_by, created_date)
VALUES (1, 'James', 'Cooke', 2000, 'Vier', USER, CURRENT_DATE);

SELECT *
FROM students
WHERE student_id = 1;

-- Oefening 18
-- James Cooke schrijft zich vandaag ook in voor bovengenoemde cursussessie.
INSERT INTO enrollments(student_id, section_id, enroll_date, created_by, created_date)
VALUES (1, 1, CURRENT_DATE, USER, CURRENT_DATE);

-- Oefening 19
-- Door omstandigheden werd de cursussessie 1 met een week verlaat naar 11 maart 2023
UPDATE sections
SET start_date_time = start_date_time + INTERVAL '1 week'
WHERE section_id = 1;

-- (extra: doe de update zonder de eigenlijke datum te gebruiken)
UPDATE sections
SET start_date_time = to_date(11 - 03 - 2023, 'dd-mm-yyyy')
WHERE section_id = 1;

-- Oefening 20
-- James Cooke kijkt in zijn agenda en merkt dat hij die week niet vrij is. Hij laat zich dus terug uitschrijven voor de cursussessie.
DELETE
FROM enrollments
WHERE student_id = 1
  AND section_id = 1;

-- Oefening 21
-- Gert Verhulst neemt ontslag in het vormingsinstituut.
-- De administratie past de databank aan met volgende instructie:
DELETE
FROM instructors
WHERE instructor_id = 1;

-- Hoe komt het dat deze delete zonder problemen wordt uitgevoerd ondanks de FK van SECTIONS naar INSTRUCTORS?
-- Als het wordt verwijderd, dan wordt de section op null gezet

-- Controleer de inhoud van SECTIONS.
SELECT *
FROM sections;

-- Oefening 22
-- Zorg ervoor dat de course_no in courses een identity columns wordt die altijd een nummer
-- genereert. Let op foreign keys die naar dit veld verwijzen, we verhogen de nummer telkens
-- met 10. (de nummer is het volgende tiental na de hoogste nummer in de huidige tabel)
-- TIP:
SELECT conname, pg_catalog.pg_get_constraintdef(r.oid, true) as condef
FROM pg_catalog.pg_constraint r
WHERE r.confrelid = 'public.courses'::regclass;
-- Los de volgende problemen op:
-- - Er verwijzen 2 foreign keys naar de kolom course_no. Deze moeten blijven staan.
-- - Het type van de kolom staat nog niet goed
-- - De huidige data moet in de kolom blijven.

ALTER TABLE sections
    ALTER COLUMN course_no
        SET DATA TYPE INTEGER;

SELECT MAX(course_no)
    FROM courses;

ALTER TABLE courses
    ALTER COLUMN prerequisite SET DATA TYPE INTEGER,
    ALTER COLUMN course_no SET DATA TYPE INTEGER,
ALTER COLUMN course_no
ADD GENERATED ALWAYS AS IDENTITY (START WITH 460 INCREMENT BY 10);

-- Test je statement met de volgende insert:
INSERT INTO courses (description, cost, prerequisite, created_by, created_date)
VALUES ('Testcourse', 1000, 10, USER, CURRENT_DATE);

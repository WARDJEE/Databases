-- Subqueries

-- Oefening 1
-- Welke cursussen hebben als prerequisite de cursus ‘Intro to Programming’?
SELECT course_no, description, prerequisite
FROM courses
WHERE prerequisite IN (SELECT course_no
                       FROM courses
                       WHERE description = 'Intro to Programming');

-- Oefening 2
-- Geef cursusnr en beschrijving van cursussen die gedoceerd worden door Fernand Hanks. Zuivere subquery schrijven!
SELECT course_no, description
FROM courses
WHERE course_no IN (SELECT course_no
                    FROM sections
                    WHERE instructor_id = (SELECT instructor_id
                                           FROM instructors
                                           WHERE LOWER(CONCAT(first_name, ' ', last_name)) = 'fernand hanks'))
ORDER BY course_no;

-- Oefening 3
-- Welke studenten hebben minder punten behaald op hun final exam (FI) voor sectie 95 (=section_id)  dan studente Maria Martin?
SELECT student_id, last_name, first_name
FROM students
WHERE student_id IN (SELECT student_id
                     FROM grades
                     WHERE LOWER(grade_type_code) = 'fi'
                       AND section_id = 95
                       AND numeric_grade < (SELECT numeric_grade
                                            FROM grades
                                            WHERE LOWER(grade_type_code) = 'fi'
                                              AND section_id = 95
                                              AND student_id = (SELECT student_id
                                                                FROM students
                                                                WHERE LOWER(CONCAT(first_name, ' ', last_name)) = 'maria martin')))
ORDER BY student_id;

-- Oefening 4
-- Welke studenten uit de state CT zijn nog voor geen enkele sectie ingeschreven?
SELECT student_id, first_name, last_name
FROM students
WHERE zip IN (SELECT zip
              FROM zipcodes
              WHERE LOWER(state) = 'ct')
  AND student_id NOT IN (SELECT student_id
                         FROM enrollments)
ORDER BY last_name;

-- Oefening 5
-- Welke cursussen gaan door op locatie L211?
SELECT course_no, description
FROM courses
WHERE course_no IN (SELECT course_no
                    FROM sections
                    WHERE location = 'L211')
ORDER BY course_no;

-- Oefening 6
-- Toon een lijst met studenten die ingeschreven zijn voor de cursus ‘Intro to SQL’.  Zuivere subquery!
SELECT student_id, first_name, last_name
FROM students
WHERE student_id IN (SELECT student_id
                     FROM enrollments
                     WHERE section_id IN (SELECT section_id
                                          FROM sections
                                          WHERE course_no = (SELECT course_no
                                                             FROM courses
                                                             WHERE LOWER(description) = 'intro to sql')));

-- Oefening 7
-- Welke cursussen kosten het minst.
SELECT course_no, description, cost
FROM courses
WHERE cost = (SELECT MIN(cost)
              FROM courses)
ORDER BY course_no;

-- Oefening 8
-- Voor welke cursussectie worden het minst aantal homeworks opgegeven?
SELECT DISTINCT section_id, number_per_section aantal_huiswerken
FROM grade_type_weights
WHERE LOWER(grade_type_code) = 'hm'
  AND number_per_section = (SELECT MIN(grade_code_occurrence)
                            FROM grades
                            WHERE LOWER(grade_type_code) = 'hm');

-- Oefening 9
-- Welke student(en)  behaalde(n) het hoogste gemiddelde resultaat voor zijn (hun) homeworks.
-- a. Zorg voor volgende output
SELECT student_id, first_name, last_name
FROM students
WHERE student_id IN (SELECT student_id
                     FROM grades
                     WHERE LOWER(grade_type_code) = 'hm'
                     GROUP BY student_id
                     HAVING AVG(numeric_grade) >= ALl (SELECT AVG(numeric_grade)
                                                       FROM grades
                                                       WHERE LOWER(grade_type_code) = 'hm'
                                                       GROUP BY student_id));

-- b. Zorg nu dat de namen en het resultaat in het resultaat staan: (tip: een zuivere subquery is nu niet mogelijk)
SELECT s.student_id, s.first_name, s.last_name, AVG(g.numeric_grade)
FROM students s
         JOIN grades g ON s.student_id = g.student_id
WHERE LOWER(g.grade_type_code) = 'hm'
GROUP BY s.student_id, s.first_name, s.last_name
HAVING AVG(g.numeric_grade) >= ALl (SELECT AVG(numeric_grade)
                                    FROM grades
                                    WHERE LOWER(grade_type_code) = 'hm'
                                    GROUP BY student_id);

-- Oefening 10
-- Toon de meest ambitieuze student (= degene die zich inschreef voor het meest aantal sections).
SELECT s.student_id, s.first_name, s.last_name, COUNT(e.section_id) aantal_section
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.section_id) >= ALL (SELECT COUNT(section_id)
                                   FROM enrollments
                                   GROUP BY student_id);

-- MAX
SELECT s.student_id, s.first_name, s.last_name, COUNT(*) aantal_section
FROM enrollments e,
     students s
WHERE s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(*) = (
    -- Zoek het hoogste aantal inschrijvingen in de hele tabel
    SELECT MAX(count_per_student)
    FROM (SELECT COUNT(*) AS count_per_student
          FROM enrollments
          GROUP BY student_id))
ORDER BY last_name;

-- Oefening 11
-- Toon alle sections met de laagste inschrijvingskost en een capaciteit die
-- kleiner dan of gelijk is aan de gemiddelde capaciteit van alle cursussecties.
SELECT section_id, capacity
FROM sections
WHERE course_no IN (SELECT course_no
                    FROM courses
                    WHERE cost = (SELECT MIN(cost)
                                  FROM courses))
  AND capacity <= (SELECT AVG(capacity)
                   FROM sections);

-- Oefening 12
-- We willen een lijst van cursussen (met beschrijving) en de totale capaciteit van hun secties.
-- We zijn alleen geïnteresseerd in die secties waarvoor de totale capaciteit kleiner of gelijk is
-- dan de gemiddelde capaciteit van alle secties.
SELECT c.course_no, c.description, SUM(s.capacity) total_capacity
FROM courses c
         JOIN sections s ON c.course_no = s.course_no
GROUP BY c.course_no, c.description
HAVING SUM(s.capacity) <= (SELECT AVG(capacity)
                           FROM sections)
ORDER BY c.course_no;


-- Views

-- Oefening 1
-- a. Schrijf een view V_PROGRAMMING_COURSES, die een overzicht geeft van cursussen rond programmeren
-- (hebben in hun beschrijving het woord ‘program’).
-- Toon in de view de attributen COURSE_NO, DESCRIPTION en PREREQUISITE.
CREATE OR REPLACE VIEW v_programming_courses AS
SELECT course_no, description, prerequisite
FROM courses
WHERE description LIKE '%program%';


-- b. Voer de volgende instructie uit :
UPDATE v_programming_courses
SET cost=2000
WHERE UPPER(description) = 'PROGRAMMING TECHNIQUES';

--Waarom lukt de DML instructie (niet)?
-- Omdat cost niet bestaat in de view --

-- c. voer de volgende instructie uit :
DELETE
FROM v_programming_courses
WHERE UPPER(description) = 'INTRO TO SQL'

-- Waarom lukt de DML instructie niet?
-- Resultaat: 0 rows deleted.
-- View bevat alleen descriptions met program erin --

-- Oefening 2
-- a. Voer de volgende instructie uit:
CREATE OR REPLACE VIEW v_sections
AS
SELECT c.*, section_id
FROM courses c
         JOIN sections s ON s.course_no = c.course_no;

-- Verwijder nu uit de tabel COURSES het attribuut MODIFIED_DATE.
ALTER TABLE courses
    DROP COLUMN modified_date;
-- Wat merk je?
-- Gaat niet omdat deze kollom wordt gerbuikt in een view --

-- b. Voer de volgende instructie uit:
CREATE OR REPLACE VIEW v_students
AS
SELECT *
FROM students
WHERE zip = '07010';

-- Voeg het attribuut EMAIL (30 karakters) toe aan de onderliggende tabel STUDENTS.
ALTER TABLE students
    ADD email VARCHAR(30);

-- Selecteer vervolgens op de view.
SELECT *
FROM v_students;

-- Wat merk je?
-- email staat niet in de view --
-- Hoe bekijk je de definitie van de view?
select pg_get_viewdef('v_students', true);

-- Wat is de oorzaak van het probleem?
-- email is pas toegevoegd nadat je de view hebt gemaakt en is er dus niet in opgeslagen --
-- Hoe los je het op?
-- De view terug laten runnen --

-- Oefening 3
-- a. Creëer een view V_CHEAP_COURSES waarin je alle informatie toont over cursussen die minder dan 1095 kosten.
CREATE OR REPLACE VIEW v_cheap_courses AS
SELECT *
FROM courses
WHERE cost < 1100;

-- b. Voer nu via de view de volgende rij toe aan de tabel COURSES:
-- COURSE_NO 900
-- DESCRIPTION ‘Expensive’
-- COST 2000
-- CREATED_BY ‘Me’
-- CREATED_DATE SYSDATE
-- MODIFIED_BY ‘Me’
INSERT INTO v_cheap_courses (course_no, description, cost, created_by, created_date, modified_by)
VALUES (900, 'Expensive', 2000, 'Me', CURRENT_DATE, 'Me');

-- c. Controleer via de view of de nieuwe rij is toegevoegd
SELECT *
FROM v_cheap_courses;

-- Wat merk je?
-- Rij is niet toegevoegd --

-- d. Controleer in de tabel COURSES of de rij is toegevoegd.
SELECT *
FROM courses
WHERE course_no = 900;

-- e. Pas de view definitie aan zodat dergelijke rij in de toekomst niet meer via de view kan toegevoegd worden?
-- Je moet de informatie over de toegevoegde optie in de data dictionary kunnen terugvinden.
CREATE OR REPLACE VIEW v_cheap_courses AS
SELECT *
FROM courses
WHERE cost < 1100
WITH CHECK OPTION;

-- f. Controleer of je aanpassing werkt.
-- Verwijder eerst uit de tabel COURSES de cursus met COURSE_NO 900.
DELETE
FROM courses
WHERE course_no = 900;
-- Voer daarna bovenstaande insert opnieuw uit op de view.
INSERT INTO v_cheap_courses (course_no, description, cost, created_by, created_date, modified_by)
VALUES (900, 'Expensive', 2000, 'Me', CURRENT_DATE, 'Me');

-- Vaststelling?
-- Nu gaat het niet meer --

-- Oefening 4
-- a. Probeer een update via de view: Lukt dit?

-- b. Met welk soort view hebben we hier te maken?

-- c. Welke DML instructies kunnen er via deze view uitgevoerd worden op onderliggende tabellen? INSERT? UPDATE? DELETE?

-- d. Hoe kan je dit controleren








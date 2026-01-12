-- Indexen

-- Oefening 1
-- a. Zoek in de dictionary tabellen op welke indexen er momenteel op de tabellen uit de SA database staan.
-- Gebruik de dictionary tabel pg_indexes en vraag voor alle tabellen de tabelnaam en de indexnaam op.
SELECT *
FROM pg_indexes;

-- b. Welke van deze indexen werden automatisch door postgresql aangemaakt?
-- Indexes van primary keys constraints en unique constraints --

-- c. Wat merk je aan de naamgeving van deze indexen?
-- Die zijn hetzelfde als die van de constraints --

-- Oefening 2
-- Creëer op de attributen SECTION_ID en GRADE_TYPE_CODE uit de tabel GRADES een samengestelde index.
CREATE INDEX ind_sect_id_gr_type_code ON grades (section_id, grade_type_code);

-- In welke volgorde plaats je de attributen bij creatie en waarom?
-- section_id heeft meer verschillende waarden dan grade_type_code waardoor hij meer rijen wegfiltert --

-- Oefening 3
-- Creëer een index IND_LAST_NAME_STUD op het attribuut LAST_NAME uit de tabel STUDENT.
CREATE INDEX ind_last_name_stud ON students (last_name);
-- a. Voer de volgende select uit:
EXPLAIN ANALYZE
SELECT *
FROM students
WHERE last_name = 'Frost';
-- Bekijk via het EXPLAIN ANALYZE of de zojuist gecreëerde index bij de uitvoering van de instructie werd gebruikt.
-- De index wordt gebruikt --


-- b. Voer de volgende select uit:
EXPLAIN ANALYZE
SELECT *
FROM students
WHERE UPPER(last_name) = 'FROST';
-- Bekijk opnieuw via het EXPLAIN ANALYZE of de index bij de uitvoering van de instructie werd gebruikt. Leg uit!
-- De index wordt niet gebruikt omdat er een functie wordt op gebruikt waardoor hij trager is --

-- c. Je kan een function based index creëren om bovenstaand probleem op te lossen.
CREATE INDEX ind_func_last_name ON students (UPPER(last_name));

-- Voer nadien bovenstaande SELECT opnieuw uit en controleer via het EXPLAIN ANALYZE of de function based index werd gebruikt.
EXPLAIN ANALYZE
SELECT *
FROM students
WHERE UPPER(last_name) = 'FROST';

-- Oefening 4
-- a. Ga na welke index op de tabel GRADE_CONVERSIONS staat.
SELECT *
FROM pg_indexes
WHERE LOWER(tablename) = 'grade_conversions';
-- grcon_pk --

-- b. Probeer de index te verwijderen met DROP INDEX. Wat merk je?
DROP INDEX grcon_pk;

-- c. Hoe ga je te werk om de index te verwijderen?
ALTER TABLE grade_conversions
    DROP CONSTRAINT grcon_pk;


-- Correlated subqueries

-- Oefening 5
-- Toon alle cursussen die geen secties hebben.
SELECT c.course_no, c.description
FROM courses c
WHERE NOT EXISTS (SELECT
                  FROM sections s
                  WHERE s.course_no = c.course_no);

-- Oefening 6
-- Welke docenten doceerden nog geen cursussecties. Geef ook weer uit welke state ze komen.
SELECT CONCAT_WS(' ', last_name, first_name), (SELECT state FROM zipcodes z WHERE z.zip = i.zip)
FROM instructors i
WHERE NOT EXISTS (SELECT
                  FROM sections s
                  WHERE i.instructor_id = s.instructor_id)
ORDER BY i.zip;

-- Oefening 7
-- Toon de niet populaire cursussen (= cursussen waarvoor nog geen inschrijvingen voorkomen).
SELECT s.section_id,
       (SELECT description
        FROM courses c
        WHERE s.course_no = c.course_no) unpopular_courses
FROM sections s
WHERE NOT EXISTS (SELECT
                  FROM enrollments e
                  WHERE s.section_id = e.section_id)
ORDER BY s.section_id;

-- Oefening 8
-- Geef een overzicht van sections die volzet zijn en toon hun id en capaciteit.
-- (volzet = aantal ingeschreven studenten komt overeen met maximale capaciteit)
SELECT s.section_id, s.capacity
FROM sections s
WHERE s.capacity = (SELECT COUNT(e.student_id)
                    FROM enrollments e
                    WHERE e.section_id = s.section_id);

-- Oefening 9
-- Geef per section de student(en) die de meest aantal punten behaalde(n) op projecten. Let op de volgorde.
SELECT g1.section_id, c.description, g1.student_id, g1.numeric_grade
FROM grades g1
         JOIN sections s ON g1.section_id = s.section_id
         JOIN courses c ON s.course_no = c.course_no
WHERE LOWER(g1.grade_type_code) = 'pj'
  AND g1.numeric_grade = (SELECT MAX(g2.numeric_grade)
                          FROM grades g2
                          WHERE LOWER(g2.grade_type_code) = 'pj'
                            AND g2.section_id = g1.section_id)
ORDER BY g1.section_id;

-- Oefening 10
-- Los op gebruik makend van [NOT] EXISTS
-- a. Welke docent(en) heeft (hebben) nog geen enkele cursussectie gedoceerd?
SELECT i.instructor_id, i.first_name, i.last_name, i.street_address
FROM instructors i
WHERE NOT EXISTS (SELECT
                  FROM sections s
                  WHERE s.instructor_id = i.instructor_id)
ORDER BY i.instructor_id;

-- b. Welke studenten uit de state CT zijn nog voor geen enkele sectie ingeschreven?
SELECT s.student_id, s.first_name, s.last_name
FROM students s
WHERE s.zip IN (SELECT zip
                FROM zipcodes
                WHERE LOWER(state) = 'ct')
  AND NOT EXISTS (SELECT
                  FROM enrollments e
                  WHERE e.student_id = s.student_id);

-- Welke cursussen gaan door op locatie L211?
SELECT c.course_no, c.description
FROM courses c
WHERE EXISTS (SELECT
              FROM sections s
              WHERE s.course_no = c.course_no
                AND s.location = 'L211')
ORDER BY c.course_no;

-- Oefening 11
-- We willen weten welke cursussen geen prerequisite voor een andere cursus zijn.
-- De volgende SELECT geeft geen rijen terug omdat de operator NOT IN is en omdat de resultatentabel
-- van de binnenste SELECT onder andere NULL waarden bevat.
SELECT *
FROM courses
WHERE course_no NOT IN (SELECT prerequisite
                        FROM courses);

-- Herschrijf de query gebruik makend van [NOT] EXISTS.
SELECT course_no, description
FROM courses c1
WHERE NOT EXISTS (SELECT
                  FROM courses c2
                  WHERE c1.course_no = c2.prerequisite)
ORDER BY c1.course_no;

-- Oefening 12
-- Wie scoorde voor een sectie gemiddeld meer dan 5% boven het gemiddelde voor die sectie?
SELECT ROUND(AVG(g1.numeric_grade)) "Average score", g1.section_id, g1.student_id
FROM grades g1
GROUP BY g1.section_id, g1.student_id
HAVING AVG(g1.numeric_grade) > (SELECT AVG(g2.numeric_grade) * 1.05
                                FROM grades g2
                                WHERE g1.section_id = g2.section_id)
ORDER BY 1 DESC, 3;

-- Oefening 13
-- Wie scoorde voor een cursus gemiddeld meer dan 5% boven het gemiddelde voor die cursus?
SELECT ROUND(AVG(g1.numeric_grade)) "Average Score", s1.course_no, g1.student_id
FROM grades g1
         JOIN sections s1 ON g1.section_id = s1.section_id
GROUP BY s1.course_no, g1.student_id
HAVING AVG(g1.numeric_grade) > (SELECT AVG(g2.numeric_grade) * 1.05
                                FROM grades g2
                                         JOIN sections s2 ON g2.section_id = s2.section_id
                                WHERE s2.course_no = s1.course_no)
ORDER BY 1 DESC, 3;


-- Toepassingen op DML

-- Oefening 14
-- a. Er wordt een nieuwe cursus gegeven: ‘Advanced SQL’.
-- De cursus krijgt het nummer volgend op het hoogste reeds toegekende course_no.
-- De cursus kost 1500. De prerequisite is de cursus met beschrijving ‘Intro To SQL’.
-- De rij werd aangemaakt (en aangepast) door jou op datum van vandaag (zoek in het statement de huidige datum op).
SELECT *
FROM courses
ORDER BY course_no DESC;
INSERT INTO courses
VALUES ((SELECT MAX(course_no) + 1
         FROM courses), 'Advanced SQL', 1500, (SELECT course_no
                                               FROM courses
                                               WHERE LOWER(description) = 'intro to sql'), 'Ward', CURRENT_DATE,
        'Ward', CURRENT_DATE);

-- b. Instructor Todd Smythe zal op 8 juni 2019 een eerste sessie van deze cursus geven op locatie L214.
-- Section_no = 1 en section_id krijgt de waarde volgend op de hoogst toegekende waarde voor section_id.
-- Locatie L214 heeft plaats voor 15 studenten.
SELECT *
FROM sections
ORDER BY section_id DESC;
INSERT INTO sections (section_id, course_no, section_no, start_date_time, location, instructor_id, capacity, created_by,
                      created_date, modified_by, modified_date)
VALUES ((SELECT MAX(section_id) + 1
         FROM sections), (SELECT course_no
                          FROM courses
                          WHERE description = 'Advanced SQL'), 1, TO_DATE('08-06-2019', 'dd-mm-yyyy'), 'L214',
        (SELECT instructor_id
         FROM instructors
         WHERE LOWER(CONCAT_WS(' ', first_name, last_name)) = 'todd smythe'), 15, 'Ward', CURRENT_DATE, 'Ward',
        CURRENT_DATE);

-- c. Een niewe student schrijft zich in. Het betreft Lucy Coopers (Ms.) afkomstig uit zipcode 06880.
-- Ze schrijft zich in op datum van vandaag. Haar student_id is één hoger als het laatst toegekende student_id.
-- De rij werd aangemaakt door jou op datum van vandaag.
INSERT INTO students (student_id, salutation, first_name, last_name, zip, registration_date, created_by, created_date,
                      modified_by, modified_date)
VALUES ((SELECT MAX(student_id) + 1
         FROM students), 'Ms.', 'Lucy', 'Coopers', '06880', CURRENT_DATE, 'Ward', CURRENT_DATE, 'Ward', CURRENT_DATE);

-- d. Lucy Coopers schrijft zich in voor de hierboven toegevoegde cursussectie.
-- De rij werd aangemaakt (en aangepast) door jou op datum van vandaag.
INSERT INTO enrollments (student_id, section_id, enroll_date, final_grade, created_by, created_date, modified_by,
                         modified_date)
VALUES ((SELECT student_id
         FROM students
         WHERE LOWER(CONCAT_WS(' ', first_name, last_name)) = 'lucy coopers'), (SELECT section_id
                                                                                FROM sections
                                                                                WHERE course_no = (SELECT course_no
                                                                                                   FROM courses
                                                                                                   WHERE description = 'Advanced SQL')),
        CURRENT_DATE, NULL, 'Ward', CURRENT_DATE, 'Ward', CURRENT_DATE);

-- Oefening 15
-- Cursussessies waarvoor meer dan 10 inschrijvingen zijn worden verhuisd naar locatie L909.
-- Bij een correcte oplossing worden er 3 rijen gewijzigd.
UPDATE sections
SET location = 'L909'
WHERE section_id IN (SELECT section_id
                     FROM enrollments
                     GROUP BY section_id
                     HAVING COUNT(student_id) > 10);

-- Oefening 16
-- Voor alle secties van de cursus ‘Intro to Information Systems’ worden de punten voor het
-- participeren (grade_type_code PA) herleid tot het gemiddelde punt voor participatie voor die sectie.
-- (Er worden 27 rijen gewijzigd!) Maak de nodige aanpassingen in de databank.
UPDATE grades g
SET numeric_grade = (SELECT AVG(numeric_grade)
                     FROM grades
                     WHERE section_id = g.section_id
                       AND grade_type_code = 'PA')
WHERE LOWER(grade_type_code) = 'pa'
  AND section_id IN (SELECT section_id
                     FROM sections s
                              JOIN courses c ON s.course_no = c.course_no
                     WHERE description = 'Intro to Information Systems');

-- Oefening 17
-- Geef eerst de volgende instructie:
ALTER TABLE sections
    ALTER COLUMN instructor_id DROP NOT NULL;

-- De docent met achternaam Hanks verlaat het vormingscentrum.
-- a. Zet in alle cursussecties die hij rond Java gaf (hebben het woord ‘Java’ in de cursusbeschrijving),
-- Nina Schorin als vervangende docent. (5 updates)
UPDATE sections
SET instructor_id = (SELECT instructor_id
                     FROM instructors
                     WHERE LOWER(CONCAT_WS(' ', first_name, last_name)) = 'nina schorin')

WHERE instructor_id = (SELECT instructor_id
                       FROM instructors
                       WHERE LOWER(last_name) = 'hanks')
  AND section_id IN (SELECT section_id
                     FROM courses
                     WHERE LOWER(description) LIKE '%java%');

-- b. Vul voor de overige cursussen instructor_id in een tweede instructie voorlopig op met een NULL waarde. (4 updates)
UPDATE sections
SET instructor_id = null

WHERE instructor_id = (SELECT instructor_id
                       FROM instructors
                       WHERE LOWER(last_name) = 'hanks');

-- c. Verwijder nu docent Hanks uit de databank.
DELETE
FROM instructors
WHERE LOWER(last_name) = 'hanks';

-- Oefening 18
-- Geef eerst de volgende instructies:
CREATE TABLE diligent_students
AS
SELECT student_id, First_name, last_name
FROM students;

-- a. Ten gevolge van de voorgaande instructie is de tabel diligent_students gecreëerd en
-- opgevuld met de student_id’s, first_name’s en last_name’s van alle studenten. Maak deze tabel leeg.
DELETE
FROM diligent_students;

-- Controleer daarna de inhoud van de tabel.
SELECT *
FROM diligent_students;

-- b. Vul nu de tabel met de studentgegevens (id, first_name en last_name) van de studenten met een bovengemiddeld aantal inschrijvingen.
INSERT INTO diligent_students (student_id, First_name, last_name)
SELECT s.student_id, s.first_name, s.last_name
FROM students s
WHERE s.student_id IN (SELECT e.student_id
                       FROM enrollments e
                       GROUP BY e.student_id
                       HAVING COUNT(*) > (SELECT AVG(aantal)
                                          FROM (SELECT COUNT(*) aantal
                                                FROM enrollments
                                                GROUP BY student_id)x));

-- Controleer de inhoud van de tabel diligent_students. De tabel ijverig_studenten zou nu 52 studenten moeten bevatten.
SELECT *
FROM diligent_students;

-- Toepassingen op SET-operatoren --

-- Oefening 1
-- Geef de studenten die zich nog voor geen enkele sectie hebben ingeschreven.
-- Met JOIN
SELECT s.student_id
FROM students s
         LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.section_id IS NULL;

-- Met EXCEPT
SELECT student_id
FROM students
EXCEPT
SELECT student_id
FROM enrollments;

-- Met NOT EXISTS (Correlated subquery)
SELECT s.student_id
FROM students s
WHERE NOT EXISTS(select
                 FROM enrollments
                 WHERE student_id = s.student_id);

-- Oefening 2
-- Welke cursussen hebben geen enkele sectie?
-- JOIN
SELECT c.course_no
FROM courses c
         LEFT JOIN sections s ON c.course_no = s.course_no
WHERE s.section_id IS NULL;

-- EXCEPT
SELECT course_no
FROM courses
EXCEPT
SELECT course_no
FROM sections;

-- NOT EXISTS (Correlated subquery)
SELECT c.course_no
FROM courses c
WHERE NOT EXISTS(select
                 FROM sections
                 WHERE course_no = c.course_no);

-- Oefening 3
-- A) Geef alle achternamen van studenten en instructors en vermeld in een 2e kolom de status (student of instructor).
SELECT last_name, 'student' status
FROM students
UNION ALL
SELECT last_name, 'instructor'
FROM instructors;

-- B) Geef alle achternamen van studenten en instructors maar zonder de dubbels?
SELECT last_name, 'student' status
FROM students
UNION
SELECT last_name, 'instructor'
FROM instructors;

-- Oefening 4
-- Welke voornamen komen zowel bij studenten als bij instructors voor?
-- JOIN
SELECT s.first_name
FROM students s
         JOIN instructors i ON s.first_name = i.first_name;

-- INTERSECT
SELECT first_name
FROM students
INTERSECT
SELECT first_name
FROM instructors;

-- Oefening 5
-- In welke steden wonen zowel studenten als instructors?
-- JOIN
SELECT DISTINCT z.zip, z.city, z.state
FROM students s
         JOIN zipcodes z ON s.zip = z.zip
         JOIN instructors i ON s.zip = i.zip;

-- INTERSECT
SELECT z.zip, z.city, z.state
FROM students s
         JOIN zipcodes z ON s.zip = z.zip
INTERSECT
SELECT z.zip, z.city, z.state
FROM instructors i
         JOIN zipcodes z ON i.zip = z.zip;

-- EXIST
SELECT DISTINCT z.zip, z.city, z.state
FROM students s
         JOIN zipcodes z ON s.zip = z.zip
WHERE EXISTS(select
             FROM instructors i
             WHERE i.zip = s.zip);

-- Oefening 6
-- Welke cursussen met voorvereiste hebben minstens vijf secties?
-- INTERSECT
SELECT course_no
FROM courses
WHERE prerequisite IS NOT NULL
INTERSECT
SELECT course_no
FROM sections
GROUP BY course_no
HAVING COUNT(section_id) >= 5;

-- JOIN
SELECT c.course_no
FROM courses c
         JOIN sections s ON c.course_no = s.course_no
WHERE c.prerequisite IS NOT NULL
GROUP BY c.course_no
HAVING COUNT(s.section_id) >= 5;

-- Oefening 7
-- Voor welke inschrijvingen zijn er nog geen evaluaties gebeurd?
-- EXCEPT
SELECT student_id
FROM enrollments
EXCEPT
SELECT student_id
FROM grades;

-- JOIN
SELECT e.student_id
FROM enrollments e
         LEFT JOIN grades g ON e.student_id = g.student_id
WHERE g.student_id IS NULL;

-- Oefening 8
-- Zijn er cursussen die prerequisite zijn voor andere cursussen waarvoor geen secties zijn georganiseerd?
-- EXCEPT
SELECT c1.course_no
FROM courses c1
         JOIN courses c2 ON c1.prerequisite = c2.course_no
EXCEPT
SELECT course_no
FROM sections;

-- JOIN
SELECT c1.course_no
FROM courses c1
         JOIN courses c2 ON c1.prerequisite = c2.course_no
         LEFT JOIN sections s ON c1.course_no = s.course_no
WHERE s.course_no IS NULL;

-- Oefening 9
-- Bepaal de gemiddelde kostprijs voor alle cursussen. (Vervang voor je berekening null-waarden door 0)
SELECT ROUND(AVG(COALESCE(cost, 0)), 1) "average cost"
FROM courses;

-- Oefening 10
-- Tel voor elke prerequisite het aantal cursussen waarvoor deze prerequisite vereist is.
SELECT COALESCE(TO_CHAR(prerequisite, '9999'), 'geen'), COUNT(*)
FROM courses
GROUP BY prerequisite
ORDER BY prerequisite DESC;

-- Oefening 11
-- Geef voor alle cursussen de beschrijving en de eventuele beschrijving van de voorvereiste van de cursus.
SELECT c1.course_no                                       cursus,
       c1.description                                     course_desc,
       COALESCE(TO_CHAR(c1.prerequisite, '9999'), 'none') prerequisite,
       COALESCE(c2.description, 'none')                   prereq_desc
FROM courses c1
         LEFT JOIN courses c2 ON c1.prerequisite = c2.course_no
ORDER BY c1.course_no;


-- Toepassingen op tekst en conditionele functies --

-- Oefening 1
-- Geef een overzicht van alle steden met een zipcode kleiner dan 5000 en steden gelegen in de staat WV.
-- Toon city en staat zoals in onderstaande RT. Let op de volgorde.
SELECT city, INITCAP(state) state
FROM zipcodes
WHERE TO_NUMBER(zip, '99999') < '5000'
   OR LOWER(state) = 'wv'
ORDER BY 2, 1;

-- Oefening 2
-- Toon onderstaande RT waarin alle steden uit de staat CT die beginnen met een letter tussen A en M uitgelijnd worden.
SELECT RPAD(city, 20, '.') "CITY"
FROM zipcodes
WHERE LOWER(state) = 'ct'
  AND SUBSTRING(LOWER(city), 1, 1) BETWEEN 'a' AND 'm';

-- Oefening 3
-- Geef in een aparte kolom aan op de hoeveelste plaats ‘a’ voorkomt in de naam van een student.
-- Toon enkel die namen waar de letter ‘a’ pas na de 8ste positie in de naam staat.
SELECT last_name, POSITION('a' IN last_name)
FROM students
WHERE POSITION('a' IN last_name) > 8;

-- Oefening 4
-- Toon een lijst van alle studenten met een student_id kleiner dan 106.
-- Geef het aantal dagen geleden dat de rij gecreëerd werd.
-- Onderstaande resultaat werd gegenereerd op 19/10/2021.
SELECT student_id, last_name, created_date, CONCAT(CURRENT_DATE - created_date, ' dagen geleden') created_date
FROM students
WHERE student_id < 106;

-- Oefening 5
-- Voor welke cursussecties werd er in oktober 2021 ingeschreven?
SELECT DISTINCT section_id
FROM enrollments
WHERE enroll_date BETWEEN '2021-10-01' AND '2021-10-31';

-- Oefening 6
-- Geef de verschillende kostprijzen van de cursussen, dezelfde prijs verhoogd met 50% en deze prijs afgerond.
SELECT DISTINCT cost, cost + cost * 0.5 "kost + 50%", ROUND(cost + cost * 0.5) "kost + 50% met afronding"
FROM courses
WHERE cost IS NOT NULL;

-- Oefening 7
-- Uit welke verschillende staten komen de studenten en docenten?
-- Wanneer de state NY of NJ is moet de naam van de staat voluit geschreven worden (resp. New York en New Jersey);
-- in alle andere gevallen moet de afgekorte state-naam getoond worden.
-- Zie resultaat op de volgende pagina.
SELECT DISTINCT state,
                CASE
                    WHEN LOWER(state) = 'ny' THEN 'NEW YORK'
                    WHEN LOWER(state) = 'nj' THEN 'NEW JERSEY'
                    ELSE state
                    END state
FROM zipcodes;

-- Oefening 8
-- Geef een overzicht van de resultaten die studenten behaalden op hun homeworks (grade_type_code=’PA’) voor cursussectie 101.
-- Behaalde een student een numeric grade van 90 of meer dan moet de tekst ‘uitstekend' getoond worden.
-- Behaalde de student tussen 80 en 89 (beide inbegrepen) dan moet de tekst ‘voortreffelijk’ worden getoond.
-- In alle andere gevallen geldt de tekst ‘kan beter’.
-- Gebruik voor je oplossing verplicht CASE.
SELECT student_id,
       section_id,
       numeric_grade,
       CASE
           WHEN numeric_grade >= 90 THEN 'uitstekend'
           WHEN numeric_grade BETWEEN 80 AND 89 THEN 'voortreffelijk'
           ELSE 'kan beter'
           END numeric_grade
FROM grades
WHERE LOWER(grade_type_code) = 'pa'
  AND section_id = 101;

-- Oefening 9
-- Geef een lijst van de studenten met nummer 123, 161 en 190 en hun resp. registratiedatum in volgende formaten
SELECT last_name, registration_date, TO_CHAR(registration_date, 'dd-mm-yyyy') "REG.DATE", TO_CHAR(registration_date, 'dy') as day
    FROM students
WHERE student_id IN (123, 161, 190);

-- Oefening 10
-- Geef een overzicht van de cursussen (met een nummer hoger dan 300) en hun inschrijvingskost.
-- Indien er geen kost gekend is vermeld je ‘onbekende kost’.
-- Sorteer van groot naar klein.
SELECT course_no, COALESCE(TO_CHAR(cost, '9999'), 'onbekende kost') "Kost"
    FROM courses
WHERE course_no > 300;
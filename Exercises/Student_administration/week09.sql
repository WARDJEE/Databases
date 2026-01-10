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
SELECT last_name,
       registration_date,
       TO_CHAR(registration_date, 'dd-mm-yyyy') "REG.DATE",
       TO_CHAR(registration_date, 'dy') AS      day
FROM students
WHERE student_id IN (123, 161, 190);

-- Oefening 10
-- Geef een overzicht van de cursussen (met een nummer hoger dan 300) en hun inschrijvingskost.
-- Indien er geen kost gekend is vermeld je ‘onbekende kost’.
-- Sorteer van groot naar klein.
SELECT course_no, COALESCE(TO_CHAR(cost, '9999'), 'onbekende kost') "Kost"
FROM courses
WHERE course_no > 300
ORDER BY 2;

-- Oefening 11
-- Geef een overzicht van de studenten met een achternaam beginnende met ‘E’. Bekijk eerst aandachtig de resultatentabel.
SELECT CONCAT_WS(' ', SUBSTRING(first_name, 1, 1), last_name)
FROM students
WHERE last_name LIKE 'E%'
ORDER BY last_name;

-- Oefening 12
-- Geef alle studenten die een ‘.’ in hun voornaam hebben en die aangesproken wordt als ‘Ms.’
-- Sorteer op achternaam, die met de minste letters eerst.
SELECT student_id, salutation, first_name, last_name
FROM students
WHERE first_name LIKE '%.%'
  AND salutation = 'Ms.'
ORDER BY LENGTH(last_name);

-- Oefening 13
-- Welke studenten hebben de letter Y in hun voornaam én wonen op een locatie met een postcode
-- gelijk aan 10025 of hebben een achternaam waarvan de eerste letter zich tussen W en Z bevindt?
SELECT student_id, first_name voornbaam, last_name achternaam, zip
FROM students
WHERE LOWER(first_name) LIKE '%y%'
    AND zip = '10025'
   OR SUBSTRING(last_name, 1, 1) BETWEEN 'W' AND 'Z'
ORDER BY student_id;

-- Oefening 14
-- Geef de omschrijving van de cursussen die beginnen met ‘Intro to’ en die geen enkele prerequisite hebben.
SELECT description, prerequisite
FROM courses
WHERE description LIKE 'Intro to%'
  AND prerequisite IS NULL;

-- Oefening 15
-- Laat het system tellen hoeveel letters er staan in de volgende tekst:
-- ’Ik tel zoveel letters in totaal’. Zie onderstaand resultaat.
SELECT LENGTH('Ik tel zoveel letters in totaal') "Totaal";

-- Oefening 16
-- Geef alle studenten die aangesproken wordt als ‘Ms.’ En die ofwel ‘Allende’ ofwel ‘Grant’ noemen.
-- Sorteer op achternaam, die met de minste letters eerst.
SELECT student_id, salutation, first_name, last_name
FROM students
WHERE salutation = 'Ms.'
  AND LOWER(last_name) IN ('grant', 'allende');

-- Oefening 17
-- Geef een overzicht van alle instructeurs die in hun achternaam de letter o op de 2de plaats hebben.
SELECT last_name "LAST NAME", first_name "FIRST NAME"
FROM instructors
WHERE last_name LIKE '_o%';
-- POSITION('o' IN last_name) = 2

-- Oefening 18
-- Toon met onderstaande schrijfwijze de datum van vandaag.
-- (uiteraard krijg je een ander resultaat, afhankelijk van de dag)
SELECT 'vandaag is het ' || RPAD(TO_CHAR(CURRENT_DATE, 'dd/mm/yyyy'), 14, '*') "Welke dag zijn we?";

-- Oefening 19
-- Toon met onderstaande schrijfwijze de datum van vandaag.
SELECT CONCAT_WS(' ','vandaag is het', RPAD(TO_CHAR(CURRENT_DATE, 'FMDay'), 10, '*'), 'de', TO_CHAR(CURRENT_DATE, 'ddTH')) "Welke dag zijn we?";

-- Oefening 20
-- Schrijf nu een query die in de description kolom het woord ‘Java’ vervangt door ‘C#’
SELECT course_no, REPLACE(description, 'Java', 'C#')
    FROM courses
    WHERE description LIKE '%Java%'
ORDER BY course_no;

-- Oefening 21
-- Ga in de tabel GRADE_TYPE_WEIGHTS op zoek naar rijen waarvoor CREATED_DATE gelijk is aan MODIFIED_DATE.
-- Maak gebruik van de NULLIF functie.
SELECT section_id, grade_type_code, created_date, modified_date
    FROM grade_type_weights
WHERE NULLIF(created_date, modified_date) IS NULL;

-- Oefening 22
-- a. Geef voor alle cursussen met het woord ‘Intro’ in hun beschrijving de prerequisite.
--    Indien geen voorkennis vereist, moet de melding ‘geen voorkennis’ getoond worden.
SELECT course_no, description, COALESCE(TO_CHAR(prerequisite, 'FM99999'), 'geen voorkennis nodig')
    FROM courses
WHERE description LIKE 'Intro%'
ORDER BY course_no;

-- b. Geef voor alle cursussen met het woord ‘Intro’ in hun beschrijving weer of voorkennis vereist is of niet.
-- Wanneer voorkennis vereist is moet de tekst ‘opgelet prerequisite’ + de prerequisite getoond worden.
SELECT course_no, description, CASE WHEN prerequisite IS NULL THEN 'Geen voorkennis nodig'
ELSE CONCAT('Opgelet prerequisite nodig van ', prerequisite) END "case"
    FROM courses
WHERE description LIKE 'Intro%'
ORDER BY course_no;

-- c. De punten voor ProjectAdministratie (grade_type_code=’PA’) moeten herleid worden naar 20.
-- Er moet afgerond worden tot op het geheel. Resultaat is slechts een deel van de output.
SELECT student_id, section_id, grade_type_code, ROUND(numeric_grade/5) numeric_grade_op_20
    FROM grades
WHERE LOWER(grade_type_code) = 'pa'
ORDER BY student_id;

-- Oefening 23
-- Hoeveel maanden is dit academiejaar reeds bezig (uiteraard krijg je een ander resultaat, afhankelijk van de dag)
SELECT EXTRACT(Month FROM AGE (CURRENT_DATE,'01/09/2025')) "maanden al bezig";

-- Oefening 24
-- a. Bepaal voor de sections tussen 80 en 89 (beide incl) op welke dag ze starten.
-- Let op de schrijfwijze van de datums!
SELECT section_id, TO_CHAR(start_date_time, 'dd/mm/yyyy day') start_date_time
    FROM sections
WHERE section_id BETWEEN  80 AND 89;

-- b. Bovenstaande sections zullen om praktische redenen uiteindelijk de eerste maandag na de voorziene startdatum beginnen.
-- Geef onderstaande aangepaste resultatentabel.
-- (Opgelet: de inhoud van de databank moet niet aangepast worden)
SELECT section_id, start_date_time, TO_CHAR(start_date_time + (9 - CAST(TO_CHAR(start_date_time, 'D') AS INTEGER)), 'fmday dd/mm/yyyy') new_start_date
    FROM sections
WHERE section_id BETWEEN  80 AND 89;

-- 25. tip: bekijk de format masks in de cursus ‘databanken 1’
-- a. Geef een overzicht van de inschrijvingen voor section 117.
-- Let op de manier waarop de datum is geschreven.
SELECT student_id, section_id, TO_CHAR(enroll_date, 'dd day yyyy')
    FROM enrollments
WHERE section_id = 117;

-- b. Pas de datum uit bovenstaande query aan zodat je de volgende resultatentabel krijgt:
SELECT student_id, section_id, CONCAT_WS(' ', 'the', TO_CHAR(enroll_date, 'ddth'), 'in the', TO_CHAR(enroll_date, 'wwth'), 'week of the year', TO_CHAR(enroll_date, 'yyyy'))
FROM enrollments
WHERE section_id = 117;
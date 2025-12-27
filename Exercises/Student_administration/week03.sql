--Week 3
--oefening 1
SELECT city, INITCAP(state) "state"
FROM zipcodes
WHERE zip < '05000'
   OR LOWER(state) = 'wv'
ORDER BY state, city;

--oefening 2
SELECT RPAD(city, 20,'.') "CITY"
FROM zipcodes
WHERE LOWER(state) = 'ct'
  AND SUBSTRING(LOWER(city), 1, 1) BETWEEN 'a' AND 'm';

--oefening 3
SELECT last_name, POSITION('a' IN last_name)
FROM students
WHERE POSITION('a' IN last_name) > 8;

--oefening 4
SELECT student_id, last_name, created_date , CONCAT(current_date-created_date, ' dagen geleden') created_date
FROM students
WHERE student_id < 106;

--oefening 5
SELECT DISTINCT(section_id)
FROM enrollments
WHERE enroll_date BETWEEN '2021-10-01' AND '2021-10-31';

--oefening 6
SELECT DISTINCT(cost), cost*1.5 "kost + 50%", ROUND(cost*1.5) "kost + 50% met afronding"
FROM courses
WHERE cost IS NOT NULL;

--oefening 7
SELECT last_name, registration_date, TO_CHAR(registration_date, 'DD-MM-YYYY') "REG.DATE", TO_CHAR(registration_date, 'dy') as day
FROM students
WHERE student_id IN (123, 161, 190);

--oefening 8
SELECT CONCAT(SUBSTR(first_name, 1,1), ' ', last_name)
FROM students
WHERE LOWER(SUBSTR(last_name, 1, 1)) = 'e'
ORDER BY last_name;

--oefening 9
SELECT  student_id, salutation, first_name, last_name
FROM students
WHERE first_name LIKE '%.%'
  AND LOWER(salutation) = 'ms.'
ORDER BY LENGTH(last_name);

--oefening 10
SELECT student_id, first_name voornaam, last_name achternaam, zip
FROM students
WHERE LOWER(first_name) LIKE '%y%'
    AND zip = '10025'
   OR LOWER(SUBSTR(last_name, 1, 1)) BETWEEN 'w' AND 'z';

--oefening 11
SELECT description, prerequisite
FROM courses
WHERE description LIKE 'Intro to%'
  AND prerequisite IS NULL;

--oefening 12
SELECT LENGTH('Ik tel zoveel letters in totaal') "Totaal";

--oefening 13
SELECT student_id, salutation, first_name, last_name
FROM students
WHERE LOWER(salutation) = 'ms.'
  AND LOWER(last_name) IN ('allende', 'grant')
ORDER BY LENGTH(last_name);

--oefening 14
SELECT last_name "LAST_NAME", first_name "FIRST_NAME"
FROM instructors
WHERE last_name LIKE '_o%';

--oefening 15
SELECT CONCAT('vandaag is het ', RPAD(TO_CHAR(NOW(), 'DD-MM-YYYY'), 14, '*')) "Welke dag zijn we?";

--oefening 16
SELECT CONCAT('vandaag is het ', RPAD(TO_CHAR(NOW(), 'Day'), 10,'*'), ' de ', TO_CHAR(NOW(), 'DDTH')) "WWelke dag zijn we?";

--oefening 17
SELECT course_no, REPLACE(description, 'Java', 'C#') description
FROM courses
WHERE LOWER(description) LIKE '%java%'
ORDER BY course_no;

--oefening 18
SELECT student_id, section_id, grade_type_code, ROUND(numeric_grade/5) numeric_grade_op_20
FROM grades
WHERE LOWER(grade_type_code) = 'pa';

--oefening 19
SElECT EXTRACT(MONTH FROM AGE(NOW(), '2025-09-01')) "maanden al bezig";

--oefening 20
set lc_time = 'nl_BE';
SHOW lc_time;
SELECT section_id, TO_CHAR(start_date_time, 'DD-MM-YYYY TMday') start_date_time
FROM sections
WHERE section_id BETWEEN 80 AND 89;

--oefening 21a
SELECT student_id, section_id, TO_CHAR(enroll_date, 'DD month YYYY') inschrijvingsdatum
FROM enrollments
WHERE section_id = 117;

--oefening 21b
SELECT student_id, section_id, CONCAT('The ', TO_CHAR(enroll_date, 'DDth'), ' in the ', TO_CHAR(enroll_date, 'WWth'), ' week of the year ', TO_CHAR(enroll_date, 'YYYY') ) inschrijvingsdatum
FROM enrollments
WHERE section_id = 117;
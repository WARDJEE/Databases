--Week 2
--oefening 1
SELECT salutation, last_name, first_name, street_address
FROM instructors
WHERE LOWER(street_address) = '518 west 120th';

--oefening 2
SELECT salutation, first_name, last_name
FROM students
WHERE LOWER(last_name) = 'grant'
ORDER BY salutation DESC, first_name;

--oefening 3
SELECT *
FROM students
WHERE LOWER(salutation) = 'ms.'
  AND LOWER(last_name) IN ('allende', 'grant')
ORDER BY last_name;

--oefening 4
SELECT student_id, section_id, enroll_date, final_grade
FROM enrollments
WHERE final_grade != 0;

--oefening 5
SELECT CONCAT(first_name, ' ',last_name) "Name", street_address "Adress", zip
FROM students
WHERE zip IN ('10048', '11102', '11209');

--oefening 6
SELECT student_id, first_name first, last_name last, zip
FROM students
WHERE (LOWER(first_name) = 'yvonne'
    AND zip = '11209')
   OR LOWER(last_name) = 'zuckerberg';

--oefening 7
SELECT description, prerequisite
FROM courses
WHERE prerequisite < 122;

--oefening 8
SELECT salutation, last_name "LAST NAME", first_name "FIRST NAME", phone
FROM instructors
WHERE LOWER(last_name) != 'schorin';

--oefening 9
--Geeft een error want je geeft student_id niet weer
SELECT DISTINCT first_name, last_name
FROM students
WHERE zip = '10025'
ORDER BY student_id;

--oefening 10
SELECT description "desc", prerequisite "pre"
FROM courses
WHERE prerequisite IS NOT NULL
ORDER BY description;

--Herschijf ORDER BY op 2 andere mannieren
--ORDER BY "desc"
--ORDER BY 1

--oefening 11
SELECT description, cost, prerequisite
FROM courses
WHERE cost = 1195
  AND prerequisite IN (20, 25);

--oefening 12
--Lukt deze instructie? Nee, je moet eerst de kleinste waarde geven.
SELECT course_no, cost
FROM courses
WHERE cost BETWEEN 1500 AND 1000;

--oefening 13
--Lukt deze instructie? Nee, je kan NOT hier niet gerbuiken. Het kan er wel voor staan.
SELECT description, prerequisite
FROM courses;
--WHERE prerequisite NOT >= 140;

--oefening 14
SELECT description
FROM grade_types
WHERE description >= 'Midterm' AND description <= 'Project';

--Herschrijf
SELECT description
FROM grade_types
WHERE LOWER(description) BETWEEN 'midterm' AND 'project';

--oefening 15
SELECT city
FROM zipcodes
WHERE state != 'NY' ;

--Herschrijf
SELECT city
FROM zipcodes
WHERE NOT state = 'NY';

--oefening 16
SELECT student_id, last_name, zip
FROM students
WHERE zip BETWEEN '05000' AND '06825'
ORDER BY zip, last_name;

--oefening 17
SELECT student_id, last_name, zip
FROM students
WHERE zip IN ('06483','06605','06798','06820')
ORDER BY zip, last_name DESC;

--oefening 18
SELECT student_id, first_name first, last_name last
FROM students
WHERE LOWER(first_name) IN ('brian', 'angel', 'yvonne')
   OR lower(last_name) = 'torres'
ORDER BY last_name, first_name;

--oefening 19
SELECT student_id, last_name first, first_name last, registration_date registration
FROM students
WHERE registration_date < '2021-02-03'
ORDER BY last_name;

--oefening 20
SELECT *
FROM grade_conversions
WHERE grade_point BETWEEN 3 AND 4;

--oefening 21
SELECT course_no, description, prerequisite
FROM courses
WHERE course_no < 100
ORDER BY prerequisite;
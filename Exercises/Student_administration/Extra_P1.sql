-- oefening 1
SELECT s.first_name "Voornaam", s.last_name "Achternaam", g.section_id "SectieID", AVG(g.numeric_grade) "GemHW"
FROM students s
         JOIN grades g ON s.student_id = g.student_id
WHERE LOWER(g.grade_type_code) = 'hm'
GROUP BY s.first_name, s.last_name, g.section_id
HAVING AVG(g.numeric_grade) < 80
ORDER BY s.last_name, g.section_id;

-- oefening 2
SELECT c1.description "Cursus", c2.description "Vereiste"
FROM courses c1
         JOIN courses c2 ON c1.prerequisite = c2.course_no
ORDER BY c1.description;

-- oefening 3
SELECT se.section_id "SectieID", c.description "Cursus", COUNT(enroll_date) "AantalStudenten"
FROM sections se
         JOIN courses c ON se.course_no = c.course_no
         LEFT JOIN enrollments e ON se.section_id = e.section_id
GROUP BY se.section_id, c.description
ORDER BY se.section_id;

-- oefening 4
SELECT se.course_no
FROM sections se
        JOIN courses c ON se.course_no = c.course_no
WHERE section_id IS NULL;

-- oefening 5
SELECT CONCAT(i.first_name, ' ', i.last_name) "Docent", SUM(se.capacity) "TotaleCapaciteit"
FROM sections se
         JOIN instructors i ON se.instructor_id = i.instructor_id
GROUP BY CONCAT(i.first_name, ' ', i.last_name);

-- oefening 6
SELECT z.city "Stad", COUNT(student_id) "AantalStudenten"
FROM students s
         JOIN zipcodes z ON s.zip = z.zip
GROUP BY z.city
HAVING COUNT(student_id) > 2;

-- oefening 7
SELECT CONCAT(s.first_name, ' ', s.last_name) "Student", c.description "Cursus", CONCAT(i.first_name, ' ', i.last_name) "Docent"
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
         JOIN sections se ON e.section_id = se.section_id
         JOIN instructors i ON se.instructor_id = i.instructor_id
         JOIN courses c ON se.course_no = c.course_no
ORDER BY s.first_name;

-- oefening 8
SELECT c.description "Cursus", ROUND(AVG(g.numeric_grade),2) "GemHW"
FROM courses c
         JOIN sections se ON c.course_no = se.course_no
         JOIN grades g ON se.section_id = g.section_id
WHERE LOWER(g.grade_type_code) = 'hm'
GROUP BY c.description;


-- oefening 9
SELECT s.first_name "Voornaam", s.last_name "Achernaam"
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
WHERE enroll_date IS NULL;

-- oefening 10
SELECT section_id "SectieID", MAX(numeric_grade) "HoogsteHW"
FROM grades
WHERE LOWER(grade_type_code) = 'hm'
GROUP BY section_id;

-- oefening 11
SELECT s.first_name "Voornaam", s.last_name "Achternaam", ROUND(AVG(numeric_grade), 2) "GemFinal"
FROM students s
         JOIN grades g ON s.student_id = g.student_id
WHERE LOWER(grade_type_code) = 'fi'
GROUP BY s.first_name, s.last_name;

-- oefening 12
SELECT se.section_id "SectieID", c.description "Cursus", COUNT(e.enroll_date) "AantalInschijvingen", se.capacity "CAPACITY"
FROM sections se
         JOIN courses c ON se.course_no = c.course_no
         JOIN enrollments e ON se.section_id = e.section_id
GROUP BY se.section_id, c.description, se.capacity
HAVING COUNT(e.enroll_date) < se.capacity *0.7;

-- oefening 13
SELECT i.first_name "Voornaam", i.last_name "Achternaam"
FROM instructors i
         JOIN sections se ON i.instructor_id = se.instructor_id
WHERE se.section_id IS NULL;

-- oefening 14
SELECT description "cursus", cost "Kostprijs"
FROM courses
GROUP BY description, cost
HAVING cost > AVG(cost);

-- oefening 15
SELECT CONCAT(s.first_name, ' ', s.last_name) "Student", AVG(g.numeric_grade) "GemHW"
FROM students s
         JOIN grades g ON s.student_id = g.student_id
WHERE LOWER(g.grade_type_code) = 'hm'
GROUP BY CONCAT(s.first_name, ' ', s.last_name)
ORDER BY AVG(g.numeric_grade)
FETCH NEXT 3 ROWS WITH TIES;

-- oefening 16
SELECT c.description "Cursus", COUNT(se.section_id) "AantalSecties"
FROM courses c
         JOIN sections se ON c.course_no = se.course_no
GROUP BY c.description;

-- oefening 17
SELECT z.state "Staat", COUNT(s.student_id) "AantalStudenten"
FROM students s
         JOIN zipcodes z ON s.zip = z.zip
GROUP BY z.state;

-- oefening 18
SELECT c1.description "Cursus", c2.description "Vereiste", c3.description "VereisteVanVereiste"
FROM courses c1
         JOIN courses c2 ON c1.prerequisite = c2.course_no
         JOIN courses c3 ON c2.prerequisite = c3.course_no;

-- oefening 19
SELECT CONCAT(i.first_name, ' ', i.last_name) "Docent", ROUND(AVG(numeric_grade), 2) "GemHW"
FROM instructors i
         JOIN sections se ON i.instructor_id = se.instructor_id
         JOIN grades g ON se.section_id = g.section_id
WHERE LOWER(g.grade_type_code) = 'hm'
GROUP BY CONCAT(i.first_name, ' ', i.last_name);


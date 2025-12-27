--Week 4
--oefening 1
SELECT s.last_name, s.zip, z.state, z.city
FROM students s
         JOIN zipcodes z ON s.zip = z.zip
WHERE CAST(s.zip AS INTEGER) < 03000
ORDER BY z.zip;

--oefening 2
SELECT DISTINCT(s.first_name), s.last_name, s.student_id, e.enroll_date
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enroll_date < '2021-02-03'
ORDER BY s.last_name;

--oefening 3
SELECT c.course_no, c.description, s.section_no
FROM courses c
         JOIN sections s ON s.course_no = c.course_no
WHERE c.prerequisite IS NULL
ORDER BY course_no, s.section_no;

--oefening 4
SELECT s.student_id,c.course_no, TO_CHAR(e.enroll_date, 'MM-DD-YYYY HH12:MIAM') enrolled, se.section_id
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
         JOIN sections se ON e.section_id = se.section_id
         JOIN courses c ON se.course_no = c.course_no
WHERE LOWER(c.description) = 'intro to information systems'
ORDER BY s.student_id;

--oefening 5
SELECT s.student_id "Student ID", i.instructor_id "Instructor ID", s.zip "Student ZIP", i.zip "Instructor ZIP"
FROM students s
         JOIN instructors i ON s.zip = i.zip;

--oefening 6
SELECT DISTINCT c.course_no course, s.section_no section, e.student_id student
FROM enrollments e
         JOIN sections s ON e.section_id = s.section_id
         JOIN courses c ON s.course_no = c.course_no
         JOIN instructors i ON s.instructor_id = i.instructor_id
WHERE i.zip = '10025'
  AND c.prerequisite IS NULL
ORDER BY e.student_id;

--oefening 7
SELECT CONCAT(first_name, ' ', last_name) name, i.street_address, CONCAT(z.city, ', ', z.state, ' ', z.zip) city_state_zip,s.start_date_time, s.section_id
FROM instructors i
         JOIN sections s ON i.instructor_id = s.instructor_id
         JOIN zipcodes z ON i.zip = z.zip
WHERE s.start_date_time BETWEEN '01-04-2021' AND '30-04-2021'
ORDER BY first_name;

--oefening 8
SELECT DISTINCT s.student_id, s.first_name, s.last_name
FROM students s
         JOIN zipcodes z ON s.zip = z.zip
         JOIN enrollments e ON s.student_id = e.student_id
WHERE LOWER(z.state) = 'ct'
ORDER BY s.student_id;

--oefening 9
SELECT CONCAT(s.first_name, ' ', s.last_name) name, g.section_id, CONCAT(g.grade_type_code,' ', g.grade_code_occurrence) evaluation_type, g.numeric_grade grade
FROM students s
         JOIN grades g ON s.student_id = g.student_id
WHERE LOWER(CONCAT(s.first_name, ' ', s.last_name)) = 'daniel wicelinski'
  AND g.section_id = 87
ORDER BY g.grade_type_code, g.grade_code_occurrence;

--oefening 10
SELECT s.student_id, s.first_name, s.last_name, se.course_no, g.numeric_grade, gc.letter_grade, se.section_id
FROM sections se
         JOIN grades g ON se.section_id = g.section_id
         JOIN grade_conversions gc ON g.numeric_grade BETWEEN gc.min_grade AND gc.max_grade
         JOIN students s ON g.student_id = s.student_id
WHERE se.course_no = 420
  AND LOWER(g.grade_type_code) = 'fi';

--oefening 11
SELECT  s.student_id, s.first_name, s.last_name, g.section_id, gtw.percent_of_final_grade pct, g.grade_type_code, g.numeric_grade grade
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN grade_type_weights gtw ON (gtw.grade_type_code = g.grade_type_code AND gtw.section_id = g.section_id)
WHERE g.numeric_grade <= 80
  AND LOWER(g.grade_type_code) = 'pj'
ORDER BY g.numeric_grade;

--oefening 12
SELECT LOWER(c.description) description, se.section_no, se.location, se.capacity
FROM courses c
         JOIN sections se ON c.course_no = se.course_no
WHERE LOWER(se.location) = 'l211'
ORDER BY c.description desc;

--oefening 13
SELECT c.description, se.section_no, se.start_date_time
FROM courses c
         JOIN sections se ON c.course_no = se.course_no
         JOIN enrollments e ON se.section_id = e.section_id
         JOIN students s ON e.student_id = s.student_id
WHERE LOWER(CONCAT(s.first_name, ' ', s.last_name)) = 'joseph german';

--oefening 14
SELECT c.course_no, c.description, se.section_id
FROM courses c
         JOIN sections se ON c.course_no = se.course_no
         JOIN grade_type_weights gtw ON se.section_id = gtw.section_id
WHERE LOWER(gtw.grade_type_code) = 'pa'
  AND gtw.percent_of_final_grade >= 25
ORDER BY c.course_no;

--oefening 15
SELECT s.first_name, s.last_name, g.numeric_grade
FROM students s
         JOIN grades g ON s.student_id = g.student_id
WHERE LOWER(g.grade_type_code) = 'pj'
  AND g.numeric_grade >= '99';

--oefening 16
SELECT s.student_id, s.last_name, s.first_name, g.section_id, CONCAT(g.grade_type_code, ' ', g.grade_code_occurrence) quiz, g.numeric_grade
FROM students s
         JOIN grades g ON s.student_id = g.student_id
WHERE s.zip = '10956'
  AND LOWER(g.grade_type_code) = 'qz';

--oefening 17
SELECT c.course_no, se.section_no, i.first_name, i.last_name
FROM courses c
         JOIN sections se ON c.course_no = se.course_no
         JOIN instructors i ON se.instructor_id = i.instructor_id
WHERE c.prerequisite = 20
ORDER BY c.course_no, se.section_no;

--oefening 18a
--Het laat zien welke studenten dezelfde zipcode hebben als instructors
SELECT stud.student_id, i.instructor_id, stud.zip, i.zip
FROM students stud
         JOIN instructors i ON stud.zip = i.zip;

--oefening 18b
--Het laat zien welke studenten dezelfde zipcode hebben als instructors waarvan ze les hebben
SELECT stud.student_id, i.instructor_id, stud.zip, i.zip
FROM students stud
         JOIN enrollments e ON stud.student_id = e.student_id
         JOIN sections sec ON e.section_id = sec.section_id
         JOIN instructors I ON sec.instructor_id = i.instructor_id
WHERE stud.zip = i.zip;

--oefening 19
SELECT c1.course_no course, c1.description, c1.prerequisite, c2.description "description prerequisite"
FROM courses c1
         JOIN courses c2 ON c2.course_no = c1.prerequisite
WHERE c1.prerequisite IS NOT NULL
ORDER BY c1.course_no;

--oefening 20
SELECT s1.student_id, s1.last_name, s1.street_address
FROM students s1
         JOIN students s2 ON s1.street_address = s2.street_address AND s1.zip = s2.zip
WHERE s1.student_id != s2.student_id
ORDER BY s1.street_address;

--oefening 21
SELECT DISTINCT i1.first_name, i1.last_name, i1.zip
FROM instructors i1
         JOIN instructors i2 ON i1.zip = i2.zip
WHERE i1.instructor_id != i2.instructor_id
ORDER BY i1.zip;

--oefening 22
SELECT se1.section_id, TO_CHAR(se1.start_date_time, 'dd-MON-YYYY HH24:MI') starttijd, se1.location
FROM sections se1
         JOIN sections se2 ON se1.start_date_time = se2.start_date_time AND se1.location = se2.location
WHERE se1.section_id != se2.section_id
ORDER BY  se1.start_date_time, se1.section_id;

--oefening 23
SELECT s1.student_id, s1.last_name, s1.first_name
FROM students s1
         JOIN grades g1 ON s1.student_id = g1.student_id
         JOIN grades g2 ON g1.section_id = g2.section_id AND g1.grade_type_code = g2.grade_type_code
         JOIN students s2 ON s2.student_id = g2.student_id
WHERE LOWER(CONCAT(s2.first_name, ' ', s2.last_name)) = 'maria martin'
  AND g1.section_id = 95
  AND g1.grade_type_code = 'FI'
  AND g1.numeric_grade < g2.numeric_grade
ORDER BY s1.student_id DESC;

--oefening 24
SELECT g1.student_id, g2.numeric_grade "Midterm Grade", g1.numeric_grade "Final Grade"
FROM grades g1
         JOIN grades g2 ON g1.section_id = g2.section_id AND g1.student_id = g2.student_id
WHERE g1.section_id = '99'
  AND LOWER(g1.grade_type_code) = 'fi'
  AND LOWER(g2.grade_type_code) = 'mt'
  AND g1.numeric_grade < g2.numeric_grade;
--Week 5
--oefening 1a
SELECT COUNT(*) number_of_enrollements
FROM enrollments;

--oefening 1b
SELECT COUNT(DISTINCT(section_id)) "Number of Different sections"
FROM enrollments;

--oefening 1c
SELECT SUM(capacity) total_capacity, ROUND(AVG(capacity)) average_capacity, MIN(capacity) minimum_capacity, MAX(capacity) maximum_capacity
FROM sections;

--oefening 2
SELECT MAX(cost) expensive_course
FROM courses;

--oefening 3
SELECT MIN(enroll_date) "First", MAX(enroll_date) "Most Recent"
FROM enrollments;

--oefening 4
SELECT COUNT(course_no) "courses without prerequisite"
FROM courses
WHERE prerequisite IS NULL;

--oefening 5
SELECT COUNT(DISTINCT(student_id)) "Number enlisted students"
FROM enrollments;

--oefening 6
SELECT MIN(description) "first in order", MAX(description) "last in order"
FROM courses;

--oefening 7
SELECT MAX(enroll_date) "most recent subscription"
FROM enrollments;

--oefening 8
SELECT location, COUNT(sections) "Number of sections", SUM(capacity) "to capacity", MIN(capacity) "Minimum capaciteit", MAX(capacity) "Maximum capaciteit"
FROM sections
GROUP BY location;

--oefening 9a
SELECT location, instructor_id, COUNT(section_id) "Number of sections", SUM(capacity) tot_cap, MIN(capacity) min_cap, MAX(capacity) max_cap
FROM sections
GROUP BY location, instructor_id
ORDER BY location;

--oefening 9b
SELECT location, instructor_id, COUNT(section_id) "Number of sections", SUM(capacity) tot_cap, MIN(capacity) min_cap, MAX(capacity) max_cap
FROM sections
GROUP BY location, instructor_id
HAVING SUM(capacity) > 50
ORDER BY tot_cap DESC;

--oefening 9c
SELECT location, instructor_id, COUNT(section_id) "Number of sections", SUM(capacity) tot_cap, MIN(capacity) min_cap, MAX(capacity) max_cap
FROM sections
WHERE course_no > 99
GROUP BY location, instructor_id
HAVING SUM(capacity) > 50
ORDER BY tot_cap DESC;

--oefening 9d
SELECT location "Location", SUM(capacity) "Total Capacity"
FROM sections
WHERE location like 'L5%'
GROUP BY location
HAVING COUNT(location) >= 3;

--oefening 10
SELECT student_id, section_id, AVG(numeric_grade) average_grade_homeworks
FROM grades
WHERE LOWER(grade_type_code) = 'hm'
GROUP BY student_id, section_id
HAVING AVG(numeric_grade) < 80
ORDER BY student_id, section_id;

--oefening 11
SELECT student_id, COUNT(section_id) "Number of sections"
FROM enrollments
GROUP BY student_id
HAVING COUNT(section_id) > 2;

--oefening 12
SELECT course_no "course #", AVG(capacity) "Agv. Capacity", ROUND(AVG(capacity)) "Agv. capacity without decimals"
FROM sections se
JOIN instructors i ON se.instructor_id = i.instructor_id
WHERE LOWER(CONCAT(i.first_name, ' ', i.last_name)) = 'fernand hanks'
GROUP BY course_no;

--oefening 13
SELECT cost, COUNT(course_no) count
FROM courses
GROUP BY cost
ORDER BY cost;

--oefening 14
SELECT enroll_date, COUNT(student_id) "aantal inschrijvingen"
FROM enrollments
WHERE section_id = 90
GROUP BY enroll_date;

--oefening 15
SELECT employer, COUNT(student_id) "Number of students"
FROM students
GROUP BY employer
HAVING COUNT(student_id) > 4;

--oefening 16
SELECT instructor_id, COUNT(course_no) "Number of courses"
FROM sections
GROUP BY instructor_id
ORDER BY instructor_id;

--oefening 17
SELECT section_id, MAX(numeric_grade) "highest grade"
FROM grades
WHERE section_id BETWEEN 85 and 93
AND LOWER(grade_type_code) = 'mt'
GROUP BY section_id;

--oefening 18
SELECT student_id, ROUND(AVG(numeric_grade)) "average evaluation"
FROM grades
GROUP BY student_id
HAVING COUNT(DISTINCT section_id) > 2;

--oefening 19
SELECT zip, COUNT(student_id) "Number of students"
FROM students
GROUP BY zip
HAVING COUNT(student_id) > 5;

--oefening 20
SELECT c.course_no, c.description
FROM courses c
LEFT JOIN sections se ON c.course_no = se.course_no
WHERE se.course_no IS NULL
ORDER BY c.course_no;

--oefening 21
SELECT c.description, c.prerequisite prereq, se.section_id, se.location
FROM courses c
LEFT JOIN sections se ON c.course_no = se.course_no
WHERE c.prerequisite = 350;

--oefening 22
SELECT CONCAT(i.last_name, ' ', i.first_name) "name lecturer", z.state
FROM instructors i
LEFT JOIN sections se ON i.instructor_id = se.instructor_id
LEFT JOIN zipcodes z ON i.zip = z.zip
WHERE se.section_id IS NULL;

--oefening 23
SELECT se.section_id, c.description unpopular_courses
FROM sections se
LEFT JOIN enrollments e ON se.section_id = e.section_id
JOIN courses c ON se.course_no = c.course_no
WHERE e.enroll_date IS NULL
ORDER BY se.section_id;

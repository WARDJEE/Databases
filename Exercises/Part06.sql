-- Conventie: <prefix>_<tabelnaam>_<optionele_kolomnaam>
-- PRIMARY KEY - prefix pk, geen komlom
-- CHECK - prefix ch
-- FOREIGN KEY - prefix fk
-- UNIQ - un


-- Oefening 1
DROP TABLE IF EXISTS students;
CREATE TABLE students
(
    student_id CHAR(10),
    name       VARCHAR(50),
    street     VARCHAR(100),
    nr         NUMERIC(4),
    postalcode NUMERIC(4),
    city       VARCHAR(30),
    birth_date DATE
);

-- Oefening 2
DROP TABLE IF EXISTS students;
CREATE TABLE students
(
    student_id CHAR(10)
        CONSTRAINT pk_students
            PRIMARY KEY,
    name       VARCHAR(50)  NOT NULL,
    street     VARCHAR(100) NOT NULL,
    nr         NUMERIC(4)   NOT NULL
        CONSTRAINT ch_students_nr
            CHECK (nr > 0),
    postalcode NUMERIC(4)   NOT NULL
        CONSTRAINT ch_students_postalcode
            CHECK (postalcode BETWEEN 1000 AND 9999),
    city       VARCHAR(30)  NOT NULL,
    birth_date DATE         NOT NULL
        CONSTRAINT ch_students_birth_date
            CHECK (birth_date < CURRENT_DATE)
);

-- Oefening 3
DROP TABLE IF EXISTS classes;
CREATE TABLE classes
(
    class_id   NUMERIC(4),
    building   CHAR(2),
    floor      NUMERIC(1),
    roomnumber NUMERIC(2)
);

-- Oefening 4
DROP TABLE IF EXISTS classes;
CREATE TABLE classes
(
    class_id   NUMERIC(4)
        CONSTRAINT pk_classes
            PRIMARY KEY,
    building   CHAR(2)    NOT NULL
        CONSTRAINT ch_classes_building
            CHECK (LOWER(building) IN ('gr', 'ph', 'sw')),
    floor      NUMERIC(1) NOT NULL
        CONSTRAINT ch_classes_floor
            CHECK (floor BETWEEN 1 AND 5),
    roomnumber NUMERIC(2) NOT NULL
        CONSTRAINT ch_classes_roomnumber
            CHECK (roomnumber > 0)
);

-- Oefening 5
DROP TABLE IF EXISTS students_classes;
CREATE TABLE student_classes
(
    studentnumber CHAR(10),
    classnumber   NUMERIC(4)
);

-- Oefening 6
DROP TABLE IF EXISTS students_classes;
CREATE TABLE students_classes
(
    studentnumber CHAR(10)
        CONSTRAINT fk_student_classes_studentnumber
            REFERENCES students (student_id)
            ON DELETE CASCADE,
    classnumber   NUMERIC(4)
        CONSTRAINT fk_student_classes_classnumber
            REFERENCES classes (class_id)
);

-- Insert
INSERT INTO students
(student_id, name, street, nr, postalcode, city, birth_date)
VALUES
    ('100', 'Albert Einstein', 'Mercer Street', 112, 8540, '
Princeton, New Jersey', '1879-03-14');
INSERT INTO classes (class_id, building, floor, roomnumber)
VALUES (1, 'GR', '1', 13);
INSERT INTO students_classes (studentnumber, classnumber)
VALUES (100, 1);
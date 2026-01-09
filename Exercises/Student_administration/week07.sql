CREATE TABLE zipcodes
(
    zip           VARCHAR(5)
        CONSTRAINT pk_zipcodes_zip PRIMARY KEY,
    city          VARCHAR(25),
    state         VARCHAR(2),
    created_by    VARCHAR(30)
        CONSTRAINT nn_zipcodes_created_by NOT NULL,
    created_date  DATE
        CONSTRAINT nn_zipcodes_created_date NOT NULL,
    modified_by   VARCHAR(30),
    modified_date DATE
);

CREATE TABLE students
(
    student_id        NUMERIC(8)
        CONSTRAINT pk_students_student_id PRIMARY KEY,
    salutation        VARCHAR(5),
    first_name        VARCHAR(25),
    last_name         VARCHAR(25)
        CONSTRAINT nn_students_last_name NOT NULL
        CONSTRAINT ch_students_last_name CHECK (last_name = UPPER(last_name)),
    street_address    VARCHAR(50),
    zip               VARCHAR(5)
        CONSTRAINT nn_students_zip NOT NULL
        CONSTRAINT fk_students_zip REFERENCES zipcodes,
    phone             VARCHAR(15),
    employer          VARCHAR(50),
    registration_date DATE
        CONSTRAINT nn_students_registration_date NOT NULL
        DEFAULT CURRENT_DATE,
    created_by        VARCHAR(30)
        CONSTRAINT nn_students_created_by NOT NULL,
    created_date      DATE
        CONSTRAINT nn_students_created_date NOT NULL,
    modified_by       VARCHAR(30),
    modified_date     DATE
);

CREATE TABLE courses
(
    course_no     NUMERIC(8)
        CONSTRAINT pk_courses_course_no PRIMARY KEY,
    description   VARCHAR(50)
        CONSTRAINT nn_courses_description NOT NULL,
    cost          NUMERIC(9, 2),
    prerequisite  NUMERIC(8)
        CONSTRAINT fk_courses_prerequisite REFERENCES courses (course_no),
    created_by    VARCHAR(30)
        CONSTRAINT nn_courses_created_by NOT NULL,
    created_date  DATE
        CONSTRAINT nn_courses_created_date NOT NULL,
    modified_by   VARCHAR(30),
    modified_date DATE
);

CREATE TABLE instructors
(
    instructor_id  NUMERIC(8)
        CONSTRAINT pk_instructors_instructor_id PRIMARY KEY,
    salutation     VARCHAR(5),
    first_name     VARCHAR(25),
    last_name      VARCHAR(25),
    street_address VARCHAR(50),
    zip            VARCHAR(5)
        CONSTRAINT fk_instructors_zip REFERENCES zipcodes,
    phone          VARCHAR(15),
    created_by     VARCHAR(30)
        CONSTRAINT nn_instructors_created_by NOT NULL,
    created_date   DATE
        CONSTRAINT nn_instructors_created_date NOT NULL,
    modified_by    VARCHAR(30),
    modified_date  DATE
);

CREATE TABLE sections
(
    section_id      NUMERIC(8)
        CONSTRAINT pk_sections_section_id PRIMARY KEY,
    course_no       NUMERIC(8)
        CONSTRAINT fk_sections_course_no REFERENCES courses
        CONSTRAINT nn_sections_course_no NOT NULL,
    section_no      NUMERIC(3)
        CONSTRAINT nn_sections_section_no NOT NULL,
    start_date_time DATE,
    location        VARCHAR(50),
    instructor_id   NUMERIC(8)
        CONSTRAINT fk_sections_instructor_id REFERENCES instructors
        CONSTRAINT nn_sections_instructor_id NOT NULL,
    capacity        NUMERIC(3),
    created_by      VARCHAR(30)
        CONSTRAINT nn_sectionssections_created_by NOT NULL,
    created_date    DATE
        CONSTRAINT nn_sections_created_date NOT NULL,
    modified_by     VARCHAR(30),
    modified_date   DATE,
    CONSTRAINT u_sections_course_no_section_no UNIQUE (course_no, section_no)
);

CREATE TABLE enrollments
(
    student_id    NUMERIC(8)
        CONSTRAINT fk_enrollments_student_id REFERENCES students (student_id),
    section_id    NUMERIC(8)
        CONSTRAINT fk_enrollments_section_id REFERENCES sections (section_id),
    enroll_date   DATE
        CONSTRAINT nn_enrollments_enroll_date NOT NULL,
    final_grade   NUMERIC(3),
    created_by    VARCHAR(30)
        CONSTRAINT nn_enrollments_created_by NOT NULL,
    created_date  DATE
        CONSTRAINT nn_enrollments_created_date NOT NULL,
    modified_by   VARCHAR(30),
    modified_date DATE,
    CONSTRAINT pk_enrollments_student_id_section_id PRIMARY KEY (student_id, section_id)
);

CREATE TABLE grade_types
(
    grade_type_code CHAR(2)
        CONSTRAINT pk_grade_types_grade_type_code PRIMARY KEY,
    description     VARCHAR(50)
        CONSTRAINT nn_grade_types_description NOT NULL,
    created_by      VARCHAR(30)
        CONSTRAINT nn_grade_types_created_by NOT NULL,
    created_date    DATE
        CONSTRAINT nn_grade_types_created_date NOT NULL,
    modified_by     VARCHAR(30),
    modified_date   DATE
);

CREATE TABLE grade_type_weights
(
    grade_type_code        CHAR(2)
        CONSTRAINT fk_grade_type_weights_grade_type_code REFERENCES grade_types,
    section_id             NUMERIC(8)
        CONSTRAINT fk_grade_type_weights_section_id REFERENCES sections,
    number_per_section     NUMERIC(3)
        CONSTRAINT nn_grade_type_weights_number_per_section NOT NULL,
    percent_of_final_grade NUMERIC(3)
        CONSTRAINT nn_grade_type_weights_percent_of_final_grade NOT NULL,
    drop_lowest            CHAR
        CONSTRAINT ch_grade_type_weights_drop_lowest CHECK (drop_lowest IN ('Y', 'N')),
    created_by             VARCHAR(30)
        CONSTRAINT nn_grade_type_weights_created_by NOT NULL,
    created_date           DATE
        CONSTRAINT nn_grade_type_weights_created_date NOT NULL,
    modified_by            VARCHAR(30),
    modified_date          DATE,
    CONSTRAINT pk_grade_type_weights PRIMARY KEY (grade_type_code, section_id)
);

CREATE TABLE grades
(
    grade_code_occurrence NUMERIC(38),
    grade_type_code       CHAR(2)
        CONSTRAINT fk_grades_grade_type_code REFERENCES grade_types,
    student_id            NUMERIC(8),
    section_id            NUMERIC(8),
    numeric_grade         NUMERIC(3)
        CONSTRAINT nn_grades_created_by NOT NULL
        DEFAULT 0,
    comments              VARCHAR(2000),
    created_by            VARCHAR(30)
        CONSTRAINT nn_grades_created_by NOT NULL,
    created_date          DATE
        CONSTRAINT nn_grades_created_date NOT NULL,
    modified_by           VARCHAR(30),
    modified_date         DATE,
    CONSTRAINT fk_grades_enrollments FOREIGN KEY (student_id, section_id) REFERENCES enrollments (student_id, section_id),
    CONSTRAINT fk_grades_grade_type_weights FOREIGN KEY (section_id, grade_type_code) REFERENCES grade_type_weights (section_id, grade_type_code),
    CONSTRAINT pk_grades PRIMARY KEY (grade_code_occurrence, grade_type_code, student_id, section_id)
);

CREATE TABLE grade_conversion
(
    letter_grade  VARCHAR(2)
        CONSTRAINT pk_grade_conversion_letter_grade PRIMARY KEY,
    grade_point   NUMERIC(3, 2)
        CONSTRAINT nn_grade_conversion_grade_point NOT NULL
        DEFAULT 0,
    max_grade     NUMERIC(3)
        CONSTRAINT nn_grade_conversion_max_grade NOT NULL,
    min_grade     NUMERIC(3)
        CONSTRAINT nn_grade_conversion_min_grade NOT NULL,
    created_by    VARCHAR(30)
        CONSTRAINT nn_grade_conversion_created_by NOT NULL,
    created_date  DATE
        CONSTRAINT nn_grade_conversion_created_date NOT NULL,
    modified_by   VARCHAR(30),
    modified_date DATE
);
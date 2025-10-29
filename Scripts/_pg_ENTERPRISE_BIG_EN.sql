-- ******************************
-- DROP Tables
-- ******************************
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS family_members CASCADE;

-- ******************************
-- CREATE Tables
-- ******************************
CREATE TABLE departments (
    department_id              numeric(2)       
		CONSTRAINT pk_departments PRIMARY KEY,
    department_name            varchar(30)
		CONSTRAINT nn_department_name NOT NULL,
    manager_id         CHAR(9),   
    mgr_start_date     DATE
);  

CREATE TABLE employees (
    employee_id             CHAR(9)         
		CONSTRAINT pk_employees PRIMARY KEY,
    last_name          varchar(25)    
		CONSTRAINT nn_last_name NOT NULL,
    first_name            varchar(25)    
		CONSTRAINT nn_first_name NOT NULL,
    infix       varchar(25),
    street               varchar(50),
    location              varchar(25),
    province           CHAR(2), 
    postal_code            varchar(7),
    birth_date           DATE, 
    salary             numeric(7,2)     
		CONSTRAINT ck_salary CHECK (salary <= 85000),
    parking_spot       numeric(4)       
		CONSTRAINT un_parking_spot UNIQUE,
    gender            CHAR(1),
    department_id     numeric(2)   
		CONSTRAINT fk_emp_department_id REFERENCES departments(department_id),
    manager_id         CHAR(9)
    	CONSTRAINT fk_emp_manager_id REFERENCES employees(employee_id) 
);  

CREATE TABLE projects (
    project_id         numeric(2)           CONSTRAINT pk_projects PRIMARY KEY,
    project_name       varchar(40)        CONSTRAINT nn_project_name NOT NULL,
    location           varchar(25),
    department_id      numeric(2)           CONSTRAINT fk_proj_department_id REFERENCES departments(department_id)
);

CREATE TABLE locations (
    department_id          numeric (2)          CONSTRAINT fk_loc_dep REFERENCES departments(department_id), 
    location          varchar(20),				
    CONSTRAINT pk_locations  PRIMARY KEY (department_id, location)
); 

CREATE TABLE tasks (
    employee_id         CHAR(9)         CONSTRAINT fk_tasks_emp REFERENCES   employees(employee_id),                
    project_id         numeric(2)       CONSTRAINT fk_tasks_proj REFERENCES   projects(project_id), 
    hours            numeric(5,1),    CONSTRAINT pk_tasks PRIMARY KEY (employee_id, project_id)
);

CREATE TABLE family_members (
                                employee_id         CHAR(9)
                                    CONSTRAINT fk_fam_emp REFERENCES employees(employee_id),
                                name            varchar(50),
                                gender        CHAR(1)
                                    CONSTRAINT c_gender CHECK (gender IN('M', 'F', 'X'))
                                    CONSTRAINT nn_gender NOT NULL,
                                birth_date       DATE
                                    CONSTRAINT nn_birth_date NOT NULL
                                    CONSTRAINT c_birth_date
                                        CHECK (birth_date
                                            BETWEEN to_date ('20-03-1950', 'DD-MM-YYYY')
                                            AND to_date ('01-01-2022', 'DD-MM-YYYY')),
                                relationship       varchar(15)
                                    CONSTRAINT nn_relationship NOT NULL,
                                CONSTRAINT pk_family_members PRIMARY KEY (employee_id, name)
);


------------------------------------------------
------   INSERT THE DATA INTO TABLES  ----------
------------------------------------------------

DELETE FROM tasks WHERE 1 = 1;
DELETE FROM projects WHERE 1 = 1;
DELETE FROM locations WHERE 1 = 1;
DELETE FROM family_members WHERE 1 = 1;
DELETE FROM employees WHERE 1 = 1;
DELETE FROM departments WHERE 1 = 1;

-- Rijen van de tabel departments.  Het SOFI-nummer van de afdelingsmanager
-- en de datum van indiensttreding zijn null.

INSERT INTO departments(department_id,department_name,manager_id,mgr_start_date)
VALUES (7, 'Production', NULL, NULL );
INSERT INTO departments(department_id,department_name,manager_id,mgr_start_date)
VALUES (3, 'Administration', NULL, NULL);
INSERT INTO departments(department_id,department_name,manager_id,mgr_start_date)
VALUES (1, 'Headquarters', NULL, NULL );

INSERT INTO departments (department_id, department_name, manager_id, mgr_start_date)
VALUES
    (8, 'Marketing', '123456789',              to_date('2010-05-25', 'YYYY-MM-DD')),
    (9, 'Sales', '234567890',                  to_date('2009-12-12', 'YYYY-MM-DD')),
    (10, 'Finance', '345678901',               to_date('2012-03-18', 'YYYY-MM-DD')),
    (11, 'Research', '456789012',              to_date('2011-08-23', 'YYYY-MM-DD')),
    (12, 'Development', '567890123',           to_date('2013-11-30', 'YYYY-MM-DD')),
    (13, 'Customer Service', '678901234',      to_date('2008-02-14', 'YYYY-MM-DD')),
    (14, 'Information Technology', '789012345',to_date('2014-05-07', 'YYYY-MM-DD')),
    (15, 'Human Resources', '890123456',       to_date('2015-02-22', 'YYYY-MM-DD')),
    (16, 'Logistics', '901234567',             to_date('2017-06-10', 'YYYY-MM-DD')),
    (17, 'Procurement', '012345678',           to_date('2016-01-04', 'YYYY-MM-DD')),
    (18, 'Quality Control', '123456789',       to_date('2010-10-08', 'YYYY-MM-DD')),
    (19, 'Legal', NULL,                 to_date('2009-06-15', 'YYYY-MM-DD')),
    (20, 'Engineering', '345678901',           to_date('2012-09-18', 'YYYY-MM-DD')),
    (21, 'Facilities', '456789012',            to_date('2011-05-23', 'YYYY-MM-DD')),
    (22, 'Security', '567890123',              to_date('2013-08-30', 'YYYY-MM-DD')),
    (23, 'Public Relations', '678901234',       to_date('2008-11-14', 'YYYY-MM-DD')),
    (24, 'Media', '789012345',                 to_date('2014-04-07', 'YYYY-MM-DD')),
    (25, 'Advertising', '890123456',           to_date('2015-01-22', 'YYYY-MM-DD')),
    (26, 'Design', '901234567',                to_date('2017-05-10', 'YYYY-MM-DD')),
    (27, 'Production Planning', '012345678',   to_date('2016-01-02', 'YYYY-MM-DD'));

--SELECT DISTINCT manager_id from departments order by 1;


-- Rijen van de tabel employees.
INSERT INTO employees ( employee_id,last_name,first_name,infix,street,location,province,postal_code,birth_date,salary,parking_spot,gender,department_id,manager_id)
VALUES ( '999666666', 'Bordoloi', 'Bijoy', NULL,
         'Zuidelijke Rondweg 12', 'Eindhoven', 'NB', '6202 EK',
         TO_DATE ('10-11-1977', 'DD-MM-YYYY'), 55000, 1, 'M', 1, NULL );
INSERT INTO employees (employee_id,last_name,first_name,infix,street,location,province,postal_code,birth_date,salary,parking_spot,gender,department_id,manager_id)
VALUES ( '999555555', 'Jochems', 'Suzan',
         NULL, 'Nuthseweg 17', 'maastricht', 'LI', '9394 LR',
         TO_DATE('20-06-1981', 'DD-MM-YYYY'), 43000, 3, 'F',
         3, '999666666' );
INSERT INTO employees (employee_id,last_name,first_name,infix,street,location,province,postal_code,birth_date,salary,parking_spot,gender,department_id,manager_id)
VALUES ( '999444444', 'Zuiderweg', 'Willem',
         NULL, 'Lindberghdreef 303', 'Oegstgeest', 'ZH', '2340 RV',
         TO_DATE('12-08-1985', 'DD-MM-YYYY'), 43000, 32, 'M',
         7, '999666666' );
INSERT INTO employees (employee_id,last_name,first_name,infix,street,location,province,postal_code,birth_date,salary,parking_spot,gender,department_id,manager_id)
VALUES ( '999887777', 'Muiden', 'Martina',
         'van der', 'Hoofdstraat 14', 'Maarssen', 'UT', '9394 LM',
         TO_DATE('19-07-1988', 'DD-MM-YYYY'), 25000, 402, 'F',
         3, '999555555' );
INSERT INTO employees (employee_id,last_name,first_name,infix,street,location,province,postal_code,birth_date,salary,parking_spot,gender,department_id,manager_id)
VALUES( '999222222', 'Amelsvoort', 'Henk',
        'van', 'Zeestraat 14', 'Maastricht', 'LI', '9394 MK',
        TO_DATE('29-03-1979', 'DD-MM-YYYY'), 25000, 422, 'M',
        3, '999555555' );
INSERT INTO employees (employee_id,last_name,first_name,infix,street,location,province,postal_code,birth_date,salary,parking_spot,gender,department_id,manager_id)
VALUES ( '999111111', 'Bock', 'Douglas',
         NULL, 'Monteverdidreef 2', 'Oegstgeest', 'ZH', '6312 CB',
         TO_DATE('01-09-1965', 'DD-MM-YYYY'), 30000, 542, 'M',
         7, '999444444' );
INSERT INTO employees (employee_id,last_name,first_name,infix,street,location,province,postal_code,birth_date,salary,parking_spot,gender,department_id,manager_id)
VALUES ( '999333333', 'Joosten', 'Dennis',
         NULL, 'Eikenstraat 10', 'Groningen', 'GR', '6623 HK',
         TO_DATE('15-09-1982', 'DD-MM-YYYY'), 38000, 332, 'M',
         7, '999444444' );
INSERT INTO employees (employee_id,last_name,first_name,infix,street,location,province,postal_code,birth_date,salary,parking_spot,gender,department_id,manager_id)
VALUES ( '999888888', 'Pregers', 'Shanya',
         NULL, 'Overtoomweg 44', 'Eindhoven', 'NB', '6202 MR',
         TO_DATE('31-07-1982', 'DD-MM-YYYY'), 25000, 296, 'F',
         7, '999444444' );

INSERT INTO employees(
    employee_id,last_name,first_name,infix,street,location,
    province,postal_code,birth_date,salary,parking_spot,
    gender,department_id,manager_id)
VALUES
    ('123456789', 'Wong', 'Emely', NULL, 'Main St 456', 'New York', 'NY', '10001', to_date('1980-06-15', 'YYYY-MM-DD'), 65000.00, 543, 'M', 8, 345678901),
    ('234567890', 'Johnson', 'Mary', 'A', '2nd Ave 456', 'New York', 'NY', '10002', to_date('1982-03-20', 'YYYY-MM-DD'), 45000.00, 544, 'F', 9, 345678901),
    ('345678901', 'Garcia', 'David', NULL, '3rd St 789', 'Los Angeles', 'CA', '90001', to_date('1985-09-10', 'YYYY-MM-DD'), 75000.00, 545, 'M', NULL, NULL),
    ('456789045', 'Brown', 'Emma', '', 'Water St', 'Calgary', 'AB', 'T2T 2T2', to_date('1991-05-17', 'YYYY-MM-DD'), 80000.00, 556, 'F', 11, '345678901'),
    ('456789012', 'Davis', 'Jennifer', NULL, '4th Ave 345', 'Los Angeles', 'CA', '90002', to_date('1975-12-05', 'YYYY-MM-DD'), 60000.00, 546, 'F', 11, 345678901),
    ('567890123', 'Rodriguez', 'Michael', NULL, '5th St 678', 'Chicago', 'IL', '60001', to_date('1978-02-25', 'YYYY-MM-DD'), 80000.00, 547, 'M', 12, 345678901),
    ('678901234', 'Wilson', 'Sarah', NULL, '6th Ave 901', 'Chicago', 'IL', '60002', to_date('1989-11-18', 'YYYY-MM-DD'), 55000.00, 548, 'F', 13, 456789045),
    ('789012345', 'Martinez', 'Christopher', NULL, '7th St 234', 'Houston', 'TX', '77001', to_date('1983-07-08', 'YYYY-MM-DD'), 70000.00, 549, 'M', 14, 456789045),
    ('890123456', 'Anderson', 'Jessica', NULL, '8th Ave 567', 'Houston', 'TX', '77002', to_date('1981-01-30', 'YYYY-MM-DD'), NULL, NULL, 'F', 15, NULL),
    ('901234567', 'Thomas', 'James', 'B', '9th St 890', 'Philadelphia', 'PA', '19101', to_date('1987-04-12', 'YYYY-MM-DD'), 65000.00, 551, 'M', 16, 123456789),
    ('012345678', 'Jackson', 'Ashley', 'D', '10th Ave 123', 'Philadelphia', 'PA', '19102', to_date('1984-08-05', 'YYYY-MM-DD'), 75000.00, 552, 'F', 17, 123456789),
    ('123456790', 'Smith', 'John', '', 'Main St', 'Toronto', 'ON', 'M1M 1M1', NULL, 50000.00, 553, 'M', 8, 567890123),
    ('234567891', 'Jones', 'Emily', 'van der', 'King St', 'Vancouver', 'BC', 'V2V 2V2', to_date('1992-07-23', 'YYYY-MM-DD'), 65000.00, 554, 'F', 9, '123456789'),
    ('345678902', 'Lee', 'Michael', '', 'Queen St', 'Montreal', 'QC', 'H3H 3H3', to_date('1993-11-04', 'YYYY-MM-DD'), 70000.00, 555, 'X', 10, '234567890'),
    ('567890124', 'Wilson', 'James', '', 'Park Ave', 'Halifax', 'NS', 'B3B 3B3', to_date('1994-08-11', 'YYYY-MM-DD'), 55000.00, 557, 'M', 12, '456789012'),
    ('678901235', 'Garcia', 'Isabella', '', 'Broadway', 'Toronto', 'ON', 'M2M 2M2', to_date('1990-01-05', 'YYYY-MM-DD'), 60000.00, 558, 'F', 13, '567890123'),
    ('789012346', 'Smith', 'Noah', '', 'Granville St', 'Vancouver', 'BC', NULL, to_date('1993-03-29', 'YYYY-MM-DD'), 75000.00, 559, 'M', 14, '678901234'),
    ('890123457', 'Johnson', 'Olivia', '', 'St Catherine St', 'Montreal', NULL, 'H4H 4H4', to_date('1992-06-30', 'YYYY-MM-DD'), 65000.00, 560, 'F', 15, '789012345'),
    ('901234568', 'Martinez', 'Daniel', '', '10th Ave SW', NULL, 'AB', 'T3T 3T3', to_date('1991-12-19', 'YYYY-MM-DD'), 85000.00, 561, 'M', 16, '234567890'),
    ('012345679', 'Taylor', 'Sophia', '', NULL, 'Halifax', 'NS', 'B4B 4B4', to_date('1994-09-21', 'YYYY-MM-DD'), 50000.00, 562, 'F', 17, '678901234');


SELECT employee_id, last_name, first_name, manager_id from employees order by manager_id, employee_id;

INSERT INTO employees(employee_id, last_name, first_name, infix, street, location, province, postal_code, birth_date, salary, parking_spot, gender, department_id, manager_id)
VALUES ('100001001', 'Smith', 'John', NULL, 'Main St. 123', 'New York', 'NY', '10001', to_date('1990-01-01', 'YYYY-MM-DD'), 50000.00, 563, 'M', 8, '123456789');

INSERT INTO employees(employee_id, last_name, first_name, infix, street, location, province, postal_code, birth_date, salary, parking_spot, gender, department_id, manager_id)
VALUES ('100001002', 'Johnson', 'Jessica', NULL, 'Broadway 456', 'New York', 'NY', '10001', to_date('1991-02-15', 'YYYY-MM-DD'), 60000.00, 564, 'F', 8, '123456789');

INSERT INTO employees(employee_id, last_name, first_name, infix, street, location, province, postal_code, birth_date, salary, parking_spot, gender, department_id, manager_id)
VALUES ('100001003', 'Lee', 'David', NULL, 'Oak St. 789', 'Los Angeles', 'CA', '90001', to_date('1988-05-07', 'YYYY-MM-DD'), 55000.00, 565, 'M', 9, '234567890');

INSERT INTO employees(employee_id, last_name, first_name, infix, street, location, province, postal_code, birth_date, salary, parking_spot, gender, department_id, manager_id)
VALUES ('100001004', 'Garcia', 'Maria', NULL, '1st St. 456', 'Los Angeles', 'CA', '90001', to_date('1993-11-28', 'YYYY-MM-DD'), 65000.00, 566, 'F', 9, '234567890');

INSERT INTO employees(employee_id, last_name, first_name, infix, street, location, province, postal_code, birth_date, salary, parking_spot, gender, department_id, manager_id)
VALUES ('100001005', 'Kim', 'Andrew', NULL, '3rd St. 789', 'San Francisco', 'CA', '94101', to_date('1989-07-15', 'YYYY-MM-DD'), 55000.00, 567, 'M', 10, '456789012');

INSERT INTO employees(employee_id, last_name, first_name, infix, street, location, province, postal_code, birth_date, salary, parking_spot, gender, department_id, manager_id)
VALUES ('100001006', 'Nguyen', 'Van', NULL, '4th St. 123', 'San Francisco', 'CA', '94101', to_date('1990-12-31', 'YYYY-MM-DD'), 60000.00, 568, 'M', 10, '456789012');

-- SELECT CONCAT('INSERT INTO locations (department_id,location) VALUES (',
--               d.department_id,
--               ',''',
--               e.location,
--               ''' );')
-- from employees e
--          JOIN departments d ON (e.employee_id = d.manager_id);


-- Rijen van de tabel locations.
INSERT INTO locations (department_id,location) VALUES (1, 'Eindhoven');
INSERT INTO locations (department_id,location) VALUES (3, 'Maastricht');
INSERT INTO locations (department_id,location) VALUES (7, 'Oegstgeest');
INSERT INTO locations (department_id,location) VALUES (7, 'Groningen');
INSERT INTO locations (department_id,location) VALUES (7, 'Eindhoven');

INSERT INTO locations (department_id,location) VALUES (8,'New York' );
INSERT INTO locations (department_id,location) VALUES (9,'New York' );
INSERT INTO locations (department_id,location) VALUES (10,'Los Angeles' );
INSERT INTO locations (department_id,location) VALUES (11,'Los Angeles' );
INSERT INTO locations (department_id,location) VALUES (12,'Chicago' );
INSERT INTO locations (department_id,location) VALUES (13,'Chicago' );
INSERT INTO locations (department_id,location) VALUES (14,'Houston' );
INSERT INTO locations (department_id,location) VALUES (15,'Houston' );
INSERT INTO locations (department_id,location) VALUES (16,'Philadelphia' );
INSERT INTO locations (department_id,location) VALUES (17,'Philadelphia' );
INSERT INTO locations (department_id,location) VALUES (18,'New York' );
INSERT INTO locations (department_id,location) VALUES (19,'New York' );
INSERT INTO locations (department_id,location) VALUES (20,'Los Angeles' );
INSERT INTO locations (department_id,location) VALUES (21,'Los Angeles' );
INSERT INTO locations (department_id,location) VALUES (22,'Chicago' );
INSERT INTO locations (department_id,location) VALUES (23,'Chicago' );
INSERT INTO locations (department_id,location) VALUES (24,'Houston' );
INSERT INTO locations (department_id,location) VALUES (25,'Houston' );
INSERT INTO locations (department_id,location) VALUES (26,'Philadelphia' );

--SELECT * from departments;



-- Rijen van de tabel projects.
INSERT INTO projects (project_id,project_name,location,department_id)
VALUES (1, 'Ordermanagement', 'Oegstgeest', 7);
INSERT INTO projects (project_id,project_name,location,department_id)
VALUES (2, 'Salaryadministration', 'Groningen', 7);
INSERT INTO projects (project_id,project_name,location,department_id)
VALUES (3, 'Warehouse', 'Eindhoven', 7);
INSERT INTO projects (project_id,project_name,location,department_id)
VALUES (10, 'Inventory', 'Maastricht', 3);
INSERT INTO projects (project_id,project_name,location,department_id)
VALUES (20, 'HumanResources', 'Eindhoven', 1);
INSERT INTO projects (project_id,project_name,location,department_id)
VALUES (30, 'Debtors', 'Maastricht', 3);

INSERT INTO projects(project_id, project_name, location, department_id)
VALUES (40, 'Production Optimization', 'New York', 8),
       (41, 'Social Media Campaign', 'San Francisco', 9),
       (42, 'Tax Management', 'Chicago', 10),
       (43, 'Product Development', 'Los Angeles', 11),
       (44, 'R&D of New Technology', NULL, 12),
       (45, 'Customer Retention', 'Miami', 13),
       (46, 'Database Migration', 'Seattle', 14),
       (47, 'Recruiting and Hiring', 'Austin', 15),
       (48, 'Inventory Management', 'Houston', 16),
       (49, 'Procurement Process Improvement', 'Boston', 17),
       (50, 'Quality Control Audit', 'Philadelphia', NULL),
       (51, 'Intellectual Property Law', 'Denver', 19),
       (52, 'Engineering Design', 'Phoenix', 20),
       (53, 'Office Renovation', 'Las Vegas', 21),
       (54, 'Security Audit', 'Portland', 22),
       (55, 'Public Relations Campaign', 'San Antonio', 23),
       (56, 'Ad Campaign', 'Nashville', 24),
       (57, 'Website Redesign', 'Columbus', 25),
       (58, 'Packaging Design', 'Detroit', 26),
       (59, 'Process Improvement', 'Memphis', 27);


--SELECT * from projects;

-- Rijen van de tabel tasks.
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999111111', 1, 31.4);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999111111', 2, 8.5);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999333333', 3, 42.1);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999888888', 1, 21.0);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999888888', 2, 22.0);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999444444', 2, 12.2);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999444444', 3, 10.5);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999444444', 1, NULL);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999444444', 10, 10.1);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999444444', 20, 11.8);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999887777', 30, 30.8);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999887777', 10, 10.2);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999222222', 10, 34.5);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999222222', 30, 5.1);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999555555', 30, 19.2);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999555555', 20, 14.8);
INSERT INTO tasks (employee_id,project_id,hours)
VALUES ( '999666666', 20, NULL);


-- Employee 123456789
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('123456789', 40, 45.2);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('123456789', 45, 87.1);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('123456789', 58, 12.6);

-- Employee 234567890
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('234567890', 42, 68.5);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('234567890', 51, 90.0);

-- Employee 345678901
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('345678901', 46, 23.8);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('345678901', 53, 50.1);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('345678901', 57, 17.2);

-- Employee 456789012
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('456789012', 40, 75.3);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('456789012', 47, 98.6);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('456789012', 50, 32.0);

-- Employee 567890123
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('567890123', 43, 54.7);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('567890123', 48, 41.8);

-- Employee 678901234
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('678901234', 49, 79.2);

-- Employee 789012345
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('789012345', 44, 67.1);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('789012345', 52, 99.9);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('789012345', 58, 7.9);

-- Employee 890123456
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('890123456', 41, 24.3);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('890123456', 46, 12.1);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('890123456', 53, 61.5);

-- Employee 901234567
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('901234567', 42, 36.7);
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('901234567', 47, 87.3);

-- Employee 012345678
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('012345678', 45, 93.5);

-- Employee 123456790
INSERT INTO tasks (employee_id, project_id, hours) VALUES ('123456790', 50, 12.4);

INSERT INTO tasks (employee_id, project_id, hours)
VALUES ('234567891', 40, 32.5),
       ('234567891', 43, 78.2),
       ('345678902', 44, 12.1),
       ('345678902', 45, 97.4),
       ('345678902', 46, 51.3),
       ('456789045', 47, 63.7),
       ('567890124', 50, 44.2),
       ('567890124', 51, 84.5),
       ('678901235', 53, 17.8),
       ('789012346', 54, 39.1),
       ('789012346', 55, 65.8),
       ('890123457', 56, 27.3),
       ('890123457', 57, 94.9),
       ('012345679', 58, 23.4),
       ('100001001', 41, 96.2),
       ('100001002', 42, 52.6),
       ('100001002', 44, 11.8),
       ('100001004', 46, 88.7),
       ('100001005', 49, 45.2),
       ('100001006', 52, 71.4);


-- SELECT * from tasks;


-- SELECT employee_id, date_part('year', age(birth_date)) as age, birth_date, gender from employees;

--Given following employee_id's and their corresponding age and birthdate
-- employee_id, age, birthdate, gender
-- 999666666,45,1977-11-10,M
-- 999555555,41,1981-06-20,F
-- 999444444,37,1985-08-12,M
-- 999887777,34,1988-07-19,F
-- 999222222,43,1979-03-29,M
-- 999111111,57,1965-09-01,M
-- 999333333,40,1982-09-15,M
-- 999888888,40,1982-07-31,F

-- -- rijen van de tabel family_members
-- INSERT INTO family_members (employee_id,name,gender,birth_date,relationship)
-- VALUES ( '999444444', 'Josefine', 'F',
--          TO_DATE ('04-05-2006', 'DD-MM-YYYY'), 'DAUGHTER');
-- INSERT INTO family_members (employee_id,name,gender,birth_date,relationship)
-- VALUES ( '999444444', 'Andrew', 'M',
--          TO_DATE('25-10-2008', 'DD-MM-YYYY'), 'SON');
-- INSERT INTO family_members (employee_id,name,gender,birth_date,relationship)
-- VALUES ( '999444444', 'Suzan', 'F',
--          TO_DATE('05-03-1985', 'DD-MM-YYYY'), 'PARTNER');
-- INSERT INTO family_members (employee_id,name,gender,birth_date,relationship)
-- VALUES ( '999555555', 'Alex', 'M',
--          TO_DATE('28-02-1978', 'DD-MM-YYYY'), 'PARTNER');
-- INSERT INTO family_members (employee_id,name,gender,birth_date,relationship)
-- VALUES ( '999111111', 'Jos', 'M',
--          TO_DATE('01-01-1988', 'DD-MM-YYYY'), 'SON');
-- INSERT INTO family_members (employee_id,name,gender,birth_date,relationship)
-- VALUES ( '999111111', 'Diana', 'F',
--          TO_DATE ('31-12-1988', 'DD-MM-YYYY'), 'DAUGHTER');
-- INSERT INTO family_members (employee_id,name,gender,birth_date,relationship)
-- VALUES ( '999111111', 'Mary', 'F',
--          TO_DATE('05-05-1967', 'DD-MM-YYYY'), 'PARTNER');

--SELECT * from employees;
INSERT INTO family_members (employee_id, name, gender, birth_date, relationship)
VALUES
    ('999666666', 'John Bordoloi', 'M', to_date('1998-04-20', 'YYYY-MM-DD'), 'SON'),
    ('999666666', 'Jane Bordoloi', 'F', to_date('2001-01-12', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('999666666', 'Mary Smith', 'F', to_date('1978-05-05', 'YYYY-MM-DD'), 'PARTNER'),
    ('999666666', 'Sarah Bordoloi', 'F', to_date('1952-08-08', 'YYYY-MM-DD'), 'MOTHER'),
    ('999555555', 'David Lee', 'M', to_date('2010-02-28', 'YYYY-MM-DD'), 'SON'),
    ('999555555', 'Emma Lee', 'F', to_date('2014-09-01', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('999555555', 'Amanda Lee', 'F', to_date('1985-11-22', 'YYYY-MM-DD'), 'PARTNER'),
    ('999555555', 'Mary Lee', 'F', to_date('1958-04-01', 'YYYY-MM-DD'), 'MOTHER'),
    ('999444444', 'William Zuiderweg', 'M', to_date('2013-06-10', 'YYYY-MM-DD'), 'SON'),
    ('999444444', 'Lily Zuiderweg', 'F', to_date('2018-01-05', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('999444444', 'Jennifer Davis', 'F', to_date('1990-08-20', 'YYYY-MM-DD'), 'PARTNER'),
    ('999444444', 'Julia Zuiderweg', 'F', to_date('1959-11-11', 'YYYY-MM-DD'), 'MOTHER'),
    ('999887777', 'Andrew Williams', 'M', to_date('2013-02-13', 'YYYY-MM-DD'), 'SON'),
    ('999887777', 'Olivia Williams', 'F', to_date('2015-07-19', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('999887777', 'Sarah Williams', 'F', to_date('1989-11-03', 'YYYY-MM-DD'), 'PARTNER'),
    ('999887777', 'Julia Muiden', 'F', to_date('1960-03-04', 'YYYY-MM-DD'), 'MOTHER'),
    ('999222222', 'Jacob Amelsvoort', 'M', to_date('2012-09-20', 'YYYY-MM-DD'), 'SON'),
    ('999222222', 'Sophia Amelsvoort', 'F', to_date('2014-04-12', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('999222222', 'Laura Brown', 'F', to_date('1981-02-17', 'YYYY-MM-DD'), 'PARTNER'),
    ('999222222', 'Emily Amelsvoort', 'F', to_date('1952-07-22', 'YYYY-MM-DD'), 'MOTHER'),
    ('999111111', 'Michael Bock', 'M', to_date('1995-03-20', 'YYYY-MM-DD'), 'SON'),
    ('999111111', 'Elizabeth Bock', 'F', to_date('1996-05-25', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('999111111', 'Karen Johnson', 'F', to_date('1955-12-06', 'YYYY-MM-DD'), 'PARTNER');

INSERT INTO family_members (employee_id, name, gender, birth_date, relationship)
VALUES ('999111111', 'Tomas Bock', 'M', to_date('2020-05-20', 'YYYY-MM-DD'), 'GRANDCHILD');

-- 123456789,42,1980-06-15
-- 234567890,40,1982-03-20
-- 345678901,37,1985-09-10
-- 456789012,47,1975-12-05

INSERT INTO family_members (employee_id, name, gender, birth_date, relationship)
VALUES
    ('123456789', 'John Smith', 'M', to_date('1990-05-15', 'YYYY-MM-DD'), 'SON'),
    ('123456789', 'Jane Smith', 'F', to_date('1993-07-01', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('123456789', 'Mary Smith', 'F', to_date('1955-01-01', 'YYYY-MM-DD'), 'MOTHER'),
    ('123456789', 'David Jansen', 'M', to_date('1970-11-10', 'YYYY-MM-DD'), 'PARTNER'),
    ('234567890', 'Mike Johnson', 'M', to_date('2010-01-01', 'YYYY-MM-DD'), 'SON'),
    ('234567890', 'Emily Johnson', 'F', to_date('2015-02-14', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('345678901', 'Adam Garcia', 'M', to_date('2012-12-31', 'YYYY-MM-DD'), 'SON'),
    ('345678901', 'Samantha Garcia', 'F', to_date('2014-03-01', 'YYYY-MM-DD'), 'DAUGHTER'),
    ('456789012', 'Lisa Brown', 'F', to_date('1978-06-01', 'YYYY-MM-DD'), 'PARTNER'),
    ('456789012', 'Lucas Brown', 'X', to_date('2008-04-01', 'YYYY-MM-DD'), 'SON'),
    ('456789012', 'Ethan Brown', 'M', to_date('2011-05-01', 'YYYY-MM-DD'), 'SON');


-- 567890123,44,1978-02-25
-- 678901234,33,1989-11-18
-- 789012345,39,1983-07-08
-- 890123456,42,1981-01-30

INSERT INTO family_members (employee_id, name, gender, birth_date, relationship)
VALUES
    ('567890123', 'John Rodriguez', 'M', to_date('15-06-2005', 'DD-MM-YYYY'), 'SON'),
    ('567890123', 'Samantha Rodriguez', 'F', to_date('22-09-2012', 'DD-MM-YYYY'), 'DAUGHTER'),
    ('567890123', 'Jane Smith', 'F', to_date('02-05-1981', 'DD-MM-YYYY'), 'PARTNER'),
    ('567890123', 'Mary Rodriguez', 'F', to_date('12-10-1950', 'DD-MM-YYYY'), 'MOTHER'),
    ('678901234', 'Matthew Davis', 'M', to_date('04-03-2018', 'DD-MM-YYYY'), 'SON'),
    ('678901234', 'Robert Davis', 'M', to_date('16-07-2019', 'DD-MM-YYYY'), 'SON'),
    ('789012345', 'Emily Martinez', 'F', to_date('08-07-2010', 'DD-MM-YYYY'), 'DAUGHTER'),
    ('789012345', 'Sarah Brown', 'M', to_date('25-05-1983', 'DD-MM-YYYY'), 'PARTNER'),
    ('890123456', 'Amy Wilson', 'F', to_date('22-02-2010', 'DD-MM-YYYY'), 'DAUGHTER'),
    ('890123456', 'Sophia Wilson', 'F', to_date('07-08-2014', 'DD-MM-YYYY'), 'DAUGHTER'),
    ('890123456', 'David Wilson', 'M', to_date('12-11-1950', 'DD-MM-YYYY'), 'GRANDCHILD'),
    ('890123456', 'Elizabeth Wilson', 'F', to_date('01-06-1954', 'DD-MM-YYYY'), 'MOTHER_IN_LAW'),
    ('890123456', 'Melissa Wilson', 'F', to_date('28-02-1995', 'DD-MM-YYYY'), 'PARTNER')
;


-- 901234567,35,1987-04-12
-- 012345678,38,1984-08-05
-- 123456790,32,1990-03-15
-- 234567891,30,1992-07-23
-- 345678902,29,1993-11-04


INSERT INTO family_members (employee_id, name, gender, birth_date, relationship) VALUES
     ('901234567', 'Samantha Smith', 'F', to_date('11-12-1990', 'DD-MM-YYYY'), 'DAUGHTER'),
     ('901234567', 'Tom Smith', 'M', to_date('03-08-2010', 'DD-MM-YYYY'), 'GRANDCHILD'),
     ('901234567', 'Sophie Smith', 'F', to_date('09-06-2015', 'DD-MM-YYYY'), 'GRANDCHILD'),
     ('901234567', 'John Smith', 'M', to_date('20-01-1960', 'DD-MM-YYYY'), 'PARTNER'),
     ('012345678', 'Emily Johnson', 'F', to_date('08-03-1991', 'DD-MM-YYYY'), 'DAUGHTER'),
     ('012345678', 'Daniel Brown', 'M', to_date('18-11-2018', 'DD-MM-YYYY'), 'GRANDCHILD'),
     ('012345678', 'Lucas Brown', 'M', to_date('14-05-2020', 'DD-MM-YYYY'), 'GRANDCHILD'),
     ('012345678', 'Bob Johnson', 'F', to_date('11-06-1993', 'DD-MM-YYYY'), 'PARTNER'),
     ('123456790', 'Joshua Smith', 'M', to_date('05-09-2017', 'DD-MM-YYYY'), 'SON'),
     ('123456790', 'Sarah Smith', 'F', to_date('12-08-2021', 'DD-MM-YYYY'), 'DAUGHTER'),
     ('123456790', 'Mary Smith', 'F', to_date('25-09-1960', 'DD-MM-YYYY'), 'MOTHER'),
     ('234567891', 'Ethan Lee', 'M', to_date('23-06-2019', 'DD-MM-YYYY'), 'SON'),
     ('234567891', 'Brian Jones', 'M', to_date('05-09-1960', 'DD-MM-YYYY'), 'FATHER'),
     ('345678902', 'Oliver Lee', 'M', to_date('18-07-2019', 'DD-MM-YYYY'), 'SON'),
     ('345678902', 'Alice Jackson', 'F', to_date('05-04-1995', 'DD-MM-YYYY'), 'PARTNER');



-- 456789045,31,1991-05-17
-- 567890124,28,1994-08-11
-- 678901235,33,1990-01-05
-- 789012346,29,1993-03-29
-- 890123457,30,1992-06-30

INSERT INTO family_members VALUES
       ('456789045', 'Anna Jones', 'F', to_date('1992-01-10', 'YYYY-MM-DD'), 'DAUGHTER'),
       ('456789045', 'John Jones', 'M', to_date('1994-07-21', 'YYYY-MM-DD'), 'SON'),
       ('456789045', 'Sarah Jones', 'F', to_date('1988-04-05', 'YYYY-MM-DD'), 'PARTNER'),
       ('567890124', 'Michael Wilson', 'M', to_date('1998-11-15', 'YYYY-MM-DD'), 'SON'),
       ('567890124', 'Lily Lee', 'F', to_date('1996-05-07', 'YYYY-MM-DD'), 'PARTNER'),
       ('678901235', 'Emma Garcia', 'M', to_date('1965-12-23', 'YYYY-MM-DD'), 'MOTHER'),
       ('789012346', 'Emily Wilson', 'F', to_date('2017-09-02', 'YYYY-MM-DD'), 'DAUGHTER'),
       ('789012346', 'Samantha Wilson', 'F', to_date('2019-03-28', 'YYYY-MM-DD'), 'DAUGHTER'),
       ('789012346', 'John Wilson', 'M', to_date('1994-01-16', 'YYYY-MM-DD'), 'PARTNER'),
       ('890123457', 'Avery Johnson', 'F', to_date('2018-06-14', 'YYYY-MM-DD'), 'DAUGHTER'),
       ('890123457', 'Sofie Johnson', 'F', to_date('2021-02-07', 'YYYY-MM-DD'), 'DAUGHTER'),
       ('890123457', 'Brian Johnson', 'M', to_date('1990-09-18', 'YYYY-MM-DD'), 'PARTNER');



-- 901234568,31,1991-12-19,M
-- 012345679,28,1994-09-21,F
-- 100001001,33,1990-01-01,M
-- 100001002,31,1991-02-15,F

INSERT INTO family_members (employee_id, name, gender, birth_date, relationship)
VALUES
-- Employee 901234568
('901234568', 'Mary Smith', 'F', to_date('1994-03-05', 'YYYY-MM-DD'), 'PARTNER'),
('901234568', 'John Martinez Jr.', 'M', to_date('2016-07-12', 'YYYY-MM-DD'), 'SON'),
('901234568', 'Sarah Martinez', 'F', to_date('2020-01-22', 'YYYY-MM-DD'), 'DAUGHTER'),
-- Employee 012345679
('012345679', 'Mark Johnson', 'M', to_date('1991-10-15', 'YYYY-MM-DD'), 'PARTNER'),
('012345679', 'Ann Johnson', 'F', to_date('2018-06-03', 'YYYY-MM-DD'), 'DAUGHTER'),
-- Employee 100001001
('100001001', 'Amy Brown', 'F', to_date('1992-04-20', 'YYYY-MM-DD'), 'PARTNER'),
('100001001', 'Tom Brown', 'M', to_date('2018-12-11', 'YYYY-MM-DD'), 'SON'),
-- Employee 100001002
('100001002', 'Emma Smith', 'F', to_date('2019-01-05', 'YYYY-MM-DD'), 'DAUGHTER'),
('100001002', 'Julia Smith', 'F', to_date('1992-09-28', 'YYYY-MM-DD'), 'PARTNER')
;


-- 100001003,34,1988-05-07,M
-- 100001004,29,1993-11-28,F
-- 100001005,33,1989-07-15,M
-- 100001006,32,1990-12-31,M

INSERT INTO family_members (employee_id, name, gender, birth_date, relationship)
VALUES
    ('100001003', 'Bob Segers', 'F', to_date('01-01-1990', 'DD-MM-YYYY'), 'PARTNER'),
    ('100001003', 'Benjamin Segers', 'M', to_date('01-01-2015', 'DD-MM-YYYY'), 'SON'),
    ('100001003', 'Sophia Segers', 'F', to_date('01-01-2018', 'DD-MM-YYYY'), 'DAUGHTER'),
    ('100001004', 'Oliver Garcia', 'M', to_date('01-01-2016', 'DD-MM-YYYY'), 'SON'),
    ('100001005', 'Ava Kim', 'F', to_date('01-01-2010', 'DD-MM-YYYY'), 'DAUGHTER'),
    ('100001005', 'William Kim', 'M', to_date('01-01-2013', 'DD-MM-YYYY'), 'SON'),
    ('100001005', 'Jacob Kim', 'M', to_date('01-01-2021', 'DD-MM-YYYY'), 'SON'),
    ('100001005', 'Emma Kim', 'F', to_date('01-01-2022', 'DD-MM-YYYY'), 'DAUGHTER'),
    ('100001006', 'Lucas Nguyen', 'M', to_date('01-01-2015', 'DD-MM-YYYY'), 'SON'),
    ('100001006', 'Ella Nguyen', 'F', to_date('01-01-2018', 'DD-MM-YYYY'), 'DAUGHTER'),
    ('100001006', 'Noah Nguyen', 'M', to_date('01-01-2021', 'DD-MM-YYYY'), 'SON');





-- Werk de rijen van de tabel departments bij met het SOFI-nummer
-- van de manager en diens datum indiensttreding.
UPDATE departments SET manager_id = '999444444',
                       mgr_start_date = TO_DATE ('22-05-2008', 'DD-MM-YYYY')
WHERE department_id = '7';
UPDATE departments SET manager_id = '999555555',
                       mgr_start_date = TO_DATE ('01-01-2011', 'DD-MM-YYYY')
WHERE department_id = '3';
UPDATE departments SET manager_id = '999666666',
                       mgr_start_date = TO_DATE ('19-06-2001', 'DD-MM-YYYY')
WHERE department_id = '1';



-- Einde van het script


ALTER TABLE departments
ADD CONSTRAINT fk_dep_emp FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ;

-- the numbers should correspond
SELECT COUNT(*), '# departments is 23'      FROM departments    UNION
SELECT COUNT(*), '# locations is 24'        FROM locations      UNION
SELECT COUNT(*), '# projects is 26'         FROM projects       UNION
SELECT COUNT(*), '# employees is 34'        FROM employees      UNION
SELECT COUNT(*), '# tasks is 61'           FROM tasks           UNION
SELECT COUNT(*), '# family_members is 95'   FROM family_members;


--SELECT * from projects;
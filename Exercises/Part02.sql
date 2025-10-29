--Oefening 1
select * from projects;

--Oefening 2
select project_name, department_id from projects;

--Oefening 3a
select 'Project', project_id, 'is handled by', department_id from projects;

--Oefening 3b
select 'Project' as " ", project_id, 'is handled by' as " ", department_id from projects;

--Oefeing 3c
select CONCAT('tekst1', ' ' , 'tekst2');
select CONCAT_WS('+','tekst1', 'tekst2');
select CONCAT(' ', 'project', project_id, ' is handled by ', department_id) as "Projects with departments" from projects;

--Oefening 4
SELECT current_date - birth_date FROM FAMILY_MEMBERS;

--Oefening 5a
--SELECT employee_id,project_id,hours; -- Geen from tasks
--SELECT * FROM TASK; -- Het is tasks

--Oefening 5b
SELECT last_name, salary, department_id FROM EMPLOYEES; --, tussen salary en department_id

--Oefening 7
--lower, upper, initcap
--distinct is dubbelen niet laten zien
select distinct department_id, initcap(location) as location from employees order by location; --order by 2 is hetzelfde want het is 2de kollom

--Oefening 8
select CURRENT_DATE;
select NOW();
select CURRENT_TIMESTAMP;

select 150 - 150*15/100;

--Oefening 8c met concat_wc

--Oefening 9
select employee_id as employee, name "NAME FAMILY MEMBER", relationship, gender from family_members where employee_id = '999111111' order by name;

--Oefening 10
select *
from departments
where LOWER(department_name) = 'administration';

--Oefening 11
SELECT employee_id, last_name, location
FROM EMPLOYEES
WHERE UPPER(location)='MAASTRICHT';

--Oefening 12
select *
from tasks
where project_id = 10 and hours >= 20 and hours <= 35;

select *
from tasks
where project_id = 10 and hours between 20 and 35;

--Oefening 13
select project_id, hours
from tasks
where employee_id = '999222222' and hours < 10;

--Oefening 14
select employee_id, last_name, province
from employees
where lower(province) in ('gr','nb')
order by last_name ;

--Oefening 15
select department_id, first_name
from employees
where lower(first_name) in ('suzan', 'martina', 'henk', 'douglas')
order by department_id desc, first_name;

--Oefening 16
select last_name, salary, department_id
from employees
where (department_id = 7 and salary < '40000')
   or employee_id = '999666666'
order by department_id, last_name;

--Oefening 21
select first_name, last_name, salary
from employees
order by salary
fetch next 1 rows with ties;

--Oefening 22
select first_name, last_name, birth_date
from employees
order by birth_date
fetch next 3 rows only;

--Oefening 23
select employee_id, project_id, hours
from tasks
where hours is not null
order by hours desc
offset 3 rows
fetch next 3 rows only;
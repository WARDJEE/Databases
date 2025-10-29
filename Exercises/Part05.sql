--oefening 1
SELECT *
FROM employees
WHERE AVG(salary)>30000;
--Verklaar de fout

select employee_id, sum(hours)
from tasks
group by employee_id;

--oefening 2
SELECT hours
FROM tasks
WHERE employee_id='999444444';

SELECT COUNT(hours)
FROM tasks
WHERE employee_id='999444444';

SELECT SUM(hours)
FROM tasks
WHERE employee_id='999444444';

--oefening 3
--Wat is het verschil tussen de volgende query’s?
SELECT SUM(salary)
FROM employees;

SELECT COUNT(salary)
FROM employees;

--oefening 4
--Waarom geven beide query’s niet hetzelfde resultaat?
SELECT COUNT(*)
FROM tasks;

SELECT COUNT(hours)
FROM tasks;

--oefening 5
SELECT COUNT(DISTINCT (project_id))
FROM tasks;

--oefening 6
SELECT ROUND(AVG(hours)) "number of hours"
FROM tasks
WHERE project_id = 30;

--oefening 7
SELECT COUNT(DISTINCT(employee_id)) empolyee_with_kids
FROM family_members
WHERE LOWER(relationship) IN ('son', 'daughter');

--oefening 8
SELECT MAX(hours) "Highest amount hours"
FROM tasks
WHERE project_id = 20;

--oefening 9
SELECT TO_CHAR(MAX(birth_date), 'YYYY-MM-DD') youngest_child
FROM family_members
WHERE LOWER(relationship) IN ('son', 'daughter')
    AND employee_id = '999111111';

--oefening 10
SELECT ROUND(AVG(LENGTH(last_name))) "Average lenght last_name"
FROM employees;

--oefening 11
SELECT project_id, COUNT(employee_id) number_of_employees
FROM tasks
group by project_id
order by project_id;

--oefening 12
select;


--Outer joins

--Oefening 1
select
from employees e
left join tasks t on (e.employee_id = t.employee_id)
left join projects p on (t.project_id = p.project_id)
;

--Oefening 4
select d.department_name, p.project_name, p.location
from departments d
left join projects p on (d.department_id = p.department_id);

--Oefening 5a
select e.employee_id, e.last_name, d.department_name, fm.name
from employees e
left join family_members fm on (e.employee_id = fm.employee_id)
left join departments d on (d.department_id = e.department_id)
where upper(substring(e.last_name for 1)) in  ('G', 'J')






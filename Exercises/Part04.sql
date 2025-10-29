--oefening 1
select d.department_id
     ,department_name
     ,project_id
     ,project_name
     ,location
from departments d, projects ;

--oefening 1 herschrijven met join
select d.department_id
     ,d.department_name
     ,p.project_id
     ,p.project_name
     ,p.location
from departments d
join projects p on d.department_id = p.department_id
order by department_id, project_id;

--oefening 2
select d.department_id, d.manager_id, e.last_name, e.salary, e.parking_spot
from departments d
join employees e on d.manager_id = e.employee_id
order by department_id;

--oefening 3
select p.project_name, p.location, concat_ws(' ', e.first_name, e.infix, e.last_name) full_name, e.department_id
from projects p
join tasks t on p.project_id = t.project_id
join employees e on t.employee_id = e.employee_id
order by department_id, full_name, location;

--oefening 4
select p.project_name, p.location, concat_ws(' ', e.first_name, e.infix, e.last_name) full_name,
       e.department_id "department of employee",
       p.department_id "department supporting the project"
from projects p
join tasks t on p.project_id = t.project_id
join employees e on t.employee_id = e.employee_id
join departments d on p.department_id = d.department_id
where lower(p.location) = 'eindhoven' or lower(d.department_name) = 'administration'
order by d.department_id, full_name, location;

--oefening 5

--oefening 6
select joch.last_name "last_name jochems", joch.location "city jochems", e.last_name, e.location "city"
from employees joch
join employees e on (lower(joch.location) <> lower(e.location))
where lower(joch.last_name) = 'jochems'
and lower(e.gender) = 'm'
order by e.last_name;

--oefening 7
select e1.employee_id, e1.last_name, to_char(e1.birth_date, 'yyyy-mm-dd') birth_date
from employees e1
join employees e2
    on ((to_char(e1.birth_date, 'MM')) = (to_char(e2.birth_date, 'MM')) and e1.employee_id != e2.employee_id)
order by to_char(e1.birth_date, 'MM');

--oefening 8
select *
from projects p3
join projects p on (p3.department_id = p.department_id
                        and p3.project_id <> p.project_id)
where p3.project_id = 3;

--oefening 9
select  e.last_name, boss.last_name boss, uber.last_name uberboss
from employees uber
join employees boss on (uber.employee_id = boss.manager_id)
join employees e on (boss.employee_id = e.manager_id)
where lower(uber.last_name) = 'bordoloi';


--Test examen
SELECT p.project_name, e.employee_id, e.first_name, e.last_name, p.hours,  e.birth_date, AGE(e.birth_date) age_employee

FROM employees e

         join tasks t on

    join projects p


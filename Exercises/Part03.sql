--9.8 op website

--oefening 1
select employee_id, to_char(birth_date, 'dd-mm-yyyy') "birth date", date_part('year', age(birth_date)) age
from family_members
where lower(relationship) in ('son', 'daughter')
and date_part('year', age(birth_date)) < 18;

--oefening 2
select employee_id, last_name, location, age(birth_date)
from employees
where date_part('year', age(birth_date)) > 30
and lower(location) in ('eindhoven', 'maarssen');

--oefening 3
select employee_id, age(birth_date) "agepartner"
from family_members
where lower(relationship) = 'partner'
and date_part('year', age(birth_date)) between 35 and 45;

--Oefening 4
select first_name, last_name, to_char(birth_date, 'dd month yyyy') "Date of birth", to_char(birth_date + interval '65 year', 'FMday FMdd FMmonth FMyyyy') pension
from employees
order by pension;

--Oefening 5a
select  name, to_char(birth_date, 'day dd month yyyy') "born on"
from family_members
order by birth_date desc;

--Oefening 5b
select  name, to_char(birth_date, 'FMday FMdd month FMyyyy') "born on"
from family_members
order by birth_date desc;

--Oefening 5c
select  name, to_char(birth_date, 'TMday FMdd TMmonth FMyyyy') "born on"
from family_members
order by birth_date desc;

set lc_time = 'fr_FR';
set lc_time = 'nl_BE';
set lc_time = 'en_US';

--Oefening 6a
select concat_ws(' ', first_name , infix , last_name) name
from employees;

--Oefening 6b nog niet af, geeft dubbele spaties
select concat(first_name , ' ' , infix, ' ',last_name) name
from employees;

--Oefening 6c
select *
from employees;

--Oefening 11
select lower(concat(SUBSTRING(first_name from 1 for 3), '.',
       substring(last_name from 1 for 3), '@gmail.com')) email
from employees
order by 1;


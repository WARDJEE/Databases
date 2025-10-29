-- ************************************************************
-- SLIDE DECK : Conversion, numerieke, datum- e tekstfuncties
-- ************************************************************
-- ************************************************************
-- Preparation
-- ************************************************************
-- _PG_CRE_ENTERPRISE_EN.sql
-- _PG_FILL_ENTERPRISE_EN.sql

show datestyle;


set datestyle to SQL,MDY;
SET lc_time = 'en_US';

-------------------------------
-- PART I: Conversion functions
-------------------------------
-------------------------------

-- Implicit conversions
-----------------------
-- text to date
UPDATE EMPLOYEES
	SET birth_date = '29-10-2010'
WHERE employee_id = '999111111';
-- date
SELECT current_date;
-- date to text
SELECT '*** ' || current_date || ' ***';


show datestyle;
SELECT '*** ' ||to_char(current_date, 'DD-MM-YYYY') ||' ***', '*** ' ||current_time ||' ***' ;
set datestyle to SQL,DMY;
SELECT '*** ' ||current_date ||' ***', '*** ' ||current_time ||' ***' ;

-- TO_CHAR
-----------

-- Date to Text
SELECT 'In ' ||to_char(birth_date,'Month')
	||' was born.' AS "month of birth"
FROM FAMILY_MEMBERS;

-- Solve the ugly white space using Fill Mode
SELECT 'In ' ||to_char(birth_date,'FMMonth')
	||' was born.' AS "month of birth"
FROM FAMILY_MEMBERS;

-- Display months in your locale using Translation Mode
SELECT 'In ' ||to_char(birth_date,'TMMonth')
	||' born.' AS "birth month"
FROM FAMILY_MEMBERS;

-- change the Language!
SET lc_time = 'en_FR';
-- and try again
SELECT 'In ' ||to_char(birth_date,'TMMonth')
	||' born.' AS "birth month"
FROM FAMILY_MEMBERS;


-- Numeric to Text
SELECT * FROM employees WHERE employee_id=999666666;
-- Problem: employee should be text!


-- Solution 1 : put quotes yourself
SELECT * FROM employees WHERE employee_id='999666666';
-- what if we get some IDs as numbers ?

-- Solution 2 : CAST
SELECT * FROM employees WHERE cast(employee_id as INT) = 999666666;

-- Solution 3 : TO_CHAR
SELECT * FROM employees WHERE employee_id=to_char(999666666,'999999999');
-- the '999999999' defines the format.. ie, 9 digits
-- no results... what's wrong?
SELECT to_char(999666666,'999999999');
-- Prefixed with white space (reserved for the sign) - so trim that
SELECT trim(to_char(999666666,'999999999'));
SELECT * FROM employees WHERE employee_id=trim(to_char(999666666,'999999999'));


-- More examples for to_char - numerical
SELECT '*'||to_char(-485, '999')||'*';
SELECT '*'||to_char(+485, '999')||'*'; -- a white space for the + sign
SELECT '*'||to_char( 485, '9 9 9')||'*'; -- a white space between the digits
SELECT '*'||to_char( 485, '999.9')||'*'; -- adding 1 decimal
SELECT '*'||to_char( 485, '9999999.9')||'*'; -- digits are dropped if insignificant
SELECT '*'||to_char( 485, '9909999.9')||'*'; -- digit 10K is NOT dropped even if insignificant
SELECT '*'||to_char(485, 'L09999.9')||'*'; --adding the locale currency


-- Ensure that SQL understands what we are asking
set datestyle to SQL,DMY;
-- to_DATE - examples
SELECT '*'||to_date('20 Sep','DD mon')||'*'; -- No year = Year 1 BC
SELECT '*'||to_date('20 Sep 2021','DD mon yyyy')||'*'; -- explicitely add year
SELECT * FROM employees WHERE birth_date > to_date('20 Sep 1984','DD mon yyyy'); --use in SELECT


--TO_NUMBER
------------

-- to_NUMBER - examples
SELECT '2500'+3; -- Implicit/automatic conversion
SELECT to_number('2500','9999')+3; -- detect 4 digits
SELECT to_number('€2500','L9999'); -- detect the currency symbol
SELECT to_number('12,345.6-','99,999.9S')+12000; --detect the sign



------------------------------
--PART II: NUMERICAL FUNCTIONS
------------------------------
------------------------------

-- Round - examples
SELECT round(15251.125); 	-- Rounding down to whole number
SELECT round(15251.675); 	-- Rounding up   to whole number
SELECT round(15251.675 , 0);-- Rounding up   to whole number
SELECT round(15251.675 , 1);-- Rounding up   to 1 decimal place.
SELECT round(15256.675 ,-1);-- Rounding up to the nearest ten


-- Trunc - examples
SELECT trunc(15251.675   ); -- Truncated to whole number
SELECT trunc(15251.675, 1); -- Truncated to 1 decimal place
SELECT trunc(15251.675,-1); -- Truncated at the tens

SELECT trunc(15251.675 + 10 ,-1); -- Truncated at the tens, forced to round up


-- Mod - examples
SELECT mod(6,3) remainder;
SELECT mod(5,3) remainder;
SELECT mod(7,35) remainder;
SELECT mod(5.2,3) remainder;

SELECT date '2021-09-28' + interval '10 hour';


--------------------------
--PART III: DATE FUNCTIONS
--------------------------
--------------------------

SELECT current_date;
SELECT current_time ;
SELECT current_time(0) ; -- limited precision / zero decimals
SELECT current_date - '01-Jan-2021'; -- implicit conversion + calculation = number of days

-- Slide - part of a date

SELECT date_part('day'   , TIMESTAMP '2021-10-29 20:38:40'); -- The 29th
SELECT date_part('dow'   , TIMESTAMP '2021-10-29 20:38:40'); -- 6=SATURDAY : Sunday (0) to Saturday (6)
SELECT date_part('dow'   , TIMESTAMP '2021-10-10 20:38:40'); -- 0=SUNDAY : Sunday (0) to Saturday (6)
SELECT date_part('ISODOW', TIMESTAMP '2021-10-10 20:38:40'); -- 7=SUNDAY : Monday (1) to Sunday   (7)

-- Slide  - age

SELECT age(birth_date) "age" FROM employees; -- calculate the age
SELECT date_part('year',age(birth_date)) "age" FROM employees; -- .. only the number of years:

-- Slide  - date/time calculations

SELECT date '2021-09-28' + 7;    -- days
SELECT date '2021-09-28' + interval '10 hour'; -- hour(s)
SELECT time '01:00'      + interval '3 hours'; -- only time
SELECT time '05:00' - time '2:00'; -- substraction
SELECT interval '1 hour' / 1.5; -- division


-- Calculate the day of conception (8 months and 22 days before birth) of the employees' children
SELECT employee_id
	,birth_date
	,to_char(birth_date - interval '8 months 22 days','DD Mon YYYY') "The date"
	,relationship
FROM family_members
WHERE relationship <>'PARTNER';




--------------------------
--PART IV: TEXT FUNCTIONS
--------------------------
--------------------------

--UPPER/LOWER/INITCAP
---------------------

SELECT last_name, first_name, province
FROM employees;


SELECT UPPER(last_name), LOWER(first_name), 
INITCAP(province)
FROM employees;


SELECT employee_id, last_name, salary
FROM employees
WHERE last_name = 'Bordoloi';



SELECT employee_id, last_name, salary
FROM employees
WHERE last_name = 'bordoloi';


--LENGTH
---------

SELECT  first_name || ' ' || last_name as naam, 
LENGTH(first_name||' '||last_name) as lengte_naam 
FROM  employees;



SELECT LENGTH('Jan Janssens') naamlengte;



--SUBSTRING
-----------

SELECT SUBSTRING(last_name, 1, 4), last_name
FROM employees
FETCH FIRST 3 ROWS ONLY;



SELECT SUBSTRING(last_name, LENGTH(last_name)-3, 4), 
last_name, LENGTH(last_name)
FROM employees
FETCH FIRST 3 ROWS ONLY;



SELECT SUBSTR(last_name, 5), last_name
FROM employees;




--POSITION
----------

SELECT POSITION('o' in last_name), last_name
FROM 	 employees
FETCH FIRST 5 ROWS ONLY;





--CONCAT
---------


SELECT CONCAT(2*3,' is het product van 2 en 3') 
"Product";


SELECT CONCAT('Vandaag is ', current_date) "Vandaag";



SELECT CONCAT_WS(',', 'abcde', 2, NULL, 22);



--LPAD - RPAD
-------------

SELECT lpad('hi', 5, 'xy');



SELECT lpad('hi', 5);


SELECT lpad('hiiiiiiiiiiii', 5, 'xy');



SELECT lpad(last_name, 25, '.')
FROM employees;




SELECT rpad(last_name, 25, '.')
FROM employees;



--Probleem met berekeningen (en ook datums)

SELECT lpad(1000+200.55, 14, '*') getal;




SELECT LPAD(TO_CHAR(1000+200.55, 'FM9999999D99')
			,14, '*') getal; 
					
			


SELECT LPAD(CAST(1000+200.55 AS text), 14, '*') getal;





SELECT LPAD(TO_CHAR(CURRENT_DATE,'DD/MM/YY')
			,14,'$#') date; 
			
		
			

SELECT LPAD(CAST(CURRENT_DATE AS text) 
			,14,'$#') date; 





--TRIM
-------


SELECT TRIM(TRAILING 'a' FROM 'aaaaaVandervekenaaaa') 
resultaat;



SELECT TRIM(LEADING 'a' FROM 'aaaaaVandervekenaaaa') 
resultaat;




SELECT TRIM(BOTH 'a' FROM 'aaaaaVandervekenaaaa') 
resultaat;



SELECT '*'||TRIM(' Vanderveken ')||'*' 
resultaat;



--Trim weglaten van argumenten

SELECT TRIM(TRAILING FROM 'aaaaaVandervekenaaaa') 
resultaat;

SELECT TRIM('a' FROM 'aaaaaVandervekenaaaa') 
resultaat;





--REPLACE
---------

SELECT REPLACE('ab*cd*ef*','*','°') 
"voorbeeld1 replace";




SELECT REPLACE('ab*cd*ef*','*','') 
"voorbeeld2 replace";



SELECT REPLACE(TO_CHAR(1000-1, 'FM999'),'9','55') 
"voorbeeld3 replace";




SELECT relationship, 
	TRIM('DRN' FROM relationship) 
	--,REPLACE(relationship, 'R', '6')
	--,TRIM(' ' FROM CAST(birth_date as text))
FROM family_members;






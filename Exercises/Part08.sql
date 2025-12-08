---------------------------
SELECT INITCAP(first_name)
FROM employees
UNION
SELECT INITCAP(SUBSTRING(name FOR POSITION(' ' IN name) - 1))
FROM family_members;
---------------------------

-- Oefening 1
-- Geef alle geboortedata (gesorteerd) uit employees en family
-- members. Resultaat moet er als volgt uitzien (Let op de schrijfwijze
-- van de datum).
SELECT TO_CHAR(birth_date, 'YYYY/MM/DD') "birth date"
FROM employees
UNION ALL
SELECT TO_CHAR(birth_date, 'YYYY/MM/DD')
FROM family_members
ORDER BY 1;
-- Extra update
UPDATE family_members
SET birth_date = TO_CHAR('1965/09/01', 'YYYY/MM/DD')
WHERE birth_date = TO_CHAR('2008/10/25', 'YYYY/MM/DD');

-- Oefening 2
-- Geef alle geboortedata (niet gesorteerd) uit de tabellen
-- medewerkers en gezinsleden.
SELECT TO_CHAR(birth_date, 'YYYY/MM/DD') "birth date"
FROM employees
UNION ALL
SELECT TO_CHAR(birth_date, 'YYYY/MM/DD')
FROM family_members;

-- Oefening 3
-- Geef alle medewerkers die geen gezinsleden hebben.
-- (OUTER JOIN WHERE id IS NULL)
SELECT employee_id
FROM employees
EXCEPT
SELECT employee_id
FROM family_members;

-- Oefening 4
-- Geef alle medewerkers die geen afdelingsmanager zijn.
-- (SELF JOIN met OUTER JOIN)
SELECT employee_id
FROM employees
EXCEPT
SELECT manager_id
FROM departments;

-------------------------------
SELECT GREATEST(1, 2, 3, 4, 5),
       LEAST(1, 2, 3, 4, 5);
-------------------------------
SELECT CASE
           WHEN (5 > 3)
               THEN '5 is groter'
           ELSE '5 is kleiner'
           END "5 en 3";
-------------------------------

-- Oefening 1
-- Geef voor elk kind van een medewerker weer of
-- zijn/haar leeftijdscategorie kind is (<18j) of volwassene (>=18j).
-- Maak gebruik van CASE.
SELECT employee_id,
       name,
       relationship,
       CASE
           WHEN (CURRENT_DATE - INTERVAL '18 year' <= birth_date)
               THEN 'adult'
           ELSE 'child'
           END
FROM family_members
WHERE lower(relationship) IN ('son', 'daughter');

-- Oefening 2
-- Geef de volledige namen van alle medewerkers. Zorg
-- ervoor dat er niet teveel of te weinig blanco's staan. Om dit goed te
-- kunnen zien vervang je na het samenstellen van de naam elke
-- blanco door een schuine streep '/'
SELECT REPLACE(CONCAT_WS('/', first_name, infix, last_name), ' ', '/') full_name
FROM employees;

-- Oefening 3a
-- Toon voor alle medewerkers de voornaam van hun partner. Als een
-- medewerker geen partner heeft toon je de text ‘Single’ in plaats van
-- zijn/haar voornaam.
SELECT e.employee_id,
       e.first_name,
       e.birth_date,
    /*CASE
        WHEN (fm.name IS NULL)
            THEN 'Single'
        else fm.name
        END partner*/
       COALESCE(fm.name, 'Single') partner -- Korte mannier
FROM employees e
         LEFT JOIN family_members fm ON (e.employee_id = fm.employee_id)
WHERE LOWER(fm.relationship) = 'partner'
   OR fm.relationship IS NULL;

-- Oefening 3b
-- Toon nu ook de geboortedatum van de partner en de voornaam van de
-- oudste van de twee (de partner met de kleinste geboortedatum dus).
-- Verwachte resultaat


-- Oefening 4a
-- Hoeveel seconden duurt deze dag al?
-- Klok
-- De dag is 58541 seconden oud.
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'SSSS');

-- Oefening 4b, c, d
-- Je weet het einduur van de les. Bereken op basis van de systeemtijd
-- hoeveel minuten de les nog duurt.
-- Klok
-- De les duurt nog 92 minuten.
SET TIMEZONE = 'Europe/Brussels';
SELECT CONCAT_WS(' ', 'De les duurt nog', DATE_PART('minute', TO_TIMESTAMP('25/11/2025 16:30', 'DD/MM/YYYY HH24:MI') -
                                                              CURRENT_TIMESTAMP),
                 'minuten') "Hoelang tot de les gedaan is?";

SELECT CASE
           WHEN DATE_PART('minute', TO_TIMESTAMP('25/11/2025 16:30', 'DD/MM/YYYY HH24:MI') -
                                    CURRENT_TIMESTAMP) > 0
               THEN 'De les is nog bezig'
           ELSE 'De les is gedaan'
           END "Status les";


-- Combo oefening zelfstudie
SELECT p.location,
       SUM(t.hours) "Totaal uren",
       CASE
           WHEN SUM(t.hours) < 50
               THEN 'Project on time'
           WHEN SUM(t.hours) BETWEEN 50 and 80
               THEN 'Project takes longer than expected'
           ELSE 'Project over due'
END "Project timing"
FROM projects p
         LEFT JOIN tasks t ON (p.project_id = t.project_id)
GROUP BY p.location
ORDER BY 2 DESC;
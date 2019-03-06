REM 1 Display the nobel laureate(s) who born after 1Jul1960.

SELECT * FROM nobel 
WHERE dob>'1-jul-1960';

REM 2 Display the Indian laureate (name, category, field, country, year awarded) who was awarded in the Chemistry category.

SELECT name,category,field,country,year_award 
FROM nobel 
WHERE country = 'India' and category='Che';

REM 3 Display the laureates (name, category,field and year of award) who was awarded between 2000 and 2005 for the Physics or Chemistry category.

SELECT name,category,field,year_award 
FROM nobel 
WHERE (year_award between 2000 and 2005) and category in ('Che','Phy');

REM 4 Display the laureates name with their age at the time of award for the Peace category.

SELECT name, year_award - extract(year FROM dob) "Age" 
FROM nobel 
WHERE category='Pea';

REM 5 Display the laureates (name,category,aff_role,country) whose name starts with A or ends with a, but not FROM Isreal.

SELECT name,category,aff_role,country 
FROM nobel 
WHERE (name like 'A%' or name like '%a') and country!='Isreal';

REM 6 Display the name, gender, affiliation, dob and country of laureates who was born in 1950s.Label the dob column as Born 1950.

SELECT  name, gender, aff_role, dob "Born 1950", country 
FROM nobel 
WHERE  extract(year FROM dob) like '%5_';

REM 7 Display the laureates (name,gender,category,aff_role,country) whose name starts with A, D or H. REMove the laureate if he/she do not have any affiliation. Sort the results in ascending order of name.

SELECT name,gender,category,aff_role,country 
FROM nobel 
WHERE (name like 'A%' or name like 'D%' or name like 'H%')
and aff_role is not null
ORDER BY name;

REM 8 Display the university name(s) that has to its credit by having at least 2 nobel laureate with them.

SELECT aff_role, count(*) 
FROM nobel 
WHERE aff_role like '%University%'
GROUP BY aff_role 
HAVING COUNT(*)>1;

REM 9 List the date of birth of youngest and eldest laureates by countrywise.Label the column as Younger, Elder respectively. Include only the country having more than one laureate. Sort the output in alphabetical order of country.

SELECT country, max(dob) "youngest", min(dob) "eldest" 
FROM nobel 
GROUP BY country 
HAVING COUNT(*)>1 
ORDER BY country;

REM 10 Show the details (year award,category,field) WHERE the award is shared among the laureates in the same category and field. Exclude the laureates FROM USA.

SELECT year_award,category,field FROM nobel 
WHERE country!='USA' 
GROUP BY year_award,category,field 
HAVING COUNT(*)>1;
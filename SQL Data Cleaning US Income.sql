# US Houshold Income Data Cleaning 
SELECT * 
FROM us_project.us_household_income
;

SELECT * 
FROM us_project.us_household_income_statistics
;

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;


SELECT COUNT(id) 
FROM us_project.us_household_income
;

SELECT COUNT(id) 
FROM us_project.us_household_income_statistics
;

SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;
#Finding Duplicate Ids
SELECT *
FROM(
	SELECT row_id,
	id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
	FROM us_project.us_household_income
	) duplicates
WHERE row_num > 1
;

#Deleteing Duplicate Ids
DELETE FROM us_project.us_household_income
WHERE row_id IN (
	SELECT row_id 
	FROM(
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_project.us_household_income
		) duplicates
WHERE row_num > 1)
;
#Checking for mispelled State_Names
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;
#Fixing Names
UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_name = 'alabama'
;

SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;
#Filling the null place
UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County' 
AND City = 'Vinemont';

SELECT  Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
-- ORDER BY 1
;

#Rename Type
UPDATE us_project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (ALand = 0 or ALand = '' or ALand IS NULL)
;
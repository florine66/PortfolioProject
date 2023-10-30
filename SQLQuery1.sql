-- Today I'm going to show you how I use SQL, to clean data based on historical sales data.

/*Verify the content of the table*/

select *
from PortfolioProject.dbo.automobile_data


-- Step 1: Inspect the fuel_type column
		--According to the data’s description, the fuel_type column should only have two unique string values: diesel and gas. 
		--To check and make sure that’s true we will execute the following query.

SELECT
DISTINCT fuel_type
FROM PortfolioProject.dbo.automobile_data

-- Step 2: Inspect the length column 
	-- Next, you will inspect a column with numerical data. The length column should contain numeric measurements of the cars. 
	-- So we will check that the minimum and maximum lengths in the file align with the data description, 
	-- which states that the lengths in this column should range from 141.1 to 208.1. We will run the followinf query to confirm 

SELECT
  MIN(length) AS min_length,
  MAX(length) AS max_length
FROM PortfolioProject.dbo.automobile_data

-- Step 3: Fill in missing data
--Missing values can create errors or skew the results during analysis. We are going to want to check your data for null or missing values. 
--These values might appear as a blank cell or the word null. So we will check to see if the num_of_doors column contains null values using this query: 

SELECT *
FROM PortfolioProject.dbo.automobile_data
WHERE num_of_doors is NULL

-- As result of the previous query, we got two results, one Mazda and one Dodge
-- In order to fill in these missing values, we check with the sales manager, who states that all Dodge gas sedans and all Mazda diesel sedans sold had 
-- four doors.

UPDATE
  PortfolioProject.dbo.automobile_data
SET
  num_of_doors = 'four'
WHERE
  make = 'dodge' 
    AND fuel_type = 'gas'
    AND body_style = 'sedan'
  
-- We got a message telling us that three rows were modified in this table. To make sure, we ran the previous query again:

SELECT *
FROM PortfolioProject.dbo.automobile_data
WHERE num_of_doors IS NULL;

-- We repeated this process to replace the null value for the Mazda. 
UPDATE
  PortfolioProject.dbo.automobile_data
SET
  num_of_doors = 'four'
WHERE
  make = 'mazda' 
    AND fuel_type = 'diesel'
    AND body_style = 'sedan'

-- Step 4: Identify potential errors
	-- Once we finished ensuring that there aren’t any missing values in the data, we want to check for other potential errors. 
	-- We then used You can use SELECT DISTINCT to check what values exist in a column by running the query below to check the num_of_cylinders column: 

SELECT
  DISTINCT num_of_cylinders
FROM
  PortfolioProject.dbo.automobile_data
  
-- After running this, we noticed that there are one too many rows. There are two entries for two cylinders: rows 6 and 7. But the two in row 7 is misspelled. 

-- To correct the misspelling for all rows, we ran the following query

UPDATE
  PortfolioProject.dbo.automobile_data
SET
  num_of_cylinders = 'two'
WHERE
  num_of_cylinders = 'tow'

-- Step 5: Ensure consistency
-- Finally, you want to check your data for any inconsistencies that might cause errors. These inconsistencies can be tricky to spot — 
-- sometimes even something as simple as an extra space can cause a problem. Check the drive_wheels column for inconsistencies 
-- by running a query with a SELECT DISTINCT statement

SELECT
  DISTINCT drive_wheels
FROM
  PortfolioProject.dbo.automobile_data

-- It appeared that 4wd appears twice in results. However, because you used a SELECT DISTINCT statement to return unique values,
-- this probably means there’s an extra space in one of the 4wd entries that makes it different from the other 4wd. 

-- To check if this is the case, you can use a LEN (LENGHT) statement to determine the length of how long each of these string variables: 

SELECT
  DISTINCT drive_wheels,
  LEN (drive_wheels) AS string_length
FROM
  PortfolioProject.dbo.automobile_data

  -- According to these results, some instances of the 4wd string have four characters instead of the expected three (4wd has 3 characters). 
  --In thIS case, We used the TRIM function to remove all extra spaces in the drive_wheels column if you are using the BigQuery free trial: 

UPDATE
  PortfolioProject.dbo.automobile_data
SET
  drive_wheels = TRIM(drive_wheels)


SELECT
  DISTINCT drive_wheels,
  LEN (drive_wheels) AS string_length
FROM
  PortfolioProject.dbo.automobile_data

  -- And now there should only be three unique values in this column! Which means your data is clean,  consistent, and ready for analysis! 

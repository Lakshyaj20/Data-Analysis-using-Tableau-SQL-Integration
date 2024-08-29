/* 
Business Question 2
Compare the number of male managers to the number of female managers 
from different departments for each year, starting from 1990.
*/

-- Switch to the 'employees_mod' database
USE employees_mod;

-- Temporarily disable the 'ONLY_FULL_GROUP_BY' SQL mode to allow using columns in SELECT that are not in GROUP BY
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Select the department name, gender of the manager, manager's employee number, manager's 'from_date' and 'to_date', and the calendar year
-- Additionally, add a computed column named 'active' to indicate whether the manager was active in the specified calendar year
SELECT
	d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
		WHEN e.calendar_year >= YEAR(dm.from_date) AND e.calendar_year <= YEAR(dm.to_date) THEN 1
        ELSE 0
	END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year      -- Extract the year from the 'hire_date' column in the 't_employees' table
     FROM 
        t_employees
     GROUP BY calendar_year) e                -- Create a derived table 'e' containing distinct calendar years
		CROSS JOIN                            -- Perform a CROSS JOIN to get all combinations of years from 'e' with all rows from 't_dept_manager' table
	t_dept_manager dm                         -- Alias 't_dept_manager' table as 'dm'
		JOIN
	t_departments d                           -- Alias 't_departments' table as 'd'
					ON dm.dept_no = d.dept_no -- Join 't_dept_manager' with 't_departments' on 'dept_no' to get department names
		JOIN
	t_employees ee                            -- Alias 't_employees' table as 'ee'
					ON dm.emp_no = ee.emp_no  -- Join 't_dept_manager' with 't_employees' on 'emp_no' to get employee gender
ORDER BY dm.emp_no, calendar_year;            -- Sort the results by manager's employee number and calendar year

/*
This SQL query aims to compare the number of male managers to female managers from different departments for each year, starting from 1990.
It does this by creating a derived table 'e' with distinct calendar years from the 't_employees' table. 
Then, it performs a CROSS JOIN with the 't_dept_manager' table to get all combinations of years and manager data. 
The query also joins the 't_departments' and 't_employees' tables to retrieve department names and employee gender. 
The 'active' column is used to indicate whether a manager was active during the specified calendar year. 
The results can be used to create a visualization in Tableau to compare male and female managers over the years in various departments.
*/
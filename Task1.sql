/*
Business Question 1
Create a visualization that provides a breakdown between the male and female employees 
working in the company each year, starting from 1990. 
*/ 

-- Switch to the 'employees_mod' database
USE employees_mod;

-- Temporarily disable the 'ONLY_FULL_GROUP_BY' SQL mode to allow using columns in SELECT that are not in GROUP BY
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Select the calendar year, gender, and count of employees for each combination of year and gender
SELECT 
    YEAR(d.from_date) AS calendar_year, 
    e.gender,                           
    COUNT(e.emp_no) AS num_of_employees 
FROM
    t_employees e                       -- Alias 't_employees' table as 'e'
        JOIN
    t_dept_emp d                        -- Alias 't_dept_emp' table as 'd'
				ON d.emp_no = e.emp_no  -- Join 't_employees' with 't_dept_emp' on 'emp_no' to get employment information
GROUP BY calendar_year, e.gender        -- Group the results by calendar_year and gender
HAVING calendar_year >= 1990            -- Filter the results to include only calendar years from 1990 onwards
-- ORDER BY calendar_year               -- (Optional) If desired, you can uncomment this line to order the results by calendar_year
;

/*
This SQL query aims to provide a breakdown of the number of male and female employees working in the company each year, starting from 1990.
It does this by joining the 't_employees' and 't_dept_emp' tables to obtain employment information, grouping the data by calendar year and gender, 
and then counting the number of employees for each combination. 
The result can be used to create a visualization in Tableau to showcase the gender distribution over the years.
*/
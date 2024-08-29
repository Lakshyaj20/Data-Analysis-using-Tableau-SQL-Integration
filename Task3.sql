/*
Business Question 3
Compare the average salary of female versus male employees in the entire company
until year 2002, and add a filter allowing you to see that per each department.
*/

-- Switch to the 'employees_mod' database
USE employees_mod;

-- Temporarily disable the 'ONLY_FULL_GROUP_BY' SQL mode to allow using columns in SELECT that are not in GROUP BY
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Select the employee gender, department name, rounded average salary, and the calendar year from the 'from_date' in the 't_salaries' table
SELECT
	e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
	t_employees e 							-- Alias 't_employees' table as 'e'
		JOIN
	t_salaries s 							-- Alias 't_salaries' table as 's'
				ON e.emp_no = s.emp_no 		-- Join 't_employees' with 't_salaries' on 'emp_no' to get employee salary
		JOIN
	t_dept_emp de 							-- Alias 't_dept_emp' table as 'de'
				ON s.emp_no = de.emp_no 	-- Join 't_salaries' with 't_dept_emp' on 'emp_no' to get department information
		JOIN
	t_departments d 						-- Alias 't_departments' table as 'd'
				ON de.dept_no = d.dept_no 	-- Join 't_dept_emp' with 't_departments' on 'dept_no' to get department names
GROUP BY d.dept_no, e.gender, calendar_year -- Group the results by department number, employee gender, and calendar year
HAVING calendar_year <= 2002 				-- Filter the results to include data only up to the year 2002
ORDER BY d.dept_no; 						-- Sort the results by department number

/*
This SQL query aims to compare the average salary of female versus male employees in the entire company until the year 2002.
It does this by joining the 't_employees', 't_salaries', 't_dept_emp', and 't_departments' tables to retrieve relevant data about employees, salaries, and departments.
The query then groups the results by department number, employee gender, and calendar year while calculating the rounded average salary.
The results can be used to create a visualization in Tableau to compare average salaries between genders per department up to the year 2002.
*/
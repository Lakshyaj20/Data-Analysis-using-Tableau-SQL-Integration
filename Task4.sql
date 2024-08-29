/*
Business Question 4
Create an SQL stored procedure that will allow you to obtain 
the average male and female salary per department within a certain salary range.
Let this range be defined by two values the user can insert when calling the procedure.
*/

-- Switch to the 'employees_mod' database
USE employees_mod;

-- Temporarily disable the 'ONLY_FULL_GROUP_BY' SQL mode to allow using columns in SELECT that are not in GROUP BY
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Drop the stored procedure 'filter_salary' if it already exists (to ensure a clean setup)
DROP PROCEDURE IF EXISTS filter_salary;

-- Set the delimiter to '$$' to define the stored procedure
DELIMITER $$
-- Create a stored procedure named 'filter_salary' with two input parameters: 'p_min_salary' and 'p_max_salary'
CREATE PROCEDURE filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
	-- Select the employee gender, department name, and average salary for each combination of department and gender
	-- Filter the results to include only employees with salaries between 'p_min_salary' and 'p_max_salary'
	SELECT
		e.gender,
		d.dept_name,
		AVG(s.salary) AS avg_salary
	FROM
		t_employees e 									 -- Alias 't_employees' table as 'e'
			JOIN
		t_salaries s 									 -- Alias 't_salaries' table as 's'
						ON e.emp_no = s.emp_no 			 -- Join 't_employees' with 't_salaries' on 'emp_no' to get employee salary
			JOIN
		t_dept_emp de 									 -- Alias 't_dept_emp' table as 'de'
						ON s.emp_no = de.emp_no 		 -- Join 't_salaries' with 't_dept_emp' on 'emp_no' to get department information
			JOIN
		t_departments d 								 -- Alias 't_departments' table as 'd'
						ON de.dept_no = d.dept_no 		 -- Join 't_dept_emp' with 't_departments' on 'dept_no' to get department names
	WHERE s.salary BETWEEN p_min_salary AND p_max_salary -- Filter the data to include salaries within the specified range
	GROUP BY d.dept_no, e.gender 						 -- Group the results by department number and employee gender
	-- ORDER BY d.dept_no 								 -- (Optional) If desired, you can uncomment this line to order the results by department number
    ;
END$$
-- Reset the delimiter back to the default ';'
DELIMITER ;

-- Call the 'filter_salary' stored procedure with two salary range parameters (50000 and 90000)
CALL filter_salary(50000, 90000);

/*
This SQL script creates a stored procedure named 'filter_salary' that allows you to obtain the average male and female salary per department within a certain salary range.
The procedure accepts two input parameters ('p_min_salary' and 'p_max_salary') that define the salary range specified by the user when calling the procedure.
The stored procedure selects relevant data from the 't_employees', 't_salaries', 't_dept_emp', and 't_departments' tables and 
filters the results to include employees whose salaries fall within the specified range.
The procedure groups the data by department number and employee gender while calculating the average salary. 
The result can be used to create a visualization in Tableau to compare the average salaries between genders for each department within the specified salary range.
*/
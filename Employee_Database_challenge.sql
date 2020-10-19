-- Challenge #1, The Number of Retiring Employees by Title

-- #1-1 Create a Retirement Titles table that holds all the titles of current employees 
-- who were born between January 1, 1952 and December 31, 1955

-- Retrieve the emp_no, first_name, and last_name columns from the Employees table.
SELECT e.emp_no, e.first_name, e.last_name,
-- Retrieve the title, from_date, and to_date columns from the Titles table.
	ti.title, ti.from_date, ti.to_date
-- Create a new table using the INTO clause.
INTO retirement_titles
FROM employees AS e
-- Join both tables on the primary key.
INNER JOIN Titles AS ti
ON (e.emp_no = ti.emp_no)
-- Filter the data on the birth_date column to retrieve the employees
-- who were born between 1952 and 1955. Then, order by the employee number.
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY ti.emp_no;

-- Export the Retirement Titles table from the previous step as retirement_titles.csv 
SELECT * FROM retirement_titles;


-- #1-2 Remove these duplicates and keep only the most recent title of each employee

-- Use the DISTINCT ON statement to retrieve the first occurrence of the employee number
-- and retrieve the employee number, first and last name, and title from the Retirement Titles table.
SELECT DISTINCT ON (emp_no) emp_no,
	first_name, 
	last_name, 
	title
-- Create a Unique Titles table using the INTO clause.
INTO retirement_unique_titles
FROM retirement_titles AS rt
-- Sort the Unique Titles table in ascending order by the employee number 
-- and descending order by the last date (i.e. to_date) of the most recent title.
ORDER BY emp_no ASC, to_date DESC ;

-- Export the Unique Titles table as unique_titles.csv 
SELECT * FROM retirement_unique_titles;


-- #1-3 Retrieve the number of employees by their most recent job title who are about to retire.

-- Retrieve the number of titles from the Unique Titles table.
SELECT COUNT(rt.emp_no), rt.title
-- Create a Retiring Titles table to hold the required information.
INTO retiring_titles_info
FROM retirement_unique_titles AS rt
-- Group the table by title, then sort the count column in descending order.
GROUP BY rt.title
ORDER BY 1 DESC;
-- Export the Retiring Titles table as retiring_titles.csv and save it to your Data folder in the Pewlett-Hackard-Analysis folder.
SELECT * FROM retiring_titles_info;



-- Challenge #2 The Employees Eligible for the Mentorship Program 

-- Use a DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
-- Retrieve the emp_no, first_name, last_name, and birth_date columns from the Employees table.
SELECT DISTINCT ON (em.emp_no) em.emp_no, 
	em.first_name, 
	em.last_name,
	em.birth_date,
-- Retrieve the from_date and to_date columns from the Department Employee table.
	de.from_date, 
	de.to_date,
-- Retrieve the title column from the Titles table.
	ti.title

-- Create a new table using the INTO clause.
INTO mentorship_eligibilty
FROM Employees AS em
-- Join the Employees and the Department Employee tables on the primary key.
INNER JOIN dept_emp AS de 
ON em.emp_no = de.emp_no
-- Join the Employees and the Titles tables on the primary key.
INNER JOIN titles AS ti 
ON em.emp_no = ti.emp_no
-- Filter the data on the to_date column to get current employees 
-- whose birth dates are between January 1, 1965 and December 31, 1965.
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
-- Order the table by the employee number.
ORDER BY em.emp_no;
-- Export the Mentorship Eligibility table as mentorship_eligibilty.csv 
SELECT * FROM mentorship_eligibilty;

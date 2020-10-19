# Pewlett-Hackard-Analysis
Pewlett-Hackard retirement and mentoring analysis using SQL database.

## Project Background and Goals

* Matplotlib has a rich set of features for creating and annotating charts that visualize data in a Data Series or DataFrame.
* This is a data analyst project at PyBer, a ride-sharing app company valued at $2.3 billion and we need to analyze all the rideshare data from January to early May of 2019 and create a compelling visualization using Matplotlib and SciPy statistics.

* Here is the list of deliverables for the analysis of the PyBer analysis:

    - Perform exploratory analysis on data from large csv files.
    - Create a bubble chart that showcases the average fare versus the total number of rides with bubble size based on the total number of drivers for each city type, including urban, suburban, and rural.
    - Determine the mean, median, and mode and create box-and-whisker plots that visualize the number of rides, the fares, and the number of drivers for each city type.
    - Create a pie chart that visualizes each of the percent of total fares, total rides, and total drivers for each city type.

* This analysis improves the access to ride-sharing service and determining the affordability for underserved neighborhoods.

## The process of project

* Verify that PostgreSQL and pgAdmin are installed correctly.
* Be able to create a SQL database using Query
* Import and export CSVs into database tables
* Combine data using joins and count the total number of rows
* Use the DISTINCT ON statement to retrieve the first occurrence for each set of rows

## Software/Tools/Libraries
* PostGreSQL 4.24. pgAdmin 4, Visual studio 1.50.
* Data Source: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv

## Results


1. The Entity Relationship Diagrams (ERDs) demonstrates relationships between 6 tables:

![QuickDBD-export.png](Image/QuickDBD-export.png)

2. Determining the number of individuals retiring:

- SQL for all Retirement Eligibility:[mentorship_eligibilty.csv](/Data/mentorship_eligibilty.csv)

*Queries*

```

SELECT emp_no, birth_date, first_name, last_name, genger AS gender, hire_date
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
```



# Challenge

## Object

Create a list of candidates for the mentorship program.


### 1. Create a Retirement Titles table that holds all the titles of current employees 
-- who were born between January 1, 1952 and December 31, 1955

*Queries*

```
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	ti.title, 
	ti.from_date, 
	ti.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN Titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY ti.emp_no;

SELECT * FROM retirement_titles;
```
Retirement Titles table that holds all the titles of current employees, 
[retirement_titles.csv](data/retirement_titles.csv)

* Table image. head(13)

![retirement_titles.PNG](Image/retirement_titles.PNG)

**In conclusion, There are 41,380 records of individuals ready to retirement**


### 2. Remove the duplicates and keep only the most recent title of each employee

--Create a Unique Titles table that contains the employee number, first and last name, and most recent title.
--Use the DISTINCT ON fuction to retrieve the first occurrence of the employee number for each set of rows.
--Sort the Unique Titles table in ascending order by the employee number and descending order by the last date.

*Queries*
```
SELECT DISTINCT ON (emp_no) emp_no,
	first_name, 
	last_name, 
	title
INTO retirement_unique_titles
FROM retirement_titles AS rt
ORDER BY emp_no ASC, to_date DESC ;

SELECT * FROM retirement_unique_titles;
```
- Current Retirement Eligibility with current title:
[retirement_unique_titles.csv](Data/retirement_unique_titles.csv)

**In conclusion, there are 33,118 records of Current Retirement Eligibility** 


### 3. Each employee ONLY display the most recent title:

- By using **partition** by and row_number() function.

*Queries*

```
SELECT employee_number, first_name, last_name, title, from_date, salary
INTO current_title_info
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY (cei.employee_number, cei.first_name, cei.last_name)
                ORDER BY cei.from_date DESC) AS emp_row_number
      FROM challenge_emp_info AS cei) AS unique_employee	  
WHERE emp_row_number =1;
```

5. The Frequency count of employee titles:
[challenge_title_info.csv](/Data/challenge_title_info.csv)

*Queries*

```
SELECT *, count(ct.Employee_number) 
		OVER (PARTITION BY ct.title ORDER BY ct.from_date DESC) AS emp_count
INTO challenge_title_info
FROM current_title_info AS ct;
```

a summary count of employees for each title:[challenge_title_count_info.csv](/Data/challenge_title_count_info.csv)

*Queries*

```
SELECT COUNT(employee_number), title
FROM challenge_title_info
GROUP BY title;
```

**Conclusion**
**In the 33118 records of Current Retirement Eligibility, there are 251 Assistant Engineers, 2711 engineers, two managers 2022 staffs,12872 Senior Staffs and 1609 Technique Leaders**



6. Determining the number of individuals available for mentorship role:

*Queries*

```
SELECT DISTINCT ON (em.emp_no) em.emp_no, 
	em.first_name, 
	em.last_name,
	em.birth_date,
	de.from_date, 
	de.to_date,
	ti.title
INTO mentorship_eligibilty
FROM Employees AS em
INNER JOIN dept_emp AS de 
ON em.emp_no = de.emp_no
INNER JOIN titles AS ti 
ON em.emp_no = ti.emp_no
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY em.emp_no;
SELECT * FROM mentorship_eligibilty;
```
SQL export csv file for eligible for mentor program, [entorship_eligibilty.csv](data/mentorship_eligibilty.csv)

* Mentorship eligibility table for current employees (table head(13))

![mentorship_eligibilty.PNG](Image/mentorship_eligibilty.PNG)

**In conclusion, there are 1549 active employees eligible for mentor plan.**

### Limitation and Suggestion
 
 1. This project assumed retirement years between 1952 and 1955. 
 We need to narrow down period into 3 single year for more accurate estimate and better analysis of potential job opening. 

 2. More detail information and analysis are needed for potential mentor table, 
 to compare with the title table of current ready-to-retirement 
 and get a better estimate of outside hiring request. 

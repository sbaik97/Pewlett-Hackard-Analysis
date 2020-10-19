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

* Read raw data in csv file.
* Clean and inspect data, correct inappropriate data.
* Merge datasets to create new DataFrame gathering more information.
* Perform calculations for key metrics use groupby() function.
* Visualize data with tables to tell story and showcase trends.

## Software/Tools/Libraries
* PostGreSQL 4.24. pgAdmin 4, Visual studio 1.50.
* Data Source: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv

## Results of project
1. The ride-sharing bubble chart shows the total number of rides per city. One bubble chart has all the city types with the different colors.

![PyBer_RideSharing_Data.png](Analysis/PyBer_RideSharing_Data.png)

2. The mean, median, and mode of the number of rides, the fares, and the number of drivers for each city type and create box-and-whisker plots with the statistics
* Number of ride per the city type

![Ride_count_data.png](Analysis/Fig_ride_count_data.png)

* Ride fare data per the city type

![Ride_fair_data.png](Analysis/Fig_ride_fair_data.png)

* Driver Count Data per the city type

![Drivers_count_data.png](Analysis/Fig_drivers_count_data.png)

3. Pie chart to visualizes each of the percent of total fares, total rides, and total drivers for each city type.

* Ride percentage the city type

![Ride_percentages.png](Analysis/ride_percentages.png)

* Fare percentage per the city type

![Ride_fair_percentage__by_city_type.png](Analysis/fares_percentage__by_city_type.png)

* Driver percentageper the city type

![Drivers_percentages.png](Analysis/driver_percentages.png)

# Challenge

## Object

Create a list of candidates for the mentorship program.


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

**In conclusion, There are 41,380 records of individuals ready to retirement**

3. Determining the number of individuals being hired:

-Current Retirement Eligibility:

*Queries*

```
SELECT r.emp_no, r.first_name, r.last_name,d.dep_no, d.to_date
INTO current_emp
FROM retirement_info AS r
LEFT JOIN dept_emp AS d
ON r.emp_no = d.emp_no
WHERE d.to_date = '9999-01-01';
```


**In conclusion, there are 33,118 records of Current Retirement Eligibility** 

- Current Retirement Eligibility with title and salary information:
[challenge_emp_info.csv](/Data/challenge_emp_info.csv)

*Queries*
```
SELECT ce.emp_no AS Employee_number,ce.first_name, ce.last_name, 
    t.title AS Title, t.from_date, s.salary AS Salary
INTO challenge_emp_info
FROM current_emp AS ce
INNER JOIN titles AS t ON ce.emp_no = t.emp_no
INNER JOIN salaries AS s ON ce.emp_no = s.emp_no;

```


4. Each employee ONLY display the most recent title:

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
SQL for eligible for mentor program, [entorship_eligibilty.csv](data/mentorship_eligibilty.csv)

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
* Mentorship eligibility table for current employees (table head(13))

![mentorship_eligibilty.PNG](Image/mentorship_eligibilty.PNG)

**In conclusion, there are 1549 active employees eligible for mentor plan.**

### Limitation and Suggestion
 
 1. This project assumed retirement years between 1952 and 1955. 
 We need to narrow down period into 3 single year for more accurate estimate and better analysis of potential job opening. 

 2. More detail information and analysis are needed for potential mentor table, 
 to compare with the title table of current ready-to-retirement 
 and get a better estimate of outside hiring request. 

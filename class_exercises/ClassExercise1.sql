/*
BC2402 Class Exercise 1
Name: Tang Te Jie, Nicholas
Matric No: U2310817H
*/

/* 1 */
SHOW TABLES;

/* 2 */
SELECT first_name, last_name, gender 
FROM employees;

/* 3 */
SELECT DISTINCT(title)
FROM titles;

/* 4 */
SELECT COUNT(*) AS emp_amt
FROM employees;

/* 5 */
SELECT COUNT(*) AS salary_amt
FROM salaries;

/* 6 */
SELECT COUNT(*) AS depart_amt
FROM departments;

/* 7 */
SELECT dept_name
FROM departments;

/* 8 */
SELECT first_name, last_name
FROM employees
WHERE gender = 'f';

/* 9 */
SELECT COUNT(*)
FROM employees
WHERE gender = 'm';

/* 10 */
SELECT *
FROM employees
WHERE YEAR(hire_date) < "1990";

/* 11 */
SELECT *
FROM employees
WHERE YEAR(hire_date) > 1995
AND gender = 'm';

/* 12 */
SELECT COUNT(*) AS emp_amt
FROM employees 
WHERE first_name 
IN ('Adin', 'Deniz', 'Youssef', 'Roded');

/* 13a */
SELECT COUNT(*) AS amt
FROM titles
WHERE title LIKE '%Engineer';

/* 13b */
SELECT COUNT(*) AS amt
FROM titles
WHERE title NOT LIKE '%Engineer';

/* 14 */
SELECT COUNT(*) FROM employees
WHERE hire_date >= '1990-01-01' 
AND hire_date <= '1994-01-01';

/* 15 */
SELECT DISTINCT last_name
FROM employees
WHERE gender = 'f'
	AND YEAR(birth_date) < 1970
    AND YEAR(hire_date) > 1996
 ORDER BY last_name ASC;
 
 /* 16 */
 SELECT gender, COUNT(*) 
 FROM employees
 WHERE hire_date < '1989-01-01'
 GROUP BY gender;
 
 /* 17a */
SELECT e.gender, d.dept_name, COUNT(*) as amt
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY e.gender, d.dept_name
ORDER BY e.gender, d.dept_name;

/* 17b */
SELECT gender, COUNT(*) AS amt
FROM employees
WHERE YEAR(hire_date) BETWEEN 1994 AND 1996
GROUP BY gender;

/* 18 */
SELECT first_name, last_name
FROM employees
WHERE emp_no IN
  (SELECT emp_no FROM dept_emp
    WHERE dept_no IN
      (SELECT dept_no FROM dept_manager 
        WHERE from_date = "1992-09-08" AND to_date = "1996-01-03"));

/* 19 */
SELECT first_name, last_name, title
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE t.to_date = '9999-01-01';

/* 20 */
SELECT d.dept_no, AVG(s.salary) AS avg_salary
FROM salaries s
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_no;

/* 21 */
SELECT 
    d.dept_no,
    COUNT(DISTINCT e.emp_no) AS empAmt,
    AVG(s.salary) AS avg_salary
FROM salaries s
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN employees e ON e.emp_no = s.emp_no
GROUP BY d.dept_no
ORDER BY d.dept_no;

/* 22 */
SELECT 
    d.dept_no,
    COUNT(DISTINCT s.emp_no) AS num_employees
FROM salaries s
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE s.salary > 130000
GROUP BY d.dept_no
ORDER BY d.dept_no;
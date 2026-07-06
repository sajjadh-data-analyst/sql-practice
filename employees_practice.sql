-- ============================================================
-- EMPLOYEES PRACTICE DATASET
-- Concepts: DDL, DML, DQL, Self-Joins, CTEs, Window Functions
-- Dataset: Company HR data (25 rows)
-- ============================================================


-- ============================================================
-- DDL — TABLE CREATION
-- ============================================================

-- Q1. Create the employees table with self-referencing foreign key
CREATE TABLE employees (
    emp_id      INT PRIMARY KEY,
    emp_name    VARCHAR(50),
    department  VARCHAR(25),
    job_title   VARCHAR(50),
    salary      INT,
    manager_id  INT REFERENCES employees(emp_id),
    hire_date   DATE,
    is_active   BOOLEAN
);

-- Q2. Add performance_rating column with named CHECK constraint
ALTER TABLE employees
ADD COLUMN performance_rating NUMERIC(2,1) DEFAULT 3.0;

ALTER TABLE employees
ADD CONSTRAINT chk_performance_rating CHECK (performance_rating BETWEEN 1.0 AND 5.0);


-- ============================================================
-- DML — INSERT DATA
-- ============================================================

-- Q3. Insert all 25 rows
-- Note: manager rows must be inserted before employee rows (FK constraint)
INSERT INTO employees (emp_id, emp_name, department, job_title, salary, manager_id, hire_date, is_active) VALUES
(1,  'Ahmed Malik',     'Engineering', 'Senior Engineer',       120000, NULL, '2019-03-15', TRUE),
(3,  'Bilal Chaudhry',  'HR',          'HR Manager',            90000,  NULL, '2018-11-20', TRUE),
(5,  'Usman Farooq',    'Sales',       'Sales Manager',         95000,  NULL, '2017-07-04', TRUE),
(8,  'Ayesha Tariq',    'Finance',     'Finance Manager',       105000, NULL, '2016-05-30', TRUE),
(13, 'Tariq Mehmood',   'Marketing',   'Marketing Manager',     88000,  NULL, '2018-04-25', TRUE),
(2,  'Sara Qureshi',    'Engineering', 'Junior Engineer',       65000,  1,    '2021-06-01', TRUE),
(4,  'Nadia Hussain',   'HR',          'HR Executive',          55000,  3,    '2022-01-10', TRUE),
(6,  'Zara Ahmed',      'Sales',       'Sales Executive',       58000,  5,    '2020-09-12', TRUE),
(7,  'Hassan Raza',     'Sales',       'Sales Executive',       62000,  5,    '2020-03-22', TRUE),
(9,  'Omar Sheikh',     'Finance',     'Analyst',               72000,  8,    '2021-11-15', TRUE),
(10, 'Fatima Zaidi',    'Finance',     'Analyst',               68000,  8,    '2022-03-01', TRUE),
(11, 'Kamran Baig',     'Engineering', 'Senior Engineer',       118000, 1,    '2019-08-19', TRUE),
(12, 'Saba Malik',      'Engineering', 'Junior Engineer',       60000,  1,    '2023-02-14', TRUE),
(14, 'Hina Siddiqui',   'Marketing',   'Marketing Executive',   52000,  13,   '2022-07-18', TRUE),
(15, 'Rizwan Khan',     'Marketing',   'Marketing Executive',   54000,  13,   '2021-12-05', TRUE),
(16, 'Madiha Awan',     'Sales',       'Sales Executive',       59000,  5,    '2023-05-09', FALSE),
(17, 'Faisal Nawaz',    'Engineering', 'Junior Engineer',       NULL,   1,    '2023-09-01', TRUE),
(18, 'Asma Chaudhry',   'HR',          'HR Executive',          53000,  3,    '2020-06-15', FALSE),
(19, 'Danish Malik',    'Finance',     'Senior Analyst',        85000,  8,    '2020-01-22', TRUE),
(20, 'Lubna Farooq',    'Marketing',   'Marketing Executive',   NULL,   13,   '2024-01-10', TRUE),
(21, 'Imran Siddiqui',  'Engineering', 'Senior Engineer',       115000, 1,    '2018-12-03', TRUE),
(22, 'Sadia Butt',      'Sales',       'Sales Executive',       61000,  5,    '2021-04-17', TRUE),
(23, 'Wasim Akram',     'HR',          'HR Executive',          57000,  3,    '2019-10-28', TRUE),
(24, 'Rabia Noor',      'Finance',     'Analyst',               70000,  8,    '2023-06-20', TRUE),
(25, 'Junaid Ali',      'Engineering', 'Junior Engineer',       63000,  1,    '2022-11-30', TRUE);


-- ============================================================
-- DML — UPDATE & DELETE
-- ============================================================

-- Q4. 10% salary raise for active Engineering employees hired before 2022
UPDATE employees
SET salary = salary * 1.1
WHERE department = 'Engineering'
  AND hire_date < '2022-01-01'
  AND is_active = TRUE;

-- Q5. Deactivate employees with NULL salary
UPDATE employees
SET is_active = FALSE
WHERE salary IS NULL;


-- ============================================================
-- DQL — BASIC TO INTERMEDIATE
-- ============================================================

-- Q6. Active employee count per department
SELECT
    department,
    COUNT(*) AS headcount
FROM employees
WHERE is_active = TRUE
GROUP BY department
ORDER BY headcount DESC;

-- Q7. Average salary per department (active employees only)
SELECT
    department,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
WHERE is_active = TRUE
  AND salary IS NOT NULL
GROUP BY department;

-- Q8. Employees earning more than their department average
SELECT
    e1.emp_name,
    e1.department,
    e1.salary,
    ROUND((SELECT AVG(e2.salary)
           FROM employees e2
           WHERE e2.department = e1.department
             AND e2.salary IS NOT NULL), 2) AS dept_avg_salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e1.department
      AND e2.salary IS NOT NULL
)
AND e1.is_active = TRUE;

-- Q9. Managers and their direct report counts (self-join)
SELECT
    m.emp_id,
    m.emp_name AS manager_name,
    COUNT(*) AS direct_reports
FROM employees e
INNER JOIN employees m ON e.manager_id = m.emp_id
GROUP BY m.emp_id, m.emp_name;

-- Q10. Departments where total salary bill exceeds 200,000
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 200000;


-- ============================================================
-- DQL — ADVANCED (CTEs, Window Functions)
-- ============================================================

-- Q11. Rank employees by salary within each department using DENSE_RANK()
SELECT
    emp_name,
    department,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees
WHERE salary IS NOT NULL;

-- Q12. Salary gap between each employee and the top earner in their department
SELECT
    emp_name,
    department,
    salary,
    MAX(salary) OVER (PARTITION BY department) AS dept_max_salary,
    MAX(salary) OVER (PARTITION BY department) - salary AS gap_from_top
FROM employees
WHERE salary IS NOT NULL;

-- Q13. Top earner per department using CTE + DENSE_RANK()
WITH ranked_salaries AS (
    SELECT
        emp_name,
        department,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
    WHERE salary IS NOT NULL
)
SELECT *
FROM ranked_salaries
WHERE salary_rank = 1;

-- Q14. Days between consecutive hires within each department using LAG()
SELECT
    emp_name,
    department,
    hire_date,
    LAG(hire_date) OVER (
        PARTITION BY department
        ORDER BY hire_date
    ) AS previous_hire_date,
    hire_date - LAG(hire_date) OVER (
        PARTITION BY department
        ORDER BY hire_date
    ) AS gap_in_days
FROM employees;

-- Q15. Employees earning below their department average (with shortfall)
WITH emp_info AS (
    SELECT emp_name, department, salary
    FROM employees
    WHERE salary IS NOT NULL
),
dept_avg AS (
    SELECT
        emp_name,
        department,
        salary,
        ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS avg_dept_salary
    FROM emp_info
)
SELECT *,
    ROUND(avg_dept_salary - salary, 2) AS shortfall
FROM dept_avg
WHERE salary < avg_dept_salary;

-- Q16. Running headcount (cumulative hires) over time
SELECT
    emp_name,
    hire_date,
    COUNT(*) OVER (ORDER BY hire_date) AS cumulative_headcount
FROM employees;

-- Q17. Pivot: count of Junior, Senior, and Manager level employees per department
SELECT
    department,
    COUNT(CASE WHEN job_title LIKE '%Junior%'  THEN 1 END) AS junior_count,
    COUNT(CASE WHEN job_title LIKE '%Senior%'  THEN 1 END) AS senior_count,
    COUNT(CASE WHEN job_title LIKE '%Manager%' THEN 1 END) AS manager_count
FROM employees
GROUP BY department;

-- Q18. Divide active employees into salary quartiles using NTILE(4)
SELECT
    emp_name,
    department,
    salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees
WHERE salary IS NOT NULL
  AND is_active = TRUE;

-- Q19. Employees hired more than a year before their manager
SELECT
    e.emp_name        AS employee_name,
    e.hire_date       AS employee_hire_date,
    m.emp_name        AS manager_name,
    m.hire_date       AS manager_hire_date
FROM employees e
INNER JOIN employees m ON e.manager_id = m.emp_id
WHERE e.hire_date < m.hire_date - INTERVAL '1 year';

-- Q20. Full reporting chain: employee -> manager (self-join)
SELECT
    e.emp_name AS employee_name,
    m.emp_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY m.emp_name;

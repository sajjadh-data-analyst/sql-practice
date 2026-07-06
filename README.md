# SQL Practice Datasets

A collection of self-built SQL practice datasets covering core to advanced concepts in PostgreSQL. Built as part of my ongoing data analytics learning journey.

---

## Datasets

### 1. Orders Dataset (`orders_practice.sql`)
A retail orders dataset with 20 rows simulating customer purchases across product categories.

**Concepts covered:**
- DDL: Table creation, ALTER TABLE, CHECK constraints
- DML: INSERT, UPDATE, DELETE, INITCAP for data cleaning
- DQL: GROUP BY, HAVING, subqueries, correlated subqueries
- Window Functions: RANK(), LAG(), running totals
- CTEs: Month-over-month revenue growth, customer spend analysis
- Pivot: CASE WHEN + SUM across categories

---

### 2. Employees Dataset (`employees_practice.sql`)
A company HR dataset with 25 rows covering departments, salaries, managers, and hire dates.

**Concepts covered:**
- DDL: Self-referencing foreign keys, named constraints
- DML: Conditional UPDATE, bulk INSERT with FK ordering
- DQL: Self-joins, correlated subqueries, aggregate filtering
- Window Functions: DENSE_RANK(), LAG(), NTILE(), running headcount
- CTEs: Department averages, top earners per department
- Pivot: Job level distribution per department

---

## How to Use

1. Open PostgreSQL (pgAdmin or psql)
2. Create a new database or use an existing one
3. Run the `.sql` file of your choice top to bottom
4. Each question is labelled with a comment (e.g. `-- Q1`, `-- Q8`)

---

## Skills Demonstrated

| Skill | Examples |
|---|---|
| Table design & constraints | Primary keys, foreign keys, CHECK, DEFAULT |
| Data cleaning | INITCAP, NULL handling, IS NOT NULL |
| Aggregation | SUM, AVG, COUNT with GROUP BY and HAVING |
| Subqueries | Correlated subqueries, scalar subqueries in SELECT |
| Window Functions | RANK, DENSE_RANK, LAG, NTILE, running totals |
| CTEs | Single and chained CTEs for multi-step analysis |
| Self-joins | Org hierarchy, manager lookup, consecutive row comparison |
| Pivoting | CASE WHEN + SUM/COUNT for cross-tab output |

---

## Background

I am a BBA Finance graduate transitioning into Data Analytics, building a portfolio of SQL, Power BI, and Python projects. This repository is part of my ongoing practice routine.

📌 [LinkedIn]([(https://www.linkedin.com/in/sajusays/)]) — connect with me for data analytics content posted regularly.

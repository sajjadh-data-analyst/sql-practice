-- ============================================================
-- ORDERS PRACTICE DATASET
-- Concepts: DDL, DML, DQL, CTEs, Window Functions
-- Dataset: Retail orders (20 rows)
-- ============================================================


-- ============================================================
-- DDL — TABLE CREATION
-- ============================================================

-- Q1. Create the orders table
CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    city        VARCHAR(50),
    product     VARCHAR(100),
    category    VARCHAR(50),
    quantity    INT,
    unit_price  INT,
    order_date  DATE,
    status      VARCHAR(20)
);

-- Q2. Add discount_pct column with default value
ALTER TABLE orders
ADD COLUMN discount_pct NUMERIC(4,1) DEFAULT 0;

-- Q3. Add CHECK constraint on unit_price (named explicitly)
ALTER TABLE orders
ADD CONSTRAINT chk_unit_price_positive CHECK (unit_price > 0);


-- ============================================================
-- DML — INSERT DATA
-- ============================================================

-- Q4. Insert all 20 rows
INSERT INTO orders (order_id, customer_name, city, product, category, quantity, unit_price, order_date, status) VALUES
(1,  'Ali Raza',       'Skardu',    'Trekking Boots', 'Footwear', 2,    4500,  '2024-01-05', 'Delivered'),
(2,  'sana khan',      'Lahore',    'Down Jacket',    'Apparel',  1,    12000, '2024-01-08', 'Delivered'),
(3,  'Bilal Ahmed',    'Karachi',   'Trekking Poles', 'Gear',     3,    1500,  '2024-01-10', 'Cancelled'),
(4,  'Ayesha Noor',    'Islamabad', 'Down Jacket',    'Apparel',  1,    12000, '2024-01-12', 'Delivered'),
(5,  'Ali Raza',       'Skardu',    'Sleeping Bag',   'Gear',     1,    7000,  '2024-02-01', 'Delivered'),
(6,  'Hassan Tariq',   NULL,        'Trekking Boots', 'Footwear', 1,    4500,  '2024-02-03', 'Pending'),
(7,  'sana khan',      'Lahore',    'Backpack 60L',   'Gear',     1,    8500,  '2024-02-15', 'Delivered'),
(8,  'Zara Iqbal',     'Multan',    'Trekking Boots', 'Footwear', 2,    4500,  '2024-02-18', 'Delivered'),
(9,  'Bilal Ahmed',    'Karachi',   'Down Jacket',    'Apparel',  1,    12000, '2024-03-01', 'Delivered'),
(10, 'Ayesha Noor',    'Islamabad', 'Sleeping Bag',   'Gear',     2,    7000,  '2024-03-05', 'Returned'),
(11, 'Usman Ali',      'Peshawar',  'Trekking Poles', 'Gear',     4,    1500,  '2024-03-10', 'Delivered'),
(12, 'Ali Raza',       'Skardu',    'Backpack 60L',   'Gear',     1,    8500,  '2024-03-15', 'Delivered'),
(13, 'Hassan Tariq',   'Quetta',    'Down Jacket',    'Apparel',  1,    12000, '2024-04-02', 'Delivered'),
(14, 'Zara Iqbal',     'Multan',    'Sleeping Bag',   'Gear',     1,    7000,  '2024-04-05', 'Pending'),
(15, 'sana khan',      'Lahore',    'Trekking Boots', 'Footwear', NULL, 4500,  '2024-04-10', 'Delivered'),
(16, 'Usman Ali',      'Peshawar',  'Backpack 60L',   'Gear',     2,    8500,  '2024-04-12', 'Delivered'),
(17, 'Bilal Ahmed',    'Karachi',   'Trekking Poles', 'Gear',     1,    1500,  '2024-05-01', 'Cancelled'),
(18, 'Ayesha Noor',    'Islamabad', 'Down Jacket',    'Apparel',  1,    12000, '2024-05-08', 'Delivered'),
(19, 'Ali Raza',       'Skardu',    'Trekking Boots', 'Footwear', 1,    4500,  '2024-05-20', 'Delivered'),
(20, 'Zara Iqbal',     'Multan',    'Backpack 60L',   'Gear',     1,    8500,  '2024-05-25', 'Delivered');


-- ============================================================
-- DML — UPDATE & DELETE
-- ============================================================

-- Q5. Update all Cancelled orders to set quantity = 0
UPDATE orders
SET quantity = 0
WHERE status = 'Cancelled';

-- Q6. Delete any order where quantity IS NULL
DELETE FROM orders
WHERE quantity IS NULL;

-- Q7. Fix inconsistent casing in customer_name (title case)
UPDATE orders
SET customer_name = INITCAP(customer_name);


-- ============================================================
-- DQL — BASIC TO INTERMEDIATE
-- ============================================================

-- Q8. Find all distinct cities (handle NULL)
SELECT DISTINCT city
FROM orders
WHERE city IS NOT NULL;

-- Q9. Total revenue per category for Delivered orders only
SELECT
    category,
    SUM(quantity * unit_price) AS total_revenue
FROM orders
WHERE status = 'Delivered'
GROUP BY category;

-- Q10. Customer(s) who placed the most orders
SELECT
    customer_name,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_name
HAVING COUNT(order_id) = (
    SELECT MAX(COUNT(order_id))
    FROM orders
    GROUP BY customer_name
);

-- Q11. Products appearing in more than one category (data quality check)
SELECT
    product,
    COUNT(DISTINCT category) AS category_count
FROM orders
GROUP BY product
HAVING COUNT(DISTINCT category) > 1;

-- Q12. Average order value per city, excluding cancelled orders
SELECT
    city,
    ROUND(AVG(quantity * unit_price), 2) AS avg_order_value
FROM orders
WHERE status <> 'Cancelled'
GROUP BY city
ORDER BY avg_order_value DESC;


-- ============================================================
-- DQL — ADVANCED (CTEs, Window Functions)
-- ============================================================

-- Q13. Rank customers by total spend (Delivered only), show top 3
SELECT
    customer_name,
    total_spent,
    customer_rank
FROM (
    SELECT
        customer_name,
        SUM(quantity * unit_price) AS total_spent,
        RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS customer_rank
    FROM orders
    WHERE status = 'Delivered'
    GROUP BY customer_name
) ranked
WHERE customer_rank <= 3;

-- Q14. First order, last order, and days between per customer
SELECT
    customer_name,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    MAX(order_date) - MIN(order_date) AS days_between_orders
FROM orders
GROUP BY customer_name;

-- Q15. Month-over-month revenue growth using CTEs
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(quantity * unit_price) AS revenue
    FROM orders
    WHERE status = 'Delivered'
    GROUP BY 1
),
mom_calc AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue,
    prev_month_revenue,
    ROUND(
        (revenue - prev_month_revenue) * 100.0 / prev_month_revenue, 2
    ) AS mom_growth_pct
FROM mom_calc;

-- Q16. Days gap between each customer's consecutive orders using LAG()
SELECT
    customer_name,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_name
        ORDER BY order_date
    ) AS previous_order_date,
    order_date - LAG(order_date) OVER (
        PARTITION BY customer_name
        ORDER BY order_date
    ) AS gap_in_days
FROM orders
ORDER BY customer_name, order_date;

-- Q17. Running total of revenue for Delivered orders ordered by date
SELECT
    order_id,
    order_date,
    quantity * unit_price AS order_value,
    SUM(quantity * unit_price) OVER (ORDER BY order_date) AS running_total
FROM orders
WHERE status = 'Delivered'
ORDER BY order_date;

-- Q18. Customers whose total spend exceeds the average total spend
WITH customer_spend AS (
    SELECT
        customer_name,
        SUM(quantity * unit_price) AS total_spent
    FROM orders
    GROUP BY customer_name
)
SELECT
    customer_name,
    total_spent
FROM customer_spend
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spend);

-- Q19. Pivot: total revenue per customer broken down by category
SELECT
    customer_name,
    SUM(CASE WHEN category = 'Footwear' THEN quantity * unit_price ELSE 0 END) AS footwear,
    SUM(CASE WHEN category = 'Apparel'  THEN quantity * unit_price ELSE 0 END) AS apparel,
    SUM(CASE WHEN category = 'Gear'     THEN quantity * unit_price ELSE 0 END) AS gear
FROM orders
GROUP BY customer_name;

-- Q20. Second highest order value per city using DENSE_RANK()
SELECT *
FROM (
    SELECT
        order_id,
        city,
        quantity * unit_price AS order_value,
        DENSE_RANK() OVER (
            PARTITION BY city
            ORDER BY quantity * unit_price DESC
        ) AS order_rank
    FROM orders
) ranked
WHERE order_rank = 2;

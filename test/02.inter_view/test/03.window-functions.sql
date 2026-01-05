-- // ─────────────────────────────────────
-- // ─────────────────────────────────────
-- 1. Ranking Functions (The "Top N" Solvers)
-- // ─────────────────────────────────────
-- // ─────────────────────────────────────

-- ROW_NUMBER()
-- Example: Assign a unique row number to each product ordered by price descending
SELECT name, price, ROW_NUMBER() OVER (
        ORDER BY price DESC
    ) AS row_num
FROM products;

-- RESULT:
-- +------------------------------+--------+---------+
-- | name                         | price  | row_num |
-- +------------------------------+--------+---------+
-- | Electric Bike                | 899.99 | 1       |
-- | Electric Bike                | 899.99 | 2       |
-- | Portable Solar Generator     | 399.99 | 3       |
-- | Portable Refrigerator Freezer| 299.99 | 4       |
-- | Window A/C Unit              | 299.99 | 5       |
-- | Wireless Security System     | 299.99 | 6       |
-- | Home Cleaning Robot          | 249.99 | 7       |
-- | Compact Digital Camera       | 249.99 | 8       |
-- | Portable USB-C Monitor       | 199.99 | 9       |
-- | Smartwatch                   | 199.99 | 10      |
-- +------------------------------+--------+---------+

-- RANK() -> Skips numbers after ties.
-- Example: Rank products by price (descending)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY price DESC
    ) AS row_num,
    name,
    price,
    RANK() OVER (
        ORDER BY price DESC
    ) AS price_rank
FROM products;

-- RESULT:
-- +---------+------------------------------+--------+------------+
-- | row_num | name                         | price  | price_rank |
-- +---------+------------------------------+--------+------------+
-- | 1       | Electric Bike                | 899.99 | 1          |
-- | 2       | Electric Bike                | 899.99 | 1          |
-- | 3       | Portable Solar Generator     | 399.99 | 3          |
-- | 4       | Portable Refrigerator Freezer| 299.99 | 4          |
-- | 5       | Window A/C Unit              | 299.99 | 4          |
-- | 6       | Wireless Security System     | 299.99 | 4          |
-- | 7       | Home Cleaning Robot          | 249.99 | 7          |
-- | 8       | Compact Digital Camera       | 249.99 | 7          |
-- | 9       | Portable USB-C Monitor       | 199.99 | 9          |
-- | 10      | Smartwatch                   | 199.99 | 9          |
-- +---------+------------------------------+--------+------------+

-- DENSE_RANK() -> No gaps in ranking numbers.
-- Example: Dense rank products by price (descending)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY price DESC
    ) AS row_num,
    name,
    price,
    DENSE_RANK() OVER (
        ORDER BY price DESC
    ) AS dense_price_rank
FROM products;

-- RESULT:
-- +---------+------------------------------+--------+------------------+
-- | row_num | name                         | price  | dense_price_rank |
-- +---------+------------------------------+--------+------------------+
-- | 1       | Electric Bike                | 899.99 | 1                |
-- | 2       | Electric Bike                | 899.99 | 1                |
-- | 3       | Portable Solar Generator     | 399.99 | 2                |
-- | 4       | Portable Refrigerator Freezer| 299.99 | 3                |
-- | 5       | Window A/C Unit              | 299.99 | 3                |
-- | 6       | Wireless Security System     | 299.99 | 3                |
-- | 7       | Home Cleaning Robot          | 249.99 | 4                |
-- | 8       | Compact Digital Camera       | 249.99 | 4                |
-- | 9       | Portable USB-C Monitor       | 199.99 | 5                |
-- | 10      | Smartwatch                   | 199.99 | 5                |
-- +---------+------------------------------+--------+------------------+

-- // ─────────────────────────────────────
-- // ─────────────────────────────────────
-- 2. Value Extraction (The "Time Travelers")
-- // ─────────────────────────────────────
-- // ─────────────────────────────────────

-- LAG(col, n) -> Access data from previous rows
-- Example: "How much did our sales increase or decrease compared to the previous recorded sale?"
-- 1. Get the sales amount from the PREVIOUS row
-- 2. Calculate the difference (Growth/Drop)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY sale_date
    ) AS row_num,
    sales.id,
    sale_date,
    amount as current_sales,
    LAG(amount, 1, 0) OVER (
        ORDER BY sale_date
    ) as previous_sales,
    amount - LAG(amount, 1, 0) OVER (
        ORDER BY sale_date
    ) as difference
FROM sales
ORDER BY sale_date;

-- RESULT:

-- +---------+-----+------------+---------------+----------------+------------+
-- | row_num | id  | sale_date  | current_sales | previous_sales | difference |
-- +---------+-----+------------+---------------+----------------+------------+
-- | 1       | 160 | 2024-01-01 | 1044          |        0       |     1044   |
-- | 2       | 726 | 2024-01-02 | 5308          |     1044       |     4264   |
-- | 3       | 690 | 2024-01-04 | 2990          |     5308       |    -2318   |
-- | 4       | 321 | 2024-01-04 | 7531          |     2990       |     4541   |
-- | 5       | 739 | 2024-01-05 | 2670          |     7531       |    -4861   |
-- | 6       | 568 | 2024-01-05 | 3493          |     2670       |      823   |
-- | 7       | 274 | 2024-01-05 | 7307          |     3493       |     3814   |
-- | 8       | 395 | 2024-01-06 | 9344          |     7307       |     2037   |
-- | 9       | 462 | 2024-01-06 | 5085          |     9344       |    -4259   |
-- | 10      | 411 | 2024-01-06 | 8589          |     5085       |     3504   |
-- +---------+-----+------------+---------------+----------------+------------+

-- LEAD(col, n) -> Access data from following rows
-- Example: "For every sale, tell me how many days passed until the next sale occurred?"
-- 1. Look AHEAD 1 row to see the Date of the next sale
-- 2. Calculate the gap (Next Date - Current Date)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY sale_date
    ) AS row_num,
    sales.id,
    sale_date,
    amount,
    LEAD(sale_date, 1) OVER (
        ORDER BY sale_date
    ) as next_sale_date,
    LEAD(sale_date, 1) OVER (
        ORDER BY sale_date
    ) - sale_date as days_until_next_sale
FROM sales
ORDER BY sale_date;

-- RESULT:

-- +---------+-----+------------+--------+----------------+-----------------------+
-- | row_num | id  | sale_date  | amount | next_sale_date | days_until_next_sale  |
-- +---------+-----+------------+--------+----------------+-----------------------+
-- | 1       | 160 | 2024-01-01 | 1044   | 2024-01-02     | 1                     |
-- | 2       | 726 | 2024-01-02 | 5308   | 2024-01-04     | 2                     |
-- | 3       | 690 | 2024-01-04 | 2990   | 2024-01-04     | 0                     |
-- | 4       | 321 | 2024-01-04 | 7531   | 2024-01-05     | 1                     |
-- | 5       | 739 | 2024-01-05 | 2670   | 2024-01-05     | 0                     |
-- | 6       | 568 | 2024-01-05 | 3493   | 2024-01-05     | 0                     |
-- | 7       | 274 | 2024-01-05 | 7307   | 2024-01-06     | 1                     |
-- | 8       | 395 | 2024-01-06 | 9344   | 2024-01-06     | 0                     |
-- | 9       | 462 | 2024-01-06 | 5085   | 2024-01-06     | 0                     |
-- | 10      | 411 | 2024-01-06 | 8589   | 2024-01-07     | 1                     |
-- +---------+-----+------------+--------+----------------+-----------------------+
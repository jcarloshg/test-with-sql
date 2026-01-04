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
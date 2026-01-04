-- Best Practice Example: List products with total available stock greater than 10
-- 1. Use explicit table aliases and reference primary key in GROUP BY for uniqueness
-- 2. Add clear formatting and comments for maintainability
-- 3. Use qualified column names for clarity
SELECT
    p.uuid AS product_uuid,
    p.name,
    SUM(s.available_quantity) AS total_available
FROM products AS p
    INNER JOIN stock AS s ON p.uuid = s.product_uuid
GROUP BY
    p.uuid,
    p.name
HAVING
    SUM(s.available_quantity) > 10;
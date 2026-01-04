-- count

SELECT COUNT(*) AS total from products;

-- sum
SELECT products.name, SUM(stock.available_quantity) AS total_available
from stock
    INNER JOIN products ON products.uuid = stock.product_uuid
GROUP BY
    products.name
ORDER BY total_available DESC;

-- min
-- Example: Find the product with the lowest price
SELECT name, price
FROM products
WHERE
    price = (
        SELECT MIN(price)
        FROM products
    );

SELECT MIN(price) FROM products;

-- avg
-- Example: Calculate the average price of all products
SELECT AVG(price) FROM products;
-- Example: Find products with a price below the average price
SELECT count(*) AS total_cheap_products
FROM products
WHERE
    price < (
        SELECT AVG(price)
        FROM products
    );
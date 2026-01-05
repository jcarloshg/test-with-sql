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

-- RESULT:
-- +--------------------------------------+-------------------------------+----------------+
-- | product_uuid                        | name                          | total_available|
-- +--------------------------------------+-------------------------------+----------------+
-- | a6394397-b61e-4651-a821-a67371deadd2| Biodegradable Dog Waste Bags  | 44             |
-- | d5eae0f2-1a0a-4ff6-bdb2-b553fde47e44| Chocolate Fudge Brownie Mix   | 75             |
-- | a4d54661-acad-4a7a-9516-2546d07618c7| Fall-Themed Table Runner      | 93             |
-- | 419b8295-5c1f-4413-baab-dec0d123f89f| Artisan Flatbreads            | 76             |
-- | e6a317a4-658b-40b9-83f3-5d628c420dfa| Luxury Rolling Makeup Case    | 75             |
-- | 9188087b-2d50-46cd-a6ce-d7723e9cca5e| Folding Pocket Knife          | 98             |
-- | a759ea5b-4c16-47c8-a93a-9d849a59f089| Interactive Robot Toy         | 42             |
-- | ff44c529-86b0-43b2-9d01-bae8307a73bf| Ready-to-Eat Chili            | 17             |
-- | bfafb80d-6b18-49a9-a49e-e7b74a9bbc4f| Mint Chocolate Chip Ice Cream | 61             |
-- | 26d53f85-c6c9-4551-a575-22438cba71a1| Pasta Maker                   | 85             |
-- +--------------------------------------+-------------------------------+----------------+
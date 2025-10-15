-- // ─────────────────────────────────────
-- // ─────────────────────────────────────
-- -- UP
-- // ─────────────────────────────────────
-- // ─────────────────────────────────────
ALTER TABLE products
ADD FULLTEXT name_description (name, description);

SELECT *
FROM products
WHERE
    MATCH(name, description) AGAINST (
        'Sauce' IN NATURAL LANGUAGE MODE
    );

-- // ─────────────────────────────────────
-- // ─────────────────────────────────────
-- -- DOWN
-- // ─────────────────────────────────────
-- // ─────────────────────────────────────

ALTER TABLE products DROP INDEX name_description;
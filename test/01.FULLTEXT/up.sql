ALTER TABLE products ADD FULLTEXT name_description (name, description);

-- DOWN
ALTER TABLE products DROP INDEX name_description;

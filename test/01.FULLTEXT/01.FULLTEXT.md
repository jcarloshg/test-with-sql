# FULLTEXT Search Implementation

This project demonstrates the implementation of MySQL's FULLTEXT search functionality for efficient text-based queries on product data.

## Overview

FULLTEXT search is a MySQL feature that allows for fast and efficient searching of text content within columns. It's particularly useful for searching large amounts of text data and provides better performance than traditional `LIKE` queries.

## Implementation Details

### Database Schema

The implementation uses a `products` table with the following structure:
- `uuid`: Primary key
- `name`: Product name (VARCHAR)
- `description`: Product description (TEXT)
- `price`: Product price

### FULLTEXT Index Creation

A composite FULLTEXT index is created on the `name` and `description` columns:

```sql
ALTER TABLE products
ADD FULLTEXT name_description (name, description);
```

### Search Query

The implementation demonstrates searching for products using natural language mode:

```sql
SELECT *
FROM products
WHERE MATCH(name, description) AGAINST (
    'Sauce' IN NATURAL LANGUAGE MODE
);
```

## Features

- **Natural Language Search**: Uses MySQL's natural language mode for intuitive text searches
- **Multi-Column Search**: Searches across both product name and description simultaneously
- **Relevance Scoring**: Results are automatically sorted by relevance to the search term

## Benefits

1. **Performance**: FULLTEXT indexes provide faster search compared to `LIKE '%term%'` queries
2. **Relevance**: Built-in relevance scoring ensures most relevant results appear first
3. **Flexibility**: Supports various search modes (natural language, boolean, query expansion)

## Usage Example

To search for products containing "Sauce":
```sql
SELECT uuid, name, description, price
FROM products
WHERE MATCH(name, description) AGAINST ('Sauce' IN NATURAL LANGUAGE MODE);
```

## Cleanup

To remove the FULLTEXT index:
```sql
ALTER TABLE products DROP INDEX name_description;
```

## Requirements

- MySQL 5.6+ (for InnoDB FULLTEXT support)
- Minimum word length: 4 characters (default MySQL setting)
- Text columns must be of type CHAR, VARCHAR, or TEXT

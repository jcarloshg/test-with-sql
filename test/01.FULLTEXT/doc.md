# FULLTEXT

Full-text search allows you to perform sophisticated text searches across database columns, going beyond simple LIKE patterns to provide more intelligent and performant text matching capabilities.

## PostgreSQL Full-Text Search

PostgreSQL provides built-in full-text search functionality through several key components:

### 1. Text Search Vectors (tsvector)
- Converts text into a normalized, searchable format
- Removes stop words and applies stemming
- Stores the processed text for efficient searching

### 2. Text Search Queries (tsquery)
- Represents search queries in a structured format
- Supports operators like AND (&), OR (|), and NOT (!)
- Allows phrase searches and proximity matching

### 3. Text Search Configuration
- Determines language-specific rules for processing text
- Controls stemming, stop words, and tokenization
- Default configuration is usually 'english'

## Implementation Examples

### Adding Full-Text Search to Products Table

```sql
-- Add a tsvector column for full-text search
ALTER TABLE products 
ADD COLUMN search_vector tsvector;

-- Create a function to update the search vector
CREATE OR REPLACE FUNCTION update_product_search_vector()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', 
        COALESCE(NEW.name, '') || ' ' || 
        COALESCE(NEW.description, '')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update search vector
CREATE TRIGGER update_product_search_vector_trigger
    BEFORE INSERT OR UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_product_search_vector();

-- Create GIN index for fast full-text searches
CREATE INDEX products_search_idx ON products USING GIN(search_vector);
```

### Basic Search Queries

```sql
-- Simple text search
SELECT * FROM products 
WHERE search_vector @@ to_tsquery('english', 'laptop');

-- Search with multiple terms (AND)
SELECT * FROM products 
WHERE search_vector @@ to_tsquery('english', 'laptop & gaming');

-- Search with OR condition
SELECT * FROM products 
WHERE search_vector @@ to_tsquery('english', 'laptop | desktop');

-- Search with NOT condition
SELECT * FROM products 
WHERE search_vector @@ to_tsquery('english', 'laptop & !refurbished');

-- Phrase search
SELECT * FROM products 
WHERE search_vector @@ phraseto_tsquery('english', 'gaming laptop');
```

### Advanced Search with Ranking

```sql
-- Search with relevance ranking
SELECT 
    uuid,
    name,
    description,
    ts_rank(search_vector, to_tsquery('english', 'laptop')) as rank
FROM products 
WHERE search_vector @@ to_tsquery('english', 'laptop')
ORDER BY rank DESC;

-- Search with headline highlighting
SELECT 
    uuid,
    name,
    ts_headline('english', description, to_tsquery('english', 'laptop')) as highlighted_description
FROM products 
WHERE search_vector @@ to_tsquery('english', 'laptop');
```

## Use Cases in Our Database

### Product Search
- Search products by name and description
- Implement autocomplete functionality
- Filter products by keywords
- Rank results by relevance

### User Search
- Find users by username or profile information
- Support partial name matching

### Advanced Features

#### 1. Weighted Search
```sql
-- Weight name more heavily than description
UPDATE products SET search_vector = 
    setweight(to_tsvector('english', name), 'A') ||
    setweight(to_tsvector('english', COALESCE(description, '')), 'B');
```

#### 2. Fuzzy Search
```sql
-- Use similarity for typo-tolerant search
SELECT * FROM products 
WHERE similarity(name, 'laptp') > 0.3  -- handles typos like 'laptp' -> 'laptop'
ORDER BY similarity(name, 'laptp') DESC;
```

#### 3. Multi-language Support
```sql
-- Support different languages
SELECT * FROM products 
WHERE search_vector @@ to_tsquery('spanish', 'ordenador');
```

## Performance Considerations

1. **Indexes**: Always create GIN or GiST indexes on tsvector columns
2. **Triggers**: Use triggers to keep search vectors updated automatically
3. **Materialized Views**: Consider for complex search scenarios
4. **Partial Indexes**: For frequently searched subsets of data

## Best Practices

1. **Normalize Data**: Clean and normalize text before indexing
2. **Stop Words**: Configure appropriate stop words for your domain
3. **Testing**: Test search queries with real data to ensure relevance
4. **Monitoring**: Monitor query performance and adjust indexes as needed

## Common Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `&` | AND | `laptop & gaming` |
| `|` | OR | `laptop | desktop` |
| `!` | NOT | `laptop & !refurbished` |
| `<->` | Followed by | `quick <-> brown` |
| `<N>` | Within N words | `quick <2> fox` |

## Useful Functions

- `to_tsvector()` - Convert text to tsvector
- `to_tsquery()` - Convert text to tsquery
- `plainto_tsquery()` - Simple query conversion
- `phraseto_tsquery()` - Phrase search
- `ts_rank()` - Calculate relevance rank
- `ts_headline()` - Generate highlighted snippets

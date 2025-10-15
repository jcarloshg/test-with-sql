# 🗃️ Test with SQL

A PostgreSQL database project with Docker containerization, featuring an e-commerce-like schema for managing users, products, stock, and reservations. This project includes automated data generation scripts and a complete database setup with sample data.

## 📋 Index

## 🎯 Project Overview

This project demonstrates a complete SQL database implementation with:

- **📊 Database Schema**: Users, Products, Stock, and Reservations tables with proper relationships
- **🐳 Docker Setup**: Containerized PostgreSQL database with automated initialization
- **⚙️ Data Generation**: TypeScript scripts to generate sample data and SQL insert statements
- **📦 Sample Data**: Pre-populated database with realistic e-commerce data

## 📊 Database Schema

### 🗂️ Tables Structure

#### 👥 Users

- `uuid` (UUID, Primary Key): Unique user identifier
- `username` (VARCHAR): User's display name
- `password` (VARCHAR): User's password

#### 🛍️ Products

- `uuid` (UUID, Primary Key): Unique product identifier
- `name` (VARCHAR): Product name
- `description` (TEXT): Product description
- `price` (DECIMAL): Product price

#### 📦 Stock

- `uuid` (UUID, Primary Key): Unique stock record identifier
- `product_uuid` (UUID, Foreign Key): Reference to products table
- `available_quantity` (INTEGER): Available inventory count
- `reserved_quantity` (INTEGER): Reserved inventory count

#### 📝 Reservations

- `uuid` (UUID, Primary Key): Unique reservation identifier
- `user_uuid` (UUID, Foreign Key): Reference to users table
- `product_id` (UUID, Foreign Key): Reference to products table
- `quantity` (INTEGER): Reserved quantity
- `status` (VARCHAR): Reservation status (PENDING, CONFIRMED, CANCELLED, EXPIRED)
- `expires_at` (TIMESTAMP): Expiration timestamp for the reservation

### 🔗 Entity Relationships

- Products → Stock (One-to-One): Each product has one stock record
- Users → Reservations (One-to-Many): Users can have multiple reservations
- Products → Reservations (One-to-Many): Products can be reserved by multiple users

## 🚀 Quick Start

### 📋 Prerequisites

- Docker and Docker Compose installed
- (Optional) Node.js and TypeScript for running data generation scripts

### 1️⃣ Start the Database

```bash
# Clone or navigate to the project directory
cd test-with-sql

# Start the PostgreSQL container
docker-compose up -d

# Check if the container is running
docker-compose ps
```

### 2️⃣ Connect to the Database

The database will be available at:

- **🌐 Host**: localhost
- **🔌 Port**: 5432
- **💾 Database**: db_for_commands
- **👤 Username**: admin
- **🔑 Password**: 123456

#### 💻 Using psql (if installed):

```bash
psql -h localhost -p 5432 -U admin -d db_for_commands
```

#### 🐳 Using Docker exec:

```bash
docker exec -it db-commands-service psql -U admin -d db_for_commands
```

### 3️⃣ Verify the Setup

Once connected, you can verify the installation:

```sql
-- View sample data
SELECT COUNT(*) FROM users;     -- Should return 4
SELECT COUNT(*) FROM products;  -- Should return ~1500
SELECT COUNT(*) FROM stock;     -- Should return ~1500

-- Sample queries
SELECT u.username, COUNT(r.uuid) as reservations_count
FROM users u
LEFT JOIN reservations r ON u.uuid = r.user_uuid
GROUP BY u.uuid, u.username;

SELECT p.name, s.available_quantity, s.reserved_quantity
FROM products p
JOIN stock s ON p.uuid = s.product_uuid
ORDER BY p.name
LIMIT 10;
```

## ⚙️ Data Generation Scripts

The project includes TypeScript utilities for generating and managing sample data:

### 📄 generate-scrits.ts

Reads JSON files and generates SQL INSERT statements for:

- Users data from `users.json`
- Products data from `products.json`
- Stock data from `stock.json`

### 📊 create-stock-json.ts

Generates stock records for all products with random:

- Available quantities (1-100)
- Reserved quantities (0 to available_quantity)

### ▶️ Running the Scripts

```bash
# Navigate to scripts directory
cd scripts

# Generate stock data (creates stock.json)
npx ts-node create-stock-json.ts

# Generate SQL inserts (creates 02.insert-data.sql)
npx ts-node generate-scrits.ts
```

## 📊 Sample Data

### 👥 Users (4 records)

- Andree (Andree123)
- John (John123)
- Jane (Jane123)
- Peter (Peter123)

### 🛍️ Products (~1500 records)

Diverse product catalog including:

- 📱 Electronics (headphones, thermometers, mirrors)
- 🍕 Food & Beverages (ice cream, coffee, snacks)
- 🏠 Home & Garden (furniture, tools, decor)
- 💄 Health & Beauty (skincare, supplements)

### 📦 Stock Records

Each product has corresponding stock with realistic inventory levels.

## 💻 Development Notes

### 🐳 Docker Configuration

- Uses PostgreSQL 15.13 official image
- Automatic database initialization via `/docker-entrypoint-initdb.d/`
- Persistent data storage with named volume `db-commands-vol`
- Environment variables for database credentials

### 🚀 Migration Strategy

- Migrations are stored in dated folders under `migrations/`
- Current migration: `2025-10-11/`
- Schema creation and data insertion are separated into different files

### 🔒 Data Integrity

- UUID primary keys for all tables
- Foreign key constraints maintain referential integrity
- CHECK constraints for reservation status validation
- NOT NULL constraints on essential fields

## 🛠️ Troubleshooting

### 💡 Useful Commands

```bash
# View container logs
docker-compose logs -f db-commands-service

# Stop and remove everything
docker-compose down -v

# Rebuild container
docker-compose build --no-cache
docker-compose up -d

# Execute SQL file directly
docker exec -i db-commands-service psql -U admin -d db_for_commands < your-script.sql
```

## 🤝 Contributing

When adding new migrations or modifying the schema:

1. Create a new dated folder under `migrations/`
2. Update the Dockerfile to copy new migration files
3. Test with a fresh container deployment
4. Update this documentation accordingly

## 📄 License

This project is for educational/testing purposes.

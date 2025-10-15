# 🗃️ Test with SQL

A PostgreSQL database project with Docker containerization, featuring an e-commerce-like schema for managing users, products, stock, and reservations. This project includes automated data generation scripts and a complete database setup with sample data.

## 📋 Index

## 01 🔍 FULLTEXT Search Implementation

FULLTEXT search is a MySQL feature that allows for fast and efficient searching of text content within columns. It's particularly useful for searching large amounts of text data and provides better performance than traditional `LIKE` queries.

- 📄 [About Info](test/01.FULLTEXT/01.FULLTEXT.md)
- 💾 [Script SQL](test/01.FULLTEXT/implementation.sql)

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

## 📄 License

This project is for educational/testing purposes.

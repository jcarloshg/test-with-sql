CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create Users table
CREATE TABLE users (
    uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Create Products table
CREATE TABLE products (
    uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL
);

-- Create Stock table
CREATE TABLE stock (
    uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    product_uuid UUID NOT NULL,
    available_quantity INTEGER NOT NULL DEFAULT 0,
    reserved_quantity INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (product_uuid) REFERENCES products (uuid)
);

-- Clean up previous tests
DROP TABLE IF EXISTS sales;

DROP TABLE IF EXISTS employees;

-- 1. Employees Table (For Ranking & Partitioning)
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- 2. Sales Table (For Time Travel & Running Totals)
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    sale_date DATE,
    amount INT
);
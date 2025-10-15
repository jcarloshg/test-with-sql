-- Create Users table
CREATE TABLE users (
    uuid VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Create Products table
CREATE TABLE products (
    uuid VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL
);

-- Create Stock table
CREATE TABLE stock (
    uuid VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    product_uuid VARCHAR(36) NOT NULL,
    available_quantity INT NOT NULL DEFAULT 0,
    reserved_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (product_uuid) REFERENCES products (uuid)
);

-- Create Reservations table
CREATE TABLE reservations (
    uuid VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_uuid VARCHAR(36) NOT NULL,
    product_id VARCHAR(36) NOT NULL,
    quantity INT NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (
        status IN (
            'PENDING',
            'CONFIRMED',
            'CANCELLED',
            'EXPIRED'
        )
    ),
    expires_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_uuid) REFERENCES users (uuid),
    FOREIGN KEY (product_id) REFERENCES products (uuid)
);
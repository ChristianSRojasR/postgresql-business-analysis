
-- =========================================
-- 1. CREACION DE TABLAS
-- =========================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    region VARCHAR(50),
    segment VARCHAR(30)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_cost NUMERIC(12,2),
    unit_price NUMERIC(12,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    status VARCHAR(20)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL
);

CREATE TABLE inventory_movements (
    movement_id INT PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    movement_date DATE NOT NULL,
    movement_type VARCHAR(30),
    quantity_signed INT NOT NULL

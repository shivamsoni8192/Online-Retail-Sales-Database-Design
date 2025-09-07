-- Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT
);

-- Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2),
    stock INT
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- OrderItems Table
CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_date DATETIME,
    amount DECIMAL(10,2),
    method VARCHAR(20),
    status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert Sample Data
INSERT INTO Customers (first_name, last_name, email, phone, address) VALUES
('Ravi', 'Kumar', 'ravi.kumar@example.com', '9876543210', 'Delhi'),
('Priya', 'Sharma', 'priya.sharma@example.com', '9123456789', 'Mumbai');

INSERT INTO Products (name, description, price, stock) VALUES
('Laptop', 'Lenovo ThinkPad T540p', 55000.00, 10),
('Smartphone', 'Samsung Galaxy S21', 70000.00, 15),
('Headphones', 'Sony WH-1000XM4', 25000.00, 20);

INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, NOW(), 'Confirmed'),
(2, NOW(), 'Shipped');

INSERT INTO OrderItems (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 55000.00),
(1, 3, 2, 50000.00),
(2, 2, 1, 70000.00);

INSERT INTO Payments (order_id, payment_date, amount, method, status) VALUES
(1, NOW(), 105000.00, 'Credit Card', 'Success'),
(2, NOW(), 70000.00, 'UPI', 'Pending');

-- Queries & Views

-- 1. Show all orders with customer details
SELECT o.order_id, c.first_name, c.last_name, o.order_date, o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- 2. Show order items with product details
SELECT oi.order_item_id, p.name, oi.quantity, oi.subtotal
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id;

-- 3. Show payments report
SELECT p.payment_id, o.order_id, p.amount, p.method, p.status
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id;

-- 4. Create a sales report view
CREATE VIEW SalesReport AS
SELECT o.order_id, c.first_name, c.last_name, SUM(oi.subtotal) AS total_amount, p.status AS payment_status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY o.order_id, c.first_name, c.last_name, p.status;
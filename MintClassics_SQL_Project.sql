
-- Step 1: Database Setup
-- Import the mintclassicsDB.sql file and verify tables
SHOW TABLES;

-- Step 2: Database Exploration
-- Inspecting the structure of the customers table
DESCRIBE customers;

-- Fetching sample data from customers and products tables
SELECT * FROM customers LIMIT 5;
SELECT * FROM products LIMIT 5;

-- Step 3: Business Queries
-- 1. Customer Insights: Top 5 customers by total payments
SELECT 
    c.customerName, 
    SUM(p.amount) AS total_payments
FROM customers c
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY total_payments DESC
LIMIT 5;

-- 2. Sales Insights: Total revenue generated
SELECT SUM(amount) AS total_revenue FROM payments;

-- Revenue by product line
SELECT 
    pl.productLine, 
    SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY pl.productLine
ORDER BY revenue DESC;

-- 3. Order Analysis: Top 5 most ordered products
SELECT 
    p.productName, 
    SUM(od.quantityOrdered) AS total_quantity
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productCode, p.productName
ORDER BY total_quantity DESC
LIMIT 5;

-- 4. Employee Performance: Total sales managed by each employee
SELECT 
    e.employeeNumber, 
    CONCAT(e.firstName, ' ', e.lastName) AS employee_name, 
    SUM(p.amount) AS total_sales
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY e.employeeNumber
ORDER BY total_sales DESC;

-- Step 4: Advanced Analysis
-- 1. Monthly revenue trends
SELECT 
    DATE_FORMAT(o.orderDate, '%Y-%m') AS month, 
    SUM(od.quantityOrdered * od.priceEach) AS monthly_revenue
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY month
ORDER BY month;

-- 2. Customer Loyalty: Number of orders per customer
SELECT 
    c.customerName, 
    COUNT(o.orderNumber) AS order_count
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerName
ORDER BY order_count DESC
LIMIT 10;

-- Step 5: Reports and Visualization
-- Exporting a sample report to CSV (modify path as needed)
SELECT * FROM customers INTO OUTFILE '/tmp/customers_report.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

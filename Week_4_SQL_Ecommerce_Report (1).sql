-- ============================================================
-- WEEK 4 PROJECT: SQL E-COMMERCE REPORT
-- DBMS: MySQL 8.x
-- Topics: Top Products, Customer Spend, NULL Handling,
--         JOINs, Aggregation, Subqueries, DDL Constraints
-- 35+ SQL Queries
-- ============================================================

DROP DATABASE IF EXISTS ecommerce_week4;
CREATE DATABASE ecommerce_week4;
USE ecommerce_week4;

-- ============================================================
-- 1. DDL: TABLE CREATION + CONSTRAINTS
-- ============================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    city VARCHAR(80),
    state VARCHAR(80),
    signup_date DATE NOT NULL,
    phone VARCHAR(20) UNIQUE
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    supplier VARCHAR(120),
    rating DECIMAL(2,1),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    shipping_city VARCHAR(80),
    coupon_code VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CHECK (status IN ('Pending','Processing','Shipped','Delivered','Cancelled'))
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    UNIQUE (order_id, product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_date DATE,
    payment_method VARCHAR(30),
    amount DECIMAL(10,2),
    payment_status VARCHAR(30) DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CHECK (amount IS NULL OR amount >= 0)
);

-- ============================================================
-- 2. SAMPLE DATA
-- ============================================================

INSERT INTO categories VALUES
(1,'Electronics'),
(2,'Fashion'),
(3,'Home & Kitchen'),
(4,'Books'),
(5,'Sports');

INSERT INTO customers VALUES
(101,'Aarav Sharma','aarav@gmail.com','Bengaluru','Karnataka','2025-01-15','9000000001'),
(102,'Priya Nair','priya@gmail.com','Kochi','Kerala','2025-02-20','9000000002'),
(103,'Rahul Verma','rahul@gmail.com','Delhi','Delhi','2025-03-05',NULL),
(104,'Sneha Rao','sneha@gmail.com','Bengaluru','Karnataka','2025-03-18','9000000004'),
(105,'Vikram Singh','vikram@gmail.com','Mumbai','Maharashtra','2025-04-10',NULL),
(106,'Ananya Das','ananya@gmail.com','Kolkata','West Bengal','2025-05-12','9000000006'),
(107,'Karan Mehta','karan@gmail.com','Pune','Maharashtra','2025-06-08','9000000007'),
(108,'Neha Gupta','neha@gmail.com','Jaipur','Rajasthan','2025-07-14',NULL),
(109,'Rohan Iyer','rohan@gmail.com','Chennai','Tamil Nadu','2025-08-01','9000000009'),
(110,'Meera Joshi','meera@gmail.com','Hyderabad','Telangana','2025-08-22','9000000010');

INSERT INTO products VALUES
(201,'Wireless Headphones',1,2499.00,45,'SoundMax',4.5),
(202,'Smart Watch',1,3999.00,30,'TechWorld',4.3),
(203,'Bluetooth Speaker',1,1799.00,60,'SoundMax',4.2),
(204,'Running Shoes',5,2999.00,25,'SportPro',4.6),
(205,'Yoga Mat',5,899.00,80,'FitLife',4.4),
(206,'T-Shirt',2,699.00,100,'UrbanWear',4.1),
(207,'Jeans',2,1599.00,55,'UrbanWear',4.0),
(208,'Coffee Maker',3,3499.00,20,'HomeBrew',4.5),
(209,'Non-Stick Pan',3,1299.00,40,'KitchenPlus',4.2),
(210,'Python Programming Book',4,799.00,70,'TechBooks',4.7),
(211,'SQL Fundamentals',4,649.00,65,'TechBooks',4.6),
(212,'Cricket Bat',5,2499.00,15,'SportPro',4.3);

INSERT INTO orders VALUES
(1001,101,'2025-09-01','Delivered','Bengaluru','SAVE10'),
(1002,102,'2025-09-03','Delivered','Kochi',NULL),
(1003,103,'2025-09-05','Shipped','Delhi','WELCOME'),
(1004,101,'2025-09-08','Delivered','Bengaluru',NULL),
(1005,104,'2025-09-10','Processing','Bengaluru','SAVE10'),
(1006,105,'2025-09-12','Cancelled','Mumbai',NULL),
(1007,106,'2025-09-15','Delivered','Kolkata','FESTIVE'),
(1008,107,'2025-09-17','Shipped','Pune',NULL),
(1009,108,'2025-09-20','Pending','Jaipur',NULL),
(1010,109,'2025-09-22','Delivered','Chennai','SAVE10'),
(1011,110,'2025-09-24','Delivered','Hyderabad',NULL),
(1012,104,'2025-09-25','Delivered','Bengaluru','FESTIVE');

INSERT INTO order_items VALUES
(1,1001,201,2,2499.00),
(2,1001,205,1,899.00),
(3,1002,202,1,3999.00),
(4,1002,206,2,699.00),
(5,1003,210,2,799.00),
(6,1003,211,1,649.00),
(7,1004,204,1,2999.00),
(8,1004,203,1,1799.00),
(9,1005,208,1,3499.00),
(10,1005,209,2,1299.00),
(11,1006,212,1,2499.00),
(12,1007,207,2,1599.00),
(13,1007,206,1,699.00),
(14,1008,201,1,2499.00),
(15,1008,203,2,1799.00),
(16,1009,205,2,899.00),
(17,1010,202,1,3999.00),
(18,1010,210,1,799.00),
(19,1011,208,1,3499.00),
(20,1011,209,1,1299.00),
(21,1012,201,1,2499.00),
(22,1012,211,2,649.00);

INSERT INTO payments VALUES
(501,1001,'2025-09-01','UPI',5897.00,'Paid'),
(502,1002,'2025-09-03','Card',5397.00,'Paid'),
(503,1003,'2025-09-05','UPI',2247.00,'Paid'),
(504,1004,'2025-09-08','Card',4798.00,'Paid'),
(505,1005,'2025-09-10','UPI',6097.00,'Pending'),
(506,1006,NULL,'Card',2499.00,'Refunded'),
(507,1007,'2025-09-15','COD',3897.00,'Paid'),
(508,1008,'2025-09-17','UPI',6097.00,'Paid'),
(509,1009,NULL,NULL,NULL,'Pending'),
(510,1010,'2025-09-22','Card',4798.00,'Paid'),
(511,1011,'2025-09-24','UPI',4798.00,'Paid'),
(512,1012,'2025-09-25','Card',3797.00,'Paid');

-- ============================================================
-- 3. BASIC SQL QUERIES
-- ============================================================

-- Q1. Display all customers
SELECT * FROM customers;

-- Q2. Display all products
SELECT * FROM products;

-- Q3. Display products costing more than 2000
SELECT product_id, product_name, price
FROM products
WHERE price > 2000;

-- Q4. Display products in ascending price order
SELECT product_name, price
FROM products
ORDER BY price ASC;

-- Q5. Display the five most expensive products
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 5;

-- Q6. Display customers from Karnataka
SELECT *
FROM customers
WHERE state = 'Karnataka';

-- Q7. Display delivered orders
SELECT *
FROM orders
WHERE status = 'Delivered';

-- ============================================================
-- 4. AGGREGATION + TOP PRODUCTS
-- ============================================================

-- Q8. Count total customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q9. Count total products
SELECT COUNT(*) AS total_products
FROM products;

-- Q10. Average product price
SELECT ROUND(AVG(price),2) AS average_product_price
FROM products;

-- Q11. Maximum and minimum product price
SELECT MAX(price) AS max_price,
       MIN(price) AS min_price
FROM products;

-- Q12. Total stock available
SELECT SUM(stock) AS total_stock
FROM products;

-- Q13. Products by category
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;

-- Q14. Top products by units sold
SELECT p.product_name,
       SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC;

-- Q15. Top products by sales revenue
SELECT p.product_name,
       ROUND(SUM(oi.quantity * oi.unit_price),2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- Q16. Category-wise revenue
SELECT c.category_name,
       ROUND(SUM(oi.quantity * oi.unit_price),2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC;

-- Q17. Products with total sales above 3000
SELECT p.product_name,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * oi.unit_price) > 3000
ORDER BY revenue DESC;

-- ============================================================
-- 5. CUSTOMER SPEND REPORT
-- ============================================================

-- Q18. Customer-wise total spending
SELECT c.customer_id,
       c.customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price),2) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spend DESC;

-- Q19. Top 5 customers by spending
SELECT c.customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price),2) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spend DESC
LIMIT 5;

-- Q20. Number of orders per customer
SELECT c.customer_name,
       COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY order_count DESC;

-- Q21. Average order value per customer
SELECT c.customer_name,
       ROUND(AVG(order_total.total_amount),2) AS avg_order_value
FROM customers c
JOIN (
    SELECT o.order_id, o.customer_id,
           SUM(oi.quantity * oi.unit_price) AS total_amount
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status <> 'Cancelled'
    GROUP BY o.order_id, o.customer_id
) AS order_total
ON c.customer_id = order_total.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY avg_order_value DESC;

-- Q22. Customers who spent more than 5000
SELECT c.customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price),2) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.customer_name
HAVING SUM(oi.quantity * oi.unit_price) > 5000;

-- ============================================================
-- 6. JOINS
-- ============================================================

-- Q23. Customer + order details
SELECT c.customer_name, o.order_id, o.order_date, o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date;

-- Q24. Product + category details
SELECT p.product_name, c.category_name, p.price
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;

-- Q25. Order + customer + product details
SELECT o.order_id,
       c.customer_name,
       p.product_name,
       oi.quantity,
       oi.unit_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- Q26. LEFT JOIN: all customers including customers without orders
SELECT c.customer_id, c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- Q27. Payment details with customer names
SELECT o.order_id,
       c.customer_name,
       pay.payment_method,
       pay.amount,
       pay.payment_status
FROM payments pay
JOIN orders o ON pay.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id;

-- Q28. Products never ordered
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- ============================================================
-- 7. NULL HANDLING
-- ============================================================

-- Q29. Display customers whose phone number is NULL
SELECT customer_id, customer_name, phone
FROM customers
WHERE phone IS NULL;

-- Q30. Replace NULL phone with 'Not Provided'
SELECT customer_name,
       COALESCE(phone, 'Not Provided') AS phone
FROM customers;

-- Q31. Replace NULL coupon with 'No Coupon'
SELECT order_id,
       COALESCE(coupon_code, 'No Coupon') AS coupon
FROM orders;

-- Q32. Replace NULL payment amount with 0
SELECT order_id,
       COALESCE(amount, 0) AS payment_amount
FROM payments;

-- Q33. Replace NULL payment method with 'Not Available'
SELECT order_id,
       COALESCE(payment_method, 'Not Available') AS payment_method
FROM payments;

-- ============================================================
-- 8. SUBQUERIES + CASE
-- ============================================================

-- Q34. Products priced above the average price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Q35. Customers with at least one delivered order
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE status = 'Delivered'
);

-- Q36. Most expensive product
SELECT product_name, price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- Q37. Classify products by price
SELECT product_name, price,
       CASE
           WHEN price >= 3000 THEN 'Premium'
           WHEN price >= 1500 THEN 'Mid-Range'
           ELSE 'Budget'
       END AS price_category
FROM products;

-- Q38. Classify orders by status
SELECT order_id, status,
       CASE
           WHEN status = 'Delivered' THEN 'Completed'
           WHEN status = 'Cancelled' THEN 'Unsuccessful'
           ELSE 'In Progress'
       END AS order_category
FROM orders;

-- ============================================================
-- 9. DATE + REPORTING QUERIES
-- ============================================================

-- Q39. Orders placed in September 2025
SELECT *
FROM orders
WHERE order_date BETWEEN '2025-09-01' AND '2025-09-30';

-- Q40. Number of orders by status
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- Q41. Daily order count
SELECT order_date, COUNT(*) AS orders
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- Q42. Monthly revenue
SELECT DATE_FORMAT(o.order_date,'%Y-%m') AS month,
       ROUND(SUM(oi.quantity * oi.unit_price),2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY DATE_FORMAT(o.order_date,'%Y-%m');

-- Q43. Payment method usage
SELECT payment_method, COUNT(*) AS payment_count
FROM payments
WHERE payment_method IS NOT NULL
GROUP BY payment_method
ORDER BY payment_count DESC;

-- Q44. Delivered revenue only
SELECT ROUND(SUM(oi.quantity * oi.unit_price),2) AS delivered_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered';

-- ============================================================
-- 10. INVENTORY ANALYSIS
-- ============================================================

-- Q45. Low-stock products
SELECT product_name, stock
FROM products
WHERE stock < 30
ORDER BY stock ASC;

-- Q46. Products with stock between 30 and 60
SELECT product_name, stock
FROM products
WHERE stock BETWEEN 30 AND 60
ORDER BY stock;

-- Q47. Highest-rated products
SELECT product_name, rating
FROM products
WHERE rating >= 4.5
ORDER BY rating DESC;

-- Q48. Category with the highest average product rating
SELECT c.category_name,
       ROUND(AVG(p.rating),2) AS avg_rating
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY avg_rating DESC
LIMIT 1;

-- ============================================================
-- 11. DDL ALTER / CONSTRAINT DEMONSTRATIONS
-- Run these individually if needed in a lab demonstration.
-- ============================================================

-- Q49. Add a default value to stock (demonstration)
ALTER TABLE products
MODIFY stock INT NOT NULL DEFAULT 0;

-- Q50. Add an index for faster product-name searches
CREATE INDEX idx_product_name ON products(product_name);

-- Q51. Add an index for customer email
CREATE INDEX idx_customer_email ON customers(email);

-- ============================================================
-- 12. FINAL E-COMMERCE SUMMARY REPORT
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM orders WHERE status = 'Delivered') AS delivered_orders,
    (SELECT COUNT(*) FROM orders WHERE status = 'Cancelled') AS cancelled_orders,
    (SELECT ROUND(SUM(oi.quantity * oi.unit_price),2)
     FROM order_items oi
     JOIN orders o ON oi.order_id = o.order_id
     WHERE o.status <> 'Cancelled') AS total_revenue;

-- ============================================================
-- END OF WEEK 4 SQL E-COMMERCE PROJECT
-- Total numbered queries: 51
-- ============================================================

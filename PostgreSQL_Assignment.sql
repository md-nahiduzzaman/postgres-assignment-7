CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0),
    stock INT CHECK (stock >= 0),
    published_year INT NOT NULL
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    book_id INT REFERENCES books(id) ON DELETE CASCADE,
    quantity INT CHECK (quantity > 0) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO books (id, title, author, price, stock, published_year) VALUES
(1, 'Eloquent JavaScript', 'Marijn Haverbeke', 28.00, 9, 2018),
(2, 'The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
(3, 'Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
(4, 'Refactoring', 'Martin Fowler', 50.00, 3, 1999),
(5, 'Design Patterns', 'Erich Gamma', 45.00, 7, 1994);

INSERT INTO customers (id, name, email, joined_date) VALUES
(1, 'Rakib', 'rekib@email.com', '2022-09-05'),
(2, 'Kiron', 'kiron@email.com', '2024-01-02'),
(3, 'Hasan', 'Hasan@email.com', '2023-12-12'),
(4, 'Rafi', 'rafi@email.com', '2022-07-30'),
(5, 'Naim', 'naim@email.com', '2023-08-21');

INSERT INTO orders (id, customer_id, book_id, quantity, order_date) VALUES
(1, 1, 2, 1, '2024-03-10'),
(2, 2, 1, 1, '2024-02-20'),
(3, 1, 3, 2, '2024-03-05'),
(4, 3, 5, 1, '2024-02-15'),
(5, 4, 4, 2, '2024-03-08');

-- 01. Find books that are out of stock.
SELECT title FROM books WHERE stock = 0;

-- 02. Retrieve the most expensive book in the store.
SELECT * FROM books ORDER BY price DESC LIMIT 1;

-- 03. Find the total number of orders placed by each customer.
SELECT c.name, COUNT(o.id) AS total_orders 
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name;

-- 04. Calculate the total revenue generated from book sales.
SELECT SUM(b.price * o.quantity) AS total_revenue 
FROM orders o
JOIN books b ON o.book_id = b.id;

-- 05. List all customers who have placed more than one order.
SELECT c.name, COUNT(o.id) AS orders_count 
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.id) > 1;

-- 06. Find the average price of books in the store.
SELECT AVG(price) AS avg_book_price FROM books;

-- 07. Increase the price of all books published before 2000 by 10%.
UPDATE books 
SET price = price * 1.10 
WHERE published_year < 2000;

-- 08. Delete customers who haven't placed any orders.
DELETE FROM customers 
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);
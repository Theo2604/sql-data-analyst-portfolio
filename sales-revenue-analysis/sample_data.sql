INSERT INTO customers (customer_name, region) VALUES
('Alice', 'North'),
('Bob', 'South'),
('Charlie', 'East'),
('Diana', 'West');

INSERT INTO products (product_name, category) VALUES
('Laptop', 'Electronics'),
('Phone', 'Electronics'),
('Desk', 'Furniture'),
('Chair', 'Furniture');

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-01-15'),
(2, '2024-02-10'),
(3, '2024-02-18'),
(1, '2024-03-05'),
(4, '2024-03-20');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200),
(1, 2, 2, 600),
(2, 3, 1, 300),
(3, 4, 4, 150),
(4, 2, 1, 650),
(5, 1, 2, 1150);


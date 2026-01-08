INSERT INTO users (signup_date) VALUES
('2024-01-01'),
('2024-01-03'),
('2024-01-05'),
('2024-01-08'),
('2024-01-10'),
('2024-01-12');

INSERT INTO events (user_id, event_type, event_date) VALUES
(1, 'signup', '2024-01-01'),
(1, 'view_product', '2024-01-01'),
(1, 'add_to_cart', '2024-01-02'),
(1, 'purchase', '2024-01-03'),

(2, 'signup', '2024-01-03'),
(2, 'view_product', '2024-01-03'),

(3, 'signup', '2024-01-05'),
(3, 'view_product', '2024-01-06'),
(3, 'add_to_cart', '2024-01-06'),

(4, 'signup', '2024-01-08'),
(4, 'view_product', '2024-01-08'),
(4, 'add_to_cart', '2024-01-09'),
(4, 'purchase', '2024-01-10'),

(5, 'signup', '2024-01-10'),

(6, 'signup', '2024-01-12'),
(6, 'view_product', '2024-01-12'),
(6, 'purchase', '2024-01-13');


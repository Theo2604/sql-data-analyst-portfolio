CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    signup_date DATE
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    transaction_date DATE,
    amount NUMERIC(10,2)
);


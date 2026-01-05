CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    signup_date DATE
);

CREATE TABLE events (
    event_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    event_type VARCHAR(50),
    event_date DATE
);


-- USERS
------------------------
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(100),
    signup_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_status VARCHAR(50) NOT NULL DEFAULT 'active'
);

-- PLANS
------------------------
CREATE TABLE plans (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL UNIQUE,
    monthly_price NUMERIC(10,2) NOT NULL,
    billing_cycle VARCHAR(20) NOT NULL DEFAULT 'monthly',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- SUBSCRIPTIONS
------------------------
CREATE TABLE subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    plan_id INT NOT NULL REFERENCES plans(plan_id),
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    start_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- INVOICES
------------------------
CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY,
    subscription_id INT NOT NULL REFERENCES subscriptions(subscription_id),
    invoice_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    invoice_amount NUMERIC(10,2) NOT NULL,
    invoice_status VARCHAR(50) NOT NULL DEFAULT 'issued'
);


-- PAYMENTS
------------------------
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    invoice_id INT NOT NULL REFERENCES invoices(invoice_id),
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_amount NUMERIC(10,2) NOT NULL,
    payment_status VARCHAR(50) NOT NULL
);


-- SUBSCRIPTION EVENTS
------------------------
CREATE TABLE subscription_events (
    event_id SERIAL PRIMARY KEY,
    subscription_id INT NOT NULL REFERENCES subscriptions(subscription_id),
    event_type VARCHAR(50) NOT NULL,
    event_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
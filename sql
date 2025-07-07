-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Store hashed passwords (e.g., using bcrypt)
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicles Table (Associated with Users)
CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER,
    connector_type VARCHAR(50) NOT NULL, -- e.g., "Type 2", "CCS", "CHAdeMO"
    battery_capacity_kwh DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Charging Stations Table
CREATE TABLE charging_stations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,
    power_kw DECIMAL(10, 2) NOT NULL,
    connector_type VARCHAR(50) NOT NULL,
    price_per_kwh DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'available', -- 'available', 'occupied', 'reserved', 'out_of_service'
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reservations Table
CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    station_id INTEGER REFERENCES charging_stations(id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'confirmed', 'cancelled', 'completed'
    payment_status VARCHAR(20) DEFAULT 'unpaid', -- 'unpaid', 'paid', 'refunded'
    total_cost DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payment Transactions Table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    reservation_id INTEGER REFERENCES reservations(id) UNIQUE, -- One payment per reservation
    transaction_id VARCHAR(255) UNIQUE, -- From payment gateway
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    payment_method VARCHAR(50), -- e.g., "credit_card", "upi", "netbanking"
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'successful', 'failed', 'refunded'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Charging Profiles (User-specific preferences)
CREATE TABLE charging_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) UNIQUE,
    preferred_connector_type VARCHAR(50),
    preferred_power_kw DECIMAL(10, 2),
    notifications_enabled BOOLEAN DEFAULT TRUE,
    auto_pay_enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

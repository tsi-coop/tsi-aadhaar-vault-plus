-- init.sql
-- SQL script for initializing the PostgreSQL database schema for TSI Aadhaar Vault Plus.

-- Create Table: api_user
CREATE TABLE api_user (
    api_key VARCHAR(255) PRIMARY KEY,
    api_secret VARCHAR(255) NOT NULL,
    client_name VARCHAR(255) NOT NULL UNIQUE,
    active BOOLEAN DEFAULT TRUE,
    created_datetime TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create Table: id_type_master
CREATE TABLE id_type_master (
    id_type_code VARCHAR(50) PRIMARY KEY,
    id_type_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    validation_regex TEXT,
    active BOOLEAN DEFAULT TRUE
);

-- Insert initial ID types (Optional, but good for quick setup)
INSERT INTO id_type_master (id_type_code, id_type_name, validation_regex, active) VALUES
('AADHAAR', 'Aadhaar Number', '^\\d{4}\\s\\d{4}\\s\\d{4}$', TRUE),
('VOTER_ID', 'Voter ID', '^[A-Z]{3}\\d{7}$', TRUE),
('ABHA_ID', 'ABHA ID', '^\\d{2}-\\d{4}-\\d{4}-\\d{4}$', TRUE)
ON CONFLICT (id_type_code) DO NOTHING; -- Avoid errors if run multiple times

-- Create Table: id_vault
-- Note: encrypted_id_number and encrypted_data_key are TEXT for Base64 encoded binary data
-- hashed_id_number uses a deterministic hash (globally salted)
CREATE TABLE id_vault (
    reference_key UUID PRIMARY KEY,
    id_type_code VARCHAR(50) NOT NULL REFERENCES id_type_master(id_type_code),
    encrypted_id_number TEXT NOT NULL,
    encrypted_data_key TEXT, -- Stores the Base64 encoded encrypted data key from KMS
    hashed_id_number VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Unique index to prevent duplicate IDs for the same type (using deterministic hash)
CREATE UNIQUE INDEX ux_id_type_hashed_id ON id_vault (id_type_code, hashed_id_number);


-- Create Table: event_log
CREATE TABLE event_log (
    log_id BIGSERIAL PRIMARY KEY,
    api_key VARCHAR(255) REFERENCES api_user(api_key),
    operation_type VARCHAR(50) NOT NULL,
    id_type_code VARCHAR(50) REFERENCES id_type_master(id_type_code),
    reference_key UUID REFERENCES id_vault(reference_key),
    log_datetime TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create Table: admin_user
CREATE TABLE admin_user (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    role VARCHAR(50) NOT NULL DEFAULT 'AUDIT_VIEWER',
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP WITHOUT TIME ZONE
);
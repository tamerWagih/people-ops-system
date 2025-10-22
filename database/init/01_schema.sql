-- People Operation and Management System - Database Initialization
-- This file is used by Docker Compose to initialize the database
-- Created: October 22, 2025

-- Create database if it doesn't exist
SELECT 'CREATE DATABASE people_ops_dev'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'people_ops_dev')\gexec

-- Connect to the people_ops_dev database
\c people_ops_dev;

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Create basic tables for testing
CREATE TABLE IF NOT EXISTS employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hr_id VARCHAR(50) UNIQUE NOT NULL,
    full_name_en VARCHAR(255) NOT NULL,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_en VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert sample data
INSERT INTO departments (id, name_en, code) VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'Human Resources', 'HR'),
('550e8400-e29b-41d4-a716-446655440002', 'Information Technology', 'IT')
ON CONFLICT (id) DO NOTHING;

INSERT INTO employees (id, hr_id, full_name_en, national_id) VALUES 
('750e8400-e29b-41d4-a716-446655440001', 'EMP001', 'Ahmed Mohamed', '12345678901234')
ON CONFLICT (id) DO NOTHING;

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE people_ops_dev TO people_ops;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO people_ops;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO people_ops;

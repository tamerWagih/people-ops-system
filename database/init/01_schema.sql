-- People Operation and Management System - Database Initialization
-- This file only creates the database and user
-- The actual schema is applied via migrations

-- Create database if it doesn't exist
SELECT 'CREATE DATABASE people_ops_dev'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'people_ops_dev')\gexec

-- Connect to the people_ops_dev database
\c people_ops_dev;

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE people_ops_dev TO people_ops;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO people_ops;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO people_ops;
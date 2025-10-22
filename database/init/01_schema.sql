-- People Operation and Management System - Database Initialization
-- This file is used by Docker Compose to initialize the database
-- Created: October 22, 2025

-- Create database if it doesn't exist
SELECT 'CREATE DATABASE people_ops'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'people_ops')\gexec

-- Connect to the people_ops database
\c people_ops;

-- Run the initial migration
\i /docker-entrypoint-initdb.d/migrations/001_initial_schema.sql

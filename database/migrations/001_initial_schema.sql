-- People Operation and Management System - Initial Database Migration
-- Migration: 001_initial_schema.sql
-- Created: October 22, 2025
-- Description: Creates the initial database schema for HR and WFM modules

-- =============================================
-- CREATE DATABASE AND EXTENSIONS
-- =============================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For text search
CREATE EXTENSION IF NOT EXISTS "btree_gin"; -- For GIN indexes

-- =============================================
-- HR SCHEMA IMPLEMENTATION
-- =============================================

-- Include HR schema
\i database/schemas/hr-schema.sql

-- =============================================
-- WFM SCHEMA IMPLEMENTATION
-- =============================================

-- Include WFM schema
\i database/schemas/wfm-schema.sql

-- =============================================
-- INITIAL DATA SEEDING
-- =============================================

-- Insert default departments
INSERT INTO departments (id, name, description) VALUES
    (uuid_generate_v4(), 'Human Resources', 'Human Resources Department'),
    (uuid_generate_v4(), 'Workforce Management', 'Workforce Management Department'),
    (uuid_generate_v4(), 'Operations', 'Operations Department'),
    (uuid_generate_v4(), 'Training', 'Training Department'),
    (uuid_generate_v4(), 'Quality Assurance', 'Quality Assurance Department'),
    (uuid_generate_v4(), 'IT', 'Information Technology Department'),
    (uuid_generate_v4(), 'Finance', 'Finance Department'),
    (uuid_generate_v4(), 'Administration', 'Administration Department');

-- Insert default accounts
INSERT INTO accounts (id, name, description) VALUES
    (uuid_generate_v4(), 'Internal', 'Internal Operations'),
    (uuid_generate_v4(), 'Client A', 'Client A Operations'),
    (uuid_generate_v4(), 'Client B', 'Client B Operations'),
    (uuid_generate_v4(), 'Client C', 'Client C Operations');

-- Insert default LOBs
INSERT INTO lobs (id, name, description) VALUES
    (uuid_generate_v4(), 'Customer Service', 'Customer Service Line of Business'),
    (uuid_generate_v4(), 'Technical Support', 'Technical Support Line of Business'),
    (uuid_generate_v4(), 'Sales', 'Sales Line of Business'),
    (uuid_generate_v4(), 'Back Office', 'Back Office Operations');

-- Insert default activity codes
INSERT INTO activity_codes (id, code, name, description, is_productive, color) VALUES
    (uuid_generate_v4(), 'AVAIL', 'Available', 'Agent is available for calls', true, '#10B981'),
    (uuid_generate_v4(), 'BREAK', 'Break', 'Agent is on break', false, '#F59E0B'),
    (uuid_generate_v4(), 'LUNCH', 'Lunch', 'Agent is on lunch break', false, '#EF4444'),
    (uuid_generate_v4(), 'COACH', 'Coaching', 'Agent is in coaching session', true, '#3B82F6'),
    (uuid_generate_v4(), 'TRAIN', 'Training', 'Agent is in training session', true, '#8B5CF6'),
    (uuid_generate_v4(), 'MEET', 'Meeting', 'Agent is in meeting', true, '#06B6D4'),
    (uuid_generate_v4(), 'ADMIN', 'Administrative', 'Agent is doing administrative work', true, '#6B7280'),
    (uuid_generate_v4(), 'LEAVE', 'Leave', 'Agent is on leave', false, '#DC2626'),
    (uuid_generate_v4(), 'EARLY', 'Early Leave', 'Agent left early', false, '#F97316');

-- Insert default leave types
INSERT INTO leave_types (id, name, code, max_days_per_year, requires_approval, is_paid) VALUES
    (uuid_generate_v4(), 'Annual Leave', 'ANNUAL', 21, true, true),
    (uuid_generate_v4(), 'Sick Leave', 'SICK', 10, true, true),
    (uuid_generate_v4(), 'Emergency Leave', 'EMERGENCY', 5, true, true),
    (uuid_generate_v4(), 'Personal Leave', 'PERSONAL', 3, true, false),
    (uuid_generate_v4(), 'Maternity Leave', 'MATERNITY', 90, true, true),
    (uuid_generate_v4(), 'Paternity Leave', 'PATERNITY', 7, true, true),
    (uuid_generate_v4(), 'Unpaid Leave', 'UNPAID', 30, true, false);

-- =============================================
-- CREATE ROLES AND PERMISSIONS
-- =============================================

-- Create application roles
CREATE ROLE people_ops_app;
CREATE ROLE people_ops_readonly;

-- Grant basic permissions
GRANT CONNECT ON DATABASE people_ops TO people_ops_app;
GRANT USAGE ON SCHEMA public TO people_ops_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO people_ops_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO people_ops_app;

GRANT CONNECT ON DATABASE people_ops TO people_ops_readonly;
GRANT USAGE ON SCHEMA public TO people_ops_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO people_ops_readonly;

-- =============================================
-- CREATE INITIAL ADMIN USER
-- =============================================

-- Insert system admin user (this will be replaced by proper user management)
INSERT INTO employees (
    id, hr_id, full_name_en, national_id, date_of_birth, gender, 
    department_id, current_title, hiring_date, status, employment_type
) VALUES (
    uuid_generate_v4(),
    'ADMIN001',
    'System Administrator',
    '12345678901234',
    '1990-01-01',
    'Male',
    (SELECT id FROM departments WHERE name = 'IT' LIMIT 1),
    'System Administrator',
    CURRENT_DATE,
    'Active',
    'Full Time'
);

-- =============================================
-- CREATE INITIAL NOTIFICATION SETTINGS
-- =============================================

-- Create notification settings table
CREATE TABLE notification_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) NOT NULL,
    is_enabled BOOLEAN DEFAULT true,
    email_enabled BOOLEAN DEFAULT true,
    sms_enabled BOOLEAN DEFAULT false,
    days_before INTEGER DEFAULT 7, -- Days before expiry to send notification
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default notification settings for all employees
INSERT INTO notification_settings (employee_id, notification_type, days_before)
SELECT 
    e.id,
    'CONTRACT_EXPIRY',
    45
FROM employees e
WHERE e.is_deleted = false;

INSERT INTO notification_settings (employee_id, notification_type, days_before)
SELECT 
    e.id,
    'DOCUMENT_EXPIRY',
    7
FROM employees e
WHERE e.is_deleted = false;

INSERT INTO notification_settings (employee_id, notification_type, days_before)
SELECT 
    e.id,
    'RESIGNATION',
    0
FROM employees e
WHERE e.is_deleted = false;

-- =============================================
-- PERFORMANCE OPTIMIZATION
-- =============================================

-- Create additional indexes for common queries
CREATE INDEX CONCURRENTLY idx_employees_search ON employees USING gin(
    to_tsvector('english', full_name_en || ' ' || hr_id || ' ' || national_id)
);

CREATE INDEX CONCURRENTLY idx_agent_schedules_employee_activity ON agent_schedules(employee_id, activity_code_id);
CREATE INDEX CONCURRENTLY idx_leave_requests_employee_status ON leave_requests(employee_id, status);

-- =============================================
-- MIGRATION COMPLETION
-- =============================================

-- Update migration log
INSERT INTO schema_migrations (version, applied_at) VALUES ('001_initial_schema', NOW());

-- Create schema migrations table if it doesn't exist
CREATE TABLE IF NOT EXISTS schema_migrations (
    version VARCHAR(255) PRIMARY KEY,
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMIT;

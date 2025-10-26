-- People Operation and Management System - Initial Migration (Normalized Schema)
-- Migration: 001_initial_schema.sql
-- Created: October 26, 2025
-- Description: Creates the normalized database schema (HR + WFM) with separated employee tables

-- Include the complete normalized schema
\i database/schema/complete_schema.sql

-- Apply initial seed data
\i database/seeds/initial_data.sql

-- Create migration tracking table
CREATE TABLE IF NOT EXISTS schema_migrations (
    version VARCHAR(255) PRIMARY KEY,
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Record this migration
INSERT INTO schema_migrations (version) VALUES ('001_initial_schema_normalized');
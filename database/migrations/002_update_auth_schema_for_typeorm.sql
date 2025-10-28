-- Migration: Update authentication schema to match TypeORM entities
-- This migration updates column names to match TypeORM naming conventions
-- Created: October 28, 2025

-- =============================================
-- UPDATE USERS TABLE
-- =============================================

-- Rename columns to match TypeORM entity
ALTER TABLE users RENAME COLUMN password_hash TO password;
ALTER TABLE users RENAME COLUMN first_name TO firstName;
ALTER TABLE users RENAME COLUMN last_name TO lastName;
ALTER TABLE users RENAME COLUMN is_verified TO isEmailVerified;
ALTER TABLE users RENAME COLUMN last_login TO lastLoginAt;
ALTER TABLE users RENAME COLUMN created_at TO createdAt;
ALTER TABLE users RENAME COLUMN updated_at TO updatedAt;

-- Add missing columns from TypeORM entity
ALTER TABLE users ADD COLUMN middleName VARCHAR(100);
ALTER TABLE users ADD COLUMN passwordChangedAt TIMESTAMP WITH TIME ZONE;
ALTER TABLE users ADD COLUMN profilePicture VARCHAR(500);
ALTER TABLE users ADD COLUMN notes TEXT;

-- =============================================
-- UPDATE ROLES TABLE
-- =============================================

-- Rename columns to match TypeORM entity
ALTER TABLE roles RENAME COLUMN is_active TO isActive;
ALTER TABLE roles RENAME COLUMN created_at TO createdAt;
ALTER TABLE roles RENAME COLUMN updated_at TO updatedAt;

-- Add missing columns from TypeORM entity
ALTER TABLE roles ADD COLUMN isSystemRole BOOLEAN DEFAULT false;

-- =============================================
-- UPDATE USER_ROLES TABLE
-- =============================================

-- Rename columns to match TypeORM entity
ALTER TABLE user_roles RENAME COLUMN user_id TO userId;
ALTER TABLE user_roles RENAME COLUMN role_id TO roleId;
ALTER TABLE user_roles RENAME COLUMN assigned_by TO assignedBy;
ALTER TABLE user_roles RENAME COLUMN assigned_at TO assignedAt;
ALTER TABLE user_roles RENAME COLUMN expires_at TO expiresAt;

-- =============================================
-- UPDATE ROLE_PERMISSIONS TABLE
-- =============================================

-- Rename columns to match TypeORM entity
ALTER TABLE role_permissions RENAME COLUMN role_id TO roleId;
ALTER TABLE role_permissions RENAME COLUMN permission_id TO permissionId;
ALTER TABLE role_permissions RENAME COLUMN granted_at TO grantedAt;
ALTER TABLE role_permissions RENAME COLUMN granted_by TO grantedBy;

-- =============================================
-- UPDATE PERMISSIONS TABLE
-- =============================================

-- Rename columns to match TypeORM entity
ALTER TABLE permissions RENAME COLUMN created_at TO createdAt;

-- =============================================
-- UPDATE CONSTRAINTS
-- =============================================

-- Drop old constraints
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_user_id_role_id_key;
ALTER TABLE role_permissions DROP CONSTRAINT IF EXISTS role_permissions_role_id_permission_id_key;

-- Add new constraints with updated column names
ALTER TABLE user_roles ADD CONSTRAINT user_roles_userId_roleId_key UNIQUE (userId, roleId);
ALTER TABLE role_permissions ADD CONSTRAINT role_permissions_roleId_permissionId_key UNIQUE (roleId, permissionId);

-- =============================================
-- UPDATE INDEXES
-- =============================================

-- Drop old indexes
DROP INDEX IF EXISTS idx_users_username;
DROP INDEX IF EXISTS idx_users_email;

-- Add new indexes with updated column names
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_firstName ON users(firstName);
CREATE INDEX idx_users_lastName ON users(lastName);

-- =============================================
-- VERIFICATION
-- =============================================

-- Verify the changes
SELECT 'Schema updated successfully!' AS status;
SELECT 'Users table columns:' AS info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'users' ORDER BY ordinal_position;
SELECT 'Roles table columns:' AS info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'roles' ORDER BY ordinal_position;
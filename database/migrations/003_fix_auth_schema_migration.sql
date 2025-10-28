-- Migration: Fix authentication schema migration issues
-- This migration properly handles the transition from old schema to new TypeORM schema
-- Created: October 28, 2025

-- =============================================
-- STEP 1: BACKUP EXISTING DATA
-- =============================================

-- Create temporary tables to backup existing data
CREATE TABLE IF NOT EXISTS users_backup AS SELECT * FROM users;
CREATE TABLE IF NOT EXISTS roles_backup AS SELECT * FROM roles;
CREATE TABLE IF NOT EXISTS permissions_backup AS SELECT * FROM permissions;
CREATE TABLE IF NOT EXISTS user_roles_backup AS SELECT * FROM user_roles;
CREATE TABLE IF NOT EXISTS role_permissions_backup AS SELECT * FROM role_permissions;

-- =============================================
-- STEP 2: CLEAR EXISTING TABLES
-- =============================================

-- Drop foreign key constraints first
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_user_id_fkey;
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_role_id_fkey;
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_assigned_by_fkey;
ALTER TABLE role_permissions DROP CONSTRAINT IF EXISTS role_permissions_role_id_fkey;
ALTER TABLE role_permissions DROP CONSTRAINT IF EXISTS role_permissions_permission_id_fkey;
ALTER TABLE role_permissions DROP CONSTRAINT IF EXISTS role_permissions_granted_by_fkey;

-- Clear tables
TRUNCATE TABLE user_roles CASCADE;
TRUNCATE TABLE role_permissions CASCADE;
TRUNCATE TABLE users CASCADE;
TRUNCATE TABLE roles CASCADE;
TRUNCATE TABLE permissions CASCADE;

-- =============================================
-- STEP 3: RECREATE TABLES WITH CORRECT SCHEMA
-- =============================================

-- Drop and recreate users table
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    "firstName" VARCHAR(100) NOT NULL,
    "lastName" VARCHAR(100) NOT NULL,
    "middleName" VARCHAR(100),
    "isActive" BOOLEAN DEFAULT true,
    "isEmailVerified" BOOLEAN DEFAULT false,
    "lastLoginAt" TIMESTAMP WITH TIME ZONE,
    "passwordChangedAt" TIMESTAMP WITH TIME ZONE,
    "profilePicture" VARCHAR(500),
    notes TEXT,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Drop and recreate roles table
DROP TABLE IF EXISTS roles CASCADE;
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    "isActive" BOOLEAN DEFAULT true,
    "isSystemRole" BOOLEAN DEFAULT false,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Drop and recreate permissions table
DROP TABLE IF EXISTS permissions CASCADE;
CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    module VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    resource VARCHAR(50) NOT NULL,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Drop and recreate user_roles table
DROP TABLE IF EXISTS user_roles CASCADE;
CREATE TABLE user_roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "userId" UUID NOT NULL,
    "roleId" UUID NOT NULL,
    "assignedBy" UUID,
    "expiresAt" TIMESTAMP WITH TIME ZONE,
    "assignedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE("userId", "roleId")
);

-- Drop and recreate role_permissions table
DROP TABLE IF EXISTS role_permissions CASCADE;
CREATE TABLE role_permissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "roleId" UUID NOT NULL,
    "permissionId" UUID NOT NULL,
    "grantedBy" UUID,
    "grantedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE("roleId", "permissionId")
);

-- =============================================
-- STEP 4: ADD FOREIGN KEY CONSTRAINTS
-- =============================================

-- Add foreign key constraints
ALTER TABLE user_roles 
    ADD CONSTRAINT user_roles_userId_fkey 
    FOREIGN KEY ("userId") REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE user_roles 
    ADD CONSTRAINT user_roles_roleId_fkey 
    FOREIGN KEY ("roleId") REFERENCES roles(id) ON DELETE CASCADE;

ALTER TABLE user_roles 
    ADD CONSTRAINT user_roles_assignedBy_fkey 
    FOREIGN KEY ("assignedBy") REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE role_permissions 
    ADD CONSTRAINT role_permissions_roleId_fkey 
    FOREIGN KEY ("roleId") REFERENCES roles(id) ON DELETE CASCADE;

ALTER TABLE role_permissions 
    ADD CONSTRAINT role_permissions_permissionId_fkey 
    FOREIGN KEY ("permissionId") REFERENCES permissions(id) ON DELETE CASCADE;

ALTER TABLE role_permissions 
    ADD CONSTRAINT role_permissions_grantedBy_fkey 
    FOREIGN KEY ("grantedBy") REFERENCES users(id) ON DELETE SET NULL;

-- =============================================
-- STEP 5: ADD INDEXES
-- =============================================

-- Add indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_firstName ON users("firstName");
CREATE INDEX idx_users_lastName ON users("lastName");
CREATE INDEX idx_roles_name ON roles(name);
CREATE INDEX idx_permissions_name ON permissions(name);
CREATE INDEX idx_user_roles_userId ON user_roles("userId");
CREATE INDEX idx_user_roles_roleId ON user_roles("roleId");
CREATE INDEX idx_role_permissions_roleId ON role_permissions("roleId");
CREATE INDEX idx_role_permissions_permissionId ON role_permissions("permissionId");

-- =============================================
-- STEP 6: RESTORE DATA FROM BACKUP
-- =============================================

-- Restore users data (mapping old column names to new ones)
INSERT INTO users (id, email, password, "firstName", "lastName", "middleName", "isActive", "isEmailVerified", "lastLoginAt", "passwordChangedAt", "profilePicture", notes, "createdAt", "updatedAt")
SELECT 
    id,
    email,
    COALESCE(password, password_hash, '$2b$12$default.hash.for.missing.passwords'),
    COALESCE(firstname, first_name, 'Unknown'),
    COALESCE(lastname, last_name, 'User'),
    middlename,
    COALESCE(is_active, true),
    COALESCE(isemailverified, is_verified, false),
    lastloginat,
    passwordchangedat,
    profilepicture,
    notes,
    COALESCE(createdat, created_at, NOW()),
    COALESCE(updatedat, updated_at, NOW())
FROM users_backup;

-- Restore roles data
INSERT INTO roles (id, name, description, "isActive", "isSystemRole", "createdAt", "updatedAt")
SELECT 
    id,
    name,
    description,
    COALESCE(isactive, is_active, true),
    COALESCE(issystemrole, false),
    COALESCE(createdat, created_at, NOW()),
    COALESCE(updatedat, updated_at, NOW())
FROM roles_backup;

-- Restore permissions data
INSERT INTO permissions (id, name, description, module, action, resource, "createdAt")
SELECT 
    id,
    name,
    description,
    COALESCE(module, 'SYSTEM'),
    COALESCE(action, 'READ'),
    COALESCE(resource, 'GENERAL'),
    COALESCE(createdat, created_at, NOW())
FROM permissions_backup;

-- Restore user_roles data
INSERT INTO user_roles (id, "userId", "roleId", "assignedBy", "expiresAt", "assignedAt")
SELECT 
    id,
    COALESCE(userid, user_id),
    COALESCE(roleid, role_id),
    assignedby,
    expiresat,
    COALESCE(assignedat, assigned_at, NOW())
FROM user_roles_backup
WHERE COALESCE(userid, user_id) IS NOT NULL 
  AND COALESCE(roleid, role_id) IS NOT NULL;

-- Restore role_permissions data
INSERT INTO role_permissions (id, "roleId", "permissionId", "grantedBy", "grantedAt")
SELECT 
    id,
    COALESCE(roleid, role_id),
    COALESCE(permissionid, permission_id),
    grantedby,
    COALESCE(grantedat, granted_at, NOW())
FROM role_permissions_backup
WHERE COALESCE(roleid, role_id) IS NOT NULL 
  AND COALESCE(permissionid, permission_id) IS NOT NULL;

-- =============================================
-- STEP 7: CLEANUP
-- =============================================

-- Drop backup tables
DROP TABLE IF EXISTS users_backup;
DROP TABLE IF EXISTS roles_backup;
DROP TABLE IF EXISTS permissions_backup;
DROP TABLE IF EXISTS user_roles_backup;
DROP TABLE IF EXISTS role_permissions_backup;

-- =============================================
-- STEP 8: VERIFICATION
-- =============================================

-- Verify the changes
SELECT 'Schema migration completed successfully!' AS status;
SELECT 'Users table columns:' AS info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'users' ORDER BY ordinal_position;
SELECT 'Roles table columns:' AS info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'roles' ORDER BY ordinal_position;
SELECT 'User count:' AS info;
SELECT COUNT(*) as user_count FROM users;
SELECT 'Role count:' AS info;
SELECT COUNT(*) as role_count FROM roles;

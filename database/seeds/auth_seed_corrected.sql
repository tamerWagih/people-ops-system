-- Authentication System Seed Data (Corrected for actual schema)
-- This file seeds the authentication tables with sample users, roles, and permissions

-- Insert roles (using correct column names from schema)
INSERT INTO roles (id, name, description, is_active, created_at, updated_at) VALUES
    (uuid_generate_v4(), 'System_Admin', 'Super Administrator with full system access', true, NOW(), NOW()),
    (uuid_generate_v4(), 'HR_Manager', 'Human Resources Manager', true, NOW(), NOW()),
    (uuid_generate_v4(), 'HR_Specialist', 'Human Resources Specialist', true, NOW(), NOW()),
    (uuid_generate_v4(), 'WFM_Manager', 'Workforce Management Manager', true, NOW(), NOW()),
    (uuid_generate_v4(), 'WFM_Planner', 'Workforce Management Planner', true, NOW(), NOW()),
    (uuid_generate_v4(), 'Employee', 'Regular Employee', true, NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Insert permissions
INSERT INTO permissions (id, name, description, module, action, resource, created_at) VALUES
    -- User management permissions
    (uuid_generate_v4(), 'users:create', 'Create users', 'HR', 'CREATE', 'USER', NOW()),
    (uuid_generate_v4(), 'users:read', 'Read users', 'HR', 'READ', 'USER', NOW()),
    (uuid_generate_v4(), 'users:update', 'Update users', 'HR', 'UPDATE', 'USER', NOW()),
    (uuid_generate_v4(), 'users:delete', 'Delete users', 'HR', 'DELETE', 'USER', NOW()),
    
    -- Employee management permissions
    (uuid_generate_v4(), 'employees:create', 'Create employees', 'HR', 'CREATE', 'EMPLOYEE', NOW()),
    (uuid_generate_v4(), 'employees:read', 'Read employees', 'HR', 'READ', 'EMPLOYEE', NOW()),
    (uuid_generate_v4(), 'employees:update', 'Update employees', 'HR', 'UPDATE', 'EMPLOYEE', NOW()),
    (uuid_generate_v4(), 'employees:delete', 'Delete employees', 'HR', 'DELETE', 'EMPLOYEE', NOW()),
    
    -- WFM permissions
    (uuid_generate_v4(), 'schedules:create', 'Create schedules', 'WFM', 'CREATE', 'SCHEDULE', NOW()),
    (uuid_generate_v4(), 'schedules:read', 'Read schedules', 'WFM', 'READ', 'SCHEDULE', NOW()),
    (uuid_generate_v4(), 'schedules:update', 'Update schedules', 'WFM', 'UPDATE', 'SCHEDULE', NOW()),
    (uuid_generate_v4(), 'schedules:delete', 'Delete schedules', 'WFM', 'DELETE', 'SCHEDULE', NOW())
ON CONFLICT (name) DO NOTHING;

-- Assign permissions to roles
-- System Admin gets all permissions
INSERT INTO role_permissions (id, role_id, permission_id, granted_at)
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id,
    NOW()
FROM roles r, permissions p
WHERE r.name = 'System_Admin'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- HR Manager gets HR permissions
INSERT INTO role_permissions (id, role_id, permission_id, granted_at)
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id,
    NOW()
FROM roles r, permissions p
WHERE r.name = 'HR_Manager' 
AND p.name IN ('users:create', 'users:read', 'users:update', 'users:delete', 'employees:create', 'employees:read', 'employees:update', 'employees:delete')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- HR Specialist gets limited HR permissions
INSERT INTO role_permissions (id, role_id, permission_id, granted_at)
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id,
    NOW()
FROM roles r, permissions p
WHERE r.name = 'HR_Specialist' 
AND p.name IN ('users:read', 'users:update', 'employees:create', 'employees:read', 'employees:update')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- WFM Manager gets WFM permissions
INSERT INTO role_permissions (id, role_id, permission_id, granted_at)
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id,
    NOW()
FROM roles r, permissions p
WHERE r.name = 'WFM_Manager' 
AND p.name IN ('schedules:create', 'schedules:read', 'schedules:update', 'schedules:delete', 'employees:read')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- WFM Planner gets limited WFM permissions
INSERT INTO role_permissions (id, role_id, permission_id, granted_at)
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id,
    NOW()
FROM roles r, permissions p
WHERE r.name = 'WFM_Planner' 
AND p.name IN ('schedules:create', 'schedules:read', 'schedules:update', 'employees:read')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Employee gets basic read permissions
INSERT INTO role_permissions (id, role_id, permission_id, granted_at)
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id,
    NOW()
FROM roles r, permissions p
WHERE r.name = 'Employee' 
AND p.name IN ('employees:read')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Insert sample users (using correct column names: password_hash, first_name, last_name, is_verified)
INSERT INTO users (id, username, email, password_hash, first_name, last_name, is_active, is_verified, created_at, updated_at) VALUES
    (uuid_generate_v4(), 'admin', 'admin@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'Admin', 'User', true, true, NOW(), NOW()),
    (uuid_generate_v4(), 'hr_manager', 'hr.manager@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'HR', 'Manager', true, true, NOW(), NOW()),
    (uuid_generate_v4(), 'wfm_manager', 'wfm.manager@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'WFM', 'Manager', true, true, NOW(), NOW()),
    (uuid_generate_v4(), 'employee', 'employee@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'John', 'Doe', true, true, NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Assign roles to users
-- Admin user gets System_Admin role
INSERT INTO user_roles (id, user_id, role_id, assigned_at)
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id,
    NOW()
FROM users u, roles r
WHERE u.email = 'admin@example.com' AND r.name = 'System_Admin'
ON CONFLICT (user_id, role_id) DO NOTHING;

-- HR Manager gets HR_Manager role
INSERT INTO user_roles (id, user_id, role_id, assigned_at)
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id,
    NOW()
FROM users u, roles r
WHERE u.email = 'hr.manager@example.com' AND r.name = 'HR_Manager'
ON CONFLICT (user_id, role_id) DO NOTHING;

-- WFM Manager gets WFM_Manager role
INSERT INTO user_roles (id, user_id, role_id, assigned_at)
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id,
    NOW()
FROM users u, roles r
WHERE u.email = 'wfm.manager@example.com' AND r.name = 'WFM_Manager'
ON CONFLICT (user_id, role_id) DO NOTHING;

-- Employee gets Employee role
INSERT INTO user_roles (id, user_id, role_id, assigned_at)
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id,
    NOW()
FROM users u, roles r
WHERE u.email = 'employee@example.com' AND r.name = 'Employee'
ON CONFLICT (user_id, role_id) DO NOTHING;

-- Display summary
SELECT 'Authentication seed data inserted successfully!' as status;
SELECT 'Sample users created:' as info;
SELECT email, first_name, last_name FROM users WHERE email LIKE '%@example.com';
SELECT 'Roles created:' as info;
SELECT name, description FROM roles;

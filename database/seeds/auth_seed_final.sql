-- Authentication System Seed Data (Final - matches TypeORM entities)
-- This file seeds the authentication tables with sample users, roles, and permissions
-- Using correct column names that match TypeORM entity definitions

-- Insert roles (using correct column names: name, description, isActive, isSystemRole)
INSERT INTO roles (id, name, description, "isActive", "isSystemRole") VALUES
    (uuid_generate_v4(), 'System_Admin', 'Super Administrator with full system access', true, true),
    (uuid_generate_v4(), 'HR_Manager', 'Human Resources Manager', true, false),
    (uuid_generate_v4(), 'HR_Specialist', 'Human Resources Specialist', true, false),
    (uuid_generate_v4(), 'WFM_Manager', 'Workforce Management Manager', true, false),
    (uuid_generate_v4(), 'WFM_Planner', 'Workforce Management Planner', true, false),
    (uuid_generate_v4(), 'Employee', 'Regular Employee', true, false)
ON CONFLICT (name) DO NOTHING;

-- Insert permissions
INSERT INTO permissions (id, name, description, module, action, resource) VALUES
    -- User management permissions
    (uuid_generate_v4(), 'users:create', 'Create users', 'HR', 'CREATE', 'USER'),
    (uuid_generate_v4(), 'users:read', 'Read users', 'HR', 'READ', 'USER'),
    (uuid_generate_v4(), 'users:update', 'Update users', 'HR', 'UPDATE', 'USER'),
    (uuid_generate_v4(), 'users:delete', 'Delete users', 'HR', 'DELETE', 'USER'),
    
    -- Employee management permissions
    (uuid_generate_v4(), 'employees:create', 'Create employees', 'HR', 'CREATE', 'EMPLOYEE'),
    (uuid_generate_v4(), 'employees:read', 'Read employees', 'HR', 'READ', 'EMPLOYEE'),
    (uuid_generate_v4(), 'employees:update', 'Update employees', 'HR', 'UPDATE', 'EMPLOYEE'),
    (uuid_generate_v4(), 'employees:delete', 'Delete employees', 'HR', 'DELETE', 'EMPLOYEE'),
    
    -- WFM permissions
    (uuid_generate_v4(), 'schedules:create', 'Create schedules', 'WFM', 'CREATE', 'SCHEDULE'),
    (uuid_generate_v4(), 'schedules:read', 'Read schedules', 'WFM', 'READ', 'SCHEDULE'),
    (uuid_generate_v4(), 'schedules:update', 'Update schedules', 'WFM', 'UPDATE', 'SCHEDULE'),
    (uuid_generate_v4(), 'schedules:delete', 'Delete schedules', 'WFM', 'DELETE', 'SCHEDULE'),
    
    -- System permissions
    (uuid_generate_v4(), 'system:admin', 'System administration', 'SYSTEM', 'ADMIN', 'SYSTEM'),
    (uuid_generate_v4(), 'reports:read', 'Read reports', 'REPORTS', 'READ', 'REPORT'),
    (uuid_generate_v4(), 'reports:create', 'Create reports', 'REPORTS', 'CREATE', 'REPORT')
ON CONFLICT (name) DO NOTHING;

-- Assign permissions to roles
-- System Admin gets all permissions
INSERT INTO role_permissions (id, "roleId", "permissionId")
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id
FROM roles r, permissions p
WHERE r.name = 'System_Admin'
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- HR Manager gets HR permissions
INSERT INTO role_permissions (id, "roleId", "permissionId")
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id
FROM roles r, permissions p
WHERE r.name = 'HR_Manager' 
AND p.name IN ('users:create', 'users:read', 'users:update', 'users:delete', 'employees:create', 'employees:read', 'employees:update', 'employees:delete', 'reports:read')
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- HR Specialist gets limited HR permissions
INSERT INTO role_permissions (id, "roleId", "permissionId")
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id
FROM roles r, permissions p
WHERE r.name = 'HR_Specialist' 
AND p.name IN ('users:read', 'users:update', 'employees:create', 'employees:read', 'employees:update', 'reports:read')
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- WFM Manager gets WFM permissions
INSERT INTO role_permissions (id, "roleId", "permissionId")
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id
FROM roles r, permissions p
WHERE r.name = 'WFM_Manager' 
AND p.name IN ('schedules:create', 'schedules:read', 'schedules:update', 'schedules:delete', 'employees:read', 'reports:read', 'reports:create')
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- WFM Planner gets limited WFM permissions
INSERT INTO role_permissions (id, "roleId", "permissionId")
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id
FROM roles r, permissions p
WHERE r.name = 'WFM_Planner' 
AND p.name IN ('schedules:create', 'schedules:read', 'schedules:update', 'employees:read', 'reports:read')
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- Employee gets basic read permissions
INSERT INTO role_permissions (id, "roleId", "permissionId")
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id
FROM roles r, permissions p
WHERE r.name = 'Employee' 
AND p.name IN ('employees:read', 'schedules:read')
ON CONFLICT ("roleId", "permissionId") DO NOTHING;

-- Insert sample users (using correct column names: email, password, firstName, lastName, isActive, isEmailVerified)
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified") VALUES
    (uuid_generate_v4(), 'admin@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'Admin', 'User', true, true),
    (uuid_generate_v4(), 'hr.manager@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'HR', 'Manager', true, true),
    (uuid_generate_v4(), 'hr.specialist@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'HR', 'Specialist', true, true),
    (uuid_generate_v4(), 'wfm.manager@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'WFM', 'Manager', true, true),
    (uuid_generate_v4(), 'wfm.planner@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'WFM', 'Planner', true, true),
    (uuid_generate_v4(), 'employee@example.com', '$2b$12$.JH1ZzH1E.ghESHGWDPwGuN8Oo7vhc7kuW256PFju5m3NZOdDtatC', 'John', 'Doe', true, true)
ON CONFLICT (email) DO NOTHING;

-- Assign roles to users
-- Admin user gets System_Admin role
INSERT INTO user_roles (id, "userId", "roleId")
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id
FROM users u, roles r
WHERE u.email = 'admin@example.com' AND r.name = 'System_Admin'
ON CONFLICT ("userId", "roleId") DO NOTHING;

-- HR Manager gets HR_Manager role
INSERT INTO user_roles (id, "userId", "roleId")
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id
FROM users u, roles r
WHERE u.email = 'hr.manager@example.com' AND r.name = 'HR_Manager'
ON CONFLICT ("userId", "roleId") DO NOTHING;

-- HR Specialist gets HR_Specialist role
INSERT INTO user_roles (id, "userId", "roleId")
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id
FROM users u, roles r
WHERE u.email = 'hr.specialist@example.com' AND r.name = 'HR_Specialist'
ON CONFLICT ("userId", "roleId") DO NOTHING;

-- WFM Manager gets WFM_Manager role
INSERT INTO user_roles (id, "userId", "roleId")
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id
FROM users u, roles r
WHERE u.email = 'wfm.manager@example.com' AND r.name = 'WFM_Manager'
ON CONFLICT ("userId", "roleId") DO NOTHING;

-- WFM Planner gets WFM_Planner role
INSERT INTO user_roles (id, "userId", "roleId")
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id
FROM users u, roles r
WHERE u.email = 'wfm.planner@example.com' AND r.name = 'WFM_Planner'
ON CONFLICT ("userId", "roleId") DO NOTHING;

-- Employee gets Employee role
INSERT INTO user_roles (id, "userId", "roleId")
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id
FROM users u, roles r
WHERE u.email = 'employee@example.com' AND r.name = 'Employee'
ON CONFLICT ("userId", "roleId") DO NOTHING;

-- Display summary
SELECT 'Authentication seed data inserted successfully!' as status;
SELECT 'Sample users created:' as info;
SELECT email, "firstName", "lastName" FROM users WHERE email LIKE '%@example.com';
SELECT 'Roles created:' as info;
SELECT name, description FROM roles;
SELECT 'Permissions created:' as info;
SELECT name, module, action, resource FROM permissions;
SELECT 'User-Role assignments:' as info;
SELECT u.email, r.name as role_name 
FROM users u 
JOIN user_roles ur ON u.id = ur."userId" 
JOIN roles r ON ur."roleId" = r.id;

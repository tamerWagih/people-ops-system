-- Test Accounts for People Operations System
-- This script creates test users with different roles for testing purposes

-- Note: Passwords are hashed using bcrypt with salt rounds 12
-- All test passwords are: "test123"

-- Test User 1: HR Admin
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'hr.admin@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'Sarah',
    'Johnson',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 2: HR Manager
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'hr.manager@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'Michael',
    'Chen',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 3: HR Representative
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'hr.rep@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'Emily',
    'Davis',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 4: WFM Admin
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'wfm.admin@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'David',
    'Rodriguez',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 5: WFM Supervisor
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'wfm.supervisor@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'Lisa',
    'Anderson',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 6: WFM Agent
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'wfm.agent@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'James',
    'Wilson',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 7: Department Manager
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'dept.manager@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'Jennifer',
    'Brown',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 8: HR Viewer (Read-only)
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'hr.viewer@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'Robert',
    'Taylor',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 9: WFM Planner
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'wfm.planner@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'Maria',
    'Garcia',
    true,
    true,
    NOW(),
    NOW()
);

-- Test User 10: Inactive User (for testing deactivated accounts)
INSERT INTO users (id, email, password, "firstName", "lastName", "isActive", "isEmailVerified", "createdAt", "updatedAt") VALUES
(
    uuid_generate_v4(),
    'inactive.user@test.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzK4aG', -- test123
    'Inactive',
    'User',
    false,
    true,
    NOW(),
    NOW()
);

-- Now assign roles to these users
-- Get user IDs and role IDs for assignment
DO $$
DECLARE
    hr_admin_user_id UUID;
    hr_manager_user_id UUID;
    hr_rep_user_id UUID;
    wfm_admin_user_id UUID;
    wfm_supervisor_user_id UUID;
    wfm_agent_user_id UUID;
    dept_manager_user_id UUID;
    hr_viewer_user_id UUID;
    wfm_planner_user_id UUID;
    inactive_user_id UUID;
    
    system_admin_role_id UUID;
    hr_admin_role_id UUID;
    hr_manager_role_id UUID;
    hr_rep_role_id UUID;
    hr_viewer_role_id UUID;
    wfm_admin_role_id UUID;
    wfm_supervisor_role_id UUID;
    wfm_agent_role_id UUID;
    wfm_planner_role_id UUID;
    dept_manager_role_id UUID;
BEGIN
    -- Get user IDs
    SELECT id INTO hr_admin_user_id FROM users WHERE email = 'hr.admin@test.com';
    SELECT id INTO hr_manager_user_id FROM users WHERE email = 'hr.manager@test.com';
    SELECT id INTO hr_rep_user_id FROM users WHERE email = 'hr.rep@test.com';
    SELECT id INTO wfm_admin_user_id FROM users WHERE email = 'wfm.admin@test.com';
    SELECT id INTO wfm_supervisor_user_id FROM users WHERE email = 'wfm.supervisor@test.com';
    SELECT id INTO wfm_agent_user_id FROM users WHERE email = 'wfm.agent@test.com';
    SELECT id INTO dept_manager_user_id FROM users WHERE email = 'dept.manager@test.com';
    SELECT id INTO hr_viewer_user_id FROM users WHERE email = 'hr.viewer@test.com';
    SELECT id INTO wfm_planner_user_id FROM users WHERE email = 'wfm.planner@test.com';
    SELECT id INTO inactive_user_id FROM users WHERE email = 'inactive.user@test.com';
    
    -- Get role IDs
    SELECT id INTO system_admin_role_id FROM roles WHERE name = 'System_Admin';
    SELECT id INTO hr_admin_role_id FROM roles WHERE name = 'HR_Admin';
    SELECT id INTO hr_manager_role_id FROM roles WHERE name = 'HR_Manager';
    SELECT id INTO hr_rep_role_id FROM roles WHERE name = 'HR_Representative';
    SELECT id INTO hr_viewer_role_id FROM roles WHERE name = 'HR_Viewer';
    SELECT id INTO wfm_admin_role_id FROM roles WHERE name = 'WFM_Admin';
    SELECT id INTO wfm_supervisor_role_id FROM roles WHERE name = 'WFM_Supervisor';
    SELECT id INTO wfm_agent_role_id FROM roles WHERE name = 'WFM_Agent';
    SELECT id INTO wfm_planner_role_id FROM roles WHERE name = 'WFM_Planner';
    SELECT id INTO dept_manager_role_id FROM roles WHERE name = 'Department_Manager';
    
    -- Assign roles
    INSERT INTO user_roles ("userId", "roleId", "assignedAt") VALUES
        (hr_admin_user_id, hr_admin_role_id, NOW()),
        (hr_manager_user_id, hr_manager_role_id, NOW()),
        (hr_rep_user_id, hr_rep_role_id, NOW()),
        (wfm_admin_user_id, wfm_admin_role_id, NOW()),
        (wfm_supervisor_user_id, wfm_supervisor_role_id, NOW()),
        (wfm_agent_user_id, wfm_agent_role_id, NOW()),
        (dept_manager_user_id, dept_manager_role_id, NOW()),
        (hr_viewer_user_id, hr_viewer_role_id, NOW()),
        (wfm_planner_user_id, wfm_planner_role_id, NOW()),
        (inactive_user_id, wfm_agent_role_id, NOW()); -- Inactive user gets WFM_Agent role
    
    RAISE NOTICE 'Test accounts created and roles assigned successfully';
END $$;

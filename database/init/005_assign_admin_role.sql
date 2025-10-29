-- Assign System_Admin role to admin user
-- This fixes the "Role: Unknown" issue

-- First, get the admin user ID
DO $$
DECLARE
    admin_user_id uuid;
    system_admin_role_id uuid;
BEGIN
    -- Get admin user ID
    SELECT id INTO admin_user_id FROM users WHERE email = 'admin@example.com';
    
    -- Get System_Admin role ID
    SELECT id INTO system_admin_role_id FROM roles WHERE name = 'System_Admin';
    
    -- Check if user already has this role
    IF NOT EXISTS (
        SELECT 1 FROM user_roles 
        WHERE "userId" = admin_user_id AND "roleId" = system_admin_role_id
    ) THEN
        -- Assign System_Admin role to admin user
        INSERT INTO user_roles ("userId", "roleId", "assignedAt") 
        VALUES (admin_user_id, system_admin_role_id, NOW());
        
        RAISE NOTICE 'System_Admin role assigned to admin user';
    ELSE
        RAISE NOTICE 'Admin user already has System_Admin role';
    END IF;
END $$;

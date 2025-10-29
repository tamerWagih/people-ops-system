-- Add Employee permissions
INSERT INTO permissions (id, name, resource, action, description, module, "createdAt") VALUES
    (uuid_generate_v4(), 'employees:CREATE', 'employees', 'CREATE', 'Create employees', 'HR', NOW()),
    (uuid_generate_v4(), 'employees:READ', 'employees', 'READ', 'Read employees', 'HR', NOW()),
    (uuid_generate_v4(), 'employees:UPDATE', 'employees', 'UPDATE', 'Update employees', 'HR', NOW()),
    (uuid_generate_v4(), 'employees:DELETE', 'employees', 'DELETE', 'Delete employees', 'HR', NOW())
ON CONFLICT (name) DO NOTHING;

-- Assign employee permissions to System_Admin role
DO $$
DECLARE
    system_admin_role_id UUID;
    emp_create_permission_id UUID;
    emp_read_permission_id UUID;
    emp_update_permission_id UUID;
    emp_delete_permission_id UUID;
BEGIN
    -- Get System_Admin role ID
    SELECT id INTO system_admin_role_id FROM roles WHERE name = 'System_Admin';
    
    -- Get employee permission IDs
    SELECT id INTO emp_create_permission_id FROM permissions WHERE name = 'employees:CREATE';
    SELECT id INTO emp_read_permission_id FROM permissions WHERE name = 'employees:READ';
    SELECT id INTO emp_update_permission_id FROM permissions WHERE name = 'employees:UPDATE';
    SELECT id INTO emp_delete_permission_id FROM permissions WHERE name = 'employees:DELETE';
    
    -- Assign permissions to System_Admin role
    IF system_admin_role_id IS NOT NULL THEN
        INSERT INTO role_permissions ("roleId", "permissionId", "assignedAt") VALUES
            (system_admin_role_id, emp_create_permission_id, NOW()),
            (system_admin_role_id, emp_read_permission_id, NOW()),
            (system_admin_role_id, emp_update_permission_id, NOW()),
            (system_admin_role_id, emp_delete_permission_id, NOW())
        ON CONFLICT ("roleId", "permissionId") DO NOTHING;
        
        RAISE NOTICE 'Employee permissions assigned to System_Admin role';
    END IF;
END $$;

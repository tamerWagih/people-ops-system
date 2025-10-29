-- Role Permissions based on HR_Authentication_Template.xlsx and WFM_Authentication_Template.xlsx
-- This file seeds permissions for all 12 roles defined in the templates

-- Clear existing role permissions
DELETE FROM role_permissions;

-- Get role IDs for reference
DO $$
DECLARE
    system_admin_id UUID;
    hr_admin_id UUID;
    hr_manager_id UUID;
    hr_representative_id UUID;
    hr_viewer_id UUID;
    wfm_admin_id UUID;
    wfm_planner_id UUID;
    wfm_supervisor_id UUID;
    wfm_agent_id UUID;
    dept_manager_id UUID;
BEGIN
    -- Get role IDs
    SELECT id INTO system_admin_id FROM roles WHERE name = 'System_Admin';
    SELECT id INTO hr_admin_id FROM roles WHERE name = 'HR_Admin';
    SELECT id INTO hr_manager_id FROM roles WHERE name = 'HR_Manager';
    SELECT id INTO hr_representative_id FROM roles WHERE name = 'HR_Representative';
    SELECT id INTO hr_viewer_id FROM roles WHERE name = 'HR_Viewer';
    SELECT id INTO wfm_admin_id FROM roles WHERE name = 'WFM_Admin';
    SELECT id INTO wfm_planner_id FROM roles WHERE name = 'WFM_Planner';
    SELECT id INTO wfm_supervisor_id FROM roles WHERE name = 'WFM_Supervisor';
    SELECT id INTO wfm_agent_id FROM roles WHERE name = 'WFM_Agent';
    SELECT id INTO dept_manager_id FROM roles WHERE name = 'Department_Manager';

    -- System_Admin: Full system access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT system_admin_id, p.id FROM permissions p;

    -- HR_Admin: Full HR system administrator with complete access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT hr_admin_id, p.id FROM permissions p 
    WHERE p.resource IN ('employees', 'departments', 'positions', 'employee_personal_info', 'employee_contact_info', 'employee_employment_info', 'employee_insurance_info', 'employee_bank_info', 'documents', 'notifications', 'workflow_instances', 'clearance_process', 'exit_interviews', 'reports', 'audit_logs');

    -- HR_Manager: HR Manager with management-level access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT hr_manager_id, p.id FROM permissions p 
    WHERE p.resource IN ('employees', 'departments', 'positions', 'employee_personal_info', 'employee_contact_info', 'employee_employment_info', 'employee_insurance_info', 'employee_bank_info', 'documents', 'notifications', 'workflow_instances', 'clearance_process', 'exit_interviews', 'reports')
    AND p.action IN ('CREATE', 'READ', 'UPDATE');

    -- HR_Representative: HR Representative with limited employee management access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT hr_representative_id, p.id FROM permissions p 
    WHERE p.resource IN ('employees', 'departments', 'positions', 'employee_personal_info', 'employee_contact_info', 'employee_employment_info', 'employee_insurance_info', 'employee_bank_info', 'documents', 'notifications', 'workflow_instances', 'reports')
    AND p.action IN ('CREATE', 'READ', 'UPDATE');

    -- HR_Viewer: HR Viewer with read-only access to employee data
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT hr_viewer_id, p.id FROM permissions p 
    WHERE p.resource IN ('employees', 'departments', 'positions', 'employee_personal_info', 'employee_contact_info', 'employee_employment_info', 'employee_insurance_info', 'employee_bank_info', 'documents', 'notifications', 'reports')
    AND p.action = 'READ';

    -- WFM_Admin: Full WFM system administrator with complete access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT wfm_admin_id, p.id FROM permissions p 
    WHERE p.resource IN ('agent_schedules', 'shift_templates', 'activity_codes', 'client_requirements', 'leave_requests', 'leave_types', 'employee_leave_balances', 'shift_trade_requests', 'capacity_plans', 'employees', 'departments', 'accounts', 'lobs', 'reports', 'audit_logs');

    -- WFM_Planner: WFM Planner with management-level access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT wfm_planner_id, p.id FROM permissions p 
    WHERE p.resource IN ('agent_schedules', 'shift_templates', 'activity_codes', 'client_requirements', 'leave_requests', 'leave_types', 'employee_leave_balances', 'shift_trade_requests', 'capacity_plans', 'employees', 'departments', 'accounts', 'lobs', 'reports')
    AND p.action IN ('CREATE', 'READ', 'UPDATE');

    -- WFM_Supervisor: WFM Supervisor with team management access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT wfm_supervisor_id, p.id FROM permissions p 
    WHERE p.resource IN ('agent_schedules', 'shift_templates', 'activity_codes', 'client_requirements', 'leave_requests', 'leave_types', 'employee_leave_balances', 'shift_trade_requests', 'capacity_plans', 'employees', 'departments', 'accounts', 'lobs', 'reports')
    AND p.action IN ('CREATE', 'READ', 'UPDATE');

    -- WFM_Agent: WFM Agent with limited self-service access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT wfm_agent_id, p.id FROM permissions p 
    WHERE p.resource IN ('agent_schedules', 'leave_requests', 'employee_leave_balances', 'shift_trade_requests', 'employees', 'departments')
    AND p.action IN ('CREATE', 'READ');

    -- Department_Manager: Department Manager with department-specific access
    INSERT INTO role_permissions ("roleId", "permissionId") 
    SELECT dept_manager_id, p.id FROM permissions p 
    WHERE p.resource IN ('employees', 'departments', 'positions', 'employee_personal_info', 'employee_contact_info', 'employee_employment_info', 'agent_schedules', 'leave_requests', 'employee_leave_balances', 'reports')
    AND p.action IN ('READ', 'UPDATE');

END $$;

-- Verify role permissions
SELECT 
    r.name as role_name,
    COUNT(rp."permissionId") as permission_count,
    STRING_AGG(DISTINCT p.resource, ', ' ORDER BY p.resource) as resources
FROM roles r
LEFT JOIN role_permissions rp ON r.id = rp."roleId"
LEFT JOIN permissions p ON rp."permissionId" = p.id
WHERE r."isActive" = true
GROUP BY r.id, r.name
ORDER BY 
    CASE 
        WHEN r.name = 'System_Admin' THEN 1
        WHEN r.name LIKE 'HR_%' THEN 2
        WHEN r.name LIKE 'WFM_%' THEN 3
        WHEN r.name = 'Department_Manager' THEN 4
        ELSE 5
    END,
    r.name;

-- Migration: Update roles to match template structure
-- This migration updates existing roles and adds missing ones based on HR_Authentication_Template.xlsx and WFM_Authentication_Template.xlsx

-- Step 1: Update existing roles to match template names
UPDATE roles SET 
    name = 'HR_Representative',
    description = 'HR Representative with limited employee management access'
WHERE name = 'HR_Specialist';

UPDATE roles SET 
    name = 'WFM_Admin',
    description = 'Full WFM system administrator with complete access'
WHERE name = 'WFM_Manager';

UPDATE roles SET 
    name = 'WFM_Agent',
    description = 'WFM Agent with limited self-service access'
WHERE name = 'Employee';

-- Step 2: Add missing roles
INSERT INTO roles (id, name, description, is_active, created_at, updated_at) VALUES
    (uuid_generate_v4(), 'HR_Admin', 'Full HR system administrator with complete access', true, NOW(), NOW()),
    (uuid_generate_v4(), 'HR_Viewer', 'HR Viewer with read-only access to employee data', true, NOW(), NOW()),
    (uuid_generate_v4(), 'WFM_Supervisor', 'WFM Supervisor with team management access', true, NOW(), NOW()),
    (uuid_generate_v4(), 'Department_Manager', 'Department Manager with department-specific access', true, NOW(), NOW());

-- Step 3: Verify all 12 roles are present
SELECT 
    name,
    description,
    is_active,
    created_at
FROM roles 
WHERE is_active = true
ORDER BY 
    CASE 
        WHEN name = 'System_Admin' THEN 1
        WHEN name LIKE 'HR_%' THEN 2
        WHEN name LIKE 'WFM_%' THEN 3
        WHEN name = 'Department_Manager' THEN 4
        ELSE 5
    END,
    name;

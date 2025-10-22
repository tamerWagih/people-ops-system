-- People Operation and Management System - Initial Seed Data
-- Created: October 22, 2025

-- =============================================
-- SEED DEPARTMENTS
-- =============================================
INSERT INTO departments (id, name, description) VALUES
    (uuid_generate_v4(), 'Human Resources', 'Human Resources Department'),
    (uuid_generate_v4(), 'Workforce Management', 'Workforce Management Department'),
    (uuid_generate_v4(), 'Operations', 'Operations Department'),
    (uuid_generate_v4(), 'Training', 'Training Department'),
    (uuid_generate_v4(), 'Quality Assurance', 'Quality Assurance Department'),
    (uuid_generate_v4(), 'IT', 'Information Technology Department'),
    (uuid_generate_v4(), 'Finance', 'Finance Department'),
    (uuid_generate_v4(), 'Administration', 'Administration Department')
ON CONFLICT (name) DO NOTHING;

-- =============================================
-- SEED ACCOUNTS
-- =============================================
INSERT INTO accounts (id, name, description) VALUES
    (uuid_generate_v4(), 'Internal', 'Internal Operations'),
    (uuid_generate_v4(), 'Client A', 'Client A Operations'),
    (uuid_generate_v4(), 'Client B', 'Client B Operations'),
    (uuid_generate_v4(), 'Client C', 'Client C Operations')
ON CONFLICT (name) DO NOTHING;

-- =============================================
-- SEED LINES OF BUSINESS
-- =============================================
INSERT INTO lobs (id, name, description) VALUES
    (uuid_generate_v4(), 'Customer Service', 'Customer Service Line of Business'),
    (uuid_generate_v4(), 'Technical Support', 'Technical Support Line of Business'),
    (uuid_generate_v4(), 'Sales', 'Sales Line of Business'),
    (uuid_generate_v4(), 'Back Office', 'Back Office Operations')
ON CONFLICT (name) DO NOTHING;

-- =============================================
-- SEED ACTIVITY CODES
-- =============================================
INSERT INTO activity_codes (id, code, name, description, is_productive, color) VALUES
    (uuid_generate_v4(), 'AVAIL', 'Available', 'Agent is available for calls', true, '#10B981'),
    (uuid_generate_v4(), 'BREAK', 'Break', 'Agent is on break', false, '#F59E0B'),
    (uuid_generate_v4(), 'LUNCH', 'Lunch', 'Agent is on lunch break', false, '#EF4444'),
    (uuid_generate_v4(), 'COACH', 'Coaching', 'Agent is in coaching session', true, '#3B82F6'),
    (uuid_generate_v4(), 'TRAIN', 'Training', 'Agent is in training session', true, '#8B5CF6'),
    (uuid_generate_v4(), 'MEET', 'Meeting', 'Agent is in meeting', true, '#06B6D4'),
    (uuid_generate_v4(), 'ADMIN', 'Administrative', 'Agent is doing administrative work', true, '#6B7280'),
    (uuid_generate_v4(), 'LEAVE', 'Leave', 'Agent is on leave', false, '#DC2626'),
    (uuid_generate_v4(), 'EARLY', 'Early Leave', 'Agent left early', false, '#F97316')
ON CONFLICT (code) DO NOTHING;

-- =============================================
-- SEED LEAVE TYPES
-- =============================================
INSERT INTO leave_types (id, name, code, max_days_per_year, requires_approval, is_paid) VALUES
    (uuid_generate_v4(), 'Annual Leave', 'ANNUAL', 21, true, true),
    (uuid_generate_v4(), 'Sick Leave', 'SICK', 10, true, true),
    (uuid_generate_v4(), 'Emergency Leave', 'EMERGENCY', 5, true, true),
    (uuid_generate_v4(), 'Personal Leave', 'PERSONAL', 3, true, false),
    (uuid_generate_v4(), 'Maternity Leave', 'MATERNITY', 90, true, true),
    (uuid_generate_v4(), 'Paternity Leave', 'PATERNITY', 7, true, true),
    (uuid_generate_v4(), 'Unpaid Leave', 'UNPAID', 30, true, false)
ON CONFLICT (code) DO NOTHING;

-- =============================================
-- CREATE SAMPLE EMPLOYEES
-- =============================================

-- Get department IDs for reference
DO $$
DECLARE
    hr_dept_id UUID;
    wfm_dept_id UUID;
    ops_dept_id UUID;
    it_dept_id UUID;
    internal_account_id UUID;
    cs_lob_id UUID;
BEGIN
    -- Get department IDs
    SELECT id INTO hr_dept_id FROM departments WHERE name = 'Human Resources' LIMIT 1;
    SELECT id INTO wfm_dept_id FROM departments WHERE name = 'Workforce Management' LIMIT 1;
    SELECT id INTO ops_dept_id FROM departments WHERE name = 'Operations' LIMIT 1;
    SELECT id INTO it_dept_id FROM departments WHERE name = 'IT' LIMIT 1;
    
    -- Get account and LOB IDs
    SELECT id INTO internal_account_id FROM accounts WHERE name = 'Internal' LIMIT 1;
    SELECT id INTO cs_lob_id FROM lobs WHERE name = 'Customer Service' LIMIT 1;
    
    -- Insert sample employees
    INSERT INTO employees (
        hr_id, full_name_en, national_id, date_of_birth, gender, 
        department_id, current_title, hiring_date, status, employment_type,
        business_area, phone_1, personal_email
    ) VALUES 
    ('HR001', 'Ahmed Mohamed', '12345678901234', '1990-05-15', 'Male', 
     hr_dept_id, 'HR Manager', '2020-01-15', 'Active', 'Full Time',
     'Production', '01234567890', 'ahmed.mohamed@company.com'),
    
    ('WFM001', 'Sara Ahmed', '23456789012345', '1988-03-22', 'Female',
     wfm_dept_id, 'WFM Planner', '2019-06-01', 'Active', 'Full Time',
     'Production', '01234567891', 'sara.ahmed@company.com'),
    
    ('OPS001', 'Mohamed Ali', '34567890123456', '1992-11-08', 'Male',
     ops_dept_id, 'Operations Supervisor', '2021-03-10', 'Active', 'Full Time',
     'Production', '01234567892', 'mohamed.ali@company.com'),
    
    ('IT001', 'Fatma Hassan', '45678901234567', '1985-09-12', 'Female',
     it_dept_id, 'IT Administrator', '2018-08-20', 'Active', 'Full Time',
     'Production', '01234567893', 'fatma.hassan@company.com')
    ON CONFLICT (hr_id) DO NOTHING;
    
    -- Set up reporting lines
    UPDATE employees 
    SET first_reporting_line_id = (SELECT id FROM employees WHERE hr_id = 'HR001' LIMIT 1)
    WHERE hr_id IN ('WFM001', 'OPS001');
    
    UPDATE employees 
    SET first_reporting_line_id = (SELECT id FROM employees WHERE hr_id = 'IT001' LIMIT 1)
    WHERE hr_id = 'IT001';
    
    -- Set up account and LOB assignments
    UPDATE employees 
    SET account_id = internal_account_id, lob_id = cs_lob_id
    WHERE hr_id IN ('HR001', 'WFM001', 'OPS001', 'IT001');
    
END $$;

-- =============================================
-- CREATE SAMPLE LEAVE BALANCES
-- =============================================
INSERT INTO employee_leave_balances (employee_id, leave_type_id, year, total_days)
SELECT 
    e.id,
    lt.id,
    2025,
    lt.max_days_per_year
FROM employees e
CROSS JOIN leave_types lt
WHERE e.is_deleted = false
ON CONFLICT (employee_id, leave_type_id, year) DO NOTHING;

-- =============================================
-- CREATE SAMPLE NOTIFICATION SETTINGS
-- =============================================
INSERT INTO notification_settings (employee_id, notification_type, days_before, is_enabled, email_enabled)
SELECT 
    e.id,
    'CONTRACT_EXPIRY',
    45,
    true,
    true
FROM employees e
WHERE e.is_deleted = false
ON CONFLICT (employee_id, notification_type) DO NOTHING;

INSERT INTO notification_settings (employee_id, notification_type, days_before, is_enabled, email_enabled)
SELECT 
    e.id,
    'DOCUMENT_EXPIRY',
    7,
    true,
    true
FROM employees e
WHERE e.is_deleted = false
ON CONFLICT (employee_id, notification_type) DO NOTHING;

INSERT INTO notification_settings (employee_id, notification_type, days_before, is_enabled, email_enabled)
SELECT 
    e.id,
    'RESIGNATION',
    0,
    true,
    true
FROM employees e
WHERE e.is_deleted = false
ON CONFLICT (employee_id, notification_type) DO NOTHING;

-- =============================================
-- CREATE SAMPLE SCHEDULES (for testing)
-- =============================================
INSERT INTO agent_schedules (employee_id, schedule_date, shift_start, shift_end, activity_code_id)
SELECT 
    e.id,
    CURRENT_DATE + INTERVAL '1 day',
    '09:00:00',
    '17:00:00',
    ac.id
FROM employees e
CROSS JOIN activity_codes ac
WHERE e.hr_id = 'OPS001' 
    AND ac.code = 'AVAIL'
ON CONFLICT DO NOTHING;

-- =============================================
-- CREATE SAMPLE CLIENT REQUIREMENTS
-- =============================================
INSERT INTO client_requirements (client_name, account_id, lob_id, requirement_date, interval_type, total_requirements)
SELECT 
    'Sample Client',
    a.id,
    l.id,
    CURRENT_DATE + INTERVAL '1 day',
    '30min',
    10
FROM accounts a, lobs l
WHERE a.name = 'Client A' AND l.name = 'Customer Service'
LIMIT 1;

-- Create requirement intervals
INSERT INTO client_requirement_intervals (client_requirement_id, interval_start, interval_end, required_agents)
SELECT 
    cr.id,
    '09:00:00',
    '09:30:00',
    5
FROM client_requirements cr
WHERE cr.client_name = 'Sample Client'
LIMIT 1;

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- Verify data was inserted correctly
SELECT 'Departments' as table_name, COUNT(*) as count FROM departments
UNION ALL
SELECT 'Accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'LOBs', COUNT(*) FROM lobs
UNION ALL
SELECT 'Activity Codes', COUNT(*) FROM activity_codes
UNION ALL
SELECT 'Leave Types', COUNT(*) FROM leave_types
UNION ALL
SELECT 'Employees', COUNT(*) FROM employees
UNION ALL
SELECT 'Leave Balances', COUNT(*) FROM employee_leave_balances
UNION ALL
SELECT 'Notification Settings', COUNT(*) FROM notification_settings;

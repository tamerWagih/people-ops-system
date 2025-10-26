-- People Operation and Management System - Initial Seed Data (Normalized Schema)
-- Created: October 26, 2025

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
-- CREATE SAMPLE EMPLOYEES (Core Table Only)
-- =============================================

-- Get department IDs for reference
DO $$
DECLARE
    hr_dept_id UUID;
    wfm_dept_id UUID;
    ops_dept_id UUID;
    it_dept_id UUID;
BEGIN
    -- Get department IDs
    SELECT id INTO hr_dept_id FROM departments WHERE name = 'Human Resources' LIMIT 1;
    SELECT id INTO wfm_dept_id FROM departments WHERE name = 'Workforce Management' LIMIT 1;
    SELECT id INTO ops_dept_id FROM departments WHERE name = 'Operations' LIMIT 1;
    SELECT id INTO it_dept_id FROM departments WHERE name = 'IT' LIMIT 1;
    
    -- Insert sample employees (core table only)
    INSERT INTO employees (
        hr_id, full_name_en, national_id, date_of_birth, gender, 
        department_id, current_title, hiring_date, status, employment_type
    ) VALUES 
    ('HR001', 'Ahmed Mohamed', '12345678901234', '1990-05-15', 'Male', 
     hr_dept_id, 'HR Manager', '2020-01-15', 'Active', 'Full Time'),
    
    ('WFM001', 'Sara Ahmed', '23456789012345', '1988-03-22', 'Female',
     wfm_dept_id, 'WFM Planner', '2019-06-01', 'Active', 'Full Time'),
    
    ('OPS001', 'Mohamed Ali', '34567890123456', '1992-11-08', 'Male',
     ops_dept_id, 'Operations Supervisor', '2021-03-10', 'Active', 'Full Time'),
    
    ('IT001', 'Fatma Hassan', '45678901234567', '1985-09-12', 'Female',
     it_dept_id, 'IT Administrator', '2018-08-20', 'Active', 'Full Time')
    ON CONFLICT (hr_id) DO NOTHING;
    
END $$;

-- =============================================
-- CREATE EMPLOYEE PERSONAL INFORMATION
-- =============================================
DO $$
DECLARE
    hr_emp_id UUID;
    wfm_emp_id UUID;
    ops_emp_id UUID;
    it_emp_id UUID;
BEGIN
    -- Get employee IDs
    SELECT id INTO hr_emp_id FROM employees WHERE hr_id = 'HR001' LIMIT 1;
    SELECT id INTO wfm_emp_id FROM employees WHERE hr_id = 'WFM001' LIMIT 1;
    SELECT id INTO ops_emp_id FROM employees WHERE hr_id = 'OPS001' LIMIT 1;
    SELECT id INTO it_emp_id FROM employees WHERE hr_id = 'IT001' LIMIT 1;
    
    -- Insert personal information
    INSERT INTO employee_personal_info (
        employee_id, graduation_year, major, academic_year,
        profile, batch_skill, elastix, zoiper_extension, nt, channel,
        birth_certificate, national_id_copy, education_certificate, 
        military_certificate, work_book, criminal_record, 
        insurance_print, personal_photos, form_111, bank_account_form
    ) VALUES 
    (hr_emp_id, 2012, 'Business Administration', '2012', 'Manager', 'Management', 'EXT001', 'Z001', 'NT001', 'CH001',
     true, true, true, true, true, true, true, true, true, true),
    
    (wfm_emp_id, 2010, 'Operations Management', '2010', 'Planner', 'WFM', 'EXT002', 'Z002', 'NT002', 'CH002',
     true, true, true, true, true, true, true, true, true, true),
    
    (ops_emp_id, 2014, 'Computer Science', '2014', 'Supervisor', 'Operations', 'EXT003', 'Z003', 'NT003', 'CH003',
     true, true, true, true, true, true, true, true, true, true),
    
    (it_emp_id, 2007, 'Information Technology', '2007', 'Admin', 'IT', 'EXT004', 'Z004', 'NT004', 'CH004',
     true, true, true, true, true, true, true, true, true, true)
    ON CONFLICT DO NOTHING;
    
END $$;

-- =============================================
-- CREATE EMPLOYEE CONTACT INFORMATION
-- =============================================
DO $$
DECLARE
    hr_emp_id UUID;
    wfm_emp_id UUID;
    ops_emp_id UUID;
    it_emp_id UUID;
BEGIN
    -- Get employee IDs
    SELECT id INTO hr_emp_id FROM employees WHERE hr_id = 'HR001' LIMIT 1;
    SELECT id INTO wfm_emp_id FROM employees WHERE hr_id = 'WFM001' LIMIT 1;
    SELECT id INTO ops_emp_id FROM employees WHERE hr_id = 'OPS001' LIMIT 1;
    SELECT id INTO it_emp_id FROM employees WHERE hr_id = 'IT001' LIMIT 1;
    
    -- Insert contact information
    INSERT INTO employee_contact_info (
        employee_id, phone_1, phone_2, home_address, emergency_contact_no, emergency_contact_degree,
        personal_email, octopus_email, bpo_email, cci_email, client_email
    ) VALUES 
    (hr_emp_id, '01234567890', '01234567891', 'Cairo, Egypt', '01234567892', 'Brother',
     'ahmed.mohamed@personal.com', 'ahmed.mohamed@octopus.com', 'ahmed.mohamed@bpo.com', 'ahmed.mohamed@cci.com', 'ahmed.mohamed@client.com'),
    
    (wfm_emp_id, '01234567893', '01234567894', 'Alexandria, Egypt', '01234567895', 'Sister',
     'sara.ahmed@personal.com', 'sara.ahmed@octopus.com', 'sara.ahmed@bpo.com', 'sara.ahmed@cci.com', 'sara.ahmed@client.com'),
    
    (ops_emp_id, '01234567896', '01234567897', 'Giza, Egypt', '01234567898', 'Father',
     'mohamed.ali@personal.com', 'mohamed.ali@octopus.com', 'mohamed.ali@bpo.com', 'mohamed.ali@cci.com', 'mohamed.ali@client.com'),
    
    (it_emp_id, '01234567899', '01234567900', 'Sharm El Sheikh, Egypt', '01234567901', 'Mother',
     'fatma.hassan@personal.com', 'fatma.hassan@octopus.com', 'fatma.hassan@bpo.com', 'fatma.hassan@cci.com', 'fatma.hassan@client.com')
    ON CONFLICT DO NOTHING;
    
END $$;

-- =============================================
-- CREATE EMPLOYEE EMPLOYMENT INFORMATION
-- =============================================
DO $$
DECLARE
    hr_emp_id UUID;
    wfm_emp_id UUID;
    ops_emp_id UUID;
    it_emp_id UUID;
    internal_account_id UUID;
    cs_lob_id UUID;
BEGIN
    -- Get employee IDs
    SELECT id INTO hr_emp_id FROM employees WHERE hr_id = 'HR001' LIMIT 1;
    SELECT id INTO wfm_emp_id FROM employees WHERE hr_id = 'WFM001' LIMIT 1;
    SELECT id INTO ops_emp_id FROM employees WHERE hr_id = 'OPS001' LIMIT 1;
    SELECT id INTO it_emp_id FROM employees WHERE hr_id = 'IT001' LIMIT 1;
    
    -- Get account and LOB IDs
    SELECT id INTO internal_account_id FROM accounts WHERE name = 'Internal' LIMIT 1;
    SELECT id INTO cs_lob_id FROM lobs WHERE name = 'Customer Service' LIMIT 1;
    
    -- Insert employment information
    INSERT INTO employee_employment_info (
        employee_id, sub_department, language, first_reporting_line_id, second_reporting_line_id,
        previous_titles, account_id, lob_id, sub_lob, work_on_site, site,
        contract_date, certification_date, effective_date, business_area, status_date,
        internal_external, sf_rooster_fd, batch_no, tenure_days, skill, lts_login_id,
        attrition_reason, sub_attrition_reason, resignation_date, active_directly, locker_number
    ) VALUES 
    (hr_emp_id, 'HR Management', 'English', NULL, NULL, ARRAY['HR Assistant', 'HR Specialist'],
     internal_account_id, cs_lob_id, 'HR Operations', true, 'Plaza', '2020-01-15', '2020-01-20', '2020-01-15',
     'Production', '2020-01-15', 'Internal', 'SF001', 'BATCH001', 1500, 'HR Management', 'LTS001',
     NULL, NULL, NULL, true, 'L001'),
    
    (wfm_emp_id, 'WFM Planning', 'English', hr_emp_id, NULL, ARRAY['WFM Analyst'],
     internal_account_id, cs_lob_id, 'WFM Operations', true, 'Palm City', '2019-06-01', '2019-06-05', '2019-06-01',
     'Production', '2019-06-01', 'Internal', 'SF002', 'BATCH002', 2000, 'WFM Planning', 'LTS002',
     NULL, NULL, NULL, true, 'L002'),
    
    (ops_emp_id, 'Operations', 'English', hr_emp_id, NULL, ARRAY['Operations Agent'],
     internal_account_id, cs_lob_id, 'Operations', true, 'Smart Valley', '2021-03-10', '2021-03-15', '2021-03-10',
     'Production', '2021-03-10', 'Internal', 'SF003', 'BATCH003', 1000, 'Operations', 'LTS003',
     NULL, NULL, NULL, true, 'L003'),
    
    (it_emp_id, 'IT Support', 'English', hr_emp_id, NULL, ARRAY['IT Technician'],
     internal_account_id, cs_lob_id, 'IT Operations', true, 'Assiut', '2018-08-20', '2018-08-25', '2018-08-20',
     'Production', '2018-08-20', 'Internal', 'SF004', 'BATCH004', 2500, 'IT Support', 'LTS004',
     NULL, NULL, NULL, true, 'L004')
    ON CONFLICT DO NOTHING;
    
END $$;

-- =============================================
-- CREATE EMPLOYEE INSURANCE INFORMATION
-- =============================================
DO $$
DECLARE
    hr_emp_id UUID;
    wfm_emp_id UUID;
    ops_emp_id UUID;
    it_emp_id UUID;
BEGIN
    -- Get employee IDs
    SELECT id INTO hr_emp_id FROM employees WHERE hr_id = 'HR001' LIMIT 1;
    SELECT id INTO wfm_emp_id FROM employees WHERE hr_id = 'WFM001' LIMIT 1;
    SELECT id INTO ops_emp_id FROM employees WHERE hr_id = 'OPS001' LIMIT 1;
    SELECT id INTO it_emp_id FROM employees WHERE hr_id = 'IT001' LIMIT 1;
    
    -- Insert insurance information
    INSERT INTO employee_insurance_info (
        employee_id, insurance_title, nda_signed, signing_contract,
        headset_serial, laptop_serial, laptop_custody_form,
        insurance_salary, social_insurance_no, social_insurance_date, social_insurance_status, social_insurance_applicable,
        medical_insurance_applicable, medical_insurance_no, medical_insurance_status, medical_insurance_expiry
    ) VALUES 
    (hr_emp_id, 'Manager', true, true, 'HS001', 'LP001', true, 15000.00, 'SI001', '2020-01-15', true, true, true, 'MI001', true, '2025-12-31'),
    
    (wfm_emp_id, 'Planner', true, true, 'HS002', 'LP002', true, 12000.00, 'SI002', '2019-06-01', true, true, true, 'MI002', true, '2025-12-31'),
    
    (ops_emp_id, 'Supervisor', true, true, 'HS003', 'LP003', true, 10000.00, 'SI003', '2021-03-10', true, true, true, 'MI003', true, '2025-12-31'),
    
    (it_emp_id, 'Administrator', true, true, 'HS004', 'LP004', true, 18000.00, 'SI004', '2018-08-20', true, true, true, 'MI004', true, '2025-12-31')
    ON CONFLICT DO NOTHING;
    
END $$;

-- =============================================
-- CREATE EMPLOYEE BANK INFORMATION
-- =============================================
DO $$
DECLARE
    hr_emp_id UUID;
    wfm_emp_id UUID;
    ops_emp_id UUID;
    it_emp_id UUID;
BEGIN
    -- Get employee IDs
    SELECT id INTO hr_emp_id FROM employees WHERE hr_id = 'HR001' LIMIT 1;
    SELECT id INTO wfm_emp_id FROM employees WHERE hr_id = 'WFM001' LIMIT 1;
    SELECT id INTO ops_emp_id FROM employees WHERE hr_id = 'OPS001' LIMIT 1;
    SELECT id INTO it_emp_id FROM employees WHERE hr_id = 'IT001' LIMIT 1;
    
    -- Insert bank information
    INSERT INTO employee_bank_info (
        employee_id, bank_account_number, salary
    ) VALUES 
    (hr_emp_id, '12345678901234567890', 15000.00),
    (wfm_emp_id, '12345678901234567891', 12000.00),
    (ops_emp_id, '12345678901234567892', 10000.00),
    (it_emp_id, '12345678901234567893', 18000.00)
    ON CONFLICT DO NOTHING;
    
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
SELECT 'Database seeded successfully!' as status;
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
SELECT 'Employee Personal Info', COUNT(*) FROM employee_personal_info
UNION ALL
SELECT 'Employee Contact Info', COUNT(*) FROM employee_contact_info
UNION ALL
SELECT 'Employee Employment Info', COUNT(*) FROM employee_employment_info
UNION ALL
SELECT 'Employee Insurance Info', COUNT(*) FROM employee_insurance_info
UNION ALL
SELECT 'Employee Bank Info', COUNT(*) FROM employee_bank_info
UNION ALL
SELECT 'Leave Balances', COUNT(*) FROM employee_leave_balances
UNION ALL
SELECT 'Notification Settings', COUNT(*) FROM notification_settings;
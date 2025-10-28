-- People Operation and Management System - Initial Seed Data (Updated)
-- Created: October 27, 2025
-- Last Modified: October 27, 2025 (Updated with clean reference data)

-- =============================================
-- SEED SUPPORTING TABLES WITH CLEAN DATA
-- =============================================

-- Departments (27 cleaned departments)
INSERT INTO departments (id, name, description) VALUES
    (uuid_generate_v4(), 'Academy', 'Academy Department'),
    (uuid_generate_v4(), 'Administration', 'Administration Department'),
    (uuid_generate_v4(), 'Brightskies', 'Brightskies Department'),
    (uuid_generate_v4(), 'Commercial', 'Commercial Department'),
    (uuid_generate_v4(), 'Dentistry', 'Dentistry Department'),
    (uuid_generate_v4(), 'Digital Solutions', 'Digital Solutions Department'),
    (uuid_generate_v4(), 'Facility', 'Facility Department'),
    (uuid_generate_v4(), 'Finance', 'Finance Department'),
    (uuid_generate_v4(), 'Governance ,Risk & Compliance', 'Governance Risk & Compliance Department'),
    (uuid_generate_v4(), 'Human Resources', 'Human Resources Department'),
    (uuid_generate_v4(), 'IT', 'Information Technology Department'),
    (uuid_generate_v4(), 'MIS', 'Management Information Systems Department'),
    (uuid_generate_v4(), 'Marketing', 'Marketing Department'),
    (uuid_generate_v4(), 'OD', 'Organizational Development Department'),
    (uuid_generate_v4(), 'Octopus Academy', 'Octopus Academy Department'),
    (uuid_generate_v4(), 'Operations', 'Operations Department'),
    (uuid_generate_v4(), 'People & Culture', 'People & Culture Department'),
    (uuid_generate_v4(), 'People and Culture', 'People and Culture Department'),
    (uuid_generate_v4(), 'Physical Security', 'Physical Security Department'),
    (uuid_generate_v4(), 'Quality', 'Quality Department'),
    (uuid_generate_v4(), 'Quality Assurance', 'Quality Assurance Department'),
    (uuid_generate_v4(), 'Supporting Functions', 'Supporting Functions Department'),
    (uuid_generate_v4(), 'Talent Acquisition', 'Talent Acquisition Department'),
    (uuid_generate_v4(), 'Top Management', 'Top Management Department'),
    (uuid_generate_v4(), 'Training', 'Training Department'),
    (uuid_generate_v4(), 'WFM', 'Workforce Management Department'),
    (uuid_generate_v4(), 'Warehouse', 'Warehouse Department');

-- Accounts (39 cleaned accounts)
INSERT INTO accounts (id, name, description) VALUES
    (uuid_generate_v4(), 'Admin', 'Admin Account'),
    (uuid_generate_v4(), 'Annotation', 'Annotation Account'),
    (uuid_generate_v4(), 'Dentakay', 'Dentakay Account'),
    (uuid_generate_v4(), 'Dispatch', 'Dispatch Account'),
    (uuid_generate_v4(), 'EnBW', 'EnBW Account'),
    (uuid_generate_v4(), 'Facility', 'Facility Account'),
    (uuid_generate_v4(), 'Governance ,Risk & Compliance', 'Governance Risk & Compliance Account'),
    (uuid_generate_v4(), 'HoPro', 'HoPro Account'),
    (uuid_generate_v4(), 'Human Resources', 'Human Resources Account'),
    (uuid_generate_v4(), 'Instacart', 'Instacart Account'),
    (uuid_generate_v4(), 'Instacart - Consumer', 'Instacart Consumer Account'),
    (uuid_generate_v4(), 'Instacart - Shopper', 'Instacart Shopper Account'),
    (uuid_generate_v4(), 'Instacart - Shoppers', 'Instacart Shoppers Account'),
    (uuid_generate_v4(), 'Instcard Consumer-SHW', 'Instcard Consumer-SHW Account'),
    (uuid_generate_v4(), 'Management', 'Management Account'),
    (uuid_generate_v4(), 'Mizlegal', 'Mizlegal Account'),
    (uuid_generate_v4(), 'Netflix', 'Netflix Account'),
    (uuid_generate_v4(), 'Netflix/Instacart', 'Netflix/Instacart Account'),
    (uuid_generate_v4(), 'OYO', 'OYO Account'),
    (uuid_generate_v4(), 'Offshore', 'Offshore Account'),
    (uuid_generate_v4(), 'Palning & Scheduling', 'Planning & Scheduling Account'),
    (uuid_generate_v4(), 'Physical Security', 'Physical Security Account'),
    (uuid_generate_v4(), 'RTM', 'RTM Account'),
    (uuid_generate_v4(), 'SHW', 'SHW Account'),
    (uuid_generate_v4(), 'Sales', 'Sales Account'),
    (uuid_generate_v4(), 'SoundHound', 'SoundHound Account'),
    (uuid_generate_v4(), 'Supporting Functions', 'Supporting Functions Account'),
    (uuid_generate_v4(), 'TGM', 'TGM Account'),
    (uuid_generate_v4(), 'Talabat', 'Talabat Account'),
    (uuid_generate_v4(), 'Talabat - Content', 'Talabat Content Account'),
    (uuid_generate_v4(), 'Talabat - Customer Care', 'Talabat Customer Care Account'),
    (uuid_generate_v4(), 'Talabat - Dispatch', 'Talabat Dispatch Account'),
    (uuid_generate_v4(), 'Talabat - Partner Care', 'Talabat Partner Care Account'),
    (uuid_generate_v4(), 'Talabat - Partner Support', 'Talabat Partner Support Account'),
    (uuid_generate_v4(), 'Talent Acquisition', 'Talent Acquisition Account'),
    (uuid_generate_v4(), 'Transportation', 'Transportation Account'),
    (uuid_generate_v4(), 'Urban Piper', 'Urban Piper Account'),
    (uuid_generate_v4(), 'Voltec', 'Voltec Account'),
    (uuid_generate_v4(), 'Warehouse', 'Warehouse Account');

-- Lines of Business (37 cleaned LOBs)
INSERT INTO lobs (id, name, description) VALUES
    (uuid_generate_v4(), 'AWT', 'AWT Line of Business'),
    (uuid_generate_v4(), 'Back Office', 'Back Office Line of Business'),
    (uuid_generate_v4(), 'CLT', 'CLT Line of Business'),
    (uuid_generate_v4(), 'CS', 'CS Line of Business'),
    (uuid_generate_v4(), 'Customer Care', 'Customer Care Line of Business'),
    (uuid_generate_v4(), 'Care ++', 'Care ++ Line of Business'),
    (uuid_generate_v4(), 'Care Profile', 'Care Profile Line of Business'),
    (uuid_generate_v4(), 'Chat', 'Chat Line of Business'),
    (uuid_generate_v4(), 'Content Moderation', 'Content Moderation Line of Business'),
    (uuid_generate_v4(), 'Danish', 'Danish Line of Business'),
    (uuid_generate_v4(), 'Dispatch', 'Dispatch Line of Business'),
    (uuid_generate_v4(), 'ELevated Profile', 'Elevated Profile Line of Business'),
    (uuid_generate_v4(), 'GHC EG', 'GHC EG Line of Business'),
    (uuid_generate_v4(), 'German', 'German Line of Business'),
    (uuid_generate_v4(), 'HoPro', 'HoPro Line of Business'),
    (uuid_generate_v4(), 'LC', 'LC Line of Business'),
    (uuid_generate_v4(), 'MRR', 'MRR Line of Business'),
    (uuid_generate_v4(), 'Menu Editing', 'Menu Editing Line of Business'),
    (uuid_generate_v4(), 'Menu Editing Minor', 'Menu Editing Minor Line of Business'),
    (uuid_generate_v4(), 'Menu Editing NFV', 'Menu Editing NFV Line of Business'),
    (uuid_generate_v4(), 'Menu Typing FV', 'Menu Typing FV Line of Business'),
    (uuid_generate_v4(), 'Menu editing AAA MQC', 'Menu editing AAA MQC Line of Business'),
    (uuid_generate_v4(), 'NAT', 'NAT Line of Business'),
    (uuid_generate_v4(), 'OBDE', 'OBDE Line of Business'),
    (uuid_generate_v4(), 'Partner Support', 'Partner Support Line of Business'),
    (uuid_generate_v4(), 'Payment Reconciliation', 'Payment Reconciliation Line of Business'),
    (uuid_generate_v4(), 'RS', 'RS Line of Business'),
    (uuid_generate_v4(), 'Sales', 'Sales Line of Business'),
    (uuid_generate_v4(), 'Sales AR', 'Sales AR Line of Business'),
    (uuid_generate_v4(), 'Security', 'Security Line of Business'),
    (uuid_generate_v4(), 'Supporting Function', 'Supporting Function Line of Business'),
    (uuid_generate_v4(), 'Supporting Functions', 'Supporting Functions Line of Business'),
    (uuid_generate_v4(), 'T Mart', 'T Mart Line of Business'),
    (uuid_generate_v4(), 'TGM', 'TGM Line of Business'),
    (uuid_generate_v4(), 'TPRO', 'TPRO Line of Business'),
    (uuid_generate_v4(), 'Vendor Sales', 'Vendor Sales Line of Business'),
    (uuid_generate_v4(), 'Voice', 'Voice Line of Business');

-- Activity Codes (WFM)
INSERT INTO activity_codes (id, code, name, description, is_productive, color) VALUES
    (uuid_generate_v4(), 'AVAIL', 'Available', 'Agent is available for calls', true, '#10B981'),
    (uuid_generate_v4(), 'BREAK', 'Break', 'Agent is on break', false, '#F59E0B'),
    (uuid_generate_v4(), 'LUNCH', 'Lunch', 'Agent is on lunch break', false, '#EF4444'),
    (uuid_generate_v4(), 'COACH', 'Coaching', 'Agent is in coaching session', true, '#3B82F6'),
    (uuid_generate_v4(), 'TRAIN', 'Training', 'Agent is in training session', true, '#8B5CF6'),
    (uuid_generate_v4(), 'MEET', 'Meeting', 'Agent is in meeting', true, '#06B6D4'),
    (uuid_generate_v4(), 'ADMIN', 'Administrative', 'Agent is doing administrative work', true, '#6B7280'),
    (uuid_generate_v4(), 'LEAVE', 'Leave', 'Agent is on leave', false, '#DC2626'),
    (uuid_generate_v4(), 'EARLY', 'Early Leave', 'Agent left early', false, '#F97316'),
    (uuid_generate_v4(), 'OFF', 'OFF', 'Agent is off duty', false, '#9CA3AF'),
    (uuid_generate_v4(), 'SICK', 'Sick', 'Agent is on sick leave', false, '#EF4444'),
    (uuid_generate_v4(), 'TASK', 'Task', 'Agent is working on specific task', true, '#10B981'),
    (uuid_generate_v4(), 'USL', 'Unpaid Sick Leave', 'Agent is on unpaid sick leave', false, '#DC2626'),
    (uuid_generate_v4(), 'DAYS_OFF', 'Days OFF', 'Agent is on scheduled days off', false, '#9CA3AF'),
    (uuid_generate_v4(), 'NOT_SCH', 'Not Scheduled', 'Agent is not scheduled', false, '#6B7280'),
    (uuid_generate_v4(), 'CASUAL', 'Casual', 'Agent is on casual leave', false, '#F59E0B'),
    (uuid_generate_v4(), 'PLANNED_SICK', 'Planned Sick', 'Agent is on planned sick leave', false, '#EF4444'),
    (uuid_generate_v4(), 'PROMOTED', 'Promoted', 'Agent has been promoted', true, '#10B981');

-- Leave Types
INSERT INTO leave_types (id, name, code, max_days_per_year, requires_approval, is_paid) VALUES
    (uuid_generate_v4(), 'Annual Leave', 'ANNUAL', 21, true, true),
    (uuid_generate_v4(), 'Sick Leave', 'SICK', 10, true, true),
    (uuid_generate_v4(), 'Emergency Leave', 'EMERGENCY', 5, true, true),
    (uuid_generate_v4(), 'Personal Leave', 'PERSONAL', 3, true, false),
    (uuid_generate_v4(), 'Maternity Leave', 'MATERNITY', 90, true, true),
    (uuid_generate_v4(), 'Paternity Leave', 'PATERNITY', 7, true, true),
    (uuid_generate_v4(), 'Unpaid Leave', 'UNPAID', 30, true, false);

-- Shift Templates
INSERT INTO shift_templates (id, name, shift_start, shift_end, break_duration) VALUES
    (uuid_generate_v4(), 'Morning Shift', '07:00:00', '16:00:00', 60),
    (uuid_generate_v4(), 'Day Shift', '08:00:00', '17:00:00', 60),
    (uuid_generate_v4(), 'Afternoon Shift', '09:00:00', '18:00:00', 60),
    (uuid_generate_v4(), 'Evening Shift', '10:00:00', '19:00:00', 60),
    (uuid_generate_v4(), 'Night Shift', '11:00:00', '20:00:00', 60),
    (uuid_generate_v4(), 'Late Night Shift', '12:00:00', '21:00:00', 60),
    (uuid_generate_v4(), 'Graveyard Shift', '13:00:00', '22:00:00', 60);

-- =============================================
-- SEED AUTHENTICATION SYSTEM
-- =============================================

-- Roles
INSERT INTO roles (id, name, description) VALUES
    (uuid_generate_v4(), 'Super Admin', 'Super Administrator with full system access'),
    (uuid_generate_v4(), 'HR Manager', 'Human Resources Manager'),
    (uuid_generate_v4(), 'HR Specialist', 'Human Resources Specialist'),
    (uuid_generate_v4(), 'WFM Manager', 'Workforce Management Manager'),
    (uuid_generate_v4(), 'WFM Planner', 'Workforce Management Planner'),
    (uuid_generate_v4(), 'Operations Manager', 'Operations Manager'),
    (uuid_generate_v4(), 'Team Leader', 'Team Leader'),
    (uuid_generate_v4(), 'Agent', 'Customer Service Agent'),
    (uuid_generate_v4(), 'Employee', 'Regular Employee');

-- Permissions
INSERT INTO permissions (id, name, description, module, action, resource) VALUES
    -- HR Permissions
    (uuid_generate_v4(), 'HR_CREATE_EMPLOYEE', 'Create new employee', 'HR', 'CREATE', 'EMPLOYEE'),
    (uuid_generate_v4(), 'HR_READ_EMPLOYEE', 'View employee information', 'HR', 'READ', 'EMPLOYEE'),
    (uuid_generate_v4(), 'HR_UPDATE_EMPLOYEE', 'Update employee information', 'HR', 'UPDATE', 'EMPLOYEE'),
    (uuid_generate_v4(), 'HR_DELETE_EMPLOYEE', 'Delete employee', 'HR', 'DELETE', 'EMPLOYEE'),
    
    -- WFM Permissions
    (uuid_generate_v4(), 'WFM_CREATE_SCHEDULE', 'Create schedules', 'WFM', 'CREATE', 'SCHEDULE'),
    (uuid_generate_v4(), 'WFM_READ_SCHEDULE', 'View schedules', 'WFM', 'READ', 'SCHEDULE'),
    (uuid_generate_v4(), 'WFM_UPDATE_SCHEDULE', 'Update schedules', 'WFM', 'UPDATE', 'SCHEDULE'),
    (uuid_generate_v4(), 'WFM_DELETE_SCHEDULE', 'Delete schedules', 'WFM', 'DELETE', 'SCHEDULE'),
    
    -- Admin Permissions
    (uuid_generate_v4(), 'ADMIN_CREATE_USER', 'Create users', 'ADMIN', 'CREATE', 'USER'),
    (uuid_generate_v4(), 'ADMIN_READ_USER', 'View users', 'ADMIN', 'READ', 'USER'),
    (uuid_generate_v4(), 'ADMIN_UPDATE_USER', 'Update users', 'ADMIN', 'UPDATE', 'USER'),
    (uuid_generate_v4(), 'ADMIN_DELETE_USER', 'Delete users', 'ADMIN', 'DELETE', 'USER');

-- =============================================
-- CREATE SAMPLE EMPLOYEES (CORE)
-- =============================================
DO $$
DECLARE
    hr_dept_id UUID;
    wfm_dept_id UUID;
    ops_dept_id UUID;
    it_dept_id UUID;
    internal_account_id UUID;
    cs_lob_id UUID;
    
    hr_emp_id UUID;
    wfm_emp_id UUID;
    ops_emp_id UUID;
    it_emp_id UUID;
BEGIN
    -- Get department IDs
    SELECT id INTO hr_dept_id FROM departments WHERE name = 'Human Resources' LIMIT 1;
    SELECT id INTO wfm_dept_id FROM departments WHERE name = 'WFM' LIMIT 1;
    SELECT id INTO ops_dept_id FROM departments WHERE name = 'Operations' LIMIT 1;
    SELECT id INTO it_dept_id FROM departments WHERE name = 'IT' LIMIT 1;
    
    -- Get account and LOB IDs
    SELECT id INTO internal_account_id FROM accounts WHERE name = 'Admin' LIMIT 1;
    SELECT id INTO cs_lob_id FROM lobs WHERE name = 'Customer Care' LIMIT 1;
    
    -- Insert sample employees (core info)
    INSERT INTO employees (
        hr_id, full_name_en, national_id, date_of_birth, gender, 
        department_id, current_title, hiring_date, status, employment_type
    ) VALUES 
    ('HR001', 'Ahmed Mohamed', '12345678901234', '1990-05-15', 'Male', 
     hr_dept_id, 'HR Manager', '2020-01-15', 'Active', 'Full Time')
    ON CONFLICT (hr_id) DO NOTHING
    RETURNING id INTO hr_emp_id;
    
    INSERT INTO employees (
        hr_id, full_name_en, national_id, date_of_birth, gender, 
        department_id, current_title, hiring_date, status, employment_type
    ) VALUES 
    ('WFM001', 'Sara Ahmed', '23456789012345', '1988-03-22', 'Female',
     wfm_dept_id, 'WFM Planner', '2019-06-01', 'Active', 'Full Time')
    ON CONFLICT (hr_id) DO NOTHING
    RETURNING id INTO wfm_emp_id;
    
    INSERT INTO employees (
        hr_id, full_name_en, national_id, date_of_birth, gender, 
        department_id, current_title, hiring_date, status, employment_type
    ) VALUES 
    ('OPS001', 'Mohamed Ali', '34567890123456', '1992-11-08', 'Male',
     ops_dept_id, 'Operations Supervisor', '2021-03-10', 'Active', 'Full Time')
    ON CONFLICT (hr_id) DO NOTHING
    RETURNING id INTO ops_emp_id;
    
    INSERT INTO employees (
        hr_id, full_name_en, national_id, date_of_birth, gender, 
        department_id, current_title, hiring_date, status, employment_type
    ) VALUES 
    ('IT001', 'Fatma Hassan', '45678901234567', '1985-09-12', 'Female',
     it_dept_id, 'IT Administrator', '2018-08-20', 'Active', 'Full Time')
    ON CONFLICT (hr_id) DO NOTHING
    RETURNING id INTO it_emp_id;

    -- =============================================
    -- INSERT EMPLOYEE PERSONAL INFO
    -- =============================================
    INSERT INTO employee_personal_info (
        employee_id, graduation_year, major, academic_year,
        profile, batch_skill, elastix, zoiper_extension, nt, channel,
        birth_certificate, national_id_copy, education_certificate, 
        military_certificate, work_book, criminal_record, 
        insurance_print, personal_photos, form_111, bank_account_form,
        headset_serial, laptop_serial, yubikey_serial, locker_number
    ) VALUES 
    (hr_emp_id, 2012, 'Business Administration', '2012', 'Manager', 'Management', 'EXT001', 'Z001', 'NT001', 'CH001',
     true, true, true, true, true, true, true, true, true, true, 'HS001', 'LP001', 'YK001', 'L001'),
    
    (wfm_emp_id, 2010, 'Operations Management', '2010', 'Planner', 'WFM', 'EXT002', 'Z002', 'NT002', 'CH002',
     true, true, true, true, true, true, true, true, true, true, 'HS002', 'LP002', 'YK002', 'L002'),
    
    (ops_emp_id, 2014, 'Computer Science', '2014', 'Supervisor', 'Operations', 'EXT003', 'Z003', 'NT003', 'CH003',
     true, true, true, true, true, true, true, true, true, true, 'HS003', 'LP003', 'YK003', 'L003'),
    
    (it_emp_id, 2007, 'Information Technology', '2007', 'Admin', 'IT', 'EXT004', 'Z004', 'NT004', 'CH004',
     true, true, true, true, true, true, true, true, true, true, 'HS004', 'LP004', 'YK004', 'L004');

    -- =============================================
    -- INSERT EMPLOYEE CONTACT INFO
    -- =============================================
    INSERT INTO employee_contact_info (
        employee_id, phone_1, phone_2, home_address, emergency_contact_no, emergency_contact_degree,
        personal_email, octopus_email, bpo_email, cci_email, client_email, m360_email
    ) VALUES 
    (hr_emp_id, '01234567890', '01234567891', 'Cairo, Egypt', '01234567892', 'Brother',
     'ahmed.mohamed@personal.com', 'ahmed.mohamed@octopus.com', 'ahmed.mohamed@bpo.com', 'ahmed.mohamed@cci.com', 'ahmed.mohamed@client.com', 'ahmed.mohamed@m360.com'),
    
    (wfm_emp_id, '01234567893', '01234567894', 'Alexandria, Egypt', '01234567895', 'Sister',
     'sara.ahmed@personal.com', 'sara.ahmed@octopus.com', 'sara.ahmed@bpo.com', 'sara.ahmed@cci.com', 'sara.ahmed@client.com', 'sara.ahmed@m360.com'),
    
    (ops_emp_id, '01234567896', '01234567897', 'Giza, Egypt', '01234567898', 'Father',
     'mohamed.ali@personal.com', 'mohamed.ali@octopus.com', 'mohamed.ali@bpo.com', 'mohamed.ali@cci.com', 'mohamed.ali@client.com', 'mohamed.ali@m360.com'),
    
    (it_emp_id, '01234567899', '01234567900', 'Sharm El Sheikh, Egypt', '01234567901', 'Mother',
     'fatma.hassan@personal.com', 'fatma.hassan@octopus.com', 'fatma.hassan@bpo.com', 'fatma.hassan@cci.com', 'fatma.hassan@client.com', 'fatma.hassan@m360.com');

    -- =============================================
    -- INSERT EMPLOYEE EMPLOYMENT INFO
    -- =============================================
    INSERT INTO employee_employment_info (
        employee_id, sub_department, language, first_reporting_line_id, second_reporting_line_id,
        previous_titles, account_id, lob_id, sub_lob, work_on_site, site,
        contract_date, certification_date, effective_date, business_area, status_date,
        internal_external, sf_rooster_fd, batch_no, tenure_days, skill, lts_login_id,
        attrition_reason, sub_attrition_reason, resignation_date, active_directly
    ) VALUES 
    (hr_emp_id, 'HR Management', 'English', NULL, NULL, ARRAY['HR Assistant', 'HR Specialist'],
     internal_account_id, cs_lob_id, 'HR Operations', true, 'Plaza', '2020-01-15', '2020-01-20', '2020-01-15',
     'Production', '2020-01-15', 'Internal', 'SF001', 'BATCH001', 1500, 'HR Management', 'LTS001',
     NULL, NULL, NULL, true),
    
    (wfm_emp_id, 'WFM Planning', 'English', hr_emp_id, NULL, ARRAY['WFM Analyst'],
     internal_account_id, cs_lob_id, 'WFM Operations', true, 'Palm City', '2019-06-01', '2019-06-05', '2019-06-01',
     'Production', '2019-06-01', 'Internal', 'SF002', 'BATCH002', 2000, 'WFM Planning', 'LTS002',
     NULL, NULL, NULL, true),
    
    (ops_emp_id, 'Operations', 'English', hr_emp_id, NULL, ARRAY['Operations Agent'],
     internal_account_id, cs_lob_id, 'Operations', true, 'Smart Valley', '2021-03-10', '2021-03-15', '2021-03-10',
     'Production', '2021-03-10', 'Internal', 'SF003', 'BATCH003', 1000, 'Operations', 'LTS003',
     NULL, NULL, NULL, true),
    
    (it_emp_id, 'IT Support', 'English', hr_emp_id, NULL, ARRAY['IT Technician'],
     internal_account_id, cs_lob_id, 'IT Operations', true, 'Assiut', '2018-08-20', '2018-08-25', '2018-08-20',
     'Production', '2018-08-20', 'Internal', 'SF004', 'BATCH004', 2500, 'IT Support', 'LTS004',
     NULL, NULL, NULL, true);

    -- =============================================
    -- INSERT EMPLOYEE INSURANCE INFO
    -- =============================================
    INSERT INTO employee_insurance_info (
        employee_id, insurance_title, nda_signed, signing_contract,
        headset_serial, laptop_serial, laptop_custody_form,
        insurance_salary, social_insurance_no, social_insurance_date, social_insurance_status, social_insurance_applicable,
        medical_insurance_applicable, medical_insurance_no, medical_insurance_status, medical_insurance_expiry
    ) VALUES 
    (hr_emp_id, 'Manager', true, true, 'HS001', 'LP001', true, 15000.00, 'SI001', '2020-01-15', true, true, true, 'MI001', true, '2025-12-31'),
    
    (wfm_emp_id, 'Planner', true, true, 'HS002', 'LP002', true, 12000.00, 'SI002', '2019-06-01', true, true, true, 'MI002', true, '2025-12-31'),
    
    (ops_emp_id, 'Supervisor', true, true, 'HS003', 'LP003', true, 10000.00, 'SI003', '2021-03-10', true, true, true, 'MI003', true, '2025-12-31'),
    
    (it_emp_id, 'Administrator', true, true, 'HS004', 'LP004', true, 18000.00, 'SI004', '2018-08-20', true, true, true, 'MI004', true, '2025-12-31');

    -- =============================================
    -- INSERT EMPLOYEE BANK INFO
    -- =============================================
    INSERT INTO employee_bank_info (
        employee_id, bank_account_number, salary
    ) VALUES 
    (hr_emp_id, '12345678901234567890', 15000.00),
    (wfm_emp_id, '12345678901234567891', 12000.00),
    (ops_emp_id, '12345678901234567892', 10000.00),
    (it_emp_id, '12345678901234567893', 18000.00);

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
    WHERE e.is_deleted = false;

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
    WHERE e.is_deleted = false;

INSERT INTO notification_settings (employee_id, notification_type, days_before, is_enabled, email_enabled)
SELECT 
    e.id,
    'DOCUMENT_EXPIRY',
    7,
    true,
    true
FROM employees e
    WHERE e.is_deleted = false;

INSERT INTO notification_settings (employee_id, notification_type, days_before, is_enabled, email_enabled)
SELECT 
    e.id,
    'RESIGNATION',
    0,
    true,
    true
FROM employees e
    WHERE e.is_deleted = false;

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
        AND ac.code = 'AVAIL';

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
    WHERE a.name = 'Talabat' AND l.name = 'Customer Care'
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
    
END $$;

-- =============================================
-- VERIFICATION QUERIES
-- =============================================
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
SELECT 'Shift Templates', COUNT(*) FROM shift_templates
UNION ALL
SELECT 'Roles', COUNT(*) FROM roles
UNION ALL
SELECT 'Permissions', COUNT(*) FROM permissions
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

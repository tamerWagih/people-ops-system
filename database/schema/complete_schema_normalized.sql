-- People Operation and Management System - Complete Database Schema (Normalized)
-- Separated employee tables for better performance and maintainability
-- Created: October 26, 2025

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- CORE EMPLOYEE TABLE (Basic Info Only)
-- =============================================
CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hr_id VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID,
    updated_by UUID,
    
    -- Basic Personal Information
    full_name_en VARCHAR(255) NOT NULL,
    full_name_ar VARCHAR(255),
    national_id VARCHAR(20) UNIQUE NOT NULL,
    national_id_expiry DATE,
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    religion VARCHAR(50),
    nationality VARCHAR(50) DEFAULT 'Egyptian',
    is_egyptian BOOLEAN DEFAULT true,
    passport_number VARCHAR(50),
    passport_expiry DATE,
    
    -- Basic Employment Info
    department_id UUID,
    current_title VARCHAR(100),
    hiring_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive')),
    employment_type VARCHAR(20) CHECK (employment_type IN ('Full Time', 'Part Time')),
    
    -- Audit fields
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMP WITH TIME ZONE,
    deleted_by UUID
);

-- =============================================
-- EMPLOYEE PERSONAL INFORMATION
-- =============================================
CREATE TABLE employee_personal_info (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    
    -- Education
    graduation_year INTEGER,
    major VARCHAR(100),
    academic_year VARCHAR(20),
    
    -- Additional Personal Info
    profile VARCHAR(100),
    batch_skill VARCHAR(100),
    elastix VARCHAR(100),
    zoiper_extension VARCHAR(100),
    nt VARCHAR(100),
    channel VARCHAR(100),
    
    -- Document Status (Arabic field names from requirements)
    birth_certificate BOOLEAN DEFAULT false,
    national_id_copy BOOLEAN DEFAULT false,
    education_certificate BOOLEAN DEFAULT false,
    military_certificate BOOLEAN DEFAULT false,
    work_book BOOLEAN DEFAULT false,
    criminal_record BOOLEAN DEFAULT false,
    insurance_print BOOLEAN DEFAULT false,
    personal_photos BOOLEAN DEFAULT false,
    form_111 BOOLEAN DEFAULT false,
    bank_account_form BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- EMPLOYEE CONTACT INFORMATION
-- =============================================
CREATE TABLE employee_contact_info (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    
    -- Contact Details
    phone_1 VARCHAR(20),
    phone_2 VARCHAR(20),
    home_address TEXT,
    emergency_contact_no VARCHAR(20),
    emergency_contact_degree VARCHAR(50),
    
    -- Email Addresses
    personal_email VARCHAR(255),
    octopus_email VARCHAR(255),
    bpo_email VARCHAR(255),
    cci_email VARCHAR(255),
    client_email VARCHAR(255),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- EMPLOYEE EMPLOYMENT INFORMATION
-- =============================================
CREATE TABLE employee_employment_info (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    
    -- Employment Details
    sub_department VARCHAR(100),
    language VARCHAR(50),
    first_reporting_line_id UUID REFERENCES employees(id),
    second_reporting_line_id UUID REFERENCES employees(id),
    previous_titles TEXT[],
    account_id UUID,
    lob_id UUID,
    sub_lob VARCHAR(100),
    
    -- Work Location
    work_on_site BOOLEAN DEFAULT false,
    site VARCHAR(100),
    
    -- Contract Information
    contract_date DATE,
    certification_date DATE,
    effective_date DATE,
    business_area VARCHAR(20) CHECK (business_area IN ('Production', 'Training')),
    status_date DATE,
    internal_external VARCHAR(20) CHECK (internal_external IN ('Internal', 'External')),
    
    -- Additional Employment Info
    sf_rooster_fd VARCHAR(50),
    batch_no VARCHAR(50),
    tenure_days INTEGER,
    skill VARCHAR(100),
    lts_login_id VARCHAR(100),
    attrition_reason VARCHAR(100),
    sub_attrition_reason TEXT,
    
    -- Resignation Information
    resignation_date DATE,
    active_directly BOOLEAN DEFAULT true,
    locker_number VARCHAR(20),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- EMPLOYEE INSURANCE INFORMATION
-- =============================================
CREATE TABLE employee_insurance_info (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    
    -- Insurance Details
    insurance_title VARCHAR(100),
    nda_signed BOOLEAN DEFAULT false,
    signing_contract BOOLEAN DEFAULT false,
    
    -- Asset Information
    headset_serial VARCHAR(100),
    laptop_serial VARCHAR(100),
    laptop_custody_form BOOLEAN DEFAULT false,
    
    -- Social Insurance
    insurance_salary DECIMAL(10,2),
    social_insurance_no VARCHAR(50),
    social_insurance_date DATE,
    social_insurance_status BOOLEAN DEFAULT false,
    social_insurance_applicable BOOLEAN DEFAULT true,
    
    -- Medical Insurance
    medical_insurance_applicable BOOLEAN DEFAULT true,
    medical_insurance_no VARCHAR(50),
    medical_insurance_status BOOLEAN DEFAULT false,
    medical_insurance_expiry DATE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- EMPLOYEE BANK INFORMATION
-- =============================================
CREATE TABLE employee_bank_info (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    
    -- Bank Details
    bank_account_number VARCHAR(50),
    salary DECIMAL(10,2),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- SUPPORTING TABLES
-- =============================================

-- Departments
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Accounts
CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Lines of Business (LOB)
CREATE TABLE lobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- WFM TABLES
-- =============================================

-- Activity Codes
CREATE TABLE activity_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_productive BOOLEAN DEFAULT true,
    color VARCHAR(7),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Agent Schedules
CREATE TABLE agent_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    schedule_date DATE NOT NULL,
    shift_start TIME NOT NULL,
    shift_end TIME NOT NULL,
    activity_code_id UUID REFERENCES activity_codes(id),
    is_break BOOLEAN DEFAULT false,
    break_duration INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Client Requirements
CREATE TABLE client_requirements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_name VARCHAR(100) NOT NULL,
    account_id UUID REFERENCES accounts(id),
    lob_id UUID REFERENCES lobs(id),
    requirement_date DATE NOT NULL,
    interval_type VARCHAR(10) CHECK (interval_type IN ('15min', '30min', '60min')),
    total_requirements INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID,
    updated_by UUID
);

-- Client Requirements Intervals
CREATE TABLE client_requirement_intervals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_requirement_id UUID REFERENCES client_requirements(id) ON DELETE CASCADE,
    interval_start TIME NOT NULL,
    interval_end TIME NOT NULL,
    required_agents INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Leave Types
CREATE TABLE leave_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    max_days_per_year INTEGER,
    requires_approval BOOLEAN DEFAULT true,
    is_paid BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Employee Leave Balances
CREATE TABLE employee_leave_balances (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    leave_type_id UUID REFERENCES leave_types(id),
    year INTEGER NOT NULL,
    total_days INTEGER NOT NULL DEFAULT 0,
    used_days INTEGER NOT NULL DEFAULT 0,
    remaining_days INTEGER GENERATED ALWAYS AS (total_days - used_days) STORED,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(employee_id, leave_type_id, year)
);

-- Leave Requests
CREATE TABLE leave_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    leave_type_id UUID REFERENCES leave_types(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days INTEGER NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Cancelled')),
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_by UUID REFERENCES employees(id),
    approved_at TIMESTAMP WITH TIME ZONE,
    rejection_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Shift Trade Requests
CREATE TABLE shift_trade_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requester_employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    target_employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    requester_schedule_id UUID REFERENCES agent_schedules(id) ON DELETE CASCADE,
    target_schedule_id UUID REFERENCES agent_schedules(id) ON DELETE CASCADE,
    trade_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Cancelled')),
    requester_approval BOOLEAN DEFAULT false,
    target_approval BOOLEAN DEFAULT false,
    supervisor_approval BOOLEAN DEFAULT false,
    supervisor_id UUID REFERENCES employees(id),
    reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Capacity Plans
CREATE TABLE capacity_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    plan_name VARCHAR(100) NOT NULL,
    plan_period_start DATE NOT NULL,
    plan_period_end DATE NOT NULL,
    account_id UUID REFERENCES accounts(id),
    lob_id UUID REFERENCES lobs(id),
    total_required_fte DECIMAL(10,2) NOT NULL,
    current_fte DECIMAL(10,2) NOT NULL,
    new_hires INTEGER DEFAULT 0,
    expected_attrition INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID,
    updated_by UUID
);

-- Capacity Plan Details
CREATE TABLE capacity_plan_details (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    capacity_plan_id UUID REFERENCES capacity_plans(id) ON DELETE CASCADE,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    period_type VARCHAR(10) CHECK (period_type IN ('Weekly', 'Monthly')),
    required_fte DECIMAL(10,2) NOT NULL,
    current_fte DECIMAL(10,2) NOT NULL,
    gap_fte DECIMAL(10,2) GENERATED ALWAYS AS (required_fte - current_fte) STORED,
    new_hires INTEGER DEFAULT 0,
    attrition INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- NOTIFICATION SYSTEM
-- =============================================

-- Notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT false,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    read_at TIMESTAMP WITH TIME ZONE,
    priority VARCHAR(20) DEFAULT 'Medium' CHECK (priority IN ('Low', 'Medium', 'High', 'Critical'))
);

-- Notification Settings
CREATE TABLE notification_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) NOT NULL,
    is_enabled BOOLEAN DEFAULT true,
    email_enabled BOOLEAN DEFAULT true,
    sms_enabled BOOLEAN DEFAULT false,
    days_before INTEGER DEFAULT 7,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- DOCUMENT MANAGEMENT
-- =============================================

-- Employee Documents
CREATE TABLE employee_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    document_type VARCHAR(50) NOT NULL,
    document_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    uploaded_by UUID,
    expiry_date DATE,
    is_verified BOOLEAN DEFAULT false,
    verified_by UUID,
    verified_at TIMESTAMP WITH TIME ZONE
);

-- Medical Insurance
CREATE TABLE medical_insurance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    policy_number VARCHAR(100),
    insurance_company VARCHAR(100),
    coverage_start_date DATE,
    coverage_end_date DATE,
    premium_amount DECIMAL(10,2),
    beneficiaries JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- AUDIT SYSTEM
-- =============================================

-- Audit Logs
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    action VARCHAR(20) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_values JSONB,
    new_values JSONB,
    changed_by UUID,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT
);

-- =============================================
-- ADD FOREIGN KEY CONSTRAINTS
-- =============================================

-- Add foreign key constraints after all tables are created
ALTER TABLE employees ADD CONSTRAINT fk_employees_department 
    FOREIGN KEY (department_id) REFERENCES departments(id);

ALTER TABLE employee_employment_info ADD CONSTRAINT fk_employment_account 
    FOREIGN KEY (account_id) REFERENCES accounts(id);

ALTER TABLE employee_employment_info ADD CONSTRAINT fk_employment_lob 
    FOREIGN KEY (lob_id) REFERENCES lobs(id);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Employee indexes
CREATE INDEX idx_employees_hr_id ON employees(hr_id);
CREATE INDEX idx_employees_national_id ON employees(national_id);
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_status ON employees(status);

-- Employee info indexes
CREATE INDEX idx_employee_personal_info_employee ON employee_personal_info(employee_id);
CREATE INDEX idx_employee_contact_info_employee ON employee_contact_info(employee_id);
CREATE INDEX idx_employee_employment_info_employee ON employee_employment_info(employee_id);
CREATE INDEX idx_employee_insurance_info_employee ON employee_insurance_info(employee_id);
CREATE INDEX idx_employee_bank_info_employee ON employee_bank_info(employee_id);

-- Schedule indexes
CREATE INDEX idx_agent_schedules_employee_date ON agent_schedules(employee_id, schedule_date);
CREATE INDEX idx_agent_schedules_date ON agent_schedules(schedule_date);

-- Leave indexes
CREATE INDEX idx_leave_requests_employee ON leave_requests(employee_id);
CREATE INDEX idx_leave_requests_status ON leave_requests(status);

-- Notification indexes
CREATE INDEX idx_notifications_employee_id ON notifications(employee_id);
CREATE INDEX idx_notifications_type ON notifications(notification_type);

-- Audit indexes
CREATE INDEX idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX idx_audit_logs_changed_at ON audit_logs(changed_at);

-- =============================================
-- FUNCTIONS FOR BUSINESS LOGIC
-- =============================================

-- Function to calculate age from date of birth
CREATE OR REPLACE FUNCTION calculate_age(birth_date DATE)
RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM AGE(birth_date));
END;
$$ LANGUAGE plpgsql;

-- Function to extract date of birth from National ID
CREATE OR REPLACE FUNCTION extract_dob_from_national_id(national_id VARCHAR)
RETURNS DATE AS $$
DECLARE
    year_part VARCHAR(2);
    month_part VARCHAR(2);
    day_part VARCHAR(2);
    full_year INTEGER;
BEGIN
    IF LENGTH(national_id) = 14 THEN
        year_part := SUBSTRING(national_id FROM 1 FOR 2);
        month_part := SUBSTRING(national_id FROM 3 FOR 2);
        day_part := SUBSTRING(national_id FROM 5 FOR 2);
        
        -- Convert 2-digit year to 4-digit year
        full_year := CASE 
            WHEN year_part::INTEGER > 50 THEN 1900 + year_part::INTEGER
            ELSE 2000 + year_part::INTEGER
        END;
        
        RETURN TO_DATE(full_year::TEXT || month_part || day_part, 'YYYYMMDD');
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- VIEWS FOR REPORTING
-- =============================================

-- Complete employee view (JOINs all employee tables)
CREATE VIEW employee_complete AS
SELECT 
    e.id,
    e.hr_id,
    e.full_name_en,
    e.full_name_ar,
    e.national_id,
    e.date_of_birth,
    calculate_age(e.date_of_birth) as age,
    e.gender,
    e.department_id,
    d.name as department_name,
    e.current_title,
    e.hiring_date,
    e.status,
    e.employment_type,
    
    -- Personal info
    epi.graduation_year,
    epi.major,
    epi.academic_year,
    
    -- Contact info
    eci.phone_1,
    eci.phone_2,
    eci.personal_email,
    eci.octopus_email,
    
    -- Employment info
    eei.sub_department,
    eei.language,
    eei.work_on_site,
    eei.site,
    eei.business_area,
    
    -- Insurance info
    eii.social_insurance_no,
    eii.medical_insurance_status,
    
    -- Bank info
    ebi.salary
    
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
LEFT JOIN employee_personal_info epi ON e.id = epi.employee_id
LEFT JOIN employee_contact_info eci ON e.id = eci.employee_id
LEFT JOIN employee_employment_info eei ON e.id = eei.employee_id
LEFT JOIN employee_insurance_info eii ON e.id = eii.employee_id
LEFT JOIN employee_bank_info ebi ON e.id = ebi.employee_id
WHERE e.is_deleted = false;

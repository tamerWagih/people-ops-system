-- People Operation and Management System - HR Database Schema
-- Based on 68+ fields from requirements analysis
-- Created: October 22, 2025

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- CORE EMPLOYEE TABLE
-- =============================================
CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hr_id VARCHAR(50) UNIQUE NOT NULL, -- Auto-generated HR ID
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID,
    updated_by UUID,
    
    -- Personal Information
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
    
    -- Contact Information
    phone_1 VARCHAR(20),
    phone_2 VARCHAR(20),
    home_address TEXT,
    emergency_contact_no VARCHAR(20),
    emergency_contact_degree VARCHAR(50),
    personal_email VARCHAR(255),
    octopus_email VARCHAR(255),
    bpo_email VARCHAR(255),
    cci_email VARCHAR(255),
    client_email VARCHAR(255),
    
    -- Education
    graduation_year INTEGER,
    major VARCHAR(100),
    academic_year VARCHAR(20),
    
    -- Employment Information
    department_id UUID REFERENCES departments(id),
    sub_department VARCHAR(100),
    language VARCHAR(50),
    first_reporting_line_id UUID REFERENCES employees(id),
    second_reporting_line_id UUID REFERENCES employees(id),
    current_title VARCHAR(100),
    previous_titles TEXT[], -- Array of previous titles
    account_id UUID REFERENCES accounts(id),
    lob_id UUID REFERENCES lobs(id),
    sub_lob VARCHAR(100),
    hiring_date DATE NOT NULL,
    work_on_site BOOLEAN DEFAULT false,
    site VARCHAR(100), -- Plaza, Palm City, Smart Valley, Assiut
    contract_date DATE,
    certification_date DATE,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive')),
    effective_date DATE,
    business_area VARCHAR(20) CHECK (business_area IN ('Production', 'Training')),
    status_date DATE,
    internal_external VARCHAR(20) CHECK (internal_external IN ('Internal', 'External')),
    employment_type VARCHAR(20) CHECK (employment_type IN ('Full Time', 'Part Time')),
    sf_rooster_fd VARCHAR(50), -- MIS data
    batch_no VARCHAR(50),
    tenure_days INTEGER,
    skill VARCHAR(100),
    lts_login_id VARCHAR(100), -- MIS
    attrition_reason VARCHAR(100),
    sub_attrition_reason TEXT,
    profile VARCHAR(100),
    batch_skill VARCHAR(100),
    elastix VARCHAR(100),
    zoiper_extension VARCHAR(100),
    nt VARCHAR(100),
    channel VARCHAR(100),
    
    -- Insurance Information
    insurance_title VARCHAR(100),
    nda_signed BOOLEAN DEFAULT false,
    signing_contract BOOLEAN DEFAULT false,
    headset_serial VARCHAR(100),
    laptop_serial VARCHAR(100),
    laptop_custody_form BOOLEAN DEFAULT false,
    insurance_salary DECIMAL(10,2),
    social_insurance_no VARCHAR(50),
    social_insurance_date DATE,
    social_insurance_status BOOLEAN DEFAULT false,
    social_insurance_applicable BOOLEAN DEFAULT true,
    medical_insurance_applicable BOOLEAN DEFAULT true,
    medical_insurance_no VARCHAR(50),
    medical_insurance_status BOOLEAN DEFAULT false,
    medical_insurance_expiry DATE,
    
    -- Bank Information
    bank_account_number VARCHAR(50),
    salary DECIMAL(10,2), -- Locked, only payroll can view
    
    -- Resignation Information
    resignation_date DATE,
    active_directly BOOLEAN DEFAULT true,
    locker_number VARCHAR(20),
    
    -- Document Status
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
    
    -- Audit fields
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMP WITH TIME ZONE,
    deleted_by UUID
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
-- DOCUMENT MANAGEMENT
-- =============================================
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

-- =============================================
-- MEDICAL INSURANCE
-- =============================================
CREATE TABLE medical_insurance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    policy_number VARCHAR(100),
    insurance_company VARCHAR(100),
    coverage_start_date DATE,
    coverage_end_date DATE,
    premium_amount DECIMAL(10,2),
    beneficiaries JSONB, -- Store beneficiary information as JSON
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- NOTIFICATION SYSTEM
-- =============================================
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

-- =============================================
-- AUDIT LOG
-- =============================================
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
-- INDEXES FOR PERFORMANCE
-- =============================================
CREATE INDEX idx_employees_hr_id ON employees(hr_id);
CREATE INDEX idx_employees_national_id ON employees(national_id);
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_status ON employees(status);
CREATE INDEX idx_employees_hiring_date ON employees(hiring_date);
CREATE INDEX idx_employees_created_at ON employees(created_at);

CREATE INDEX idx_employee_documents_employee_id ON employee_documents(employee_id);
CREATE INDEX idx_employee_documents_type ON employee_documents(document_type);
CREATE INDEX idx_employee_documents_expiry ON employee_documents(expiry_date);

CREATE INDEX idx_notifications_employee_id ON notifications(employee_id);
CREATE INDEX idx_notifications_type ON notifications(notification_type);
CREATE INDEX idx_notifications_sent_at ON notifications(sent_at);

CREATE INDEX idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX idx_audit_logs_changed_at ON audit_logs(changed_at);

-- =============================================
-- TRIGGERS FOR AUDIT LOGGING
-- =============================================
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs (table_name, record_id, action, new_values, changed_by)
        VALUES (TG_TABLE_NAME, NEW.id, 'INSERT', to_jsonb(NEW), NEW.created_by);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
        VALUES (TG_TABLE_NAME, NEW.id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW), NEW.updated_by);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_values, changed_by)
        VALUES (TG_TABLE_NAME, OLD.id, 'DELETE', to_jsonb(OLD), OLD.updated_by);
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create audit triggers
CREATE TRIGGER employees_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON employees
    FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER employee_documents_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON employee_documents
    FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

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

-- Function to calculate contract days remaining
CREATE OR REPLACE FUNCTION calculate_contract_days_remaining(contract_date DATE)
RETURNS INTEGER AS $$
BEGIN
    IF contract_date IS NULL THEN
        RETURN NULL;
    END IF;
    
    RETURN EXTRACT(DAYS FROM (contract_date + INTERVAL '1 year' - CURRENT_DATE));
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- VIEWS FOR REPORTING
-- =============================================

-- Employee summary view
CREATE VIEW employee_summary AS
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
    e.business_area,
    calculate_contract_days_remaining(e.contract_date) as contract_days_remaining
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
WHERE e.is_deleted = false;

-- Document expiry alerts view
CREATE VIEW document_expiry_alerts AS
SELECT 
    e.id as employee_id,
    e.hr_id,
    e.full_name_en,
    ed.document_type,
    ed.document_name,
    ed.expiry_date,
    ed.expiry_date - CURRENT_DATE as days_until_expiry
FROM employees e
JOIN employee_documents ed ON e.id = ed.employee_id
WHERE ed.expiry_date IS NOT NULL 
    AND ed.expiry_date - CURRENT_DATE <= 30
    AND e.is_deleted = false
ORDER BY ed.expiry_date ASC;

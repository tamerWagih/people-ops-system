-- People Operation and Management System - WFM Database Schema
-- Based on 14 WFM requirements
-- Created: October 22, 2025

-- =============================================
-- WFM CORE TABLES
-- =============================================

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

-- Client Requirements Intervals (15/30 minute intervals)
CREATE TABLE client_requirement_intervals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_requirement_id UUID REFERENCES client_requirements(id) ON DELETE CASCADE,
    interval_start TIME NOT NULL,
    interval_end TIME NOT NULL,
    required_agents INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Activity Codes
CREATE TABLE activity_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_productive BOOLEAN DEFAULT true,
    color VARCHAR(7), -- Hex color code
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
    break_duration INTEGER DEFAULT 0, -- in minutes
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID,
    updated_by UUID
);

-- Schedule vs Requirements Tracking
CREATE TABLE schedule_requirements_tracking (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    schedule_date DATE NOT NULL,
    interval_start TIME NOT NULL,
    interval_end TIME NOT NULL,
    required_agents INTEGER NOT NULL DEFAULT 0,
    scheduled_agents INTEGER NOT NULL DEFAULT 0,
    overstaffing INTEGER GENERATED ALWAYS AS (scheduled_agents - required_agents) STORED,
    understaffing INTEGER GENERATED ALWAYS AS (required_agents - scheduled_agents) STORED,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- LEAVE MANAGEMENT
-- =============================================

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

-- =============================================
-- SHIFT TRADE SYSTEM
-- =============================================

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

-- =============================================
-- CAPACITY PLANNING
-- =============================================

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

-- Capacity Plan Details (Weekly/Monthly breakdown)
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
-- NOTIFICATIONS
-- =============================================

-- WFM Notifications
CREATE TABLE wfm_notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    related_schedule_id UUID REFERENCES agent_schedules(id),
    related_leave_request_id UUID REFERENCES leave_requests(id),
    related_shift_trade_id UUID REFERENCES shift_trade_requests(id),
    is_read BOOLEAN DEFAULT false,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    read_at TIMESTAMP WITH TIME ZONE,
    priority VARCHAR(20) DEFAULT 'Medium' CHECK (priority IN ('Low', 'Medium', 'High', 'Critical'))
);

-- =============================================
-- REPORTING TABLES
-- =============================================

-- Activity Hours Summary
CREATE TABLE activity_hours_summary (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    activity_code_id UUID REFERENCES activity_codes(id),
    summary_date DATE NOT NULL,
    total_hours DECIMAL(5,2) NOT NULL DEFAULT 0,
    productive_hours DECIMAL(5,2) NOT NULL DEFAULT 0,
    non_productive_hours DECIMAL(5,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Client Requirements
CREATE INDEX idx_client_requirements_date ON client_requirements(requirement_date);
CREATE INDEX idx_client_requirements_client ON client_requirements(client_name);
CREATE INDEX idx_client_requirement_intervals_requirement ON client_requirement_intervals(client_requirement_id);

-- Agent Schedules
CREATE INDEX idx_agent_schedules_employee_date ON agent_schedules(employee_id, schedule_date);
CREATE INDEX idx_agent_schedules_date ON agent_schedules(schedule_date);
CREATE INDEX idx_agent_schedules_activity ON agent_schedules(activity_code_id);

-- Leave Management
CREATE INDEX idx_leave_requests_employee ON leave_requests(employee_id);
CREATE INDEX idx_leave_requests_status ON leave_requests(status);
CREATE INDEX idx_leave_requests_dates ON leave_requests(start_date, end_date);
CREATE INDEX idx_employee_leave_balances_employee ON employee_leave_balances(employee_id);

-- Shift Trades
CREATE INDEX idx_shift_trade_requests_requester ON shift_trade_requests(requester_employee_id);
CREATE INDEX idx_shift_trade_requests_target ON shift_trade_requests(target_employee_id);
CREATE INDEX idx_shift_trade_requests_status ON shift_trade_requests(status);

-- Capacity Planning
CREATE INDEX idx_capacity_plans_period ON capacity_plans(plan_period_start, plan_period_end);
CREATE INDEX idx_capacity_plan_details_plan ON capacity_plan_details(capacity_plan_id);

-- Notifications
CREATE INDEX idx_wfm_notifications_employee ON wfm_notifications(employee_id);
CREATE INDEX idx_wfm_notifications_type ON wfm_notifications(notification_type);
CREATE INDEX idx_wfm_notifications_sent_at ON wfm_notifications(sent_at);

-- Activity Hours
CREATE INDEX idx_activity_hours_employee_date ON activity_hours_summary(employee_id, summary_date);
CREATE INDEX idx_activity_hours_activity ON activity_hours_summary(activity_code_id);

-- =============================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- =============================================

-- Function to update schedule vs requirements tracking
CREATE OR REPLACE FUNCTION update_schedule_requirements_tracking()
RETURNS TRIGGER AS $$
BEGIN
    -- Update tracking when schedules change
    INSERT INTO schedule_requirements_tracking (
        schedule_date, interval_start, interval_end, 
        required_agents, scheduled_agents
    )
    SELECT 
        NEW.schedule_date,
        NEW.shift_start,
        NEW.shift_end,
        COALESCE(cri.required_agents, 0),
        COUNT(*)
    FROM agent_schedules as
    LEFT JOIN client_requirement_intervals cri ON 
        cri.interval_start <= NEW.shift_start AND 
        cri.interval_end >= NEW.shift_end
    WHERE as.schedule_date = NEW.schedule_date
        AND as.shift_start <= NEW.shift_end 
        AND as.shift_end >= NEW.shift_start
    GROUP BY NEW.schedule_date, NEW.shift_start, NEW.shift_end, cri.required_agents
    ON CONFLICT (schedule_date, interval_start, interval_end) 
    DO UPDATE SET 
        scheduled_agents = EXCLUDED.scheduled_agents,
        updated_at = NOW();
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for schedule updates
CREATE TRIGGER schedule_requirements_tracking_trigger
    AFTER INSERT OR UPDATE OR DELETE ON agent_schedules
    FOR EACH ROW EXECUTE FUNCTION update_schedule_requirements_tracking();

-- =============================================
-- FUNCTIONS FOR BUSINESS LOGIC
-- =============================================

-- Function to calculate schedule adherence
CREATE OR REPLACE FUNCTION calculate_schedule_adherence(employee_id UUID, schedule_date DATE)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    total_scheduled_hours DECIMAL(5,2);
    actual_worked_hours DECIMAL(5,2);
    adherence_percentage DECIMAL(5,2);
BEGIN
    -- Get total scheduled hours for the day
    SELECT COALESCE(SUM(EXTRACT(EPOCH FROM (shift_end - shift_start)) / 3600), 0)
    INTO total_scheduled_hours
    FROM agent_schedules
    WHERE agent_schedules.employee_id = calculate_schedule_adherence.employee_id
        AND agent_schedules.schedule_date = calculate_schedule_adherence.schedule_date;
    
    -- Get actual worked hours (assuming productive activities)
    SELECT COALESCE(SUM(EXTRACT(EPOCH FROM (shift_end - shift_start)) / 3600), 0)
    INTO actual_worked_hours
    FROM agent_schedules as
    JOIN activity_codes ac ON as.activity_code_id = ac.id
    WHERE as.employee_id = calculate_schedule_adherence.employee_id
        AND as.schedule_date = calculate_schedule_adherence.schedule_date
        AND ac.is_productive = true;
    
    -- Calculate adherence percentage
    IF total_scheduled_hours > 0 THEN
        adherence_percentage := (actual_worked_hours / total_scheduled_hours) * 100;
    ELSE
        adherence_percentage := 0;
    END IF;
    
    RETURN adherence_percentage;
END;
$$ LANGUAGE plpgsql;

-- Function to check shift trade eligibility
CREATE OR REPLACE FUNCTION check_shift_trade_eligibility(
    requester_id UUID, 
    target_id UUID, 
    trade_date DATE
) RETURNS BOOLEAN AS $$
DECLARE
    requester_schedule_count INTEGER;
    target_schedule_count INTEGER;
BEGIN
    -- Check if requester has a schedule on the trade date
    SELECT COUNT(*)
    INTO requester_schedule_count
    FROM agent_schedules
    WHERE employee_id = requester_id 
        AND schedule_date = trade_date;
    
    -- Check if target has a schedule on the trade date
    SELECT COUNT(*)
    INTO target_schedule_count
    FROM agent_schedules
    WHERE employee_id = target_id 
        AND schedule_date = trade_date;
    
    -- Both must have schedules to be eligible for trade
    RETURN (requester_schedule_count > 0 AND target_schedule_count > 0);
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- VIEWS FOR REPORTING
-- =============================================

-- Schedule vs Requirements View
CREATE VIEW schedule_vs_requirements AS
SELECT 
    srt.schedule_date,
    srt.interval_start,
    srt.interval_end,
    srt.required_agents,
    srt.scheduled_agents,
    srt.overstaffing,
    srt.understaffing,
    CASE 
        WHEN srt.overstaffing > 0 THEN 'Overstaffed'
        WHEN srt.understaffing > 0 THEN 'Understaffed'
        ELSE 'Balanced'
    END as status
FROM schedule_requirements_tracking srt
ORDER BY srt.schedule_date, srt.interval_start;

-- Employee Schedule Summary
CREATE VIEW employee_schedule_summary AS
SELECT 
    e.id as employee_id,
    e.hr_id,
    e.full_name_en,
    as.schedule_date,
    COUNT(*) as total_shifts,
    SUM(EXTRACT(EPOCH FROM (as.shift_end - as.shift_start)) / 3600) as total_hours,
    SUM(CASE WHEN ac.is_productive THEN EXTRACT(EPOCH FROM (as.shift_end - as.shift_start)) / 3600 ELSE 0 END) as productive_hours
FROM employees e
JOIN agent_schedules as ON e.id = as.employee_id
LEFT JOIN activity_codes ac ON as.activity_code_id = ac.id
WHERE e.is_deleted = false
GROUP BY e.id, e.hr_id, e.full_name_en, as.schedule_date
ORDER BY as.schedule_date DESC;

-- Leave Balance Summary
CREATE VIEW employee_leave_balance_summary AS
SELECT 
    e.id as employee_id,
    e.hr_id,
    e.full_name_en,
    elb.year,
    lt.name as leave_type_name,
    elb.total_days,
    elb.used_days,
    elb.remaining_days
FROM employees e
JOIN employee_leave_balances elb ON e.id = elb.employee_id
JOIN leave_types lt ON elb.leave_type_id = lt.id
WHERE e.is_deleted = false
ORDER BY e.full_name_en, elb.year DESC, lt.name;

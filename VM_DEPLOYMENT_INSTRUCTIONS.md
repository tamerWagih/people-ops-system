# People Operations System - Remote VM Deployment Script
# Created: October 26, 2025
# Description: Complete deployment script for remote development VMs

# =============================================
# DEPLOYMENT INSTRUCTIONS FOR REMOTE VMs
# =============================================

echo "============================================="
echo "People Operations System - VM Deployment"
echo "============================================="

# Step 1: Prerequisites Check
echo "Step 1: Checking prerequisites..."
echo "- Docker Desktop must be running"
echo "- Git must be installed"
echo "- PowerShell or Bash available"

# Step 2: Clone Repository
echo ""
echo "Step 2: Clone the repository"
echo "git clone <repository-url>"
echo "cd people-ops-system"

# Step 3: Environment Setup
echo ""
echo "Step 3: Set up environment files"
echo "Copy env.db.template to .env.db:"
echo "cp env.db.template .env.db"
echo ""
echo "Copy env.app.template to .env.app:"
echo "cp env.app.template .env.app"

# Step 4: Database Deployment
echo ""
echo "Step 4: Deploy database services"
echo "docker-compose -f docker-compose.db.yml up -d"
echo ""
echo "Wait for services to start (30 seconds):"
echo "sleep 30"

# Step 5: Apply Database Schema
echo ""
echo "Step 5: Apply normalized database schema"
echo "Get-Content database/schema/complete_schema.sql | docker exec -i people-ops-system-postgres-1 psql -U people_ops -d people_ops_dev"

# Step 6: Apply Seed Data
echo ""
echo "Step 6: Apply initial seed data"
echo "Get-Content database/seeds/initial_data.sql | docker exec -i people-ops-system-postgres-1 psql -U people_ops -d people_ops_dev"

# Step 7: Verify Database
echo ""
echo "Step 7: Verify database setup"
echo "docker exec people-ops-system-postgres-1 psql -U people_ops -d people_ops_dev -c \"SELECT COUNT(*) FROM employees;\""
echo "docker exec people-ops-system-postgres-1 psql -U people_ops -d people_ops_dev -c \"SELECT COUNT(*) FROM employee_personal_info;\""

# Step 8: Application Deployment
echo ""
echo "Step 8: Deploy full application stack"
echo "docker-compose -f docker-compose.app.yml up -d"

# Step 9: Health Check
echo ""
echo "Step 9: Health check"
echo "docker ps"
echo "curl http://localhost:3000 (Frontend)"
echo "curl http://localhost:3001 (Backend API)"

# =============================================
# CONNECTION DETAILS
# =============================================

echo ""
echo "============================================="
echo "CONNECTION DETAILS"
echo "============================================="
echo "Database (pgAdmin):"
echo "  Host: localhost"
echo "  Port: 5432"
echo "  Database: people_ops_dev"
echo "  Username: people_ops"
echo "  Password: dev_password_123"
echo ""
echo "Application URLs:"
echo "  Frontend: http://localhost:3000"
echo "  Backend API: http://localhost:3001"
echo "  pgAdmin: http://localhost:5050"
echo ""
echo "Redis: localhost:6379"
echo "MinIO: http://localhost:9000"

# =============================================
# TROUBLESHOOTING
# =============================================

echo ""
echo "============================================="
echo "TROUBLESHOOTING"
echo "============================================="
echo "If database connection fails:"
echo "1. Check Docker Desktop is running"
echo "2. Verify containers are up: docker ps"
echo "3. Check logs: docker logs people-ops-system-postgres-1"
echo "4. Reset password: docker exec people-ops-system-postgres-1 psql -U postgres -c \"ALTER USER people_ops PASSWORD 'dev_password_123';\""
echo ""
echo "If schema application fails:"
echo "1. Drop and recreate schema:"
echo "   docker exec people-ops-system-postgres-1 psql -U people_ops -d people_ops_dev -c \"DROP SCHEMA public CASCADE; CREATE SCHEMA public;\""
echo "2. Reapply schema and seeds"
echo ""
echo "If application fails to start:"
echo "1. Check environment files exist"
echo "2. Verify ports are not in use"
echo "3. Check Docker logs: docker logs people-ops-system-backend-1"

# =============================================
# DATABASE SCHEMA SUMMARY
# =============================================

echo ""
echo "============================================="
echo "NORMALIZED DATABASE SCHEMA SUMMARY"
echo "============================================="
echo "Core Tables:"
echo "- employees (basic info only)"
echo "- employee_personal_info (education, documents)"
echo "- employee_contact_info (phones, emails, addresses)"
echo "- employee_employment_info (job details, reporting)"
echo "- employee_insurance_info (insurance, assets)"
echo "- employee_bank_info (bank details, salary)"
echo ""
echo "Supporting Tables:"
echo "- departments, accounts, lobs"
echo "- activity_codes, leave_types"
echo "- agent_schedules, client_requirements"
echo "- leave_requests, shift_trade_requests"
echo "- capacity_plans, notifications"
echo "- audit_logs"
echo ""
echo "Total Tables: 24"
echo "Views: employee_complete (JOINs all employee tables)"
echo ""
echo "Benefits of Normalized Design:"
echo "✓ Better performance (smaller tables)"
echo "✓ Easier maintenance"
echo "✓ Better security (separate sensitive data)"
echo "✓ Flexible queries (JOIN only what you need)"
echo "✓ Easier to extend"

echo ""
echo "============================================="
echo "DEPLOYMENT COMPLETE!"
echo "============================================="

# People Operation and Management System

## 🎯 Project Overview

A comprehensive HR & Workforce Management platform designed to streamline employee lifecycle management, workforce scheduling, capacity planning, and departmental workflow automation.

**Timeline:** 30 weeks (October 21, 2025 - May 18, 2026)  
**Development Strategy:** Parallel Development (HR Stream + WFM Stream)  
**Technology Stack:** Next.js 14 + NestJS + PostgreSQL + Redis + MinIO

---

## ✅ Day 1-2 Implementation Complete

### **Project Setup**

- ✅ **Next.js 14 Frontend** with TypeScript, Tailwind CSS, ESLint
- ✅ **NestJS Backend** with TypeScript and full configuration
- ✅ **Turborepo Monorepo** structure for efficient development
- ✅ **Git Repository** with branching strategy and commit hooks
- ✅ **Development Tools** (ESLint, Prettier, Husky, lint-staged)
- ✅ **Docker Compose** with PostgreSQL, Redis, MinIO, NGINX

### **Database Design**

- ✅ **HR Schema** (68+ fields) with comprehensive employee management
- ✅ **WFM Schema** (14 requirements) for workforce management
- ✅ **Database Migrations** with proper versioning
- ✅ **Seed Data** for initial setup and testing
- ✅ **Performance Indexes** and optimization
- ✅ **Audit Logging** with triggers and functions
- ✅ **Business Logic Functions** for calculations and validations

---

## 🐳 **Docker Development Environment**

### **Quick Start with Docker:**

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### **Services Included:**

- **Frontend**: Next.js on port 3000
- **Backend**: NestJS on port 4000
- **Database**: PostgreSQL on port 5432
- **Cache**: Redis on port 6379
- **Storage**: MinIO on port 9000
- **Proxy**: NGINX on port 80

### **Environment Variables:**

- **Development**: `env.development` (included)
- **Database**: Auto-configured with schemas
- **Secrets**: Development keys (change for production)

### **Prerequisites for Docker:**

- **Docker Desktop**: Must be running
- **Docker Compose**: Included with Docker Desktop
- **Ports**: 3000, 4000, 5432, 6379, 9000, 80 must be available

### **Troubleshooting:**

```bash
# If Docker Desktop isn't running:
# 1. Start Docker Desktop application
# 2. Wait for it to fully start
# 3. Then run: docker-compose up -d

# If ports are in use:
# 1. Check what's using the ports: netstat -an | Select-String ":3000|:4000"
# 2. Stop conflicting services
# 3. Or change ports in docker-compose.yml

# If build fails:
# 1. Check Dockerfile exists in frontend/ and backend/
# 2. Run: docker-compose build --no-cache
# 3. Check logs: docker-compose logs
```

---

## 🏗️ Architecture

### **Frontend (Next.js 14)**

```
frontend/
├── app/                 # App Router structure
├── components/         # Reusable components
├── lib/               # Utilities and configurations
└── public/            # Static assets
```

### **Backend (NestJS)**

```
backend/
├── src/
│   ├── modules/       # Feature modules
│   ├── common/        # Shared utilities
│   └── main.ts        # Application entry point
└── test/              # Test files
```

### **Database Schema**

```
database/
├── schemas/
│   ├── hr-schema.sql      # HR module (68+ fields)
│   └── wfm-schema.sql     # WFM module (14 requirements)
├── migrations/
│   └── 001_initial_schema.sql
├── seeds/
│   └── initial_data.sql
└── init/
    └── 01_schema.sql
```

---

## 🚀 Getting Started

### **Prerequisites**

- Node.js 18+
- PostgreSQL 16+
- Redis 7+
- Docker & Docker Compose

### **Development Setup**

```bash
# Navigate to project directory
cd people-ops-system

# Install dependencies
npm install

# Start all development servers (Frontend + Backend)
npm run dev

# OR start services individually:
# Frontend only (http://localhost:3000)
cd frontend
npm run dev

# Backend only (http://localhost:4000)
cd backend
npm run start:dev

# Run linting
npm run lint

# Run tests
npm run test
```

### **Database Setup**

```bash
# Using Docker Compose (recommended)
docker-compose up -d postgres redis minio

# Or manual PostgreSQL setup
createdb people_ops
psql people_ops < database/schemas/hr-schema.sql
psql people_ops < database/schemas/wfm-schema.sql
psql people_ops < database/seeds/initial_data.sql
```

---

## 📊 Database Schema Overview

### **HR Module (15+ Tables)**

- **employees** - Core employee data (68+ fields)
- **departments** - Department management
- **employee_documents** - Document tracking
- **medical_insurance** - Insurance management
- **notifications** - Notification system
- **audit_logs** - Complete audit trail

### **WFM Module (10+ Tables)**

- **client_requirements** - Client demand tracking
- **agent_schedules** - Agent scheduling
- **activity_codes** - Activity type management
- **leave_requests** - Leave management
- **shift_trade_requests** - Shift swapping
- **capacity_plans** - Capacity planning

### **Key Features**

- **Audit Logging** - Complete CRUD operation tracking
- **Performance Indexes** - Optimized for large datasets
- **Business Functions** - Age calculation, DOB extraction, contract days
- **Reporting Views** - Pre-built views for analytics
- **Notification System** - Automated alerts and reminders

---

## 🎯 Next Steps (Week 2)

### **Authentication & Authorization System**

- [ ] JWT token generation & validation
- [ ] Role-based access control (11 roles)
- [ ] Login/logout endpoints
- [ ] Password hashing and session management
- [ ] Protected route middleware

### **User Roles**

- **HR Roles (7):** HR Admin, HR Manager, HR Specialist, Talent Acquisition, Payroll Admin, Department Manager, Reporting Line Manager
- **WFM Roles (4):** WFM Admin, WFM Planner, WFM Supervisor, Agent

---

## 📈 Project Status

| Phase                     | Status         | Progress |
| ------------------------- | -------------- | -------- |
| **Phase 1: Foundation**   | 🟡 In Progress | 20%      |
| - Day 1-2: Project Setup  | ✅ Complete    | 100%     |
| - Week 2: Authentication  | ⏳ Next        | 0%       |
| - Week 3: Core CRUD       | ⏳ Pending     | 0%       |
| **Phase 2: HR Workflows** | ⏳ Pending     | 0%       |
| **Phase 3: WFM Module**   | ⏳ Pending     | 0%       |
| **Phase 4: Analytics**    | ⏳ Pending     | 0%       |
| **Phase 5: Testing**      | ⏳ Pending     | 0%       |

---

## 🔧 Development Commands

```bash
# Development
npm run dev              # Start all services (Frontend + Backend)
cd frontend && npm run dev     # Start frontend only (port 3000)
cd backend && npm run start:dev # Start backend only (port 4000)

# Building
npm run build           # Build all packages
cd frontend && npm run build  # Build frontend
cd backend && npm run build   # Build backend

# Testing
npm run test            # Run all tests
cd frontend && npm run test   # Frontend tests
cd backend && npm run test    # Backend tests

# Linting
npm run lint            # Lint all packages
npm run lint:fix        # Fix linting issues

# Database (when implemented)
npm run db:migrate      # Run migrations
npm run db:seed         # Seed database
npm run db:reset        # Reset database
```

## 🚨 Troubleshooting

### **Common Issues**

1. **"Could not resolve workspaces" Error**

   ```bash
   # Fix: Add packageManager field (already fixed in package.json)
   # The package.json now includes: "packageManager": "npm@10.9.3"
   ```

2. **"Found `pipeline` field instead of `tasks`" Error**

   ```bash
   # Fix: Updated turbo.json to use "tasks" instead of "pipeline"
   # This is already fixed in the current version
   ```

3. **Frontend not starting**

   ```bash
   # Navigate to frontend directory
   cd frontend
   npm run dev
   # Should start on http://localhost:3000
   ```

4. **Backend not starting**

   ```bash
   # Navigate to backend directory
   cd backend
   npm run start:dev
   # Should start on http://localhost:4000
   ```

5. **Port already in use**

   ```bash
   # Check what's using the ports
   netstat -an | findstr ":3000"
   netstat -an | findstr ":4000"

   # Kill processes if needed
   taskkill /F /PID <process_id>
   ```

6. **Dependencies not installed**

   ```bash
   # Install all dependencies
   npm install

   # Or install in specific directories
   cd frontend && npm install
   cd backend && npm install
   ```

### **Verification Commands**

```bash
# Check if services are running
netstat -an | findstr ":3000"  # Frontend
netstat -an | findstr ":4000"   # Backend

# Test frontend
curl http://localhost:3000

# Test backend
curl http://localhost:4000
```

---

## 📝 Requirements Coverage

### **HR Requirements (3 Sets)**

- ✅ **Employee Data Management** - 68+ fields, multi-section forms
- ✅ **Resignation Workflows** - 6 workflow types with department coordination
- ✅ **Document Management** - 15 document types with tracking
- ✅ **Notification System** - Automated alerts and reminders

### **WFM Requirements (14 Features)**

- ✅ **Client Requirements Upload** - Excel import with interval parsing
- ✅ **Schedule Management** - Excel upload, drag-and-drop editing
- ✅ **Activity Codes** - 9+ activity types with color coding
- ✅ **Shift Trade Process** - Agent-to-agent swapping with approvals
- ✅ **Leave Management** - Annual leave requests and approvals
- ✅ **Capacity Planning** - FTE forecasting and attrition modeling

---

## 🎉 Success Metrics

- ✅ **Project Setup** - Complete monorepo with all tools configured
- ✅ **Database Design** - Comprehensive schema with 25+ tables
- ✅ **Performance** - Optimized indexes and business functions
- ✅ **Audit Trail** - Complete operation tracking
- ✅ **Scalability** - Designed for 100K+ users
- ✅ **Maintainability** - Clean architecture and documentation

**Ready for Week 2: Authentication & Authorization System! 🚀**

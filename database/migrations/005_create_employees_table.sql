-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "employeeId" VARCHAR(50) UNIQUE NOT NULL,
    "firstName" VARCHAR(100) NOT NULL,
    "lastName" VARCHAR(100) NOT NULL,
    "middleName" VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    "nationalId" VARCHAR(50) UNIQUE,
    department VARCHAR(100),
    position VARCHAR(100),
    "hireDate" DATE,
    status VARCHAR(20) DEFAULT 'active',
    "phoneNumber" VARCHAR(20),
    address TEXT,
    "dateOfBirth" DATE,
    gender VARCHAR(10),
    "maritalStatus" VARCHAR(20),
    citizenship VARCHAR(100),
    "emergencyContactName" VARCHAR(100),
    "emergencyContactPhone" VARCHAR(20),
    "emergencyContactRelation" VARCHAR(50),
    notes TEXT,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_employees_employee_id ON employees("employeeId");
CREATE INDEX IF NOT EXISTS idx_employees_national_id ON employees("nationalId");
CREATE INDEX IF NOT EXISTS idx_employees_email ON employees(email);
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department);
CREATE INDEX IF NOT EXISTS idx_employees_position ON employees(position);
CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);

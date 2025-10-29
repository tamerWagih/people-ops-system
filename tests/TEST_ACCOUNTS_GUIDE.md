# Test Accounts Guide

This guide provides test accounts for different user roles in the People Operations Management System.

## Test Accounts

All test accounts use the password: **`test123`**

### System Administrator
- **Email:** `admin@example.com`
- **Password:** `password123`
- **Role:** System_Admin
- **Access:** Full system access

### HR Module Test Accounts

#### HR Admin
- **Email:** `hr.admin@test.com`
- **Password:** `test123`
- **Name:** Sarah Johnson
- **Role:** HR_Admin
- **Access:** Full HR system administrator access

#### HR Manager
- **Email:** `hr.manager@test.com`
- **Password:** `test123`
- **Name:** Michael Chen
- **Role:** HR_Manager
- **Access:** HR management with team oversight

#### HR Representative
- **Email:** `hr.rep@test.com`
- **Password:** `test123`
- **Name:** Emily Davis
- **Role:** HR_Representative
- **Access:** Limited employee management access

#### HR Viewer
- **Email:** `hr.viewer@test.com`
- **Password:** `test123`
- **Name:** Robert Taylor
- **Role:** HR_Viewer
- **Access:** Read-only access to employee data

### WFM Module Test Accounts

#### WFM Admin
- **Email:** `wfm.admin@test.com`
- **Password:** `test123`
- **Name:** David Rodriguez
- **Role:** WFM_Admin
- **Access:** Full WFM system administrator access

#### WFM Supervisor
- **Email:** `wfm.supervisor@test.com`
- **Password:** `test123`
- **Name:** Lisa Anderson
- **Role:** WFM_Supervisor
- **Access:** Team management access

#### WFM Agent
- **Email:** `wfm.agent@test.com`
- **Password:** `test123`
- **Name:** James Wilson
- **Role:** WFM_Agent
- **Access:** Limited self-service access

#### WFM Planner
- **Email:** `wfm.planner@test.com`
- **Password:** `test123`
- **Name:** Maria Garcia
- **Role:** WFM_Planner
- **Access:** Workforce planning and scheduling

### Department Management

#### Department Manager
- **Email:** `dept.manager@test.com`
- **Password:** `test123`
- **Name:** Jennifer Brown
- **Role:** Department_Manager
- **Access:** Department-specific access

### Special Test Cases

#### Inactive User
- **Email:** `inactive.user@test.com`
- **Password:** `test123`
- **Name:** Inactive User
- **Role:** WFM_Agent
- **Status:** Inactive (should not be able to login)
- **Purpose:** Test account deactivation handling

## Testing Scenarios

### 1. Authentication Testing

#### Login Success
- Test login with each active account
- Verify correct user information is displayed
- Test "Remember Me" functionality
- Test session persistence after browser restart

#### Login Failure
- Test with invalid credentials
- Test with inactive account (`inactive.user@test.com`)
- Test with non-existent email

### 2. Role-Based Access Testing

#### System Admin
- Should see all features and data
- Can access all modules
- Can manage users and roles

#### HR Module Roles
- **HR Admin:** Full HR access
- **HR Manager:** Management-level HR access
- **HR Representative:** Limited HR access
- **HR Viewer:** Read-only HR access

#### WFM Module Roles
- **WFM Admin:** Full WFM access
- **WFM Supervisor:** Team management access
- **WFM Agent:** Self-service access
- **WFM Planner:** Planning and scheduling access

#### Department Manager
- Department-specific access
- Limited to assigned department data

### 3. Session Management Testing

#### Remember Me Functionality
- Login with "Remember Me" checked
- Close browser completely
- Reopen and verify user is still logged in
- Verify user data persists (name, role)

#### Without Remember Me
- Login without "Remember Me" checked
- Close browser completely
- Reopen and verify user is still logged in (for 15 minutes)
- Test token expiration after 15 minutes

### 4. Security Testing

#### Password Requirements
- Test password validation
- Test password change functionality
- Test password strength requirements

#### Session Security
- Test token refresh functionality
- Test logout functionality
- Test session invalidation

## How to Use Test Accounts

### 1. Deploy Test Accounts
```bash
# On DB VM
cd people-ops-system
git pull
cp database/seeds/test_accounts.sql database/init/
docker compose -f docker-compose.db.yml exec postgres psql -U people_ops -d people_ops_dev -f /docker-entrypoint-initdb.d/test_accounts.sql
```

### 2. Test Login
1. Go to the login page
2. Use any of the test account credentials
3. Verify correct user information is displayed
4. Test different roles and permissions

### 3. Test Remember Me
1. Login with "Remember Me" checked
2. Close browser completely
3. Reopen and verify persistence
4. Repeat without "Remember Me"

## Expected Results

### Successful Login
- User should see: "Welcome, [FirstName] [LastName]"
- Role should display: "Role: [RoleName]"
- User should be redirected to dashboard

### Failed Login
- Should see error message
- Should remain on login page
- Should not create session

### Remember Me
- With Remember Me: Session persists for 30 days
- Without Remember Me: Session persists for 15 minutes (with refresh token extension)

## Troubleshooting

### Common Issues
1. **"User not found"** - Check if test accounts were created successfully
2. **"Invalid credentials"** - Verify password is exactly `test123`
3. **"Account deactivated"** - Expected for `inactive.user@test.com`
4. **Role not showing** - Check if roles were assigned correctly

### Debug Steps
1. Check database for test users: `SELECT email, "firstName", "lastName" FROM users WHERE email LIKE '%@test.com';`
2. Check role assignments: `SELECT u.email, r.name FROM users u JOIN user_roles ur ON u.id = ur."userId" JOIN roles r ON ur."roleId" = r.id WHERE u.email LIKE '%@test.com';`
3. Check browser console for errors
4. Check backend logs for authentication errors

## Notes

- All test passwords are hashed using bcrypt with 12 salt rounds
- Test accounts are created with `isActive = true` and `isEmailVerified = true`
- Inactive user account is created with `isActive = false` for testing deactivation
- All accounts are created with current timestamp for `createdAt` and `updatedAt`

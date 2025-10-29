-- Securely hash passwords for test accounts using pgcrypto (bcrypt)
-- Requires: CREATE EXTENSION pgcrypto

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Set all test accounts to bcrypt('test123') with cost 12
UPDATE users
SET password = crypt('test123', gen_salt('bf', 12)),
    "updatedAt" = NOW()
WHERE email IN (
  'hr.admin@test.com',
  'hr.manager@test.com',
  'hr.rep@test.com',
  'hr.viewer@test.com',
  'wfm.admin@test.com',
  'wfm.supervisor@test.com',
  'wfm.agent@test.com',
  'wfm.planner@test.com',
  'dept.manager@test.com',
  'inactive.user@test.com'
);

-- Notice for operators
DO $$ BEGIN RAISE NOTICE 'Hashed passwords for test accounts using bcrypt.'; END $$;



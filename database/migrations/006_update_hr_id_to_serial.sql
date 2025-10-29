-- Update hr_id column to be auto-incrementing serial
-- First, we need to handle existing data and dependent views

-- Step 1: Drop dependent views first
DROP VIEW IF EXISTS employee_complete CASCADE;

-- Step 2: Create a temporary column to store the current hr_id values
ALTER TABLE employees ADD COLUMN temp_hr_id VARCHAR(50);

-- Step 3: Copy existing hr_id values to temp column
UPDATE employees SET temp_hr_id = hr_id;

-- Step 4: Drop the old hr_id column
ALTER TABLE employees DROP COLUMN hr_id;

-- Step 5: Create new hr_id column as SERIAL
ALTER TABLE employees ADD COLUMN hr_id SERIAL;

-- Step 6: Update the sequence to start from the maximum existing value + 1
-- (This ensures new employees get IDs after existing ones)
DO $$
DECLARE
    max_hr_id INTEGER;
BEGIN
    -- Get the maximum numeric value from temp_hr_id
    SELECT COALESCE(MAX(CAST(REGEXP_REPLACE(temp_hr_id, '[^0-9]', '', 'g') AS INTEGER)), 0) 
    INTO max_hr_id 
    FROM employees 
    WHERE temp_hr_id ~ '^[0-9]+$';
    
    -- Set the sequence to start from max_hr_id + 1
    IF max_hr_id > 0 THEN
        EXECUTE 'ALTER SEQUENCE employees_hr_id_seq RESTART WITH ' || (max_hr_id + 1);
    END IF;
END $$;

-- Step 7: Drop the temporary column
ALTER TABLE employees DROP COLUMN temp_hr_id;

-- Step 8: Add back the unique constraint
ALTER TABLE employees ADD CONSTRAINT employees_hr_id_unique UNIQUE (hr_id);

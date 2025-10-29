#!/bin/bash

# Test Employee API endpoints
# Make sure to run this after deploying the backend

BASE_URL="http://localhost:4000"
API_BASE="$BASE_URL/api/employees"

echo "🧪 Testing Employee API Endpoints"
echo "=================================="

# First, get a token by logging in
echo "1. Getting authentication token..."
TOKEN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password123"}')

if [ $? -ne 0 ]; then
  echo "❌ Failed to connect to backend. Make sure it's running on port 4000"
  exit 1
fi

TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ Failed to get token. Response: $TOKEN_RESPONSE"
  exit 1
fi

echo "✅ Token obtained successfully"

# Test 1: Create Employee
echo ""
echo "2. Testing CREATE employee..."
CREATE_RESPONSE=$(curl -s -X POST "$API_BASE" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "employeeId": "EMP001",
    "firstName": "John",
    "lastName": "Doe",
    "nationalId": "1234567890",
    "department": "Engineering",
    "position": "Software Developer",
    "email": "john.doe@company.com",
    "phone": "+1234567890",
    "isActive": true
  }')

echo "Create Response: $CREATE_RESPONSE"

if echo "$CREATE_RESPONSE" | grep -q '"id"'; then
  echo "✅ Employee created successfully"
  EMPLOYEE_ID=$(echo $CREATE_RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
else
  echo "❌ Failed to create employee"
  exit 1
fi

# Test 2: Get All Employees
echo ""
echo "3. Testing GET all employees..."
GET_ALL_RESPONSE=$(curl -s -X GET "$API_BASE?page=1&limit=10" \
  -H "Authorization: Bearer $TOKEN")

echo "Get All Response: $GET_ALL_RESPONSE"

if echo "$GET_ALL_RESPONSE" | grep -q '"items"'; then
  echo "✅ Employees list retrieved successfully"
else
  echo "❌ Failed to get employees list"
fi

# Test 3: Get Single Employee
echo ""
echo "4. Testing GET single employee..."
GET_SINGLE_RESPONSE=$(curl -s -X GET "$API_BASE/$EMPLOYEE_ID" \
  -H "Authorization: Bearer $TOKEN")

echo "Get Single Response: $GET_SINGLE_RESPONSE"

if echo "$GET_SINGLE_RESPONSE" | grep -q '"id"'; then
  echo "✅ Single employee retrieved successfully"
else
  echo "❌ Failed to get single employee"
fi

# Test 4: Update Employee
echo ""
echo "5. Testing UPDATE employee..."
UPDATE_RESPONSE=$(curl -s -X PUT "$API_BASE/$EMPLOYEE_ID" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "position": "Senior Software Developer",
    "phone": "+1234567891"
  }')

echo "Update Response: $UPDATE_RESPONSE"

if echo "$UPDATE_RESPONSE" | grep -q '"id"'; then
  echo "✅ Employee updated successfully"
else
  echo "❌ Failed to update employee"
fi

# Test 5: Search Employees
echo ""
echo "6. Testing SEARCH employees..."
SEARCH_RESPONSE=$(curl -s -X GET "$API_BASE?search=John&page=1&limit=10" \
  -H "Authorization: Bearer $TOKEN")

echo "Search Response: $SEARCH_RESPONSE"

if echo "$SEARCH_RESPONSE" | grep -q '"items"'; then
  echo "✅ Employee search works successfully"
else
  echo "❌ Failed to search employees"
fi

# Test 6: Test Permissions (try with HR user)
echo ""
echo "7. Testing permissions with HR user..."
HR_TOKEN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"hr.admin@test.com","password":"test123"}')

HR_TOKEN=$(echo $HR_TOKEN_RESPONSE | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -n "$HR_TOKEN" ]; then
  HR_GET_RESPONSE=$(curl -s -X GET "$API_BASE" \
    -H "Authorization: Bearer $HR_TOKEN")
  
  if echo "$HR_GET_RESPONSE" | grep -q '"items"'; then
    echo "✅ HR user can access employees (has employees:READ permission)"
  else
    echo "❌ HR user cannot access employees"
  fi
else
  echo "⚠️  Could not test HR permissions (HR user not found)"
fi

# Test 7: Delete Employee
echo ""
echo "8. Testing DELETE employee..."
DELETE_RESPONSE=$(curl -s -X DELETE "$API_BASE/$EMPLOYEE_ID" \
  -H "Authorization: Bearer $TOKEN")

echo "Delete Response: $DELETE_RESPONSE"

if echo "$DELETE_RESPONSE" | grep -q '"success"'; then
  echo "✅ Employee deleted successfully"
else
  echo "❌ Failed to delete employee"
fi

# Test 8: Verify Deletion
echo ""
echo "9. Verifying deletion..."
VERIFY_RESPONSE=$(curl -s -X GET "$API_BASE/$EMPLOYEE_ID" \
  -H "Authorization: Bearer $TOKEN")

if echo "$VERIFY_RESPONSE" | grep -q "not found"; then
  echo "✅ Employee deletion verified"
else
  echo "❌ Employee still exists after deletion"
fi

echo ""
echo "🎉 Employee API testing completed!"
echo "=================================="

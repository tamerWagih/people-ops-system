#!/bin/bash

# Authentication Seed Runner
# This script runs the authentication seed data on the database

echo "🌱 Running Authentication Seed Data..."

# Check if database is running
if ! pg_isready -h localhost -p 5432 -U people_ops; then
    echo "❌ Database is not running. Please start the database first."
    echo "Run: docker compose -f docker-compose.db.yml up -d"
    exit 1
fi

# Run the seed file
echo "📊 Executing auth_seed.sql..."
psql -h localhost -p 5432 -U people_ops -d people_ops_dev -f auth_seed.sql

if [ $? -eq 0 ]; then
    echo "✅ Authentication seed data inserted successfully!"
    echo ""
    echo "📋 Sample users created:"
    psql -h localhost -p 5432 -U people_ops -d people_ops_dev -c "SELECT email, first_name, last_name FROM users WHERE email LIKE '%@example.com';"
    echo ""
    echo "🔐 Roles created:"
    psql -h localhost -p 5432 -U people_ops -d people_ops_dev -c "SELECT name, description FROM roles;"
else
    echo "❌ Failed to insert seed data"
    exit 1
fi

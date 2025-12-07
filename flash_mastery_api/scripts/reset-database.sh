#!/bin/bash

# Script to clean and reset Flyway database
# Usage: ./scripts/reset-database.sh [user] [password]

FLYWAY_USER=${1:-giapnt}
FLYWAY_PASSWORD=${2:-abcd1234}

echo "=========================================="
echo "Resetting Flyway Database"
echo "=========================================="
echo "User: $FLYWAY_USER"
echo ""

# Navigate to API directory
cd "$(dirname "$0")/.." || exit 1

# Clean database (drops all objects)
echo "Step 1: Cleaning database..."
mvn flyway:clean -Dflyway.user=$FLYWAY_USER -Dflyway.password=$FLYWAY_PASSWORD

if [ $? -ne 0 ]; then
    echo "Error: Clean failed!"
    exit 1
fi

echo ""
echo "Step 2: Running migrations..."
mvn flyway:migrate -Dflyway.user=$FLYWAY_USER -Dflyway.password=$FLYWAY_PASSWORD

if [ $? -ne 0 ]; then
    echo "Error: Migration failed!"
    exit 1
fi

echo ""
echo "Step 3: Verifying migration status..."
mvn flyway:info -Dflyway.user=$FLYWAY_USER -Dflyway.password=$FLYWAY_PASSWORD

echo ""
echo "=========================================="
echo "Database reset completed successfully!"
echo "=========================================="


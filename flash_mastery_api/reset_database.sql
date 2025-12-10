-- =====================================================
-- Reset Database Script
-- Description: Clean database and prepare for new migration
-- =====================================================

-- Drop all tables and schema
DROP SCHEMA IF EXISTS flash_mastery CASCADE;

-- Recreate schema
CREATE SCHEMA flash_mastery;

-- Set search path
SET search_path TO flash_mastery;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Done! Now run the Spring Boot application to create tables
SELECT 'Database reset successfully. Run Spring Boot to apply migrations.' AS message;

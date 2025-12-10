@echo off
REM =====================================================
REM Reset Database Script for Windows
REM =====================================================

echo ========================================
echo Flash Mastery - Database Reset
echo ========================================
echo.

REM Get PostgreSQL bin path from environment or use default
set PGBIN=C:\Program Files\PostgreSQL\17\bin
if defined POSTGRES_BIN set PGBIN=%POSTGRES_BIN%

REM Database connection details
set PGHOST=localhost
set PGPORT=5432
set PGDATABASE=flash_mastery
set PGUSER=giapnt
set PGPASSWORD=abcd1234

echo Connecting to PostgreSQL...
echo Host: %PGHOST%
echo Port: %PGPORT%
echo Database: %PGDATABASE%
echo User: %PGUSER%
echo.

REM Run the SQL script
"%PGBIN%\psql.exe" -h %PGHOST% -p %PGPORT% -U %PGUSER% -d postgres -f reset_database.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Database reset successfully!
    echo You can now run Spring Boot application.
    echo ========================================
) else (
    echo.
    echo ========================================
    echo ERROR: Failed to reset database
    echo Please check your PostgreSQL connection
    echo ========================================
)

echo.
pause

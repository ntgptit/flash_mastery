@echo off
REM Script to clean and reset Flyway database
REM Usage: scripts\reset-database.bat [user] [password]

setlocal enabledelayedexpansion

set FLYWAY_USER=%1
if "%FLYWAY_USER%"=="" set FLYWAY_USER=giapnt

set FLYWAY_PASSWORD=%2
if "%FLYWAY_PASSWORD%"=="" set FLYWAY_PASSWORD=abcd1234

echo ==========================================
echo Resetting Flyway Database
echo ==========================================
echo User: %FLYWAY_USER%
echo.

REM Navigate to API directory
cd /d "%~dp0.."

REM Clean database (drops all objects)
echo Step 1: Cleaning database...
call mvn flyway:clean -Dflyway.user=%FLYWAY_USER% -Dflyway.password=%FLYWAY_PASSWORD%

if errorlevel 1 (
    echo Error: Clean failed!
    exit /b 1
)

echo.
echo Step 2: Running migrations...
call mvn flyway:migrate -Dflyway.user=%FLYWAY_USER% -Dflyway.password=%FLYWAY_PASSWORD%

if errorlevel 1 (
    echo Error: Migration failed!
    exit /b 1
)

echo.
echo Step 3: Verifying migration status...
call mvn flyway:info -Dflyway.user=%FLYWAY_USER% -Dflyway.password=%FLYWAY_PASSWORD%

echo.
echo ==========================================
echo Database reset completed successfully!
echo ==========================================


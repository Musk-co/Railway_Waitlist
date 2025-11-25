@echo off
echo Railway Waitlist Probability Calculator - Setup Script
echo =====================================================

echo.
echo This script will help you set up the Railway Waitlist Calculator application.
echo.

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java is not installed or not in PATH
    echo Please install Java JDK 8 or higher
    pause
    exit /b 1
)

echo Java is installed ✓

REM Check if MySQL is running
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: MySQL command not found in PATH
    echo Please make sure MySQL is installed and running
    echo.
)

echo.
echo Setup Steps:
echo ============
echo.
echo 1. Database Setup:
echo    - Make sure MySQL is running
echo    - Create database: mysql -u root -p ^< database/railway.sql
echo    - Update credentials in src/com/waitlist/util/DBConnection.java
echo.
echo 2. Application Setup:
echo    - Download MySQL Connector/J and place in lib/ folder
echo    - Compile: ant compile
echo    - Deploy: ant deploy
echo.
echo 3. Tomcat Setup:
echo    - Download and install Apache Tomcat
echo    - Update tomcat.home path in build.xml
echo    - Start Tomcat server
echo.
echo 4. Access Application:
echo    - URL: http://localhost:8080/RailwayWaitlistCalculator/
echo.

echo Would you like to proceed with database setup? (y/n)
set /p choice=
if /i "%choice%"=="y" (
    echo.
    echo Please run the following command to set up the database:
    echo mysql -u root -p ^< database/railway.sql
    echo.
    echo After database setup, update the database credentials in:
    echo src/com/waitlist/util/DBConnection.java
    echo.
)

echo.
echo Setup script completed!
echo.
echo Next steps:
echo 1. Set up MySQL database
echo 2. Download MySQL Connector/J to lib/ folder
echo 3. Update Tomcat path in build.xml
echo 4. Run: ant full-deploy
echo 5. Start Tomcat and access the application
echo.
pause



# Railway Waitlist Probability Calculator

A production-ready web application that predicts train ticket confirmation probability using historical booking data. Built with Java, Servlets, JSP, and MySQL following MVC architecture pattern.


**Current Context Path**: `/railway` on port 8080

---

## 📋 Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure)
4. [Prerequisites](#prerequisites)
5. [Installation & Setup](#installation--setup)
6. [How to Run](#how-to-run)
7. [Database Schema](#database-schema)
8. [API/Endpoints](#apiendpoints)
9. [Usage Guide](#usage-guide)
10. [Testing](#testing)
11. [Architecture](#architecture)
12. [Security](#security)
13. [Troubleshooting](#troubleshooting)

---

## Features

### User Authentication ✅
- User registration with email validation
- Secure login with SHA-256 password hashing
- Session-based authentication (30-minute timeout)
- User dashboard with personalized search history
- Automatic search history tracking
- Logout functionality

###  Admin Dashboard & Analytics ✅
- Admin-only management interface
- User management (view all, promote, demote, deactivate)
- Train information management
- System statistics & real-time analytics
- Chart.js visualizations (bar charts, doughnut charts)
- Role-based access control (RBAC)

### Core Features
- Calculate train ticket confirmation probability
- Historical booking data analysis
- Seasonal trend adjustment
- Waitlist position-based probability scaling
- User-friendly responsive interface
- Comprehensive error handling

---

## Tech Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Backend Language** | Java | 21 |
| **Web Framework** | Servlets & JSP | 4.0 |
| **Database** | MySQL | 8.0 |
| **Server** | Apache Tomcat | 9.0.111 |
| **Build Tool** | javac (Java Compiler) | 21 |
| **Frontend** | HTML5, CSS3, JavaScript | ES6 |
| **Charts/Visualization** | Chart.js | 3.9.1 |
| **JDBC Driver** | MySQL Connector/J | 8.0.33 |
| **Architecture** | MVC Pattern | - |
| **Design Pattern** | DAO Pattern | - |
| **Security** | SHA-256, PreparedStatements | - |

---

## Project Structure

```
RailwayWaitlistProbabilityCalculator/
│
├── src/                          # Source Code
│   └── com/waitlist/
│       ├── model/                # Domain Objects
│       │   ├── Train.java
│       │   ├── BookingHistory.java
│       │   └── User.java
│       ├── dao/                  # Data Access Layer
│       │   ├── WaitlistDAO.java
│       │   ├── UserDAO.java
│       │   └── SearchHistoryDAO.java
│       ├── controller/           # Controller Layer (Servlets)
│       │   ├── WaitlistServlet.java
│       │   ├── LoginServlet.java
│       │   ├── RegisterServlet.java
│       │   ├── LogoutServlet.java
│       │   └── AdminServlet.java
│       └── util/                 # Utilities
│           ├── DBConnection.java (Singleton)
│           ├── SecurityUtil.java
│           └── ProbabilityCalculator.java
│
├── WebContent/                   # Web Resources
│   ├── index.jsp                 # Home page
│   ├── login.jsp                 # Login page
│   ├── register.jsp              # Registration page
│   ├── dashboard.jsp             # User dashboard
│   ├── admin.jsp                 # Admin dashboard (Phase 2)
│   ├── stats.jsp                 # Statistics dashboard (Phase 2)
│   ├── result.jsp                # Results page
│   ├── error.jsp                 # Error page
│   └── WEB-INF/
│       ├── web.xml               # Servlet mappings
│       ├── classes/              # Compiled classes
│       └── lib/                  # JAR files
│
├── database/
│   └── railway.sql               # Database schema & sample data
│
├── lib/
│   └── mysql-connector-java-8.0.33.jar
│
├── build/
│   └── classes/                  # Compilation output
│
└── Configuration Files
    └── build.xml
```

---

## Prerequisites

### System Requirements
- **Windows/Mac/Linux** with internet connection
- **RAM**: Minimum 2GB (4GB recommended)
- **Disk Space**: 500MB free space

### Required Software
1. **Java Development Kit (JDK) 21**
   - Download: https://www.oracle.com/java/technologies/downloads/
   - Verify: `java -version` should show Java 21

2. **Apache Tomcat 9.0.111**
   - Download: https://tomcat.apache.org/
   - Extract to: `C:\development\apache-tomcat-9.0.111\`

3. **MySQL 8.0 or higher**
   - Download: https://www.mysql.com/downloads/
   - Install and set root password to: `2507`

4. **MySQL Connector/J 8.0.33**
   - Included in `lib/` folder
   - Location after deployment: `WebContent/WEB-INF/lib/`

---

## Installation & Setup

### Step 1: Environment Variables (Windows)

Open PowerShell and set environment variables:

```powershell
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21.0.1"
$env:JRE_HOME = "C:\Program Files\Java\jdk-21.0.1"
$env:CATALINA_HOME = "C:\development\apache-tomcat-9.0.111"
$env:Path += ";$env:JAVA_HOME\bin;$env:CATALINA_HOME\bin"

# Verify installation
java -version
javac -version
```

### Step 2: Start MySQL Service

```powershell
# Check if MySQL is running
Get-Process mysqld -ErrorAction SilentlyContinue

# If not running, start it
Start-Service "MySQL80"

# Or start manually
# "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe"
```

### Step 3: Create Database

Navigate to project directory and run:

```powershell
# Create database
mysql -u root -p2507 -e "CREATE DATABASE IF NOT EXISTS railwaydb;"

# Import schema
mysql -u root -p2507 railwaydb < .\database\railway.sql

# Verify tables created
mysql -u root -p2507 railwaydb -e "SHOW TABLES;"
```

**Expected Output:**
```
booking_history
search_history
train_info
users
```

### Step 4: Compile Java Source Files

```powershell
# Create build directory
New-Item -ItemType Directory -Force -Path ".\build\classes" | Out-Null

# Compile all Java files
javac -d .\build\classes -cp ".\lib\*;.\build\classes" `
  ".\src\com\waitlist\model\*.java" `
  ".\src\com\waitlist\util\*.java" `
  ".\src\com\waitlist\dao\*.java" `
  ".\src\com\waitlist\controller\*.java"

# Verify compilation (should show 11+ .class files)
Get-ChildItem -Recurse .\build\classes\ -Filter "*.class" | Measure-Object
```

### Step 5: Copy Files to WebContent

```powershell
# Copy compiled classes
robocopy ".\build\classes" ".\WebContent\WEB-INF\classes" /E /Y

# Copy library files
robocopy ".\lib" ".\WebContent\WEB-INF\lib" /E /Y

Write-Host "✓ Files copied to WebContent"
```

### Step 6: Create WAR File

```powershell
# Navigate to WebContent
cd WebContent

# Create WAR package
jar -cf ..\railway.war .

# Verify WAR created
Get-Item ..\railway.war

cd ..
Write-Host "✓ WAR file created"
```

### Step 7: Deploy to Tomcat

```powershell
$tomcatWebapps = "C:\development\apache-tomcat-9.0.111\webapps"

# Remove old deployment if exists
if (Test-Path "$tomcatWebapps\railway") {
    Remove-Item -Recurse -Force "$tomcatWebapps\railway"
    Remove-Item -Force "$tomcatWebapps\railway.war" -ErrorAction SilentlyContinue
}

# Copy new WAR
Copy-Item "railway.war" "$tomcatWebapps\"

# Wait for extraction
Start-Sleep -Seconds 3

Write-Host "✓ Deployment complete"
```

---

## How to Run

### Starting the Application

#### 1. Start MySQL Service

```powershell
# Option A: Via Windows Service
Start-Service "MySQL80"

# Option B: Standalone
# "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe"

# Verify connection
mysql -u root -p2507 -e "SELECT 1;" > $null
Write-Host "✓ MySQL Connected"
```

#### 2. Start Tomcat Server

```powershell
cd "C:\development\apache-tomcat-9.0.111\bin"

# Start Tomcat
.\startup.bat

# Wait for startup
Start-Sleep -Seconds 8

# Verify running
Get-Process java
Write-Host "✓ Tomcat Running on port 8080"
```

#### 3. Access the Application

**Open browser and navigate to:**
```
http://localhost:8080/railway/
```

### Stopping the Application

```powershell
# Stop Tomcat
cd "C:\development\apache-tomcat-9.0.111\bin"
.\shutdown.bat

# Stop MySQL
Stop-Service "MySQL80"
```

### Complete Startup Script (PowerShell)

```powershell
# 1. Set environment
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21.0.1"
$env:CATALINA_HOME = "C:\development\apache-tomcat-9.0.111"

# 2. Start MySQL
Write-Host "Starting MySQL..." -ForegroundColor Cyan
Start-Service "MySQL80"
Start-Sleep -Seconds 3

# 3. Start Tomcat
Write-Host "Starting Tomcat..." -ForegroundColor Cyan
cd "$env:CATALINA_HOME\bin"
.\startup.bat
Start-Sleep -Seconds 8

# 4. Open browser
Write-Host "Opening browser..." -ForegroundColor Green
Start-Process "http://localhost:8080/railway/"

Write-Host "`n✓ Application ready at http://localhost:8080/railway/" -ForegroundColor Green
```

---

## Database Schema

### Tables Overview

#### 1. **train_info** - Train Information
```sql
CREATE TABLE train_info (
    train_no VARCHAR(10) PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL
);
```

#### 2. **booking_history** - Historical Booking Data
```sql
CREATE TABLE booking_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    train_no VARCHAR(10) NOT NULL,
    journey_date DATE NOT NULL,
    class_type VARCHAR(10) NOT NULL,
    total_wl INT NOT NULL,
    confirmed_tickets INT NOT NULL,
    FOREIGN KEY (train_no) REFERENCES train_info(train_no)
);
```

#### 3. **users** - User Accounts (Phase 1)
```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(10) DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);
```

#### 4. **search_history** - User Search Tracking (Phase 1)
```sql
CREATE TABLE search_history (
    search_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    train_no VARCHAR(10) NOT NULL,
    journey_date DATE NOT NULL,
    class_type VARCHAR(10) NOT NULL,
    waitlist_number INT NOT NULL,
    calculated_probability DECIMAL(5,2),
    search_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (train_no) REFERENCES train_info(train_no)
);
```

### Sample Data
- 10+ trains with complete information
- 85+ booking history records
- Pre-configured test users (admin, testuser)
- Historical data from January-June 2024

---



### Public Endpoints (No Authentication Required)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Home page |
| `/index.jsp` | GET | Home page |
| `/login.jsp` | GET | Login page |
| `/LoginServlet` | POST | Process login |
| `/register.jsp` | GET | Registration page |
| `/RegisterServlet` | POST | Process registration |
| `/LogoutServlet` | GET | Logout user |

### Protected Endpoints (Authentication Required)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/dashboard.jsp` | GET | User dashboard |
| `/WaitlistServlet` | POST | Calculate probability |
| `/result.jsp` | GET | Display results |

### Admin Endpoints (Admin Access Required)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/admin.jsp` | GET | Admin dashboard |
| `/AdminServlet?action=dashboard` | GET | Dashboard overview |
| `/AdminServlet?action=users` | GET | View all users |
| `/AdminServlet?action=trains` | GET | View all trains |
| `/AdminServlet?action=stats` | GET | View statistics |
| `/AdminServlet` | POST | User management actions |
| `/stats.jsp` | GET | Statistics with charts |

### Servlet Actions (POST)

```
AdminServlet POST actions:
- action=promote_user&userId=X  → Promote user to admin
- action=demote_user&userId=X   → Demote admin to user
- action=deactivate_user&userId=X → Deactivate user
```

---

## Usage Guide

### 1. Register New Account

1. Go to: `http://localhost:8080/railway/register.jsp`
2. Enter:
   - Username (unique)
   - Email (unique)
   - Password (min 8 characters, with uppercase, lowercase, number, special char)
3. Click "Register"
4. Redirected to login page

**Test User Already Available:**
- Username: `testuser`
- Password: `test123`

### 2. Login

1. Go to: `http://localhost:8080/railway/login.jsp`
2. Enter credentials
3. Click "Login"
4. Redirected to dashboard with search history

**Admin Credentials:**
- Username: `admin`
- Password: `admin@123`

### 3. Calculate Probability

1. Login as regular user
2. Enter train details:
   - Train Number (e.g., 12345)
   - Journey Date (e.g., 2024-01-15)
   - Class Type (e.g., AC1, SL, AC2, CC)
   - Waitlist Number (e.g., 5)
3. Click "Calculate"
4. View probability result
5. Search automatically saved to history

### 4. View Dashboard

After login, see:
- Recent searches
- Search history details
- Admin links (if admin user)

### 5. Admin Panel

**For Admin Users:**
1. Go to: `http://localhost:8080/railway/admin.jsp`
2. Available options:
   - **Dashboard Tab**: System overview
   - **Users Tab**: Manage users (promote, demote, deactivate)
   - **Trains Tab**: View train information
   - **Statistics Tab**: View system stats

### 6. Statistics Dashboard

1. Go to: `http://localhost:8080/railway/stats.jsp` (admin only)
2. View:
   - Total users
   - Total searches
   - Average probability
   - Chart: Top trains by searches
   - Chart: Probability distribution

---

## Testing

### Test Endpoints

```powershell
Write-Host "Testing Endpoints..."

$endpoints = @(
    "http://localhost:8080/railway/",
    "http://localhost:8080/railway/login.jsp",
    "http://localhost:8080/railway/register.jsp",
    "http://localhost:8080/railway/admin.jsp",
    "http://localhost:8080/railway/stats.jsp"
)

foreach ($uri in $endpoints) {
    try {
        $response = Invoke-WebRequest -Uri $uri -ErrorAction SilentlyContinue
        Write-Host "$($response.StatusCode) - $uri" -ForegroundColor Green
    } catch {
        Write-Host "ERROR - $uri" -ForegroundColor Red
    }
}
```

### Test Cases

#### Test 1: User Registration
```
1. Go to /register.jsp
2. Enter: newuser / newemail@test.com / Test@123456
3. Expected: Success message, redirect to login
4. Verify: Can login with new credentials
```

#### Test 2: Calculate Probability
```
1. Login as testuser/test123
2. Enter: Train 12345, Date 2024-01-15, Class AC1, Waitlist 5
3. Expected: ~75-80% probability, success message
4. Verify: Appears in search history
```

#### Test 3: Admin User Management
```
1. Login as admin/admin123
2. Go to Admin → Users tab
3. Click "Promote" on testuser
4. Expected: Role changes to "admin"
5. Verify: Database updated
```

#### Test 4: Statistics Dashboard
```
1. Login as admin
2. Go to Stats page
3. Expected: Charts render, stats display correctly
4. Verify: Numbers match database
```

#### Test 5: Logout
```
1. Click "Logout"
2. Expected: Session destroyed, redirect to login
3. Verify: Cannot access dashboard without login
```

---

## Architecture

### 3-Layer MVC Architecture

```
┌─────────────────────────────────────────┐
│  Presentation Layer (View)              │
│  JSP Pages: index, login, dashboard,    │
│  admin, stats, result, error            │
└─────────────────────────────────────────┘
           ↑ Forward/Include ↓
┌─────────────────────────────────────────┐
│  Business Logic Layer (Controller)      │
│  Servlets: WaitlistServlet, LoginServlet│
│  RegisterServlet, AdminServlet, etc.    │
└─────────────────────────────────────────┘
           ↑ Method Calls ↓
┌─────────────────────────────────────────┐
│  Data Access Layer (Model)              │
│  DAOs: UserDAO, WaitlistDAO,            │
│  SearchHistoryDAO + Utilities           │
└─────────────────────────────────────────┘
           ↑ SQL Queries ↓
┌─────────────────────────────────────────┐
│  Data Layer (MySQL Database)            │
│  Tables: train_info, booking_history,   │
│  users, search_history                  │
└─────────────────────────────────────────┘
```

### Design Patterns Used

1. **MVC Pattern**: Separation of concerns
2. **DAO Pattern**: Data access abstraction
3. **Singleton Pattern**: DBConnection management
4. **Factory Pattern**: Object creation in DAOs

### OOP Concepts Implemented

- **Encapsulation**: Private fields with public getters/setters
- **Inheritance**: Servlet extends HttpServlet
- **Polymorphism**: Method overriding (doGet, doPost)
- **Abstraction**: DAO pattern hides implementation details

---

## Security

### Password Security
- SHA-256 hashing with salt
- Implemented in `SecurityUtil.java`
- Never stored as plain text
- Validation on registration:
  - Minimum 8 characters
  - Contains uppercase, lowercase, number, special character

### SQL Injection Prevention
- All queries use **PreparedStatements**
- Parameter binding prevents injection
- No string concatenation in SQL

### Authentication & Authorization
- Session-based authentication
- Role-based access control (RBAC)
- 30-minute session timeout
- Admin-only pages verified server-side

### Database Security
- Foreign key constraints
- Unique indexes on username, email
- User role verification before admin operations

### Code Sample: PreparedStatement
```java
// Secure - Uses PreparedStatement
String query = "SELECT * FROM users WHERE username = ? AND role = ?";
PreparedStatement pstmt = connection.prepareStatement(query);
pstmt.setString(1, username);
pstmt.setString(2, "admin");
// Result is safe from SQL injection
```

---

## Troubleshooting

### Issue 1: "Connection Refused - MySQL"

**Problem**: Cannot connect to MySQL database

**Solution**:
```powershell
# Check if MySQL is running
Get-Process mysqld

# If not running, start it
Start-Service "MySQL80"

# Verify connection
mysql -u root -p2507 -e "SELECT 1;"

# Check DBConnection.java settings:
# DB_URL = jdbc:mysql://localhost:3306/railwaydb
# DB_USERNAME = root
# DB_PASSWORD = 2507
```

### Issue 2: "ClassNotFoundException: com.mysql.jdbc.Driver"

**Problem**: MySQL Connector JAR not in classpath

**Solution**:
```powershell
# Verify JAR exists
Get-Item ".\WebContent\WEB-INF\lib\mysql-connector-java-*.jar"

# If missing, copy it
Copy-Item ".\lib\mysql-connector-java-8.0.33.jar" `
          ".\WebContent\WEB-INF\lib\"

# Recompile and redeploy
```

### Issue 3: "404 Error - Page Not Found"

**Problem**: Application not deployed correctly

**Solution**:
```powershell
# Check Tomcat webapps directory
Get-ChildItem "C:\development\apache-tomcat-9.0.111\webapps\railway\"

# If missing, redeploy:
Copy-Item "railway.war" `
          "C:\development\apache-tomcat-9.0.111\webapps\"

# Restart Tomcat
```

### Issue 4: "500 Internal Server Error"

**Problem**: Java exception on server

**Solution**:
```powershell
# Check Tomcat logs
Get-Content "C:\development\apache-tomcat-9.0.111\logs\catalina.out" -Tail 50

# Check web.xml for errors
Get-Content ".\WebContent\WEB-INF\web.xml"

# Verify database connection in DBConnection.java
```

### Issue 5: "Session Expired"

**Problem**: Session timeout or invalid session

**Solution**:
```powershell
# Session timeout configured in web.xml (30 minutes)
# Login again and use within 30 minutes

# Check session configuration:
# <session-config>
#     <cookie-config>
#         <max-age>1800</max-age>
#     </cookie-config>
# </session-config>
```

### Issue 6: "Compilation Errors"

**Problem**: Java files don't compile

**Solution**:
```powershell
# Verify Java version
java -version  # Should show Java 21

# Check all JAR files in lib/
Get-ChildItem .\lib\

# Recompile with verbose output
javac -d .\build\classes -cp ".\lib\*;.\build\classes" `
  -verbose .\src\com\waitlist\**\*.java 2>&1 | Select-String "error"
```

### Checking Logs

**Tomcat Log Files:**
```
C:\development\apache-tomcat-9.0.111\logs\
├── catalina.out          (Main log)
├── catalina.YYYY-MM-DD.log (Daily log)
└── localhost.YYYY-MM-DD.log (Application log)
```

**View Logs:**
```powershell
# Real-time monitoring
Get-Content "catalina.out" -Wait -Tail 20

# Search for errors
Select-String "ERROR" "catalina.out"
Select-String "Exception" "catalina.out"
```

---

## Key Files & Configuration

### Database Connection

**File**: `src/com/waitlist/util/DBConnection.java`

```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/railwaydb";
private static final String DB_USERNAME = "root";
private static final String DB_PASSWORD = "2507";
```

### Servlet Mappings

**File**: `WebContent/WEB-INF/web.xml`

```xml
<servlet>
    <servlet-name>WaitlistServlet</servlet-name>
    <servlet-class>com.waitlist.controller.WaitlistServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>WaitlistServlet</servlet-name>
    <url-pattern>/WaitlistServlet</url-pattern>
</servlet-mapping>
```

### Session Configuration

**File**: `WebContent/WEB-INF/web.xml`

```xml
<session-config>
    <cookie-config>
        <max-age>1800</max-age>  <!-- 30 minutes -->
    </cookie-config>
</session-config>
```

---

## Performance Considerations

### Database Optimization
- Indexes on frequently searched columns (username, email, train_no)
- Foreign key constraints for referential integrity
- PreparedStatements for query caching

### Caching
- Session-based user caching
- Prepared statement caching

### Scalability
- Stateless servlet design
- Connection pooling ready (future enhancement)
- Load balancer compatible

---

## Useful Commands Reference

```powershell
# Environment
java -version
javac -version
mysql --version

# Database
mysql -u root -p2507
mysql -u root -p2507 railwaydb < .\database\railway.sql
mysql -u root -p2507 railwaydb -e "SHOW TABLES;"

# Build
javac -d .\build\classes -cp ".\lib\*;.\build\classes" `
  .\src\com\waitlist\**\*.java
jar -cf railway.war -C WebContent .

# Tomcat
cd $CATALINA_HOME\bin
.\startup.bat
.\shutdown.bat

# Process Management
Get-Process java
Get-Process mysqld
Stop-Process -Name java -Force
```

---

## File Statistics

| Metric | Count |
|--------|-------|
| Java Source Files | 11 |
| JSP Pages | 7 |
| DAO Classes | 3 |
| Servlet Classes | 5 |
| Utility Classes | 3 |
| Database Tables | 4 |
| Total Java Lines | 2,000+ |
| Total JSP Lines | 2,500+ |
| Compilation Status | ✅ No Errors |
| Deployment Status | ✅ Production Ready |

---

## Quick Start Summary

```
1. Install Java 21, MySQL 8.0, Tomcat 9.0.111
2. Create database: mysql -u root -p2507 < .\database\railway.sql
3. Compile: javac -d .\build\classes -cp ".\lib\*;.\build\classes" ...
4. Deploy: Copy WAR to Tomcat/webapps/
5. Start: MySQL + Tomcat
6. Access: http://localhost:8080/railway/
7. Login: admin/admin123 or testuser/test123
8. Test: Register → Calculate → View stats
```

---

## Support & Documentation

- **Tomcat**: https://tomcat.apache.org/
- **MySQL**: https://dev.mysql.com/doc/
- **Java**: https://docs.oracle.com/javase/21/
- **JSP**: https://projects.eclipse.org/projects/ee4j.jsp
- **JDBC**: https://docs.oracle.com/javase/tutorial/jdbc/

---

## License

Educational Project - 3rd Semester Level

---

**Project Status**: ✅ Complete and Production Ready  
**Last Updated**: November 25, 2025  
**Difficulty Level**: 3rd Semester / Intermediate  
**Current Deployment**: `/railway` context on `http://localhost:8080/`

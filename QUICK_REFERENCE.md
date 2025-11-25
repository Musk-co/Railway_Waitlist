# 🚂 Railway Waitlist Calculator - Quick Reference Guide

## 🎬 Getting Started

### Demo Credentials
```
Admin Account:
  Username: admin
  Password: admin123

Test User Account:
  Username: testuser
  Password: test123
```

### Application URLs
```
Home Page:          http://localhost:8080/RailwayWaitlist/
Login:              http://localhost:8080/RailwayWaitlist/login.jsp
Register:           http://localhost:8080/RailwayWaitlist/register.jsp
Probability Calculator: http://localhost:8080/RailwayWaitlist/index.jsp
User Dashboard:     http://localhost:8080/RailwayWaitlist/dashboard.jsp
Admin Dashboard:    http://localhost:8080/RailwayWaitlist/admin.jsp (admin only)
Statistics:         http://localhost:8080/RailwayWaitlist/stats.jsp (admin only)
```

---

## 📋 Testing Scenarios

### Scenario 1: New User Registration
1. Go to Register page
2. Enter username: `newuser1`
3. Enter email: `newuser@example.com`
4. Enter password: `Password123`
5. Confirm password: `Password123`
6. Click "Register"
7. **Expected**: Success message, redirect to login
8. Login with new credentials
9. **Expected**: Access dashboard with search history

### Scenario 2: Probability Calculation
1. Login as testuser / test123
2. Go to home page
3. Enter Train Number: `12345`
4. Enter Journey Date: `15-01-2024`
5. Select Class: `AC2` (AC 2 Tier)
6. Enter Waitlist Number: `5`
7. Click "Calculate Probability"
8. **Expected**: See probability result + search saved to history
9. Go to Dashboard
10. **Expected**: Latest search visible in recent searches table

### Scenario 3: Admin Features
1. Login as admin / admin123
2. Go to Dashboard
3. **Expected**: See "Admin Dashboard" and "Statistics" links
4. Click "Admin Dashboard"
5. **Expected**: See admin placeholder page with navigation
6. Click "Statistics"
7. **Expected**: See statistics dashboard placeholder

### Scenario 4: Error Handling
1. Try to access /WaitlistServlet without login
2. **Expected**: Redirect to login page
3. Try registering with duplicate username
4. **Expected**: Error message: "Username already exists"
5. Try registering with invalid email
6. **Expected**: Error message: "Please enter a valid email address"
7. Try registering with password < 6 characters
8. **Expected**: Error message: "Password must be at least 6 characters"

---

## 🔍 Key Features

### Authentication System
- ✅ Secure SHA-256 password hashing
- ✅ Email and username uniqueness validation
- ✅ Role-based access control (admin/user)
- ✅ Session management with 30-minute timeout
- ✅ Automatic login status display in header

### Search History
- ✅ Auto-save on each probability calculation
- ✅ Display last 5 searches on dashboard
- ✅ Shows: Train #, Date, Class, Waitlist #, Probability, Timestamp
- ✅ Supports analytics queries for statistics

### User Dashboard
- ✅ Welcome message with user info
- ✅ Account status badge (Admin/User)
- ✅ Member since date
- ✅ Last login timestamp
- ✅ Quick action buttons for common tasks

### Admin Features (Phase 2)
- ⧗ User management
- ⧗ Train information management
- ⧗ System statistics with charts
- ⧗ Booking history review

---

## 🔧 Configuration

### Database Configuration
```
Location: src/com/waitlist/util/DBConnection.java
URL:      jdbc:mysql://localhost:3306/railwaydb
User:     root
Password: 2507
Driver:   mysql-connector-java-8.0.33.jar
```

### Session Configuration
```
Location: WebContent/WEB-INF/web.xml
Timeout:  30 minutes
```

### Password Requirements
- Minimum 6 characters
- No special character requirements
- Case-sensitive

### Username Requirements
- 3-20 characters
- Alphanumeric only (letters and numbers)
- Must be unique

### Email Requirements
- Valid RFC format
- Must be unique
- Used for account recovery (future phase)

---

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) DEFAULT 'user',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP NULL,
  KEY idx_username (username),
  KEY idx_email (email)
);
```

### Search History Table
```sql
CREATE TABLE search_history (
  search_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  train_no VARCHAR(20) NOT NULL,
  journey_date DATE NOT NULL,
  class_type VARCHAR(20) NOT NULL,
  waitlist_number INT NOT NULL,
  probability DECIMAL(5,2) NOT NULL,
  searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (train_no) REFERENCES train_info(train_no),
  KEY idx_user_id (user_id),
  KEY idx_searched_at (searched_at)
);
```

---

## 🔐 Security Features

### Password Security
- ✅ SHA-256 one-way hashing
- ✅ No plaintext passwords stored
- ✅ Individual hash per user

### SQL Injection Prevention
- ✅ PreparedStatements in all queries
- ✅ Parameter binding throughout

### Session Security
- ✅ 30-minute auto-timeout
- ✅ Session invalidation on logout
- ✅ User role verification on protected pages

### Input Validation
- ✅ Email format validation
- ✅ Username format validation
- ✅ Password strength validation
- ✅ Duplicate prevention (indexes)

---

## 🐛 Troubleshooting

### Issue: "Login page keeps redirecting"
**Solution**: Clear browser cookies/cache, log out first, then try login again

### Issue: "Train not found" error
**Solution**: Ensure train number exists in database. Supported test trains include 12345, 16789, etc.

### Issue: "Search not appearing in dashboard"
**Solution**: 
- Ensure you're logged in
- Check browser console for errors
- Verify MySQL connection is active

### Issue: "Can't register with valid email"
**Solution**:
- Ensure @ symbol and domain are included
- Try a different email if it's already registered
- Check for typos

### Issue: "Session expires too quickly"
**Solution**: 
- Session timeout is 30 minutes of inactivity
- Refresh page to reset timer
- Contact admin to change timeout in web.xml

---

## 📊 Useful SQL Queries

### View All Users
```sql
SELECT * FROM users;
```

### View User Search History
```sql
SELECT * FROM search_history 
WHERE user_id = 1 
ORDER BY searched_at DESC 
LIMIT 10;
```

### Train Success Statistics
```sql
SELECT train_no, AVG(probability) as avg_probability, COUNT(*) as search_count
FROM search_history
GROUP BY train_no
ORDER BY avg_probability DESC;
```

### Reset Password (Admin)
```sql
UPDATE users 
SET password_hash = SHA2('newpassword', 256) 
WHERE username = 'testuser';
```

### Delete User Account (Admin)
```sql
DELETE FROM users WHERE user_id = 5;
-- Note: Also deletes search history due to foreign key constraint
```

---

## 📚 File Locations

### Java Source Files
- Servlets: `src/com/waitlist/controller/`
- Models: `src/com/waitlist/model/`
- DAOs: `src/com/waitlist/dao/`
- Utilities: `src/com/waitlist/util/`

### JSP Pages
- All JSP files: `WebContent/` (root and subfolders)

### Configuration
- Web Deployment: `WebContent/WEB-INF/web.xml`
- Database Init: `database/railway.sql`
- Build Script: `build.xml`

### Compiled Classes
- After build: `WebContent/WEB-INF/classes/com/waitlist/`
- WAR archive: `RailwayWaitlist.war` (root directory)

---

## 🚀 Deployment Checklist

- [ ] MySQL server running (port 3306)
- [ ] Database `railwaydb` created
- [ ] `railway.sql` executed (includes users & search_history tables)
- [ ] Java 21 installed
- [ ] Tomcat 9.0.111 installed and configured
- [ ] MySQL connector JAR in `lib/` folder
- [ ] All Java files compiled to `build/classes/`
- [ ] Classes copied to `WebContent/WEB-INF/classes/`
- [ ] WAR file created and copied to Tomcat webapps
- [ ] Tomcat restarted
- [ ] Application loads at `http://localhost:8080/RailwayWaitlist/`
- [ ] Can login with demo credentials

---

## 📞 Support Information

### Common Questions

**Q: How do I register a new account?**  
A: Click "Register" button, fill in details, click Submit. Redirect to login if successful.

**Q: Why did my password reset?**  
A: Passwords are not reset. If forgotten, contact admin to set new password.

**Q: Can I change my username?**  
A: Not in current version. Contact admin for account changes.

**Q: How long are searches kept?**  
A: Indefinitely. Admin can delete via database if needed.

**Q: Is this system secure for real railway bookings?**  
A: This is an educational project. For real bookings, use official IRCTC website.

---

**Version**: 1.0  
**Last Updated**: November 24, 2025  
**Maintained By**: Development Team

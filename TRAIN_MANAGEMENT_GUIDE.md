# Train Management Guide

## Overview
The Railway Waitlist Calculator now has a complete train management system that allows admins to add, edit, search, and delete trains directly from the web interface without needing to access the database.

**Status**: ✅ **Production Ready**

---

## How to Access Train Management

### Step 1: Login as Admin
1. Go to: `http://localhost:8080/railway/login.jsp`
2. Login with admin credentials:
   - **Username**: `admin`
   - **Password**: `admin@123`

### Step 2: Navigate to Admin Dashboard
3. Click the **Admin Dashboard** link (appears on dashboard after login)
4. You'll see the admin interface with tabs at the top

### Step 3: Go to Trains Tab
5. Click on the **🚂 Trains** tab in the admin menu

---

## Train Management Features

### 1. View All Trains
The main trains tab displays all trains currently in the system in a table format showing:
- Train Number
- Train Name
- Source Station
- Destination Station
- Action Buttons (Edit, Delete)

### 2. Search Trains
- Use the search bar to find trains by:
  - **Train Number** (e.g., "12001")
  - **Train Name** (e.g., "Rajdhani")
  - **Source** (e.g., "Delhi")
  - **Destination** (e.g., "Mumbai")
- Click "Search" to filter results
- Click "Clear" to reset and show all trains

### 3. Add New Train

**Form Fields:**
- **Train Number** (required): Unique identifier for the train (e.g., "12345")
- **Train Name** (required): Name of the train (e.g., "Rajdhani Express")
- **Source** (required): Origin station (e.g., "Delhi")
- **Destination** (required): Destination station (e.g., "Mumbai")

**Steps:**
1. Scroll down to the "➕ Add New Train" form
2. Fill in all four fields
3. Click "➕ Add Train" button
4. You'll see a success message: "Train added successfully!"
5. The new train will appear in the table

**Example:**
```
Train Number: 12345
Train Name: Rajdhani Express
Source: Delhi
Destination: Mumbai
```

### 4. Edit Train

**Steps:**
1. In the trains table, find the train you want to edit
2. Click the "✏️ Edit" button in the Actions column
3. A modal dialog will open with the train details
4. Edit any field you want to change:
   - Train Name
   - Source
   - Destination
5. Note: Train Number cannot be changed (read-only)
6. Click "💾 Update" to save changes
7. You'll see a success message: "Train updated successfully!"

### 5. Delete Train

**Steps:**
1. In the trains table, find the train you want to delete
2. Click the "🗑️ Delete" button in the Actions column
3. A confirmation dialog will appear asking "Are you sure you want to delete this train?"
4. Click "OK" to confirm deletion or "Cancel" to abort
5. You'll see a success message: "Train deleted successfully!"

---

## Database Integration

The train management system updates the MySQL database in real-time:

**Database Table:** `train_info`

```sql
CREATE TABLE train_info (
    train_no VARCHAR(10) PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL
);
```

**All operations are:**
- ✅ **Real-time** - Changes reflect immediately
- ✅ **Persistent** - Stored in the database
- ✅ **Secure** - Use PreparedStatements (SQL injection prevention)
- ✅ **Validated** - All fields are required and validated

---

## Error Handling

The system provides clear feedback for all operations:

### Success Messages (Green)
- "✓ Train added successfully!"
- "✓ Train updated successfully!"
- "✓ Train deleted successfully!"

### Error Messages (Red)
- "✗ All fields are required."
- "✗ Failed to add train. Train number may already exist."
- "✗ Failed to delete train."
- "✗ Failed to update train."

---

## Features Summary

| Feature | Status | Details |
|---------|--------|---------|
| View All Trains | ✅ | Display all trains in a table |
| Search Trains | ✅ | Search by train no, name, source, or destination |
| Add Train | ✅ | Add new trains via web form |
| Edit Train | ✅ | Edit existing train details via modal |
| Delete Train | ✅ | Delete trains with confirmation |
| Real-time Updates | ✅ | All changes reflected immediately |
| Database Persistence | ✅ | All data stored in MySQL |
| Input Validation | ✅ | All fields validated |
| Error Handling | ✅ | Clear error and success messages |

---

## Important Notes

1. **Train Number is Unique**: Each train must have a unique train number. Adding a train with an existing number will fail.

2. **Cannot Modify Train Number**: When editing, the train number is read-only. To change it, you must delete and re-add the train.

3. **Cascading Deletes**: Deleting a train will remove it from `train_info` table. Related booking history records are managed by foreign key constraints.

4. **Responsive Design**: The interface works on both desktop and mobile devices.

5. **Admin Only**: Only users with admin role can access this feature. Regular users cannot access train management.

---

## Backend Architecture

### Files Modified/Created
- `AdminServlet.java`: Handles POST/GET requests for train management
- `WaitlistDAO.java`: Database operations (addTrain, updateTrain, deleteTrain, searchTrains, getAllTrains)
- `admin.jsp`: Web interface for train management

### Methods Available in WaitlistDAO
```java
public List<Train> getAllTrains()           // Get all trains
public List<Train> searchTrains(String q)   // Search trains
public boolean addTrain(...)                // Add new train
public boolean updateTrain(...)             // Update train
public boolean deleteTrain(String trainNo)  // Delete train
public Train getTrainByNumber(String no)    // Get single train
```

---

## Testing the Feature

### Test Case 1: Add a Train
1. Login as admin
2. Go to Trains tab
3. Fill the form:
   - Train No: `99999`
   - Train Name: `Test Express`
   - Source: `TestCity1`
   - Destination: `TestCity2`
4. Click "Add Train"
5. ✅ Should see success message
6. ✅ Train should appear in the table

### Test Case 2: Search Trains
1. In Trains tab, enter "Test" in search box
2. Click Search
3. ✅ Should show only trains matching "Test"

### Test Case 3: Edit Train
1. Click "Edit" on any train
2. Change the train name
3. Click "Update"
4. ✅ Should see success message
5. ✅ Table should show updated name

### Test Case 4: Delete Train
1. Click "Delete" on the test train
2. Confirm deletion
3. ✅ Should see success message
4. ✅ Train should disappear from table

---

## Troubleshooting

### Issue: "Failed to add train. Train number may already exist."
**Solution**: The train number you're using already exists. Use a different train number.

### Issue: Cannot access Admin page
**Solution**: 
- Ensure you're logged in with an admin account
- Check that your user has admin role in the database

### Issue: Changes not appearing in table
**Solution**: 
- Refresh the page (F5)
- Check browser console for errors
- Verify MySQL is running

### Issue: Modal won't open when clicking Edit
**Solution**: 
- Clear browser cache
- Try a different browser
- Check browser console for JavaScript errors

---

## Video Tutorial (Steps to Follow)

1. **Login**: Admin account only
2. **Navigate**: Click Admin Dashboard → Trains tab
3. **View**: See current trains in the table
4. **Search**: Use search bar to find specific trains
5. **Add**: Fill the form and click "Add Train"
6. **Edit**: Click "Edit", change fields, click "Update"
7. **Delete**: Click "Delete" and confirm
8. **Verify**: Changes appear immediately in the table

---

**Last Updated**: November 25, 2025  
**Status**: ✅ Production Ready and Fully Functional

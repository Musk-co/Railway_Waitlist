package com.waitlist.dao;

import com.waitlist.model.User;
import com.waitlist.util.DBConnection;
import com.waitlist.util.SecurityUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO - Data Access Object for User Operations
 * Handles all database operations related to user management including registration, authentication,
 * user profile management, and administrative user operations.
 */
public class UserDAO {
    
    /**
     * Registers a new user in the system.
     * The user is created with a default "user" role and is initially active.
     * 
     * @param user The User object containing registration details (username, email, passwordHash)
     * @return True if the user was successfully registered, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean registerUser(User user) {
        String query = "INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, "user"); // Default role for new users
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error registering user: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Authenticates a user by verifying their credentials.
     * Compares the provided password against the stored password hash.
     * Updates the user's last_login timestamp upon successful authentication.
     * 
     * @param username The username to authenticate
     * @param password The plain text password to verify
     * @return User object if authentication succeeds, null if credentials are invalid or user is inactive
     * @throws SQLException if database operation fails (caught internally)
     */
    public User authenticateUser(String username, String password) {
        String query = "SELECT * FROM users WHERE username = ? AND is_active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String passwordHash = SecurityUtil.hashPassword(password);
                
                if (storedHash.equals(passwordHash)) {
                    User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password_hash"),
                        rs.getString("role"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("last_login"),
                        rs.getBoolean("is_active")
                    );
                    
                    // Update last_login timestamp
                    updateLastLogin(user.getUserId());
                    
                    return user;
                }
            }
            
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error authenticating user: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Checks if a username is already registered in the system.
     * Used for preventing duplicate usernames during registration.
     * 
     * @param username The username to check
     * @return True if the username exists, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean usernameExists(String username) {
        String query = "SELECT COUNT(*) as count FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking username availability: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Checks if an email address is already registered in the system.
     * Used for preventing duplicate email addresses during registration.
     * 
     * @param email The email address to check
     * @return True if the email exists, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean emailExists(String email) {
        String query = "SELECT COUNT(*) as count FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking email availability: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Retrieves a user by their user ID.
     * 
     * @param userId The unique user identifier
     * @return User object if found, null otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public User getUserById(int userId) {
        String query = "SELECT * FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password_hash"),
                    rs.getString("role"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("last_login"),
                    rs.getBoolean("is_active")
                );
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving user by ID: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Retrieves all users from the system.
     * Primarily used for administrative purposes to manage user accounts.
     * 
     * @return List of all User objects ordered by creation date (most recent first)
     * @throws SQLException if database operation fails (caught internally)
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            ResultSet rs = stmt.executeQuery(query);
            
            while (rs.next()) {
                User user = new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password_hash"),
                    rs.getString("role"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("last_login"),
                    rs.getBoolean("is_active")
                );
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving all users: " + e.getMessage());
        }
        
        return users;
    }
    
    /**
     * Updates the last login timestamp for a user.
     * Called automatically after successful authentication.
     * 
     * @param userId The user ID to update
     * @throws SQLException if database operation fails (caught internally)
     */
    private void updateLastLogin(int userId) {
        String query = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("Error updating last login timestamp: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
    }
    
    /**
     * Deactivates a user account, preventing them from logging in.
     * Used for administrative user management to disable accounts.
     * 
     * @param userId The user ID to deactivate
     * @return True if the user was successfully deactivated, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean deactivateUser(int userId) {
        String query = "UPDATE users SET is_active = FALSE WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deactivating user account: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Updates a user's role for administrative purposes.
     * Allows changing user privileges between "user" and "admin" roles.
     * 
     * @param userId The user ID to update
     * @param role The new role ("user" or "admin")
     * @return True if the role was successfully updated, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean updateUserRole(int userId, String role) {
        String query = "UPDATE users SET role = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, role);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating user role: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Gets the total count of registered users in the system.
     * 
     * @return Total number of users
     * @throws SQLException if database operation fails (caught internally)
     */
    public long getTotalUsers() {
        String query = "SELECT COUNT(*) as total FROM users";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong("total");
            }
            return 0;
            
        } catch (SQLException e) {
            System.err.println("Error retrieving total user count: " + e.getMessage());
            return 0;
        }
    }
}

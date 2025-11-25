package com.waitlist.model;

import java.util.Date;

/**
 * User Model Class
 * Represents a user in the railway waitlist system with authentication and role-based access.
 * Each user has credentials, profile information, and audit timestamps for tracking activity.
 */
public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private String role; // "user" or "admin"
    private Date createdAt;
    private Date lastLogin;
    private boolean isActive;
    
    /**
     * Default constructor for creating User objects.
     */
    public User() {}
    
    /**
     * Constructor for registering a new user with basic credentials.
     * Automatically sets role as "user" and marks user as active.
     * 
     * @param username Unique username for login
     * @param email User's email address
     * @param passwordHash SHA-256 hash of the user's password
     */
    public User(String username, String email, String passwordHash) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = "user";
        this.isActive = true;
    }
    
    /**
     * Full constructor for creating a complete User object with all details.
     * 
     * @param userId Unique user identifier
     * @param username Unique username for login
     * @param email User's email address
     * @param passwordHash SHA-256 hash of the user's password
     * @param role User role ("user" or "admin")
     * @param createdAt User account creation timestamp
     * @param lastLogin Most recent login timestamp
     * @param isActive Whether the user account is active
     */
    public User(int userId, String username, String email, String passwordHash, 
                String role, Date createdAt, Date lastLogin, boolean isActive) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.createdAt = createdAt;
        this.lastLogin = lastLogin;
        this.isActive = isActive;
    }
    
    /**
     * Gets the user ID.
     * 
     * @return Unique user identifier
     */
    public int getUserId() {
        return userId;
    }
    
    /**
     * Sets the user ID.
     * 
     * @param userId Unique user identifier
     */
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    /**
     * Gets the username.
     * 
     * @return Username for login
     */
    public String getUsername() {
        return username;
    }
    
    /**
     * Sets the username.
     * 
     * @param username Username for login
     */
    public void setUsername(String username) {
        this.username = username;
    }
    
    /**
     * Gets the email address.
     * 
     * @return User's email address
     */
    public String getEmail() {
        return email;
    }
    
    /**
     * Sets the email address.
     * 
     * @param email User's email address
     */
    public void setEmail(String email) {
        this.email = email;
    }
    
    /**
     * Gets the password hash.
     * 
     * @return SHA-256 hash of the user's password
     */
    public String getPasswordHash() {
        return passwordHash;
    }
    
    /**
     * Sets the password hash.
     * 
     * @param passwordHash SHA-256 hash of the user's password
     */
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    /**
     * Gets the user role.
     * 
     * @return Role: "user" or "admin"
     */
    public String getRole() {
        return role;
    }
    
    /**
     * Sets the user role.
     * 
     * @param role Role: "user" or "admin"
     */
    public void setRole(String role) {
        this.role = role;
    }
    
    /**
     * Gets the account creation timestamp.
     * 
     * @return Date when the user account was created
     */
    public Date getCreatedAt() {
        return createdAt;
    }
    
    /**
     * Sets the account creation timestamp.
     * 
     * @param createdAt Date when the user account was created
     */
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    /**
     * Gets the last login timestamp.
     * 
     * @return Date of the user's most recent login
     */
    public Date getLastLogin() {
        return lastLogin;
    }
    
    /**
     * Sets the last login timestamp.
     * 
     * @param lastLogin Date of the user's most recent login
     */
    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
    }
    
    /**
     * Checks if the user account is active.
     * 
     * @return True if the user account is active, false otherwise
     */
    public boolean isActive() {
        return isActive;
    }
    
    /**
     * Sets the user account status.
     * 
     * @param active Whether the user account is active
     */
    public void setActive(boolean active) {
        isActive = active;
    }
    
    /**
     * Checks if the user has admin privileges.
     * 
     * @return True if the user role is "admin", false otherwise
     */
    public boolean isAdmin() {
        return "admin".equals(role);
    }
    
    /**
     * Returns a string representation of the User object.
     * 
     * @return String representation with user details
     */
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}

package com.waitlist.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Manager
 * Manages MySQL database connections for the Railway Waitlist application.
 * Uses connection pooling approach - creates new connections per request (not singleton).
 * This prevents connection blocking and thread contention issues.
 */
public class DBConnection {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/railwaydb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&autoReconnect=true&maxReconnects=5";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "2507";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static boolean driverLoaded = false;
    
    static {
        // Load driver once at startup
        try {
            Class.forName(DB_DRIVER);
            driverLoaded = true;
            System.out.println("✓ MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("✗ Failed to load MySQL JDBC Driver: " + e.getMessage());
            driverLoaded = false;
        }
    }
    
    /**
     * Retrieves a fresh database connection for each request.
     * Creates a new connection instead of reusing a singleton connection.
     * This prevents thread contention and blocking issues.
     * 
     * @return New MySQL database connection
     * @throws SQLException if driver not loaded or connection fails
     */
    public static Connection getConnection() throws SQLException {
        if (!driverLoaded) {
            throw new SQLException("MySQL JDBC Driver not loaded");
        }
        
        try {
            // Create new connection for each request (not singleton)
            Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            conn.setAutoCommit(true);
            return conn;
        } catch (SQLException e) {
            System.err.println("✗ Failed to connect to database: " + e.getMessage());
            throw new SQLException("Failed to connect to database at " + DB_URL, e);
        }
    }
    
    /**
     * Close database connection
     * Should be called in try-with-resources or finally blocks
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Test database connection
     * @return true if connection is successful, false otherwise
     */
    public static boolean testConnection() {
        Connection testConn = null;
        try {
            testConn = getConnection();
            if (testConn != null && !testConn.isClosed()) {
                System.out.println("✓ Database connection test passed");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("✗ Database connection test failed: " + e.getMessage());
        } finally {
            closeConnection(testConn);
        }
        return false;
    }
}


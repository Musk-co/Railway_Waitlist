package com.waitlist.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Security Utility Class
 * Provides password hashing, validation, and security functions.
 * Uses SHA-256 encryption for secure password storage.
 */
public class SecurityUtil {
    
    /**
     * Hashes a plain text password using SHA-256 algorithm.
     * 
     * @param password The plain text password to hash
     * @return SHA-256 hashed password as hexadecimal string, or null if error occurs
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] messageDigest = md.digest(password.getBytes());
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }
    
    /**
     * Validate password (compare hashes)
     * @param plainPassword plain text password
     * @param hashedPassword hashed password from database
     * @return true if password is correct
     */
    public static boolean validatePassword(String plainPassword, String hashedPassword) {
        String hashedPlain = hashPassword(plainPassword);
        return hashedPlain != null && hashedPlain.equals(hashedPassword);
    }
    
    /**
     * Generate random token for session
     * @return random token
     */
    public static String generateToken() {
        return hashPassword(System.currentTimeMillis() + Math.random() + "");
    }
    
    /**
     * Validate email format
     * @param email email address
     * @return true if valid email format
     */
    public static boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return email.matches(emailRegex);
    }
    
    /**
     * Validate username (alphanumeric, 3-20 characters)
     * @param username username
     * @return true if valid
     */
    public static boolean isValidUsername(String username) {
        return username.matches("^[a-zA-Z0-9_]{3,20}$");
    }
    
    /**
     * Validate password strength (min 6 characters)
     * @param password password
     * @return true if strong enough
     */
    public static boolean isValidPassword(String password) {
        return password.length() >= 6;
    }
}

package com.waitlist.controller;

import com.waitlist.model.User;
import com.waitlist.dao.UserDAO;
import com.waitlist.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet for user registration
 */
public class RegisterServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private SecurityUtil securityUtil;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
        this.securityUtil = new SecurityUtil();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to registration page
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validate input
            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("error", "Username is required.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email is required.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Password is required.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Validate username format
            if (!securityUtil.isValidUsername(username)) {
                request.setAttribute("error", "Username must be 3-20 characters, alphanumeric only.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Validate email format
            if (!securityUtil.isValidEmail(email)) {
                request.setAttribute("error", "Please enter a valid email address.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Validate password strength
            if (!securityUtil.isValidPassword(password)) {
                request.setAttribute("error", "Password must be at least 6 characters.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Check if username already exists
            if (userDAO.usernameExists(username)) {
                request.setAttribute("error", "Username already exists. Please choose another.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            if (userDAO.emailExists(email)) {
                request.setAttribute("error", "Email already registered. Please use a different email or login.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPasswordHash(securityUtil.hashPassword(password));
            newUser.setRole("user");
            newUser.setActive(true);
            
            // Register user
            if (userDAO.registerUser(newUser)) {
                request.setAttribute("success", "Registration successful! Please login with your credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error in RegisterServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

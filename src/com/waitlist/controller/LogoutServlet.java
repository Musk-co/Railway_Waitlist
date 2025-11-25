package com.waitlist.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for user logout
 */
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                String username = (String) session.getAttribute("username");
                System.out.println("DEBUG - Logging out: " + username);
                session.invalidate();
            }
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            System.err.println("Error in LogoutServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }
}

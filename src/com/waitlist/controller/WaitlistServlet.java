package com.waitlist.controller;

import com.waitlist.model.Train;
import com.waitlist.model.User;
import com.waitlist.dao.WaitlistDAO;
import com.waitlist.dao.SearchHistoryDAO;
import com.waitlist.util.ProbabilityCalculator;
import com.waitlist.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Servlet controller for waitlist probability calculation
 */
public class WaitlistServlet extends HttpServlet {
    
    private WaitlistDAO waitlistDAO;
    private SearchHistoryDAO searchHistoryDAO;
    private ProbabilityCalculator probabilityCalculator;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.waitlistDAO = new WaitlistDAO();
        this.searchHistoryDAO = new SearchHistoryDAO();
        this.probabilityCalculator = new ProbabilityCalculator();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to index page for GET requests
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession(false);
            User user = null;
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
            
            if (user == null) {
                // Redirect to login if not authenticated
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Get form parameters
            String trainNo = request.getParameter("trainNo");
            String journeyDateStr = request.getParameter("journeyDate");
            String classType = request.getParameter("classType");
            String waitlistNumberStr = request.getParameter("waitlistNumber");
            
            // Validate input parameters
            if (trainNo == null || trainNo.trim().isEmpty() ||
                journeyDateStr == null || journeyDateStr.trim().isEmpty() ||
                classType == null || classType.trim().isEmpty() ||
                waitlistNumberStr == null || waitlistNumberStr.trim().isEmpty()) {
                
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Parse journey date (DD-MM-YYYY format)
            Date journeyDate;
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                journeyDate = sdf.parse(journeyDateStr);
            } catch (ParseException e) {
                request.setAttribute("error", "Invalid date format. Please use DD-MM-YYYY format (e.g., 15-01-2024).");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Parse waitlist number
            int waitlistNumber;
            try {
                waitlistNumber = Integer.parseInt(waitlistNumberStr);
                if (waitlistNumber < 0) {
                    throw new NumberFormatException("Waitlist number cannot be negative");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid waitlist number. Please enter a valid number.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Check if train exists
            Train train = waitlistDAO.getTrainByNumber(trainNo);
            if (train == null) {
                request.setAttribute("error", "Train number " + trainNo + " not found in database.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Calculate probability
            double probability = probabilityCalculator.calculateConfirmationProbability(
                trainNo, journeyDate, classType, waitlistNumber);
            
            // Save search to history (if logged in)
            if (user != null) {
                try {
                    searchHistoryDAO.saveSearch(
                        user.getUserId(),
                        trainNo,
                        journeyDateStr,
                        classType,
                        waitlistNumber,
                        probability
                    );
                    System.out.println("DEBUG - Search saved to history for user: " + user.getUsername());
                } catch (Exception e) {
                    System.err.println("Warning: Failed to save search history: " + e.getMessage());
                    // Don't fail the request if history saving fails
                }
            }
            
            // Get additional information
            String category = probabilityCalculator.getProbabilityCategory(probability);
            String recommendation = probabilityCalculator.getRecommendation(probability);
            
            // Set attributes for result page
            request.setAttribute("train", train);
            request.setAttribute("journeyDate", journeyDateStr);
            request.setAttribute("classType", classType);
            request.setAttribute("waitlistNumber", waitlistNumber);
            request.setAttribute("probability", String.format("%.2f", probability));
            request.setAttribute("category", category);
            request.setAttribute("recommendation", recommendation);
            
            // Forward to result page
            request.getRequestDispatcher("result.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error
            System.err.println("Error in WaitlistServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Set error message and forward to error page
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    @Override
    public void destroy() {
        super.destroy();
        // No need to close connections - they are closed per request
    }
}

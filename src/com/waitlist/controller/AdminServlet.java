package com.waitlist.controller;

import com.waitlist.model.User;
import com.waitlist.dao.UserDAO;
import com.waitlist.dao.WaitlistDAO;
import com.waitlist.model.Train;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for admin dashboard operations
 */
public class AdminServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private WaitlistDAO waitlistDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
        this.waitlistDAO = new WaitlistDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Check if user is admin
            HttpSession session = request.getSession(false);
            User user = null;
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
            
            if (user == null || !user.isAdmin()) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            String action = request.getParameter("action");
            if (action == null) {
                action = "dashboard";
            }
            
            switch (action) {
                case "users":
                    handleUserManagement(request, response);
                    break;
                case "trains":
                    handleTrainManagement(request, response);
                    break;
                case "stats":
                    handleStatistics(request, response);
                    break;
                default:
                    handleDashboard(request, response);
                    break;
            }
            
        } catch (Exception e) {
            System.err.println("Error in AdminServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            try {
                request.getRequestDispatcher("admin.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Check if user is admin
            HttpSession session = request.getSession(false);
            User user = null;
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
            
            if (user == null || !user.isAdmin()) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            String action = request.getParameter("action");
            if (action == null) {
                action = "dashboard";
            }
            
            switch (action) {
                case "deactivate_user":
                    handleDeactivateUser(request, response);
                    break;
                case "promote_user":
                    handlePromoteUser(request, response);
                    break;
                case "demote_user":
                    handleDemoteUser(request, response);
                    break;
                case "add_train":
                    handleAddTrain(request, response);
                    break;
                case "update_train":
                    handleUpdateTrain(request, response);
                    break;
                case "delete_train":
                    handleDeleteTrain(request, response);
                    break;
                default:
                    response.sendRedirect("admin.jsp?action=dashboard");
                    break;
            }
            
        } catch (Exception e) {
            System.err.println("Error in AdminServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            try {
                request.getRequestDispatcher("admin.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            long totalUsers = userDAO.getTotalUsers();
            long totalTrains = waitlistDAO.getTotalTrains();
            double avgProbability = waitlistDAO.getAverageProbability();
            
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalTrains", totalTrains);
            request.setAttribute("avgProbability", String.format("%.2f", avgProbability));
            request.setAttribute("action", "dashboard");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error fetching dashboard data: " + e.getMessage());
            request.setAttribute("error", "Failed to load dashboard");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        }
    }
    
    private void handleUserManagement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.setAttribute("action", "users");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error fetching users: " + e.getMessage());
            request.setAttribute("error", "Failed to load users");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        }
    }
    
    private void handleTrainManagement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String searchQuery = request.getParameter("search");
            List<Train> trains;
            
            System.out.println("✓ DEBUG: handleTrainManagement - Search parameter: " + searchQuery);
            
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                trains = waitlistDAO.searchTrains(searchQuery.trim());
                request.setAttribute("searchQuery", searchQuery.trim());
                System.out.println("✓ DEBUG: Search query found - Results: " + trains.size() + " trains");
            } else {
                trains = waitlistDAO.getAllTrains();
                System.out.println("✓ DEBUG: No search query - Fetching all trains: " + trains.size() + " trains");
            }
            
            request.setAttribute("trains", trains);
            request.setAttribute("action", "trains");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error fetching trains: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to load trains");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        }
    }
    
    private void handleStatistics(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            long totalUsers = userDAO.getTotalUsers();
            long totalTrains = waitlistDAO.getTotalTrains();
            double avgProbability = waitlistDAO.getAverageProbability();
            
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalTrains", totalTrains);
            request.setAttribute("avgProbability", String.format("%.2f", avgProbability));
            request.setAttribute("action", "stats");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error fetching statistics: " + e.getMessage());
            request.setAttribute("error", "Failed to load statistics");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        }
    }
    
    private void handleDeactivateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null && !userIdStr.isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                userDAO.deactivateUser(userId);
                response.sendRedirect("AdminServlet?action=users");
            } else {
                response.sendRedirect("AdminServlet?action=users");
            }
        } catch (Exception e) {
            System.err.println("Error deactivating user: " + e.getMessage());
            response.sendRedirect("AdminServlet?action=users");
        }
    }
    
    private void handlePromoteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null && !userIdStr.isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                userDAO.updateUserRole(userId, "admin");
                response.sendRedirect("AdminServlet?action=users");
            } else {
                response.sendRedirect("AdminServlet?action=users");
            }
        } catch (Exception e) {
            System.err.println("Error promoting user: " + e.getMessage());
            response.sendRedirect("AdminServlet?action=users");
        }
    }
    
    private void handleDemoteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null && !userIdStr.isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                userDAO.updateUserRole(userId, "user");
                response.sendRedirect("AdminServlet?action=users");
            } else {
                response.sendRedirect("AdminServlet?action=users");
            }
        } catch (Exception e) {
            System.err.println("Error demoting user: " + e.getMessage());
            response.sendRedirect("AdminServlet?action=users");
        }
    }
    
    private void handleAddTrain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String trainNo = request.getParameter("trainNo");
            String trainName = request.getParameter("trainName");
            String source = request.getParameter("source");
            String destination = request.getParameter("destination");
            
            if (trainNo != null && !trainNo.trim().isEmpty() &&
                trainName != null && !trainName.trim().isEmpty() &&
                source != null && !source.trim().isEmpty() &&
                destination != null && !destination.trim().isEmpty()) {
                
                boolean success = waitlistDAO.addTrain(trainNo.trim(), trainName.trim(), source.trim(), destination.trim());
                
                if (success) {
                    System.out.println("✓ DEBUG: Train added successfully - Train No: " + trainNo);
                    response.sendRedirect("AdminServlet?action=trains&message=Train%20added%20successfully!");
                } else {
                    System.out.println("✗ DEBUG: Failed to add train - Train No: " + trainNo);
                    response.sendRedirect("AdminServlet?action=trains&error=Failed%20to%20add%20train.%20Train%20number%20may%20already%20exist.");
                }
            } else {
                System.out.println("✗ DEBUG: Missing required fields for train addition");
                response.sendRedirect("AdminServlet?action=trains&error=All%20fields%20are%20required.");
            }
        } catch (Exception e) {
            System.err.println("Error adding train: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("AdminServlet?action=trains&error=An%20error%20occurred%20while%20adding%20the%20train.");
        }
    }
    
    private void handleDeleteTrain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String trainNo = request.getParameter("trainNo");
            
            if (trainNo != null && !trainNo.trim().isEmpty()) {
                boolean success = waitlistDAO.deleteTrain(trainNo.trim());
                
                if (success) {
                    System.out.println("✓ DEBUG: Train deleted successfully - Train No: " + trainNo);
                    response.sendRedirect("AdminServlet?action=trains&message=Train%20deleted%20successfully!");
                } else {
                    System.out.println("✗ DEBUG: Failed to delete train - Train No: " + trainNo);
                    response.sendRedirect("AdminServlet?action=trains&error=Failed%20to%20delete%20train.");
                }
            } else {
                System.out.println("✗ DEBUG: Missing train number for deletion");
                response.sendRedirect("AdminServlet?action=trains&error=Train%20number%20is%20required.");
            }
        } catch (Exception e) {
            System.err.println("Error deleting train: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("AdminServlet?action=trains&error=An%20error%20occurred%20while%20deleting%20the%20train.");
        }
    }
    
    private void handleUpdateTrain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String trainNo = request.getParameter("trainNo");
            String trainName = request.getParameter("trainName");
            String source = request.getParameter("source");
            String destination = request.getParameter("destination");
            
            if (trainNo != null && !trainNo.trim().isEmpty() &&
                trainName != null && !trainName.trim().isEmpty() &&
                source != null && !source.trim().isEmpty() &&
                destination != null && !destination.trim().isEmpty()) {
                
                boolean success = waitlistDAO.updateTrain(trainNo.trim(), trainName.trim(), source.trim(), destination.trim());
                
                if (success) {
                    System.out.println("✓ DEBUG: Train updated successfully - Train No: " + trainNo);
                    response.sendRedirect("AdminServlet?action=trains&message=Train%20updated%20successfully!");
                } else {
                    System.out.println("✗ DEBUG: Failed to update train - Train No: " + trainNo);
                    response.sendRedirect("AdminServlet?action=trains&error=Failed%20to%20update%20train.");
                }
            } else {
                System.out.println("✗ DEBUG: Missing required fields for train update");
                response.sendRedirect("AdminServlet?action=trains&error=All%20fields%20are%20required.");
            }
        } catch (Exception e) {
            System.err.println("Error updating train: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("AdminServlet?action=trains&error=An%20error%20occurred%20while%20updating%20the%20train.");
        }
    }
}

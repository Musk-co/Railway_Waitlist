package com.waitlist.dao;

import com.waitlist.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * SearchHistoryDAO - Data Access Object for Search History Operations
 * Manages search history records, user search tracking, and statistical analysis.
 * Provides methods for saving searches, retrieving user history, and generating analytics reports.
 */
public class SearchHistoryDAO {
    
    /**
     * Saves a probability calculation search to the user's search history.
     * This creates an audit trail of all probability calculations performed by users.
     * 
     * @param userId The user ID performing the search
     * @param trainNo The train number being searched
     * @param journeyDate The journey date (format: dd-MM-yyyy)
     * @param classType The class type (e.g., "1AC", "2AC", "3AC", "Sleeper")
     * @param waitlistNumber The waitlist position used in calculation
     * @param probability The calculated confirmation probability
     * @return True if the search was successfully saved, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean saveSearch(int userId, String trainNo, String journeyDate, 
                             String classType, int waitlistNumber, double probability) {
        String query = "INSERT INTO search_history (user_id, train_no, journey_date, class_type, waitlist_number, probability) " +
                      "VALUES (?, ?, STR_TO_DATE(?, '%d-%m-%Y'), ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            ps.setString(2, trainNo);
            ps.setString(3, journeyDate);
            ps.setString(4, classType);
            ps.setInt(5, waitlistNumber);
            ps.setDouble(6, probability);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error saving search history: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Retrieves a user's search history with train details.
     * Joins with train information to provide complete context for each search.
     * 
     * @param userId The user ID to retrieve history for
     * @param limit The maximum number of recent searches to retrieve
     * @return List of search records as maps containing all search and train details
     * @throws SQLException if database operation fails (caught internally)
     */
    public List<Map<String, Object>> getUserSearchHistory(int userId, int limit) {
        List<Map<String, Object>> history = new ArrayList<>();
        String query = "SELECT s.*, t.train_name, t.source, t.destination " +
                      "FROM search_history s " +
                      "JOIN train_info t ON s.train_no = t.train_no " +
                      "WHERE s.user_id = ? " +
                      "ORDER BY s.searched_at DESC LIMIT ?";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, userId);
                ps.setInt(2, limit);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    Map<String, Object> search = new HashMap<>();
                    search.put("search_id", rs.getInt("search_id"));
                    search.put("train_no", rs.getString("train_no"));
                    search.put("train_name", rs.getString("train_name"));
                    search.put("source", rs.getString("source"));
                    search.put("destination", rs.getString("destination"));
                    search.put("journey_date", rs.getDate("journey_date"));
                    search.put("class_type", rs.getString("class_type"));
                    search.put("waitlist_number", rs.getInt("waitlist_number"));
                    search.put("probability", rs.getDouble("probability"));
                    search.put("searched_at", rs.getTimestamp("searched_at"));
                    
                    history.add(search);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving user search history: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        
        return history;
    }
    
    /**
     * Calculates average probability statistics for each train searched by a user.
     * Helps understand user's search patterns and most frequently searched trains.
     * 
     * @param userId The user ID to calculate statistics for
     * @return Map of train numbers to their average confirmation probabilities
     * @throws SQLException if database operation fails (caught internally)
     */
    public Map<String, Double> getUserTrainStats(int userId) {
        Map<String, Double> stats = new HashMap<>();
        String query = "SELECT train_no, AVG(probability) as avg_probability, COUNT(*) as search_count " +
                      "FROM search_history " +
                      "WHERE user_id = ? " +
                      "GROUP BY train_no";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                String trainNo = rs.getString("train_no");
                double avgProb = rs.getDouble("avg_probability");
                stats.put(trainNo, avgProb);
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating user train statistics: " + e.getMessage());
        }
        
        return stats;
    }
    
    /**
     * Retrieves system-wide statistical information from search history.
     * Provides overview metrics for the admin dashboard.
     * 
     * @return Map containing: total_users, total_searches, avg_probability, max_probability, min_probability
     * @throws SQLException if database operation fails (caught internally)
     */
    public Map<String, Object> getGlobalStatistics() {
        Map<String, Object> stats = new HashMap<>();
        String query = "SELECT " +
                      "COUNT(DISTINCT user_id) as total_users, " +
                      "COUNT(*) as total_searches, " +
                      "AVG(probability) as avg_probability, " +
                      "MAX(probability) as max_probability, " +
                      "MIN(probability) as min_probability " +
                      "FROM search_history";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            ResultSet rs = stmt.executeQuery(query);
            
            if (rs.next()) {
                stats.put("total_users", rs.getInt("total_users"));
                stats.put("total_searches", rs.getInt("total_searches"));
                stats.put("avg_probability", rs.getDouble("avg_probability"));
                stats.put("max_probability", rs.getDouble("max_probability"));
                stats.put("min_probability", rs.getDouble("min_probability"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving global statistics: " + e.getMessage());
        }
        
        return stats;
    }
    
    /**
     * Analyzes performance statistics for each train based on search history.
     * Includes search frequency and probability distribution metrics.
     * 
     * @return List of train statistics ordered by search frequency (highest first)
     * @throws SQLException if database operation fails (caught internally)
     */
    public List<Map<String, Object>> getTrainPerformanceStats() {
        List<Map<String, Object>> stats = new ArrayList<>();
        String query = "SELECT t.train_no, t.train_name, t.source, t.destination, " +
                      "COUNT(s.search_id) as search_count, " +
                      "AVG(s.probability) as avg_probability, " +
                      "MAX(s.probability) as max_probability, " +
                      "MIN(s.probability) as min_probability " +
                      "FROM train_info t " +
                      "LEFT JOIN search_history s ON t.train_no = s.train_no " +
                      "GROUP BY t.train_no " +
                      "ORDER BY search_count DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            ResultSet rs = stmt.executeQuery(query);
            
            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("train_no", rs.getString("train_no"));
                stat.put("train_name", rs.getString("train_name"));
                stat.put("source", rs.getString("source"));
                stat.put("destination", rs.getString("destination"));
                stat.put("search_count", rs.getInt("search_count"));
                stat.put("avg_probability", rs.getDouble("avg_probability"));
                stat.put("max_probability", rs.getDouble("max_probability"));
                stat.put("min_probability", rs.getDouble("min_probability"));
                
                stats.add(stat);
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving train performance statistics: " + e.getMessage());
        }
        
        return stats;
    }
    
    /**
     * Gets the total count of searches performed in the system.
     * 
     * @return Total number of probability searches recorded
     * @throws SQLException if database operation fails (caught internally)
     */
    public long getTotalSearches() {
        String query = "SELECT COUNT(*) as total FROM search_history";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong("total");
            }
            return 0;
            
        } catch (SQLException e) {
            System.err.println("Error retrieving total search count: " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Calculates the average probability value across all recorded searches.
     * 
     * @return Average confirmation probability, or 0.0 if no data available
     * @throws SQLException if database operation fails (caught internally)
     */
    public double getAverageProbability() {
        String query = "SELECT AVG(probability) as avg_prob FROM search_history";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("avg_prob");
            }
            return 0.0;
            
        } catch (SQLException e) {
            System.err.println("Error calculating average probability: " + e.getMessage());
            return 0.0;
        }
    }
}

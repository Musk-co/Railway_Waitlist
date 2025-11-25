package com.waitlist.dao;

import com.waitlist.model.Train;
import com.waitlist.model.BookingHistory;
import com.waitlist.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

/**
 * WaitlistDAO - Data Access Object for Waitlist Operations
 * Handles all database operations related to trains, booking history, and probability calculations.
 * Provides methods for retrieving, adding, updating, and deleting train information,
 * as well as analyzing booking history and confirmation rates.
 */
public class WaitlistDAO {
    
    /**
     * Retrieves train information by train number.
     * 
     * @param trainNo The unique train number to search for
     * @return Train object containing train details, or null if not found
     * @throws SQLException if database operation fails (caught internally)
     */
    public Train getTrainByNumber(String trainNo) {
        Train train = null;
        String query = "SELECT * FROM train_info WHERE train_no = ?";
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return null;
            }
            
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, trainNo);
                
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    train = new Train(
                        rs.getString("train_no"),
                        rs.getString("train_name"),
                        rs.getString("source"),
                        rs.getString("destination")
                    );
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving train information: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        
        return train;
    }
    
    /**
     * Retrieves booking history for a specific train, date, and class.
     * Analyzes historical data to understand waitlist to confirmation patterns.
     * 
     * @param trainNo The train number to retrieve history for
     * @param journeyDate The journey date for which to retrieve history
     * @param classType The class type (e.g., "1AC", "2AC", "3AC", "Sleeper")
     * @return List of BookingHistory records matching the criteria
     * @throws SQLException if database operation fails (caught internally)
     */
    public List<BookingHistory> getBookingHistory(String trainNo, Date journeyDate, String classType) {
        List<BookingHistory> historyList = new ArrayList<>();
        String query = "SELECT * FROM booking_history WHERE train_no = ? AND journey_date = ? AND class_type = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, trainNo);
            ps.setDate(2, new java.sql.Date(journeyDate.getTime()));
            ps.setString(3, classType);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BookingHistory history = new BookingHistory(
                    rs.getInt("id"),
                    rs.getString("train_no"),
                    rs.getDate("journey_date"),
                    rs.getString("class_type"),
                    rs.getInt("total_wl"),
                    rs.getInt("confirmed_tickets")
                );
                historyList.add(history);
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving booking history: " + e.getMessage());
        }
        
        return historyList;
    }
    
    /**
     * Calculates the average confirmation rate for a specific train on a specific date and class.
     * The confirmation rate is calculated as: confirmed_tickets / total_waitlist
     * A rate closer to 1.0 indicates higher chances of confirmation.
     * 
     * @param trainNo The train number
     * @param journeyDate The journey date
     * @param classType The class type (e.g., "1AC", "2AC", "3AC", "Sleeper")
     * @return Average confirmation rate between 0.0 and 1.0, or 0.0 if no data available
     * @throws SQLException if database operation fails (caught internally)
     */
    public double getAverageConfirmationRate(String trainNo, Date journeyDate, String classType) {
        String query = "SELECT AVG(confirmed_tickets * 1.0 / total_wl) as avg_rate " +
                      "FROM booking_history " +
                      "WHERE train_no = ? AND DATE(journey_date) = DATE(?) AND class_type = ? " +
                      "AND total_wl > 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, trainNo);
            ps.setDate(2, new java.sql.Date(journeyDate.getTime()));
            ps.setString(3, classType);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                double avgRate = rs.getDouble("avg_rate");
                return Double.isNaN(avgRate) ? 0.0 : avgRate;
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating average confirmation rate: " + e.getMessage());
        }
        
        return 0.0;
    }
    
    /**
     * Retrieves historical confirmation rate based on similar dates.
     * This is useful for dates with limited booking history by using patterns
     * from same day of week and month combinations.
     * 
     * @param trainNo The train number
     * @param classType The class type
     * @param dayOfWeek Day of week (1=Sunday, 7=Saturday)
     * @param month Month number (1-12)
     * @return Average confirmation rate from similar historical dates, or 0.0 if unavailable
     * @throws SQLException if database operation fails (caught internally)
     */
    public double getHistoricalConfirmationRate(String trainNo, String classType, int dayOfWeek, int month) {
        String query = "SELECT AVG(confirmed_tickets * 1.0 / total_wl) as avg_rate " +
                      "FROM booking_history " +
                      "WHERE train_no = ? AND class_type = ? " +
                      "AND DAYOFWEEK(journey_date) = ? AND MONTH(journey_date) = ? " +
                      "AND total_wl > 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, trainNo);
            ps.setString(2, classType);
            ps.setInt(3, dayOfWeek);
            ps.setInt(4, month);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                double avgRate = rs.getDouble("avg_rate");
                return Double.isNaN(avgRate) ? 0.0 : avgRate;
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving historical confirmation rate: " + e.getMessage());
        }
        
        return 0.0;
    }
    
    /**
     * Adds a new booking history record to the database.
     * 
     * @param history The BookingHistory object containing the record details
     * @return True if the record was successfully added, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean addBookingHistory(BookingHistory history) {
        String query = "INSERT INTO booking_history (train_no, journey_date, class_type, total_wl, confirmed_tickets) " +
                      "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, history.getTrainNo());
            ps.setDate(2, new java.sql.Date(history.getJourneyDate().getTime()));
            ps.setString(3, history.getClassType());
            ps.setInt(4, history.getTotalWl());
            ps.setInt(5, history.getConfirmedTickets());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding booking history record: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Retrieves all trains from the database.
     * 
     * @return List of all Train objects ordered by train number
     * @throws SQLException if database operation fails (caught internally)
     */
    public List<Train> getAllTrains() {
        List<Train> trains = new ArrayList<>();
        String query = "SELECT * FROM train_info ORDER BY train_no";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Train train = new Train(
                    rs.getString("train_no"),
                    rs.getString("train_name"),
                    rs.getString("source"),
                    rs.getString("destination")
                );
                trains.add(train);
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving all trains: " + e.getMessage());
        }
        
        return trains;
    }
    
    /**
     * Gets the total count of trains in the database.
     * 
     * @return Total number of trains
     * @throws SQLException if database operation fails (caught internally)
     */
    public long getTotalTrains() {
        String query = "SELECT COUNT(*) as total FROM train_info";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong("total");
            }
            return 0;
            
        } catch (SQLException e) {
            System.err.println("Error retrieving total train count: " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Adds a new train to the database.
     * 
     * @param trainNo The unique train number/identifier
     * @param trainName The name of the train
     * @param source The origin station
     * @param destination The destination station
     * @return True if the train was successfully added, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean addTrain(String trainNo, String trainName, String source, String destination) {
        String query = "INSERT INTO train_info (train_no, train_name, source, destination) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, trainNo);
            ps.setString(2, trainName);
            ps.setString(3, source);
            ps.setString(4, destination);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding train: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Deletes a train from the database.
     * 
     * @param trainNo The train number to delete
     * @return True if the train was successfully deleted, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean deleteTrain(String trainNo) {
        String query = "DELETE FROM train_info WHERE train_no = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, trainNo);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting train: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Updates an existing train's information.
     * 
     * @param trainNo The train number of the train to update
     * @param trainName The new train name
     * @param source The new source station
     * @param destination The new destination station
     * @return True if the train was successfully updated, false otherwise
     * @throws SQLException if database operation fails (caught internally)
     */
    public boolean updateTrain(String trainNo, String trainName, String source, String destination) {
        String query = "UPDATE train_info SET train_name = ?, source = ?, destination = ? WHERE train_no = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, trainName);
            ps.setString(2, source);
            ps.setString(3, destination);
            ps.setString(4, trainNo);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating train information: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Searches for trains by matching multiple fields.
     * Searches across train number, train name, source, and destination fields.
     * 
     * @param searchQuery The search keyword/phrase
     * @return List of Train objects matching the search criteria
     * @throws SQLException if database operation fails (caught internally)
     */
    public List<Train> searchTrains(String searchQuery) {
        List<Train> trains = new ArrayList<>();
        String query = "SELECT * FROM train_info WHERE train_no LIKE ? OR train_name LIKE ? OR source LIKE ? OR destination LIKE ? ORDER BY train_no";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            String likeQuery = "%" + searchQuery + "%";
            ps.setString(1, likeQuery);
            ps.setString(2, likeQuery);
            ps.setString(3, likeQuery);
            ps.setString(4, likeQuery);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Train train = new Train(
                    rs.getString("train_no"),
                    rs.getString("train_name"),
                    rs.getString("source"),
                    rs.getString("destination")
                );
                trains.add(train);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching trains: " + e.getMessage());
        }
        
        return trains;
    }
    
    /**
     * Calculates the average probability from all search history records.
     * This provides an overall average of the confirmation probabilities calculated.
     * 
     * @return Average probability value, or 0.0 if no data available
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


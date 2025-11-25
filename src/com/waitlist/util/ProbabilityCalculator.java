package com.waitlist.util;

import com.waitlist.dao.WaitlistDAO;
import java.util.Calendar;
import java.util.Date;

/**
 * Probability Calculation Engine
 * Calculates the confirmation probability for railway tickets based on
 * historical booking data, current waitlist position, and seasonal factors.
 * Uses weighted algorithms to provide accurate probability predictions.
 */
public class ProbabilityCalculator {
    
    private WaitlistDAO waitlistDAO;
    
    /**
     * Default constructor initializes the WaitlistDAO.
     */
    public ProbabilityCalculator() {
        this.waitlistDAO = new WaitlistDAO();
    }
    
    /**
     * Calculates the confirmation probability for a ticket on a specific train.
     * Combines specific date data, historical trends, waitlist position, and seasonal factors.
     * 
     * @param trainNo The train number
     * @param journeyDate The journey date
     * @param classType The travel class (e.g., "1AC", "2AC")
     * @param waitlistNumber Current position in waitlist
     * @return Probability as percentage (0-100)
     */
    public double calculateConfirmationProbability(String trainNo, Date journeyDate, 
                                                 String classType, int waitlistNumber) {
        try {
            // Get specific date confirmation rate
            double specificDateRate = waitlistDAO.getAverageConfirmationRate(trainNo, journeyDate, classType);
            
            // Get historical data for similar dates
            Calendar cal = Calendar.getInstance();
            cal.setTime(journeyDate);
            int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
            int month = cal.get(Calendar.MONTH) + 1; // Calendar months are 0-based
            
            double historicalRate = waitlistDAO.getHistoricalConfirmationRate(trainNo, classType, dayOfWeek, month);
            
            // Calculate base probability using weighted average
            double baseProbability = calculateWeightedAverage(specificDateRate, historicalRate);
            
            // Apply waitlist number factor
            double waitlistFactor = calculateWaitlistFactor(waitlistNumber);
            
            // Apply seasonal factors
            double seasonalFactor = calculateSeasonalFactor(month);
            
            // Calculate final probability
            double finalProbability = baseProbability * waitlistFactor * seasonalFactor;
            
            // Ensure probability is between 0 and 1
            finalProbability = Math.max(0.0, Math.min(1.0, finalProbability));
            
            return finalProbability * 100; // Convert to percentage
            
        } catch (Exception e) {
            System.err.println("Error calculating probability: " + e.getMessage());
            return 0.0;
        }
    }
    
    /**
     * Calculate weighted average between specific and historical data
     * @param specificRate specific date rate
     * @param historicalRate historical rate
     * @return weighted average
     */
    private double calculateWeightedAverage(double specificRate, double historicalRate) {
        // If we have specific data, weight it more heavily
        if (specificRate > 0) {
            return (specificRate * 0.7) + (historicalRate * 0.3);
        } else {
            // If no specific data, use historical data
            return historicalRate > 0 ? historicalRate : 0.3; // Default 30% if no data
        }
    }
    
    /**
     * Calculate waitlist number factor
     * @param waitlistNumber current waitlist number
     * @return factor (0.0 to 1.0)
     */
    private double calculateWaitlistFactor(int waitlistNumber) {
        if (waitlistNumber <= 0) {
            return 1.0; // No waitlist
        } else if (waitlistNumber <= 5) {
            return 0.9; // High probability
        } else if (waitlistNumber <= 10) {
            return 0.7; // Good probability
        } else if (waitlistNumber <= 20) {
            return 0.5; // Moderate probability
        } else if (waitlistNumber <= 50) {
            return 0.3; // Low probability
        } else {
            return 0.1; // Very low probability
        }
    }
    
    /**
     * Calculate seasonal factor based on month
     * @param month month (1-12)
     * @return seasonal factor
     */
    private double calculateSeasonalFactor(int month) {
        // Peak travel seasons
        if (month == 4 || month == 5 || month == 10 || month == 11) {
            return 0.8; // Peak season - lower probability
        } else if (month == 6 || month == 7 || month == 8) {
            return 0.9; // Summer - moderate probability
        } else if (month == 12 || month == 1) {
            return 0.7; // Holiday season - lower probability
        } else {
            return 1.0; // Normal season
        }
    }
    
    /**
     * Get probability category based on percentage
     * @param probability probability percentage
     * @return category string
     */
    public String getProbabilityCategory(double probability) {
        if (probability >= 80) {
            return "Very High";
        } else if (probability >= 60) {
            return "High";
        } else if (probability >= 40) {
            return "Moderate";
        } else if (probability >= 20) {
            return "Low";
        } else {
            return "Very Low";
        }
    }
    
    /**
     * Get recommendation based on probability
     * @param probability probability percentage
     * @return recommendation string
     */
    public String getRecommendation(double probability) {
        if (probability >= 70) {
            return "Book with confidence. High chance of confirmation.";
        } else if (probability >= 50) {
            return "Consider booking. Moderate chance of confirmation.";
        } else if (probability >= 30) {
            return "Book with caution. Consider alternative options.";
        } else {
            return "Not recommended. Very low chance of confirmation.";
        }
    }
}


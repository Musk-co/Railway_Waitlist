package com.waitlist.model;

import java.util.Date;

/**
 * BookingHistory Model Class
 * Represents historical booking data for a train on a specific journey date.
 * Used to analyze waitlist statistics and probability calculations for future bookings.
 */
public class BookingHistory {
    private int id;
    private String trainNo;
    private Date journeyDate;
    private String classType;
    private int totalWl;
    private int confirmedTickets;
    
    /**
     * Default constructor for creating BookingHistory objects.
     */
    public BookingHistory() {}
    
    /**
     * Constructor with all booking history details.
     * 
     * @param id Unique booking history record identifier
     * @param trainNo Train number for this booking record
     * @param journeyDate Date of the journey
     * @param classType Class of travel (e.g., "1AC", "2AC", "3AC", "Sleeper")
     * @param totalWl Total number of waitlist entries
     * @param confirmedTickets Number of tickets confirmed from the waitlist
     */
    public BookingHistory(int id, String trainNo, Date journeyDate, String classType, 
                         int totalWl, int confirmedTickets) {
        this.id = id;
        this.trainNo = trainNo;
        this.journeyDate = journeyDate;
        this.classType = classType;
        this.totalWl = totalWl;
        this.confirmedTickets = confirmedTickets;
    }
    
    /**
     * Gets the booking history record ID.
     * 
     * @return Unique record identifier
     */
    public int getId() {
        return id;
    }
    
    /**
     * Sets the booking history record ID.
     * 
     * @param id Unique record identifier
     */
    public void setId(int id) {
        this.id = id;
    }
    
    /**
     * Gets the train number.
     * 
     * @return Train number for this booking record
     */
    public String getTrainNo() {
        return trainNo;
    }
    
    /**
     * Sets the train number.
     * 
     * @param trainNo Train number for this booking record
     */
    public void setTrainNo(String trainNo) {
        this.trainNo = trainNo;
    }
    
    /**
     * Gets the journey date.
     * 
     * @return Date of the journey
     */
    public Date getJourneyDate() {
        return journeyDate;
    }
    
    /**
     * Sets the journey date.
     * 
     * @param journeyDate Date of the journey
     */
    public void setJourneyDate(Date journeyDate) {
        this.journeyDate = journeyDate;
    }
    
    /**
     * Gets the class type.
     * 
     * @return Class of travel (e.g., "1AC", "2AC", "3AC", "Sleeper")
     */
    public String getClassType() {
        return classType;
    }
    
    /**
     * Sets the class type.
     * 
     * @param classType Class of travel (e.g., "1AC", "2AC", "3AC", "Sleeper")
     */
    public void setClassType(String classType) {
        this.classType = classType;
    }
    
    /**
     * Gets the total waitlist count.
     * 
     * @return Total number of waitlist entries for this journey
     */
    public int getTotalWl() {
        return totalWl;
    }
    
    /**
     * Sets the total waitlist count.
     * 
     * @param totalWl Total number of waitlist entries for this journey
     */
    public void setTotalWl(int totalWl) {
        this.totalWl = totalWl;
    }
    
    /**
     * Gets the number of confirmed tickets.
     * 
     * @return Number of tickets confirmed from the waitlist
     */
    public int getConfirmedTickets() {
        return confirmedTickets;
    }
    
    /**
     * Sets the number of confirmed tickets.
     * 
     * @param confirmedTickets Number of tickets confirmed from the waitlist
     */
    public void setConfirmedTickets(int confirmedTickets) {
        this.confirmedTickets = confirmedTickets;
    }
    
    /**
     * Returns a string representation of the BookingHistory object.
     * 
     * @return String representation with booking history details
     */
    @Override
    public String toString() {
        return "BookingHistory{" +
                "id=" + id +
                ", trainNo='" + trainNo + '\'' +
                ", journeyDate=" + journeyDate +
                ", classType='" + classType + '\'' +
                ", totalWl=" + totalWl +
                ", confirmedTickets=" + confirmedTickets +
                '}';
    }
}


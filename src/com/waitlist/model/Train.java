package com.waitlist.model;

/**
 * Train Model Class
 * Represents a train with its details: number, name, source, and destination.
 * Used throughout the application to transfer train data between layers.
 */
public class Train {
    private String trainNo;
    private String trainName;
    private String source;
    private String destination;
    
    /**
     * Default constructor for creating Train objects.
     */
    public Train() {}
    
    /**
     * Constructor with all train details.
     * 
     * @param trainNo Unique train number/identifier
     * @param trainName Name of the train
     * @param source Origin station
     * @param destination Destination station
     */
    public Train(String trainNo, String trainName, String source, String destination) {
        this.trainNo = trainNo;
        this.trainName = trainName;
        this.source = source;
        this.destination = destination;
    }
    
    /**
     * Gets the train number.
     * 
     * @return Train number/identifier
     */
    public String getTrainNo() {
        return trainNo;
    }
    
    /**
     * Sets the train number.
     * 
     * @param trainNo Unique train number/identifier
     */
    public void setTrainNo(String trainNo) {
        this.trainNo = trainNo;
    }
    
    /**
     * Gets the train name.
     * 
     * @return Train name
     */
    public String getTrainName() {
        return trainName;
    }
    
    /**
     * Sets the train name.
     * 
     * @param trainName Name of the train
     */
    public void setTrainName(String trainName) {
        this.trainName = trainName;
    }
    
    /**
     * Gets the source station.
     * 
     * @return Origin station
     */
    public String getSource() {
        return source;
    }
    
    /**
     * Sets the source station.
     * 
     * @param source Origin station
     */
    public void setSource(String source) {
        this.source = source;
    }
    
    /**
     * Gets the destination station.
     * 
     * @return Destination station
     */
    public String getDestination() {
        return destination;
    }
    
    /**
     * Sets the destination station.
     * 
     * @param destination Destination station
     */
    public void setDestination(String destination) {
        this.destination = destination;
    }
    
    @Override
    public String toString() {
        return "Train{" +
                "trainNo='" + trainNo + '\'' +
                ", trainName='" + trainName + '\'' +
                ", source='" + source + '\'' +
                ", destination='" + destination + '\'' +
                '}';
    }
}


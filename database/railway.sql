-- Railway Waitlist Probability Calculator Database Schema
-- Database: railwaydb

-- Create database
CREATE DATABASE IF NOT EXISTS railwaydb;
USE railwaydb;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS search_history;
DROP TABLE IF EXISTS booking_history;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS train_info;

-- Create users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(10) DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- Create train_info table
CREATE TABLE train_info (
    train_no VARCHAR(10) PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create booking_history table
CREATE TABLE booking_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    train_no VARCHAR(10) NOT NULL,
    journey_date DATE NOT NULL,
    class_type VARCHAR(10) NOT NULL,
    total_wl INT NOT NULL DEFAULT 0,
    confirmed_tickets INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (train_no) REFERENCES train_info(train_no) ON DELETE CASCADE,
    INDEX idx_train_date_class (train_no, journey_date, class_type),
    INDEX idx_journey_date (journey_date)
);

-- Create search_history table
CREATE TABLE search_history (
    search_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    train_no VARCHAR(10) NOT NULL,
    journey_date DATE NOT NULL,
    class_type VARCHAR(10) NOT NULL,
    waitlist_number INT NOT NULL,
    probability DECIMAL(5,2),
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (train_no) REFERENCES train_info(train_no) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_searched_at (searched_at)
);

-- Insert sample train data
INSERT INTO train_info (train_no, train_name, source, destination) VALUES
('12345', 'Rajdhani Express', 'New Delhi', 'Mumbai Central'),
('12346', 'Rajdhani Express', 'Mumbai Central', 'New Delhi'),
('12627', 'Karnataka Express', 'New Delhi', 'Bangalore'),
('12628', 'Karnataka Express', 'Bangalore', 'New Delhi'),
('12951', 'Mumbai Rajdhani', 'New Delhi', 'Mumbai Central'),
('12952', 'Mumbai Rajdhani', 'Mumbai Central', 'New Delhi'),
('12615', 'Grand Trunk Express', 'Chennai Central', 'New Delhi'),
('12616', 'Grand Trunk Express', 'New Delhi', 'Chennai Central'),
('12649', 'Shatabdi Express', 'New Delhi', 'Chandigarh'),
('12650', 'Shatabdi Express', 'Chandigarh', 'New Delhi');

-- Insert comprehensive sample booking history data (6 months of data for better predictions)
INSERT INTO booking_history (train_no, journey_date, class_type, total_wl, confirmed_tickets) VALUES
-- Rajdhani Express (12345) - AC1 - January 2024
('12345', '2024-01-15', 'AC1', 10, 8),
('12345', '2024-01-16', 'AC1', 12, 10),
('12345', '2024-01-17', 'AC1', 8, 6),
('12345', '2024-01-18', 'AC1', 15, 12),
('12345', '2024-01-19', 'AC1', 9, 7),
-- January 2024 - SL
('12345', '2024-01-15', 'SL', 50, 40),
('12345', '2024-01-16', 'SL', 60, 45),
('12345', '2024-01-17', 'SL', 40, 35),
('12345', '2024-01-18', 'SL', 70, 55),
('12345', '2024-01-19', 'SL', 45, 38),

-- Rajdhani Express (12345) - February 2024 - AC1
('12345', '2024-02-10', 'AC1', 11, 9),
('12345', '2024-02-11', 'AC1', 13, 11),
('12345', '2024-02-12', 'AC1', 9, 7),
('12345', '2024-02-14', 'AC1', 16, 13),
('12345', '2024-02-15', 'AC1', 10, 8),
-- February 2024 - SL
('12345', '2024-02-10', 'SL', 52, 42),
('12345', '2024-02-11', 'SL', 62, 48),
('12345', '2024-02-12', 'SL', 42, 37),
('12345', '2024-02-14', 'SL', 72, 58),
('12345', '2024-02-15', 'SL', 48, 40),

-- Rajdhani Express (12345) - April 2024 (Peak Season) - AC1
('12345', '2024-04-05', 'AC1', 20, 14),
('12345', '2024-04-06', 'AC1', 22, 16),
('12345', '2024-04-07', 'AC1', 18, 12),
('12345', '2024-04-08', 'AC1', 25, 18),
('12345', '2024-04-10', 'AC1', 19, 13),
-- April 2024 - SL (Peak season - lower confirmation rates)
('12345', '2024-04-05', 'SL', 100, 65),
('12345', '2024-04-06', 'SL', 110, 70),
('12345', '2024-04-07', 'SL', 90, 60),
('12345', '2024-04-08', 'SL', 120, 75),
('12345', '2024-04-10', 'SL', 95, 62),

-- Rajdhani Express (12345) - May 2024 (Peak Season) - AC1
('12345', '2024-05-05', 'AC1', 21, 13),
('12345', '2024-05-06', 'AC1', 23, 15),
('12345', '2024-05-07', 'AC1', 19, 11),
('12345', '2024-05-08', 'AC1', 26, 17),
('12345', '2024-05-10', 'AC1', 20, 12),

-- Karnataka Express (12627) - AC2 - January
('12627', '2024-01-15', 'AC2', 20, 15),
('12627', '2024-01-16', 'AC2', 25, 20),
('12627', '2024-01-17', 'AC2', 18, 14),
('12627', '2024-01-18', 'AC2', 30, 22),
('12627', '2024-01-19', 'AC2', 22, 17),
-- January 2024 - SL
('12627', '2024-01-15', 'SL', 100, 80),
('12627', '2024-01-16', 'SL', 120, 90),
('12627', '2024-01-17', 'SL', 80, 70),
('12627', '2024-01-18', 'SL', 150, 110),
('12627', '2024-01-19', 'SL', 90, 75),

-- Karnataka Express (12627) - April (Peak) - AC2
('12627', '2024-04-05', 'AC2', 30, 18),
('12627', '2024-04-06', 'AC2', 35, 21),
('12627', '2024-04-07', 'AC2', 28, 16),
('12627', '2024-04-08', 'AC2', 40, 24),
('12627', '2024-04-10', 'AC2', 32, 19),
-- April (Peak) - SL
('12627', '2024-04-05', 'SL', 150, 90),
('12627', '2024-04-06', 'SL', 170, 100),
('12627', '2024-04-07', 'SL', 130, 80),
('12627', '2024-04-08', 'SL', 200, 120),
('12627', '2024-04-10', 'SL', 160, 95),

-- Mumbai Rajdhani (12951) - AC1 - January
('12951', '2024-01-15', 'AC1', 8, 6),
('12951', '2024-01-16', 'AC1', 10, 8),
('12951', '2024-01-17', 'AC1', 6, 5),
('12951', '2024-01-18', 'AC1', 12, 9),
('12951', '2024-01-19', 'AC1', 7, 6),
-- January - AC2
('12951', '2024-01-15', 'AC2', 20, 16),
('12951', '2024-01-16', 'AC2', 25, 20),
('12951', '2024-01-17', 'AC2', 18, 15),
('12951', '2024-01-18', 'AC2', 30, 24),
('12951', '2024-01-19', 'AC2', 22, 18),

-- Grand Trunk Express (12615) - AC2 - January
('12615', '2024-01-15', 'AC2', 15, 12),
('12615', '2024-01-16', 'AC2', 20, 16),
('12615', '2024-01-17', 'AC2', 12, 10),
('12615', '2024-01-18', 'AC2', 25, 20),
('12615', '2024-01-19', 'AC2', 18, 14),
-- January - SL
('12615', '2024-01-15', 'SL', 80, 60),
('12615', '2024-01-16', 'SL', 100, 75),
('12615', '2024-01-17', 'SL', 60, 50),
('12615', '2024-01-18', 'SL', 120, 90),
('12615', '2024-01-19', 'SL', 70, 55),

-- Shatabdi Express (12649) - CC - January
('12649', '2024-01-15', 'CC', 30, 25),
('12649', '2024-01-16', 'CC', 35, 28),
('12649', '2024-01-17', 'CC', 25, 22),
('12649', '2024-01-18', 'CC', 40, 32),
('12649', '2024-01-19', 'CC', 28, 24),
-- June 2024 (Holiday season approaching) - CC
('12649', '2024-06-15', 'CC', 40, 30),
('12649', '2024-06-16', 'CC', 45, 33),
('12649', '2024-06-17', 'CC', 35, 27),
('12649', '2024-06-18', 'CC', 50, 38),
('12649', '2024-06-19', 'CC', 38, 29);

-- Create indexes for better performance
CREATE INDEX idx_booking_train_date ON booking_history(train_no, journey_date);
CREATE INDEX idx_booking_class ON booking_history(class_type);
CREATE INDEX idx_booking_wl ON booking_history(total_wl);

-- Create a view for easy analysis
CREATE VIEW waitlist_analysis AS
SELECT 
    t.train_name,
    t.source,
    t.destination,
    bh.journey_date,
    bh.class_type,
    bh.total_wl,
    bh.confirmed_tickets,
    ROUND((bh.confirmed_tickets * 100.0 / bh.total_wl), 2) AS confirmation_rate
FROM train_info t
JOIN booking_history bh ON t.train_no = bh.train_no
WHERE bh.total_wl > 0
ORDER BY bh.journey_date DESC, t.train_name, bh.class_type;

-- Create stored procedure for getting average confirmation rate
DELIMITER //
CREATE PROCEDURE GetAverageConfirmationRate(
    IN p_train_no VARCHAR(10),
    IN p_journey_date DATE,
    IN p_class_type VARCHAR(10)
)
BEGIN
    SELECT 
        AVG(confirmed_tickets * 1.0 / total_wl) as avg_rate,
        COUNT(*) as record_count
    FROM booking_history 
    WHERE train_no = p_train_no 
    AND journey_date = p_journey_date 
    AND class_type = p_class_type 
    AND total_wl > 0;
END //
DELIMITER ;

-- Insert sample users (password: Password@123 hashed with SHA-256)
-- Admin user: admin / admin123
-- Regular user: testuser / test123
INSERT INTO users (username, email, password_hash, role, is_active) VALUES
('admin', 'admin@railway.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin', TRUE),
('testuser', 'test@railway.com', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', TRUE);

-- Create stored procedure for getting historical data
DELIMITER //
CREATE PROCEDURE GetHistoricalConfirmationRate(
    IN p_train_no VARCHAR(10),
    IN p_class_type VARCHAR(10),
    IN p_day_of_week INT,
    IN p_month INT
)
BEGIN
    SELECT 
        AVG(confirmed_tickets * 1.0 / total_wl) as avg_rate,
        COUNT(*) as record_count
    FROM booking_history 
    WHERE train_no = p_train_no 
    AND class_type = p_class_type 
    AND DAYOFWEEK(journey_date) = p_day_of_week 
    AND MONTH(journey_date) = p_month 
    AND total_wl > 0;
END //
DELIMITER ;

-- Grant permissions (adjust as needed for your MySQL setup)
-- GRANT ALL PRIVILEGES ON railwaydb.* TO 'root'@'localhost';
-- FLUSH PRIVILEGES;

-- Display sample data
SELECT 'Sample Train Data:' as info;
SELECT * FROM train_info LIMIT 5;

SELECT 'Sample Booking History:' as info;
SELECT * FROM booking_history LIMIT 10;

SELECT 'Waitlist Analysis View:' as info;
SELECT * FROM waitlist_analysis LIMIT 10;



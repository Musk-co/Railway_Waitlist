# Railway Waitlist Probability Calculator - Testing Guide

## Overview

This guide provides valid test cases to run the Railway Waitlist Probability Calculator with real data from the database.

## Available Trains in Database

| Train No | Train Name | Source | Destination |
|----------|-----------|--------|-------------|
| 12345 | Rajdhani Express | New Delhi | Mumbai Central |
| 12627 | Karnataka Express | New Delhi | Bangalore |
| 12951 | Mumbai Rajdhani | New Delhi | Mumbai Central |
| 12615 | Grand Trunk Express | Chennai Central | New Delhi |
| 12649 | Shatabdi Express | New Delhi | Chandigarh |

## Available Test Data

### 85+ Records spanning 6 months

- **Train 12345 (Rajdhani)**: 35 records covering January, February, April, May 2024
- **Train 12627 (Karnataka)**: 20 records covering January and April 2024
- **Train 12951 (Mumbai Rajdhani)**: 10 records covering January 2024
- **Train 12615 (Grand Trunk)**: 10 records covering January 2024
- **Train 12649 (Shatabdi)**: 10 records covering January and June 2024

### Class Types Available

- **12345**: AC1, SL (multiple records per date)
- **12627**: AC2, SL (multiple records per date)
- **12951**: AC1, AC2
- **12615**: AC2, SL
- **12649**: CC

## Test Cases

### ✓ Test Case 1: Standard Prediction (High Confidence)
**Train**: 12345 (Rajdhani Express)
**Date**: 2024-01-15
**Class Type**: AC1
**Waitlist Number**: 3

**Expected Result**:
- Probability: ~75-80% (High confirmation rate)
- Category: High or Very High
- Reason: Historical data shows good confirmation (8/10 = 80%)

---

### ✓ Test Case 2: Sleeper Class Prediction
**Train**: 12345 (Rajdhani Express)
**Date**: 2024-01-15
**Class Type**: SL
**Waitlist Number**: 5

**Expected Result**:
- Probability: ~65-72%
- Category: High
- Reason: Good confirmation rate with SL class (40/50 = 80%)

---

### ✓ Test Case 3: Peak Season Prediction (Lower Probability)
**Train**: 12345 (Rajdhani Express)
**Date**: 2024-04-05
**Class Type**: AC1
**Waitlist Number**: 10

**Expected Result**:
- Probability: ~35-45%
- Category: Moderate or Low
- Reason: 
  - Peak season (April) has lower confirmation rates (14/20 = 70%)
  - Waitlist number 10 reduces probability further
  - Seasonal factor = 0.8 (peak season penalty)

---

### ✓ Test Case 4: May Peak Season (Even Lower)
**Train**: 12345 (Rajdhani Express)
**Date**: 2024-05-05
**Class Type**: AC1
**Waitlist Number**: 15

**Expected Result**:
- Probability: ~25-35%
- Category: Low or Very Low
- Reason:
  - May is peak season (13/21 = 61.9%)
  - High waitlist number (15) significantly reduces probability
  - Combined seasonal and waitlist factors

---

### ✓ Test Case 5: Karnataka Express (Multiple Classes)
**Train**: 12627 (Karnataka Express)
**Date**: 2024-01-15
**Class Type**: AC2
**Waitlist Number**: 8

**Expected Result**:
- Probability: ~60-68%
- Category: High
- Reason: Good historical data (15/20 = 75%)

---

### ✓ Test Case 6: Karnataka SL Class
**Train**: 12627 (Karnataka Express)
**Date**: 2024-01-15
**Class Type**: SL
**Waitlist Number**: 12

**Expected Result**:
- Probability: ~54-62%
- Category: Moderate/High
- Reason: SL class has high confirmation (80/100 = 80%), but high waitlist reduces it

---

### ✓ Test Case 7: Peak Season - Karnataka Express
**Train**: 12627 (Karnataka Express)
**Date**: 2024-04-05
**Class Type**: AC2
**Waitlist Number**: 20

**Expected Result**:
- Probability: ~18-28%
- Category: Low or Very Low
- Reason:
  - Peak season April (18/30 = 60%)
  - Very high waitlist number (20) applies strong penalty
  - Combined effect drastically reduces probability

---

### ✓ Test Case 8: Shatabdi Express (Holiday Season)
**Train**: 12649 (Shatabdi Express)
**Date**: 2024-06-15
**Class Type**: CC
**Waitlist Number**: 5

**Expected Result**:
- Probability: ~55-65%
- Category: High
- Reason:
  - June data (75% confirmation rate)
  - Low waitlist number increases probability
  - Reasonable seasonal factor

---

## Model Explanation

### How the Probability Calculator Works

The final probability is calculated as:

```
Final Probability = Base Probability × Waitlist Factor × Seasonal Factor
```

#### 1. Base Probability (70% specific + 30% historical)
- Looks for exact date data first
- Falls back to historical patterns (same day of week, same month)
- Uses 70/30 weighted average if both available

#### 2. Waitlist Factor
- 0-5: 0.9 (90% - High probability)
- 6-10: 0.7 (70% - Good probability)
- 11-20: 0.5 (50% - Moderate probability)
- 21-50: 0.3 (30% - Low probability)
- 51+: 0.1 (10% - Very low probability)

#### 3. Seasonal Factor
- Peak months (April, May, October, November): 0.8 (20% penalty)
- Summer (June, July, August): 0.9 (10% penalty)
- Holiday (December, January): 0.7 (30% penalty)
- Others: 1.0 (No penalty)

#### 4. Probability Categories
- 80-100%: **Very High**
- 60-79%: **High**
- 40-59%: **Moderate**
- 20-39%: **Low**
- 0-19%: **Very Low**

---

## Data Quality & Best Practices

### What Makes the Model Work Better

1. **More Historical Data**: Model is trained on 85+ records
2. **Multiple Class Types**: Covers AC1, AC2, AC3, SL, CC classes
3. **Seasonal Variation**: Data spans peak and off-season months
4. **Multiple Trains**: Different trains have different confirmation patterns

### Recommended Testing Approach

1. **Start with January data**: Baseline good confirmation rates
2. **Try different class types**: AC vs SL vs CC have different behaviors
3. **Test peak season (April-May)**: See how seasonal factors reduce probability
4. **Vary waitlist numbers**: Observe how position affects prediction
5. **Use high waitlist numbers**: See "Very Low" predictions

---

## Troubleshooting

### "Train number not found"
- Ensure train number exists in list above
- Check database is imported correctly
- Re-import: `mysql -u root -p2507 < database/railway.sql`

### Probability always shows 0%
- Database connection issue
- Check `DBConnection.java` has correct credentials
- Verify MySQL is running: `mysql -u root -p2507 -e "SELECT 1;"`

### No data for specific date/class combination
- Some date/class combinations don't have data
- Use dates from Test Cases above
- Or add more data to `database/railway.sql`

---

## Adding More Data

To improve predictions further, add more records to `booking_history`:

```sql
INSERT INTO booking_history (train_no, journey_date, class_type, total_wl, confirmed_tickets) VALUES
('12345', '2024-03-20', 'AC1', 12, 10),
('12345', '2024-03-20', 'SL', 55, 48),
-- Add more records...
```

Then restart Tomcat and test again.

---

## Success Criteria

✓ **Model is working correctly if:**
1. Valid train numbers show a probability percentage
2. Peak season dates (April-May) show LOWER probabilities than January
3. Higher waitlist numbers show LOWER probabilities
4. SL class typically shows higher confirmation rates than AC
5. Error page appears for invalid trains

---

## Contact & Support

For issues:
1. Check Tomcat logs: `C:\development\apache-tomcat-9.0.111\logs\`
2. Verify database: `mysql -u root -p2507 railwaydb`
3. Check browser console for JavaScript errors
4. Review README.md for setup issues

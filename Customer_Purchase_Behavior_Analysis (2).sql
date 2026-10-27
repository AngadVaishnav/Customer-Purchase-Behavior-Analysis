-- Project: Customer Purchase Behavior Analysis
-- Database: customer_purchase_behavior
-- Table: shopping_trends
-- MySQL 8+
-- Note: These are reusable analysis queries. Run them against your local dataset.
-- Do not assume results for queries unless you have executed them.

USE customer_purchase_behavior;

-- Q1. Basic dataset size
SELECT COUNT(*) AS total_records
FROM shopping_trends;

-- Q2. Check duplicate Customer IDs
SELECT `Customer ID`, COUNT(*) AS id_count
FROM shopping_trends
GROUP BY `Customer ID`
HAVING COUNT(*) > 1;

-- Q3. Check NULLs (repeat for each column if needed)
SELECT
  SUM(`Customer ID` IS NULL) AS null_customer_id,
  SUM(`Age` IS NULL) AS null_age,
  SUM(`Gender` IS NULL) AS null_gender,
  SUM(`Item Purchased` IS NULL) AS null_item_purchased,
  SUM(`Category` IS NULL) AS null_category,
  SUM(`Purchase Amount (USD)` IS NULL) AS null_purchase_amount,
  SUM(`Location` IS NULL) AS null_location,
  SUM(`Size` IS NULL) AS null_size,
  SUM(`Color` IS NULL) AS null_color,
  SUM(`Season` IS NULL) AS null_season,
  SUM(`Review Rating` IS NULL) AS null_review_rating,
  SUM(`Subscription Status` IS NULL) AS null_subscription_status,
  SUM(`Shipping Type` IS NULL) AS null_shipping_type,
  SUM(`Discount Applied` IS NULL) AS null_discount_applied,
  SUM(`Promo Code Used` IS NULL) AS null_promo_code_used,
  SUM(`Previous Purchases` IS NULL) AS null_previous_purchases,
  SUM(`Preferred Payment Method` IS NULL) AS null_payment_method,
  SUM(`Frequency of Purchases` IS NULL) AS null_purchase_frequency
FROM shopping_trends;

-- Q4. Category performance: records, average purchase amount, average rating
SELECT
  Category,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating
FROM shopping_trends
GROUP BY Category
ORDER BY avg_purchase_amount DESC;

-- Q5. Most common purchased item labels (record frequency, not units sold)
SELECT
  `Item Purchased`,
  COUNT(*) AS record_count,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount
FROM shopping_trends
GROUP BY `Item Purchased`
ORDER BY record_count DESC, avg_purchase_amount DESC
LIMIT 5;

-- Q6. Age-group analysis
SELECT
  CASE
    WHEN Age < 25 THEN 'Under 25'
    WHEN Age < 35 THEN '25-34'
    WHEN Age < 45 THEN '35-44'
    WHEN Age < 55 THEN '45-54'
    ELSE '55+'
  END AS age_group,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating
FROM shopping_trends
GROUP BY age_group
ORDER BY avg_purchase_amount DESC;

-- Q7. Gender-wise purchase behavior
SELECT
  Gender,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating
FROM shopping_trends
GROUP BY Gender
ORDER BY avg_purchase_amount DESC;

-- Q8. Discount usage percentage by category
SELECT
  Category,
  COUNT(*) AS total_records,
  SUM(CASE WHEN `Discount Applied` = 'Yes' THEN 1 ELSE 0 END) AS discount_records,
  ROUND(
    SUM(CASE WHEN `Discount Applied` = 'Yes' THEN 1 ELSE 0 END)
    / COUNT(*) * 100.0, 2
  ) AS discount_usage_pct
FROM shopping_trends
GROUP BY Category
ORDER BY discount_usage_pct DESC;

-- Q9. Average purchase amount: discount Yes vs No
SELECT
  ROUND(AVG(CASE WHEN `Discount Applied` = 'Yes'
                 THEN `Purchase Amount (USD)` END), 2) AS discount_yes_avg,
  ROUND(AVG(CASE WHEN `Discount Applied` = 'No'
                 THEN `Purchase Amount (USD)` END), 2) AS discount_no_avg,
  ROUND(
    AVG(CASE WHEN `Discount Applied` = 'Yes'
             THEN `Purchase Amount (USD)` END)
    - AVG(CASE WHEN `Discount Applied` = 'No'
               THEN `Purchase Amount (USD)` END), 2
  ) AS avg_difference
FROM shopping_trends;

-- Q10. Review rating: discount Yes vs No
SELECT
  ROUND(AVG(CASE WHEN `Discount Applied` = 'Yes'
                 THEN `Review Rating` END), 2) AS discount_yes_avg,
  ROUND(AVG(CASE WHEN `Discount Applied` = 'No'
                 THEN `Review Rating` END), 2) AS discount_no_avg,
  ROUND(
    AVG(CASE WHEN `Discount Applied` = 'Yes'
             THEN `Review Rating` END)
    - AVG(CASE WHEN `Discount Applied` = 'No'
               THEN `Review Rating` END), 2
  ) AS avg_difference
FROM shopping_trends;

-- Q11. Purchase amount by category and discount status
SELECT
  Category,
  ROUND(AVG(CASE WHEN `Discount Applied` = 'Yes'
                 THEN `Purchase Amount (USD)` END), 2) AS discount_yes_avg,
  ROUND(AVG(CASE WHEN `Discount Applied` = 'No'
                 THEN `Purchase Amount (USD)` END), 2) AS discount_no_avg,
  ROUND(
    AVG(CASE WHEN `Discount Applied` = 'Yes'
             THEN `Purchase Amount (USD)` END)
    - AVG(CASE WHEN `Discount Applied` = 'No'
               THEN `Purchase Amount (USD)` END), 2
  ) AS avg_difference
FROM shopping_trends
GROUP BY Category
ORDER BY avg_difference DESC;

-- Q12. Subscription vs non-subscription average purchase amount
SELECT
  ROUND(AVG(CASE WHEN `Subscription Status` = 'Yes'
                 THEN `Purchase Amount (USD)` END), 2) AS subscription_avg,
  ROUND(AVG(CASE WHEN `Subscription Status` = 'No'
                 THEN `Purchase Amount (USD)` END), 2) AS non_subscription_avg,
  ROUND(
    AVG(CASE WHEN `Subscription Status` = 'Yes'
             THEN `Purchase Amount (USD)` END)
    - AVG(CASE WHEN `Subscription Status` = 'No'
               THEN `Purchase Amount (USD)` END), 2
  ) AS avg_difference
FROM shopping_trends;

-- Q13. Subscription status: count, average purchase amount, average rating
SELECT
  `Subscription Status`,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating
FROM shopping_trends
GROUP BY `Subscription Status`;

-- Q14. Promo code and discount combinations
SELECT
  `Discount Applied`,
  `Promo Code Used`,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating
FROM shopping_trends
GROUP BY `Discount Applied`, `Promo Code Used`
ORDER BY total_records DESC;

-- Q15. Seasonal purchase analysis
SELECT
  Season,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating
FROM shopping_trends
GROUP BY Season
ORDER BY avg_purchase_amount DESC;

-- Q16. Payment method analysis
SELECT
  `Preferred Payment Method`,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating
FROM shopping_trends
GROUP BY `Preferred Payment Method`
ORDER BY total_records DESC;

-- Q17. Purchase frequency analysis
SELECT
  `Frequency of Purchases`,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating,
  ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases
FROM shopping_trends
GROUP BY `Frequency of Purchases`
ORDER BY total_records DESC;

-- Q18. Rank categories by average purchase amount
WITH category_summary AS (
  SELECT
    Category,
    COUNT(*) AS total_records,
    AVG(`Purchase Amount (USD)`) AS avg_purchase_amount
  FROM shopping_trends
  GROUP BY Category
)
SELECT
  Category,
  total_records,
  ROUND(avg_purchase_amount, 2) AS avg_purchase_amount,
  DENSE_RANK() OVER (ORDER BY avg_purchase_amount DESC) AS category_rank
FROM category_summary
ORDER BY category_rank;

-- Q19. Purchase amount segments (example thresholds; document as analyst-defined)
SELECT
  CASE
    WHEN `Purchase Amount (USD)` <= 25 THEN 'Low (<=25)'
    WHEN `Purchase Amount (USD)` <= 50 THEN 'Medium (25.01-50)'
    ELSE 'High (>50)'
  END AS purchase_segment,
  COUNT(*) AS total_records,
  ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
  ROUND(AVG(`Review Rating`), 2) AS avg_review_rating
FROM shopping_trends
GROUP BY purchase_segment
ORDER BY avg_purchase_amount;

-- Q20. Final validation: verify category-level discount analysis totals
SELECT
  Category,
  COUNT(*) AS total_records,
  SUM(CASE WHEN `Discount Applied` = 'Yes' THEN 1 ELSE 0 END) AS discount_yes_records,
  SUM(CASE WHEN `Discount Applied` = 'No' THEN 1 ELSE 0 END) AS discount_no_records
FROM shopping_trends
GROUP BY Category;

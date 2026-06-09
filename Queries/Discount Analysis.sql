-- Q16.What is the average discount offered, and how much revenue is lost through discounts?
SELECT
    ROUND(AVG(discount_percent),2) AS avg_discount,
    ROUND(SUM(discount_amount),2) AS total_discount_loss
FROM glowcart_sales;


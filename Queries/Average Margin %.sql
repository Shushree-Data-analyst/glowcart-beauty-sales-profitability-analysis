-- Q4.What is the average gross margin percentage across all sales?
SELECT ROUND(AVG(gross_margin_percent),2) AS avg_margin
FROM glowcart_sales;
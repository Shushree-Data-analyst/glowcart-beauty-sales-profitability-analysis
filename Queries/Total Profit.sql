-- Q3.How much total gross profit has the business earned?
SELECT ROUND(SUM(gross_profit),2) AS total_profit
FROM glowcart_sales;
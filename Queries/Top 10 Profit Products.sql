-- Q10. Which top 10 products generate the highest profit?
SELECT
    product_name,
    ROUND(SUM(gross_profit),2) AS profit
FROM glowcart_sales
GROUP BY product_name
ORDER BY profit DESC
LIMIT 10;


-- Q18. Which region and sales channel combination generates the highest profit?
SELECT
    region,
    sales_channel,
    ROUND(SUM(gross_profit),2) AS profit
FROM glowcart_sales
GROUP BY region, sales_channel
ORDER BY profit DESC
LIMIT 10;



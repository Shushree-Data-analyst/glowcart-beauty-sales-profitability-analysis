-- Q7.Which region generates the highest gross profit?
SELECT
    region,
    ROUND(SUM(gross_profit),2) AS profit
FROM glowcart_sales
GROUP BY region
ORDER BY profit DESC;
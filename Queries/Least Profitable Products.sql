-- Q11.Which products are the least profitable or underperforming?
SELECT
    product_name,
    ROUND(SUM(gross_profit),2) AS profit
FROM glowcart_sales
GROUP BY product_name
ORDER BY profit ASC
LIMIT 10;
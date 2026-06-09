-- Q13.Which sales representatives generate the highest profit?
SELECT
    sales_rep,
    ROUND(SUM(gross_profit),2) AS profit
FROM glowcart_sales
GROUP BY sales_rep
ORDER BY profit DESC;
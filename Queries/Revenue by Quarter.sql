-- Q15.Which quarter performs best in terms of revenue generation?
SELECT
    quarter,
    ROUND(SUM(net_revenue),2) AS revenue
FROM glowcart_sales
GROUP BY quarter
ORDER BY quarter;



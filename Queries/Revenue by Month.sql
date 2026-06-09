-- Q14.Which months generate the highest revenue?
SELECT
    month,
    ROUND(SUM(net_revenue),2) AS revenue
FROM glowcart_sales
GROUP BY month
ORDER BY revenue DESC;
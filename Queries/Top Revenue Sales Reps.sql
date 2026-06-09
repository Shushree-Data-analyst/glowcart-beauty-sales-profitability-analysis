-- Q12.Which sales representatives generate the highest revenue?
SELECT
    sales_rep,
    ROUND(SUM(net_revenue),2) AS revenue
FROM glowcart_sales
GROUP BY sales_rep
ORDER BY revenue DESC
LIMIT 10;






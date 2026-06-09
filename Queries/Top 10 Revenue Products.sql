-- Q9. Which top 10 products generate the highest revenue?
SELECT
    product_name,
    ROUND(SUM(net_revenue),2) AS revenue
FROM glowcart_sales
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;
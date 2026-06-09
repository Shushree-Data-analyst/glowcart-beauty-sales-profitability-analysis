-- Q19.Which products perform best in each region based on revenue?
SELECT
    region,
    product_name,
    ROUND(SUM(net_revenue),2) AS revenue
FROM glowcart_sales
GROUP BY region, product_name
ORDER BY revenue DESC;
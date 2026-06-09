-- Q5.How many orders are generated from each region?
SELECT 
    region,
    COUNT(order_id) AS total_orders
FROM glowcart_sales
GROUP BY region
ORDER BY total_orders DESC;
 -- Q6.Which region contributes the highest revenue to the business?
SELECT
    region,
    ROUND(SUM(net_revenue),2) AS revenue
FROM glowcart_sales
GROUP BY region
ORDER BY revenue DESC;


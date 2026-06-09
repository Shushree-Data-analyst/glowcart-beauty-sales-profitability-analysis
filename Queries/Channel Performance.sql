-- Q8.Which sales channel performs best in terms of revenue and profit?
SELECT
    sales_channel,
    ROUND(SUM(net_revenue),2) AS revenue,
    ROUND(SUM(gross_profit),2) AS profit
FROM glowcart_sales
GROUP BY sales_channel
ORDER BY revenue DESC;


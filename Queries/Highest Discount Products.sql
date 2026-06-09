-- 17.Which products receive the highest average discounts?
SELECT
    product_name,
    ROUND(AVG(discount_percent),2) AS avg_discount
FROM glowcart_sales
GROUP BY product_name
ORDER BY avg_discount DESC
LIMIT 10;


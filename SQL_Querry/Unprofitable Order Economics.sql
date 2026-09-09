WITH Orders as (SELECT s.order_id,r.market, SUM(sales) as revenue,
SUM(profit) as total_profit, SUM(s.quantity) as quantity
FROM fact_sales s
JOIN dim_region r
	ON s.region_code = r.region_code
GROUP BY s.order_id,r.market
)
SELECT order_id, market, revenue, total_profit, quantity,
CAST(total_profit/NULLIF(revenue,0) as numeric(5,2)) as margin,
CASE WHEN revenue < 20 THEN '$0 - $20'
        WHEN revenue >= 20 AND revenue < 50 THEN '$20 - $50'
        WHEN revenue >= 50 AND revenue < 100 THEN '$50 - $100'
        WHEN revenue >= 100 AND revenue < 200 THEN '$100 - $200'
        WHEN revenue >= 200 AND revenue < 500 THEN '$200 - $500'
        ELSE '$500+' 
    END AS Order_Value_Tier
FROM Orders
ORDER BY revenue
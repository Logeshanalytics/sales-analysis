/* ============================================================
   1. TOTAL SALES, PROFIT, AND QUANTITY (OVERALL KPI)
   ============================================================ */
SELECT 
    SUM(Revenue) AS total_revenue,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity
FROM sales_data;


/* ============================================================
   2. MONTHLY SALES TREND
   ============================================================ */
SELECT 
    Year,
    Month_Number,
    Month_Name,
    SUM(Revenue) AS monthly_revenue,
    SUM(Profit) AS monthly_profit
FROM sales_data
GROUP BY Year, Month_Number, Month_Name
ORDER BY Year, Month_Number;


/* ============================================================
   3. SALES BY REGION
   ============================================================ */
SELECT 
    Region,
    SUM(Revenue) AS total_revenue,
    SUM(Profit) AS total_profit
FROM sales_data
GROUP BY Region
ORDER BY total_revenue DESC;


/* ============================================================
   4. TOP 10 BEST-SELLING PRODUCTS (BY REVENUE)
   ============================================================ */
SELECT 
    p.Product_Name,
    SUM(s.Revenue) AS total_revenue,
    SUM(s.Quantity) AS total_quantity
FROM sales_data s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY total_revenue DESC
LIMIT 10;


/* ============================================================
   5. SALES BY CATEGORY
   ============================================================ */
SELECT 
    p.Category,
    SUM(s.Revenue) AS total_revenue,
    SUM(s.Profit) AS total_profit
FROM sales_data s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY total_revenue DESC;


/* ============================================================
   6. CUSTOMER SEGMENT PERFORMANCE
   ============================================================ */
SELECT 
    c.Segment,
    COUNT(DISTINCT s.Customer_ID) AS total_customers,
    SUM(s.Revenue) AS total_revenue,
    AVG(s.Revenue) AS avg_order_value
FROM sales_data s
JOIN customers c ON s.Customer_ID = c.Customer_ID
GROUP BY c.Segment
ORDER BY total_revenue DESC;


/* ============================================================
   7. TOP 5 CUSTOMERS BY REVENUE
   ============================================================ */
SELECT 
    c.Customer_Name,
    SUM(s.Revenue) AS total_spent
FROM sales_data s
JOIN customers c ON s.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
ORDER BY total_spent DESC
LIMIT 5;


/* ============================================================
   8. PROFIT MARGIN BY PRODUCT
   ============================================================ */
SELECT 
    p.Product_Name,
    SUM(s.Revenue) AS revenue,
    SUM(s.Profit) AS profit,
    ROUND((SUM(s.Profit) / SUM(s.Revenue)) * 100, 2) AS profit_margin_pct
FROM sales_data s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY profit_margin_pct DESC;


/* ============================================================
   9. SALES VS TARGET ANALYSIS
   ============================================================ */
SELECT 
    s.Year,
    s.Month_Number,
    s.Region,
    SUM(s.Revenue) AS actual_sales,
    SUM(t.Target_Amount) AS target_sales,
    (SUM(s.Revenue) - SUM(t.Target_Amount)) AS variance
FROM sales_data s
JOIN sales_targets t 
    ON s.Region = t.Region 
    AND s.Month_Number = t.Month_Number
    AND s.Year = t.Year
GROUP BY s.Year, s.Month_Number, s.Region
ORDER BY s.Year, s.Month_Number;


/* ============================================================
   10. CATEGORY PERFORMANCE VS TARGET
   ============================================================ */
SELECT 
    p.Category,
    s.Year,
    s.Month_Number,
    SUM(s.Revenue) AS actual_sales,
    SUM(t.Target_Amount) AS target_sales
FROM sales_data s
JOIN products p ON s.Product_ID = p.Product_ID
JOIN sales_targets t 
    ON p.Category = t.Category
    AND s.Month_Number = t.Month_Number
    AND s.Year = t.Year
GROUP BY p.Category, s.Year, s.Month_Number;


/* ============================================================
   11. AVERAGE ORDER VALUE (AOV)
   ============================================================ */
SELECT 
    Order_ID,
    SUM(Revenue) AS order_value
FROM sales_data
GROUP BY Order_ID;

-- overall AOV
SELECT 
    AVG(order_value) AS avg_order_value
FROM (
    SELECT Order_ID, SUM(Revenue) AS order_value
    FROM sales_data
    GROUP BY Order_ID
) t;


/* ============================================================
   12. REPEAT VS NEW CUSTOMERS
   ============================================================ */
SELECT 
    Customer_ID,
    COUNT(DISTINCT Order_ID) AS total_orders
FROM sales_data
GROUP BY Customer_ID;

-- classification
SELECT 
    CASE 
        WHEN total_orders = 1 THEN 'New'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT Customer_ID, COUNT(DISTINCT Order_ID) AS total_orders
    FROM sales_data
    GROUP BY Customer_ID
) t
GROUP BY customer_type;


/* ============================================================
   13. TOP STATES BY SALES
   ============================================================ */
SELECT 
    c.State,
    SUM(s.Revenue) AS total_revenue
FROM sales_data s
JOIN customers c ON s.Customer_ID = c.Customer_ID
GROUP BY c.State
ORDER BY total_revenue DESC;


/* ============================================================
   14. SHIPPING COST ANALYSIS
   ============================================================ */
SELECT 
    Region,
    SUM(Shipping_Cost) AS total_shipping,
    AVG(Shipping_Cost) AS avg_shipping_cost
FROM sales_data
GROUP BY Region;


/* ============================================================
   15. YEARLY GROWTH RATE
   ============================================================ */
SELECT 
    Year,
    SUM(Revenue) AS yearly_revenue,
    LAG(SUM(Revenue)) OVER (ORDER BY Year) AS prev_year_revenue,
    ROUND(
        (SUM(Revenue) - LAG(SUM(Revenue)) OVER (ORDER BY Year)) 
        / LAG(SUM(Revenue)) OVER (ORDER BY Year) * 100, 2
    ) AS growth_pct
FROM sales_data
GROUP BY Year;
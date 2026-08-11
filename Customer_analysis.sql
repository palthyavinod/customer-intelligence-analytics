--- MONTHLY ORDER TREND---


SELECT
      MONTH(order_purchase_timestamp) AS order_month,
      COUNT(order_id) AS total_order
FROM [dbo].[olist_orders_dataset]
GROUP BY MONTH(order_purchase_timestamp)
ORDER BY order_month;

--===============================================================================================================================================
--Query 2: order_status analysis
-- Bussiness Question:
-- How many order are there in each order status?

SELECT 
      order_status,
      COUNT(order_id) AS total_order
FROM [dbo].[olist_orders_dataset]
GROUP BY order_status
ORDER BY total_order DESC;
--========================================================================================================================================
--Query 3: Yearly order trend
--Bussiness Question:
--How many order were placed each year?
SELECT 
      YEAR(order_purchase_timestamp) AS order_year,
      COUNT(order_id) AS total_order
FROM [dbo].[olist_orders_dataset]
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;
--==========================================================================================================================================
--Query 4:Monthly order trend by Year
--Bussiness Question:
--How many order were placed in each month of each year?
SELECT 
      YEAR(order_purchase_timestamp) AS order_year,
      MONTH(order_purchase_timestamp)AS order_month,
      COUNT(order_id) AS total_order
FROM [dbo].[olist_orders_dataset]
GROUP BY 
        YEAR(order_purchase_timestamp),
        MONTH(order_purchase_timestamp)
ORDER BY 
        order_year,
        order_month;
--===========================================================================================================================================

--Query 5:
--Bussiness Question:
--Which custommer state has the highest number of order?
SELECT c.customer_state,
       COUNT(o.order_id) AS total_orders
FROM [dbo].[olist_orders_dataset] o
INNER JOIN[dbo].[olist_customers_dataset] c 
     ON o.customer_id=c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;
--=============================================================================================================================================
--QUuery 5:
--Business Question:
--TOP 10 customer in  the company
SELECT TOP 10 customer_id,
      COUNT(order_id) AS total_order
FROM [dbo].[olist_orders_dataset]
GROUP BY customer_id
ORDER BY total_order desc
--==========================================================================================================================================
--Query 6:
--Business Question:
--TOP customer state by number of order?
SELECT c.customer_state,
     COUNT(o.order_id) AS total_orders
FROM [dbo].[olist_orders_dataset] o
INNER JOIN [dbo].[olist_customers_dataset] c
     ON c.customer_id=o.customer_id
GROUP BY customer_state
ORDER BY total_orders DESC;
--===============================================================================================================================================
--Query 7:
--Business Question:
--TOP10 customer cities by Number of orders
SELECT TOP 10 c.customer_city,
     COUNT(o.order_id) AS total_orders
FROM [dbo].[olist_orders_dataset] o
INNER JOIN [dbo].[olist_customers_dataset] c 
      ON o.customer_id=c.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC;
--============================================================================================================================================
--Query 8:
--Business Question:
--TOP product categories by number of orders
SELECT TOP 10
       p.product_category_name,
       COUNT(o.order_id) AS total_orders
FROM [dbo].[olist_order_items_dataset] o
INNER JOIN [dbo].[olist_products_dataset] p
     ON o.product_id=p.product_id
GROUP BY p.product_category_name
ORDER BY total_orders DESC;
--===========================================================================================================================================
--Query 9:
--Business Question:
--Top 10 products by number of times sold
SELECT TOP 10 p.product_id,
       p.product_category_name,
       COUNT(o.order_id) AS total_orders
FROM [dbo].[olist_order_items_dataset] o
INNER JOIN [dbo].[olist_products_dataset] p
     ON p.product_id=o.product_id
GROUP BY p.product_id,
         p.product_category_name
ORDER BY total_orders DESC;

--==============================================================================================================================================
--Query 10:
--Business Question :
--Top 10 customer by revenue
SELECT TOP 10 o.customer_id,
       SUM(oi.price+oi.freight_value) AS total_revenue
FROM [dbo].[olist_order_items_dataset] as oi
INNER JOIN [dbo].[olist_orders_dataset] AS o
          ON oi.order_id=o.order_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC;
--=============================================================================================================================================
--Query 11:
--Business Question :
--Average order value
SELECT o.order_id,
       AVG(oi.price+oi.freight_value) AS order_average_value
FROM [dbo].[olist_order_items_dataset] AS oi
INNER JOIN [dbo].[olist_orders_dataset] as o 
          ON oi.order_id=o.order_id
GROUP BY o.order_id;
--=============================================================================================================================================
--Query 12:
--Bussiness Question :
--Highest revenue product category
SELECT TOP 5 p.product_category_name,
       SUM(oi.price+oi.freight_value) AS total_revenue
FROM [dbo].[olist_products_dataset] AS p
INNER JOIN [dbo].[olist_order_items_dataset] AS oi
           ON p.product_id=oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;
--===========================================================================================================================================
--Query 13:
--Buissness Question 
--Number of product sold by category
SELECT TOP 10
    p.product_category_name,
    COUNT(*) AS total_products_sold
FROM[dbo].[olist_products_dataset]  AS p
INNER JOIN[dbo].[olist_order_items_dataset]  AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_products_sold DESC;
--==============================================================================================================================================
--====================================================
-- Query 14:
-- Business Question
-- Top 10 Product Categories by Revenue

SELECT TOP 10
    p.product_category_name,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM dbo.olist_products_dataset AS p
INNER JOIN dbo.olist_order_items_dataset AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;

--=======================================================================================================================================
-- Query 15:
-- Business Question
-- Average Revenue per Product Category

SELECT
    p.product_category_name,
    AVG(oi.price + oi.freight_value) AS average_revenue
FROM dbo.olist_products_dataset AS p
INNER JOIN dbo.olist_order_items_dataset AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY average_revenue DESC;
--====================================================
-- Query 16:
-- Business Question
-- Top 10 Customers by Total Revenue

SELECT TOP 10
    o.customer_id,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM dbo.olist_orders_dataset AS o
INNER JOIN dbo.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC;
--====================================================
-- Query 17:
-- Business Question
-- Customer Purchase Classification

SELECT
    o.customer_id,
    SUM(oi.price + oi.freight_value) AS total_spending,
    CASE
        WHEN SUM(oi.price + oi.freight_value) >= 5000 THEN 'High Value'
        WHEN SUM(oi.price + oi.freight_value) >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM dbo.olist_orders_dataset AS o
INNER JOIN dbo.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spending DESC;
--====================================================
-- Query 18:
-- Business Question
-- Customers Who Placed At Least 3 Orders

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM dbo.olist_orders_dataset
GROUP BY customer_id
HAVING COUNT(DISTINCT order_id) >= 3
ORDER BY total_orders DESC;
--====================================================
-- Query 19:
-- Business Question
-- Top Customers by Number of Different Product Categories Purchased

SELECT TOP 10
    o.customer_id,
    COUNT(DISTINCT p.product_category_name) AS different_categories
FROM dbo.olist_orders_dataset AS o
INNER JOIN dbo.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
INNER JOIN dbo.olist_products_dataset AS p
    ON oi.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY different_categories DESC;
--====================================================
-- Query 20:
-- Business Question
-- Products Costing More Than Average Product Price

SELECT
    product_id,
    price
FROM dbo.olist_order_items_dataset
WHERE price >
(
    SELECT AVG(price)
    FROM dbo.olist_order_items_dataset
)
ORDER BY price DESC;
--====================================================
-- Query 21:
-- Business Question
-- Customers Spending More Than Average Customer Spending

WITH customer_spending AS
(
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spending
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT *
FROM customer_spending
WHERE total_spending >
(
    SELECT AVG(total_spending)
    FROM customer_spending
)
ORDER BY total_spending DESC;
--===================================================
-- Query 22:
-- Business Question
-- Average Order Value of Every Customer

SELECT
    o.customer_id,
    AVG(oi.price + oi.freight_value) AS average_order_value
FROM dbo.olist_orders_dataset AS o
INNER JOIN dbo.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY average_order_value DESC;
--====================================================
-- Query 23:
-- Business Question
-- Highest Order Value for Every Customer

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id
)
SELECT
    customer_id,
    MAX(order_value) AS highest_order_value
FROM order_value
GROUP BY customer_id
ORDER BY highest_order_value DESC;
--====================================================
-- Query 24:
-- Business Question
-- Lowest Order Value for Every Customer

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id
)

SELECT
    customer_id,
    MIN(order_value) AS lowest_order_value
FROM order_value
GROUP BY customer_id
ORDER BY lowest_order_value;
--====================================================
-- Query 25:
-- Business Question
-- Rank Customers Based on Total Spending

WITH customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spending
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_spending,
    RANK() OVER(ORDER BY total_spending DESC) AS customer_rank
FROM customer_revenue;
--====================================================
-- Query 26:
-- Business Question
-- Dense Rank Customers by Revenue

WITH customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spending
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_spending,
    DENSE_RANK() OVER(ORDER BY total_spending DESC) AS dense_rank
FROM customer_revenue;
--====================================================
-- Query 27:
-- Business Question
-- Row Number for Customers by Revenue

WITH customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spending
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_spending,
    ROW_NUMBER() OVER(ORDER BY total_spending DESC) AS row_num
FROM customer_revenue;
--====================================================
-- Query 28:
-- Business Question
-- Top 5 Customers Using Rank

WITH customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spending
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT *
FROM
(
    SELECT
        customer_id,
        total_spending,
        RANK() OVER(ORDER BY total_spending DESC) AS rnk
    FROM customer_revenue
) t
WHERE rnk <= 5;
--====================================================
-- Query 29:
-- Business Question
-- Revenue Rank Within Each Product Category

WITH category_revenue AS
(
    SELECT
        p.product_category_name,
        p.product_id,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM dbo.olist_products_dataset AS p
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name,
        p.product_id
)

SELECT
    *,
    RANK() OVER(
        PARTITION BY product_category_name
        ORDER BY total_revenue DESC
    ) AS category_rank
FROM category_revenue;
--====================================================
-- Query 30:
-- Business Question
-- Top Product From Each Category

WITH category_revenue AS
(
    SELECT
        p.product_category_name,
        p.product_id,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM dbo.olist_products_dataset AS p
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name,
        p.product_id
)

SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY product_category_name
               ORDER BY total_revenue DESC
           ) AS rn
    FROM category_revenue
) t
WHERE rn = 1;
--====================================================
-- Query 31:
-- Business Question
-- Previous Order Value for Each Customer

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_value,
    LAG(order_value) OVER
    (
        PARTITION BY customer_id
        ORDER BY order_purchase_timestamp
    ) AS previous_order_value
FROM order_value;
--====================================================
-- Query 32:
-- Business Question
-- Difference Between Current and Previous Order Value

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
),
previous_order AS
(
    SELECT
        customer_id,
        order_id,
        order_purchase_timestamp,
        order_value,
        LAG(order_value) OVER
        (
            PARTITION BY customer_id
            ORDER BY order_purchase_timestamp
        ) AS previous_order_value
    FROM order_value
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_value,
    previous_order_value,
    order_value - previous_order_value AS order_value_difference
FROM previous_order;
--====================================================
-- Query 33:
-- Business Question
-- Next Order Value for Each Customer

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_value,
    LEAD(order_value) OVER
    (
        PARTITION BY customer_id
        ORDER BY order_purchase_timestamp
    ) AS next_order_value
FROM order_value;
--====================================================
-- Query 34:
-- Business Question
-- Running Total of Customer Spending

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_value,
    SUM(order_value) OVER
    (
        PARTITION BY customer_id
        ORDER BY order_purchase_timestamp
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_spending
FROM order_value;
--====================================================
-- Query 35:
-- Business Question
-- Moving Average of Last 3 Orders for Each Customer

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_value,
    AVG(order_value) OVER
    (
        PARTITION BY customer_id
        ORDER BY order_purchase_timestamp
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_order_moving_average
FROM order_value;
--====================================================
-- Query 36:
-- Business Question
-- Second Highest Order Value for Each Customer

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
),
ranked_orders AS
(
    SELECT
        customer_id,
        order_id,
        order_purchase_timestamp,
        order_value,
        DENSE_RANK() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_value DESC
        ) AS rnk
    FROM order_value
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_value
FROM ranked_orders
WHERE rnk = 2;
--====================================================
-- Query 37:
-- Business Question
-- Highest Order Value for Each Customer Using Window Function

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_value,
    MAX(order_value) OVER
    (
        PARTITION BY customer_id
    ) AS highest_order_value
FROM order_value;
--====================================================
-- Query 38:
-- Business Question
-- Lowest Order Value for Each Customer Using Window Function

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_value,
    MIN(order_value) OVER
    (
        PARTITION BY customer_id
    ) AS lowest_order_value
FROM order_value;
--====================================================
-- Query 39:
-- Business Question
-- Monthly Revenue Trend

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    SUM(oi.price + oi.freight_value) AS monthly_revenue
FROM dbo.olist_orders_dataset AS o
INNER JOIN dbo.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;
--====================================================
-- Query 40:
-- Business Question
-- Month-over-Month Revenue Growth

WITH monthly_revenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
),
revenue_comparison AS
(
    SELECT
        order_year,
        order_month,
        total_revenue,
        LAG(total_revenue) OVER
        (
            ORDER BY order_year, order_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    order_year,
    order_month,
    total_revenue,
    previous_month_revenue,
    total_revenue - previous_month_revenue AS revenue_difference,
    ROUND(
        100.0 * (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_percentage
FROM revenue_comparison
ORDER BY
    order_year,
    order_month;
--====================================================
-- Query 41:
-- Business Question
-- Identify Customers Whose Current Order Value
-- Is Higher Than Their Previous Order Value

WITH order_value AS
(
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_purchase_timestamp
),
previous_order AS
(
    SELECT
        customer_id,
        order_id,
        order_purchase_timestamp,
        order_value,
        LAG(order_value) OVER
        (
            PARTITION BY customer_id
            ORDER BY order_purchase_timestamp, order_id
        ) AS previous_order_value
    FROM order_value
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    previous_order_value,
    order_value AS current_order_value,
    order_value - previous_order_value AS value_increase
FROM previous_order
WHERE order_value > previous_order_value
ORDER BY customer_id, order_purchase_timestamp;
--====================================================
-- Query 42:
-- Business Question
-- Calculate the Number of Days Between Customer Orders

WITH customer_orders AS
(
    SELECT
        customer_id,
        order_id,
        order_purchase_timestamp,
        LAG(order_purchase_timestamp) OVER
        (
            PARTITION BY customer_id
            ORDER BY order_purchase_timestamp, order_id
        ) AS previous_order_date
    FROM dbo.olist_orders_dataset
)

SELECT
    customer_id,
    order_id,
    previous_order_date,
    order_purchase_timestamp AS current_order_date,
    DATEDIFF
    (
        DAY,
        previous_order_date,
        order_purchase_timestamp
    ) AS days_between_orders
FROM customer_orders
WHERE previous_order_date IS NOT NULL
ORDER BY customer_id, order_purchase_timestamp;
--====================================================
-- Query 43:
-- Business Question
-- Find the First Order of Every Customer

WITH ranked_orders AS
(
    SELECT
        customer_id,
        order_id,
        order_purchase_timestamp,
        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_purchase_timestamp, order_id
        ) AS order_number
    FROM dbo.olist_orders_dataset
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp AS first_order_date
FROM ranked_orders
WHERE order_number = 1
ORDER BY first_order_date;
--====================================================
-- Query 44:
-- Business Question
-- Find the Latest Order of Every Customer

WITH ranked_orders AS
(
    SELECT
        customer_id,
        order_id,
        order_purchase_timestamp,
        ROW_NUMBER() OVER
        (
            PARTITION BY customer_id
            ORDER BY order_purchase_timestamp DESC, order_id DESC
        ) AS order_number
    FROM dbo.olist_orders_dataset
)

SELECT
    customer_id,
    order_id,
    order_purchase_timestamp AS latest_order_date
FROM ranked_orders
WHERE order_number = 1
ORDER BY latest_order_date DESC;
--====================================================
-- Query 45:
-- Business Question
-- Calculate Customer Purchase Lifespan

SELECT
    customer_id,
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS latest_order_date,
    COUNT(DISTINCT order_id) AS total_orders,
    DATEDIFF
    (
        DAY,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp)
    ) AS customer_lifespan_days
FROM dbo.olist_orders_dataset
GROUP BY customer_id
ORDER BY customer_lifespan_days DESC;
--====================================================
-- Query 46:
-- Business Question
-- Find Customers Who Placed More Than One Order
-- on the Same Day

SELECT
    customer_id,
    CAST(order_purchase_timestamp AS DATE) AS order_date,
    COUNT(DISTINCT order_id) AS total_orders
FROM dbo.olist_orders_dataset
GROUP BY
    customer_id,
    CAST(order_purchase_timestamp AS DATE)
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC, order_date;
--====================================================
-- Query 47:
-- Business Question
-- Calculate Monthly Running Total Revenue

WITH monthly_revenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(oi.price + oi.freight_value) AS monthly_revenue
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER
    (
        ORDER BY order_year, order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY order_year, order_month;
--====================================================
-- Query 48:
-- Business Question
-- Calculate Three-Month Moving Average Revenue

WITH monthly_revenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(oi.price + oi.freight_value) AS monthly_revenue
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    order_year,
    order_month,
    monthly_revenue,
    AVG(monthly_revenue) OVER
    (
        ORDER BY order_year, order_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_month_moving_average
FROM monthly_revenue
ORDER BY order_year, order_month;

--====================================================
-- Query 50:
-- Business Question
-- Calculate Each Product Category's Percentage
-- Contribution to Total Revenue

WITH category_revenue AS
(
    SELECT
        p.product_category_name,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM dbo.olist_products_dataset AS p
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_category_name
)

SELECT
    product_category_name,
    total_revenue,
    SUM(total_revenue) OVER() AS overall_revenue,
    ROUND
    (
        100.0 * total_revenue
        / NULLIF(SUM(total_revenue) OVER(), 0),
        2
    ) AS revenue_percentage
FROM category_revenue
ORDER BY revenue_percentage DESC;
--====================================================
-- Query 51:
-- Business Question
-- Find the Top 3 Products by Revenue
-- Within Each Product Category

WITH product_revenue AS
(
    SELECT
        p.product_category_name,
        p.product_id,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM dbo.olist_products_dataset AS p
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name,
        p.product_id
),
ranked_products AS
(
    SELECT
        product_category_name,
        product_id,
        total_revenue,
        DENSE_RANK() OVER
        (
            PARTITION BY product_category_name
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM product_revenue
)

SELECT
    product_category_name,
    product_id,
    total_revenue,
    revenue_rank
FROM ranked_products
WHERE revenue_rank <= 3
ORDER BY
    product_category_name,
    revenue_rank;
--====================================================
-- Query 52:
-- Business Question
-- Find Product Categories With Revenue
-- Above the Average Category Revenue

WITH category_revenue AS
(
    SELECT
        p.product_category_name,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM dbo.olist_products_dataset AS p
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_category_name
)

SELECT
    product_category_name,
    total_revenue
FROM category_revenue
WHERE total_revenue >
(
    SELECT AVG(total_revenue)
    FROM category_revenue
)
ORDER BY total_revenue DESC;
--====================================================
-- Query 53:
-- Business Question
-- Compare Each Customer's Spending
-- With the Average Customer Spending

WITH customer_spending AS
(
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spending
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_spending,
    AVG(total_spending) OVER() AS average_customer_spending,
    total_spending
        - AVG(total_spending) OVER() AS difference_from_average
FROM customer_spending
ORDER BY total_spending DESC;
--====================================================
-- Query 54:
-- Business Question
-- Classify Customers Based on Total Spending

WITH customer_spending AS
(
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spending
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    total_spending,
    CASE
        WHEN total_spending >= 5000 THEN 'High Value Customer'
        WHEN total_spending >= 2000 THEN 'Medium Value Customer'
        ELSE 'Low Value Customer'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spending DESC;
--====================================================
-- Query 55:
-- Business Question
-- Divide Customers Into Four Spending Groups

WITH customer_spending AS
(
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spending
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
),
customer_quartiles AS
(
    SELECT
        customer_id,
        total_spending,
        NTILE(4) OVER
        (
            ORDER BY total_spending DESC
        ) AS spending_quartile
    FROM customer_spending
)

SELECT
    customer_id,
    total_spending,
    spending_quartile,
    CASE
        WHEN spending_quartile = 1 THEN 'Top 25%'
        WHEN spending_quartile = 2 THEN 'Upper Middle 25%'
        WHEN spending_quartile = 3 THEN 'Lower Middle 25%'
        ELSE 'Bottom 25%'
    END AS customer_group
FROM customer_quartiles
ORDER BY total_spending DESC;
--====================================================
-- Query 56:
-- Business Question
-- Find Repeat Customers

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM dbo.olist_orders_dataset
GROUP BY customer_id
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;











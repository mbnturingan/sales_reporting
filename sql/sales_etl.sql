-- appending order tables
WITH all_orders AS (
SELECT
    OrderId,
    CustomerID,
    ProductID,
    OrderDate,
    Quantity,
    Revenue,
    COGS
FROM orders_2023

UNION ALL

SELECT
    OrderId,
    CustomerID,
    ProductID,
    OrderDate,
    Quantity,
    Revenue,
    COGS
FROM orders_2024

UNION ALL

SELECT
    OrderId,
    CustomerID,
    ProductID,
    OrderDate,
    Quantity,
    Revenue,
    COGS
FROM orders_2025)

-- joining metadata
SELECT
o.OrderId,
o.CustomerID,
c.Region,
o.ProductID,
o.OrderDate,
DATE(DATE_TRUNC('week', o.OrderDate)) AS WeekStart,
c.CustomerJoinDate,
o.Quantity,
o.Revenue,
CASE WHEN o.Revenue IS NULL THEN p.Price * o.Quantity ELSE o.Revenue END AS Cleaned_Revenue, -- filling nulls
o.Revenue - o.COGS AS Profit, --profit column
o.COGS,
p.ProductName,
p.ProductCategory,
p.Price,
p.Base_Cost
FROM all_orders o
LEFT JOIN customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN products p
ON o.ProductID = p.ProductID
WHERE o.CustomerID IS NOT NULL; -- filter missing customer IDs

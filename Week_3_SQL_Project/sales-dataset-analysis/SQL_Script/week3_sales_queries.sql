CREATE DATABASE `sales_dataset`;


USE `sales_dataset`;

-- =========================================
-- SALES DATASET ANALYSIS
-- =========================================
SELECT *
FROM sales_data
LIMIT 10;

SELECT COUNT(*)
FROM sales_data;

DESCRIBE sales_data;

SELECT
    SUM(CASE WHEN ORDERNUMBER IS NULL THEN 1 ELSE 0 END) AS ORDERNUMBER_NULLS,
    SUM(CASE WHEN SALES IS NULL THEN 1 ELSE 0 END) AS SALES_NULLS,
    SUM(CASE WHEN CUSTOMERNAME IS NULL THEN 1 ELSE 0 END) AS CUSTOMER_NULLS
FROM sales_data;

SELECT COUNT(*) - COUNT(DISTINCT ORDERLINENUMBER) AS PossibleDuplicates
FROM sales_data;

SELECT *
FROM sales_data
WHERE SALES < 0;

SELECT STATUS, COUNT(*) AS TotalOrders
FROM sales_data
GROUP BY STATUS;

SELECT
    MIN(ORDERDATE) AS EarliestDate,
    MAX(ORDERDATE) AS LatestDate
FROM sales_data;

-- =========================================
-- 1. TOTAL SALES REVENUE
-- =========================================

SELECT
    ROUND(SUM(SALES), 2) AS TotalRevenue
FROM sales_data;

-- =========================================
-- 2. TOP COUNTRIES BY REVENUE
-- =========================================

SELECT
    COUNTRY,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data
GROUP BY COUNTRY
ORDER BY Revenue DESC;


-- =========================================
-- 3. TOP PRODUCT LINES BY REVENUE
-- =========================================

SELECT
    PRODUCTLINE,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data
GROUP BY PRODUCTLINE
ORDER BY Revenue DESC;


-- =========================================
-- 4. MONTHLY SALES TREND ANALYSIS
-- =========================================

SELECT
    YEAR_ID,
    MONTH_ID,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID;


-- =========================================
-- 5. TOP CUSTOMERS BY REVENUE
-- =========================================

SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES), 2) AS TotalSpent
FROM sales_data
GROUP BY CUSTOMERNAME
ORDER BY TotalSpent DESC
LIMIT 10;


-- =========================================
-- 6. CUSTOMER REVENUE RANKING
-- =========================================

SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES), 2) AS TotalRevenue,
    RANK() OVER (
        ORDER BY SUM(SALES) DESC
    ) AS RevenueRank
FROM sales_data
GROUP BY CUSTOMERNAME;


-- =========================================
-- 7. BEST SALES MONTH IN EACH YEAR
-- =========================================

SELECT *
FROM (
    SELECT
        YEAR_ID,
        MONTH_ID,
        ROUND(SUM(SALES), 2) AS Revenue,
        RANK() OVER (
            PARTITION BY YEAR_ID
            ORDER BY SUM(SALES) DESC
        ) AS RevenueRank
    FROM sales_data
    GROUP BY YEAR_ID, MONTH_ID
) ranked_months
WHERE RevenueRank = 1;


-- =========================================
-- 8. TOP PRODUCTS BY REVENUE
-- =========================================

SELECT
    PRODUCTCODE,
    PRODUCTLINE,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data
GROUP BY PRODUCTCODE, PRODUCTLINE
ORDER BY Revenue DESC
LIMIT 10;

-- =========================================
-- 9. ORDER STATUS ANALYSIS
-- =========================================

SELECT
    STATUS,
    COUNT(*) AS TotalOrders,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data
GROUP BY STATUS
ORDER BY Revenue DESC;
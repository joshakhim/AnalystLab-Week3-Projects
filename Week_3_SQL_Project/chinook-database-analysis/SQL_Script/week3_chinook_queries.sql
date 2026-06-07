-- =========================================
-- ANALYSTLAB AFRICA - WEEK 3 SQL PROJECT
-- CHINOOK DATABASE ANALYSIS
-- INTERN: YOUR NAME
-- =========================================

-- =========================================
-- 1. DATABASE EXPLORATION
-- =========================================

-- View all tables
SHOW TABLES;

-- Preview customer table
SELECT * 
FROM customer
LIMIT 10;

-- Preview invoice table
SELECT *
FROM invoice
LIMIT 10;

-- Preview track table
SELECT *
FROM track
LIMIT 10;


-- =========================================
-- 2. CUSTOMER PURCHASE ANALYSIS
-- =========================================

SELECT 
    cu.CustomerId,
    cu.FirstName,
    cu.LastName,
    SUM(iv.Total) AS TotalSpent
FROM customer cu
INNER JOIN invoice iv
    ON cu.CustomerId = iv.CustomerId
GROUP BY 
    cu.CustomerId,
    cu.FirstName,
    cu.LastName
ORDER BY TotalSpent DESC;


-- =========================================
-- 3. TOP-SELLING MUSIC GENRES
-- =========================================

SELECT
    ge.Name AS Genre,
    SUM(iv.UnitPrice * iv.Quantity) AS Revenue
FROM genre ge
INNER JOIN track tr 
    ON ge.GenreId = tr.GenreId
INNER JOIN invoiceline iv
    ON tr.TrackId = iv.TrackId
GROUP BY ge.Name
ORDER BY Revenue DESC;


-- =========================================
-- 4. TOP ARTISTS BY REVENUE
-- =========================================

SELECT
    ar.Name AS Artist,
    SUM(iv.UnitPrice * iv.Quantity) AS Revenue
FROM artist ar
INNER JOIN album al
    ON ar.ArtistId = al.ArtistId
INNER JOIN track tr
    ON al.AlbumId = tr.AlbumId
INNER JOIN invoiceline iv
    ON tr.TrackId = iv.TrackId
GROUP BY ar.Name
ORDER BY Revenue DESC
LIMIT 10;

-- =========================================
-- 5. MONTHLY REVENUE TREND ANALYSIS
-- =========================================

SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
    SUM(Total) AS Revenue
FROM invoice
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY Month;


-- =========================================
-- 6. CUSTOMER SPENDING RANKING
-- =========================================

SELECT
    cu.CustomerId,
    cu.FirstName,
    cu.LastName,
    SUM(iv.Total) AS TotalSpent,
    RANK() OVER (
        ORDER BY SUM(iv.Total) DESC
    ) AS CustomerRank
FROM customer cu
INNER JOIN invoice iv
    ON cu.CustomerId = iv.CustomerId
GROUP BY
    cu.CustomerId,
    cu.FirstName,
    cu.LastName;

-- =========================================
-- 7. CUSTOMERS ABOVE AVERAGE SPENDING
-- =========================================

SELECT
    cu.CustomerId,
    cu.FirstName,
    cu.LastName,
    SUM(iv.Total) AS TotalSpent
FROM customer cu
INNER JOIN invoice iv
    ON cu.CustomerId = iv.CustomerId
GROUP BY
    cu.CustomerId,
    cu.FirstName,
    cu.LastName
HAVING SUM(iv.Total) >
(
    SELECT AVG(CustomerTotal)
    FROM
    (
        SELECT
            SUM(Total) AS CustomerTotal
        FROM invoice iv
        GROUP BY CustomerId
    ) AS AvgTable
)
ORDER BY TotalSpent DESC;


-- =========================================
-- 8. QUERY OPTIMIZATION CONCEPTS
-- =========================================

-- Create index on CustomerId for faster searches
CREATE INDEX idx_customer_id
ON invoice(CustomerId);

-- Create index on TrackId for faster joins
CREATE INDEX idx_track_id
ON invoiceline(TrackId);
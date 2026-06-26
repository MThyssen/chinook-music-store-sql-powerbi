-- 0. Sanity Check: Row Count

SELECT COUNT (*) FROM Invoice;

-- 1. Revenue by Country

SELECT
	BillingCountry,
	SUM(Total) AS TotalRevenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC;

-- 2. Revenue and Pricing by Genre

SELECT
    g.Name AS Genre,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue,
    COUNT(il.InvoiceLineId) AS TracksSold,
    ROUND(SUM(il.UnitPrice * il.Quantity) * 1.0 / COUNT(il.InvoiceLineId), 2) AS AvgPricePerTrack
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY AvgPricePerTrack DESC;


-- 3. Top 10 Content by Revenue (includes music artists and TV show franchises,
-- both modeled as "Artists" in this catalog's schema)

SELECT
	ar.Name AS Artist,
	SUM(il.UnitPrice * il.Quantity) AS TotalRevenue,
	COUNT(il.InvoiceLineId) AS TrackSold
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY TotalRevenue DESC
LIMIT 10;


-- 4. Revenue by Support Rep (Employee)

SELECT
	e.FirstName || ' ' || e.LastName AS SupportRep,
	SUM(i.Total) AS TotalRevenue,
	COUNT(DISTINCT i.CustomerId) AS CustomersServed
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId
ORDER BY TotalRevenue DESC;


-- 5. Top 10 Customers by Total Spent

SELECT
	c.FirstName || ' ' || c.LastName AS CustomerName,
	c.Country,
	COUNT(i.InvoiceID) AS NumberOfOrders,
	SUM(i.Total) AS TotalSpent,
	ROUND(SUM(i.Total)*1.0 / COUNT(i.InvoiceId),2) AS AvgOrderValue
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 10;

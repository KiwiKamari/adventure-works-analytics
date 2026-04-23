/* 
TITLE: Ventas Online/Offline
DESCRIPTION: 
Agrupación de las ventas realizadas vía online u offline.
Agrupación de las ventas realizadas por cada cliente via online u offline através de los años.
DATE: 04/03/2026
*/

-- #1 Total en ventas realizadas vía online u offline.
SELECT
	d.SalesOrderID,
	h.CustomerID,
	Case 
		WHEN h.OnlineOrderFlag = 0 THEN 'Offline'
		ELSE 'Online'
	END as SaleType
FROM [AdventureWorks2022].[Sales].[SalesOrderDetail] d
INNER JOIN [AdventureWorks2022].[Sales].[SalesOrderHeader] h
	ON d.SalesOrderID = h.SalesOrderID;





-- #2 Ventas realizadas por cada cliente via online u offline através de los años.
SELECT
	h.CustomerID,
	CONCAT_WS(' ', p.FirstName, p.MiddleName, p.LastName, p.Suffix) AS FullName,
	YEAR(h.OrderDate) AS OrderYear,
	Case 
		WHEN h.OnlineOrderFlag = 0 THEN 'Offline'
		ELSE 'Online'
	END as OrderChannel,
	COUNT(*) AS TotalOrders,
	SUM(h.SubTotal) AS TotalSales,
	SUM(h.SubTotal) / COUNT(*) AS AverageOrderValue
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] h
LEFT JOIN [AdventureWorks2022].[Person].[Person] p
	ON h.CustomerID = p.BusinessEntityID
GROUP BY 
	h.CustomerID,
	YEAR(h.OrderDate),
	CONCAT_WS(' ', p.FirstName, p.MiddleName, p.LastName, p.Suffix),
	Case 
		WHEN h.OnlineOrderFlag = 0 THEN 'Offline'
		ELSE 'Online'
	END
ORDER BY
	CustomerID,
    OrderYear,
    OrderChannel,
    TotalSales DESC;

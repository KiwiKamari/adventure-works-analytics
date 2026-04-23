/* 
TITLE: Información personal de los clientes
DESCRIPTION: 
Nombre completo, ID, residencia y datos demográficos.
DATE: 05/03/2026
*/

WITH cte_CustomerAddress AS(
	SELECT
		b.BusinessEntityID,
		a.AddressLine1,
		a.City,
		t.Name AS AddressType,
		r.CountryRegionName,
		ROW_NUMBER() OVER (
            PARTITION BY b.BusinessEntityID
            ORDER BY 
                CASE 
                    WHEN t.Name = 'Home' THEN 1
                    WHEN t.Name = 'Main Office' THEN 2
                    ELSE 3
                END
        ) AS rn
	FROM [AdventureWorks2022].[Person].[BusinessEntityAddress] b
	LEFT JOIN [AdventureWorks2022].[Person].[Address] a
		ON b.AddressID = a.AddressID
	LEFT JOIN [AdventureWorks2022].[Person].[AddressType] t
		ON b.AddressTypeID = t.AddressTypeID
	LEFT JOIN [AdventureWorks2022].[Person].[vStateProvinceCountryRegion] r
		ON a.StateProvinceID = r.StateProvinceID
),
cte_CustomerSales AS (
	SELECT
		CustomerID,
		COUNT(SalesOrderID) AS TotalOrders,
		SUM(SubTotal) AS TotalRevenue
	FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
	GROUP BY CustomerID
)

SELECT 
	DISTINCT s.CustomerID,
	CONCAT_WS(' ', p.FirstName, p.MiddleName, p.LastName, p.Suffix) AS FullName,
	a.AddressLine1 AS AddressLine,
	a.City,
	a.CountryRegionName,
	d.Gender,
	2014 - YEAR(d.BirthDate) AS Age,
	d.MaritalStatus,
	d.Occupation,
	d.YearlyIncome,
	2014 - YEAR(d.DateFirstPurchase) AS CustomerTenure,
	s.TotalOrders,
	s.TotalRevenue / NULLIF(s.TotalOrders, 0) AS AverageOrderValue,
	s.TotalRevenue,
	CASE
		WHEN s.TotalRevenue / NULLIF(s.TotalOrders, 0) >= 20000 THEN 'High Value'
		ELSE 'Low Value'
	END AS CustomerType
FROM cte_CustomerSales s
LEFT JOIN [AdventureWorks2022].[Person].[Person] p
	ON s.CustomerID = p.BusinessEntityID
LEFT JOIN cte_CustomerAddress a
	ON s.CustomerID = a.BusinessEntityID
	AND a.rn = 1
LEFT JOIN [AdventureWorks2022].[Sales].[vPersonDemographics] d
	ON s.CustomerID = d.BusinessEntityID;



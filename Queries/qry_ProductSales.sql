/* 
TITLE: KPI de Costo/Beneficio de cada Producto
DESCRIPTION: 
Datos de revenue (ingresos), costos, cantidades vendidas, profit (utilidad) y margen de ganancias de cada producto
DATE: 05/03/2026
*/

WITH cte_SalesWithCost AS ( -- Obtener el costo correcto para cada venta
    SELECT
        d.ProductID,
        d.OrderQty,
        d.LineTotal,
        c.StandardCost,
		d.ModifiedDate
    FROM Sales.SalesOrderDetail d
    OUTER APPLY ( -- Obtiene la fecha del costo más cercana a la fecha de venta
        SELECT TOP 1 StandardCost
        FROM Production.ProductCostHistory c
        WHERE c.ProductID = d.ProductID
        AND c.StartDate <= d.ModifiedDate
        ORDER BY c.StartDate DESC
    ) c
), cte_ProductSales AS ( -- Agregar ventas y costos
    SELECT
        ProductID,
        SUM(OrderQty) AS Quantity,
        SUM(LineTotal) AS Revenue,
        SUM(StandardCost * OrderQty) AS TotalCost
    FROM cte_SalesWithCost
    GROUP BY ProductID
), cte_Category AS (
	SELECT
		s.ProductSubcategoryID,
		s.Name AS Subcategory,
		c.Name AS Category
	FROM [AdventureWorks2022].[Production].[ProductSubcategory] s
	INNER JOIN [AdventureWorks2022].[Production].[ProductCategory] c
		ON s.ProductCategoryID = c.ProductCategoryID
)
SELECT
	p.ProductID,
	p.Name,
	c.Category,
	c.Subcategory,
	p.ListPrice as 'ActualPrice',
	COALESCE(s.Revenue,0) AS Revenue,
	COALESCE(s.TotalCost,0) AS TotalCost,
	COALESCE(s.Quantity,0) AS Quantity,
	(COALESCE(s.Revenue,0) - COALESCE(s.TotalCost,0)) AS 'Profit',
	(COALESCE(s.Revenue,0) - COALESCE(s.TotalCost,0)) / NULLIF(s.Revenue,0) * 100 AS 'Margin%'
FROM Production.Product p
LEFT JOIN cte_ProductSales s
	ON p.ProductID = s.ProductID
LEFT JOIN cte_Category c
	ON p.ProductSubcategoryID = c.ProductSubcategoryID
ORDER BY [Profit] DESC

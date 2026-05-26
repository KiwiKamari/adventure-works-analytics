/* 
TITLE: KPI de Costo/Beneficio de cada Producto
DESCRIPTION: 
Datos de revenue (ingresos), costos, cantidades vendidas, profit (utilidad) y margen de ganancias de cada producto
DATE: 05/03/2026
*/

CREATE OR ALTER VIEW vw_ProductSales AS
WITH cte_SalesWithCost AS (
    SELECT
        d.ProductID,

        /* Cantidad vendida por línea */
        d.OrderQty,

        /* Ingreso por línea */
        d.LineTotal,

        /* Costo unitario histórico */
        c.StandardCost,

        /* Fecha de la venta */
        d.ModifiedDate,

		/* Fecha calendario para análisis temporal */
        DATEFROMPARTS(
            YEAR(h.OrderDate),
            MONTH(h.OrderDate),
            1
        ) AS YearMonth

    FROM Sales.SalesOrderDetail d

    /* FECHA REAL DE VENTA */
    INNER JOIN Sales.SalesOrderHeader h
        ON d.SalesOrderID = h.SalesOrderID

    /* COSTO HISTÓRICO (más cercano a la fecha de venta) */
    OUTER APPLY (
        SELECT TOP 1 StandardCost
        FROM Production.ProductCostHistory c
        WHERE c.ProductID = d.ProductID
        AND c.StartDate <= d.ModifiedDate
        ORDER BY c.StartDate DESC
    ) c
),

cte_ProductSales AS (
    SELECT
        ProductID,
		YearMonth,

        /* Total de unidades vendidas */
        SUM(OrderQty) AS Quantity,

        /* Revenue total */
        SUM(LineTotal) AS Revenue,

        /* Costo total (costo unitario * cantidad) */
        SUM(StandardCost * OrderQty) AS TotalCost

    FROM cte_SalesWithCost
    GROUP BY 
		ProductID,
        YearMonth
),

cte_Category AS (
    SELECT
        s.ProductSubcategoryID,

        /* Subcategoría del producto */
		s.Name AS Subcategory,

        /* Categoría principal */
        c.Name AS Category

    FROM AdventureWorks2022.Production.ProductSubcategory s

    /* CATEGORÍA */
    INNER JOIN AdventureWorks2022.Production.ProductCategory c
        ON s.ProductCategoryID = c.ProductCategoryID
)

SELECT
    p.ProductID,

    /* Nombre del producto */
    p.Name,

	/* Tiempo */
    s.YearMonth,

    /* Clasificación */
    COALESCE(c.Category, 'Uncategorized') AS Category,
    COALESCE(c.Subcategory, 'Uncategorized') AS Subcategory,

    /* Precio de lista actual */
    p.ListPrice AS ActualPrice,

    /* Métricas */
    COALESCE(s.Revenue, 0) AS Revenue,
    COALESCE(s.TotalCost, 0) AS TotalCost,
    COALESCE(s.Quantity, 0) AS Quantity,

    /* Utilidad */
    (COALESCE(s.Revenue, 0) - COALESCE(s.TotalCost, 0)) AS Profit,

    /* Margen (%) */
    (COALESCE(s.Revenue, 0) - COALESCE(s.TotalCost, 0)) 
        / NULLIF(s.Revenue, 0) * 100 AS [Margin%]

FROM Production.Product p

/* VENTAS */
LEFT JOIN cte_ProductSales s
    ON p.ProductID = s.ProductID

/* CATEGORÍA */
LEFT JOIN cte_Category c
    ON p.ProductSubcategoryID = c.ProductSubcategoryID;
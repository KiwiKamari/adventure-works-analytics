/* 
TITLE: Ventas Online vs Offline por Cliente (Modelo Analítico Correcto)
DESCRIPTION: 
Dataset agregado por cliente, año y canal con:
- Revenue
- AOV
- Clasificación de canal
- Tipo de cliente (Omnichannel / Single Channel)

DATE: 04/03/2026
*/

CREATE OR ALTER VIEW vw_OnlineOfflineSales AS
WITH cte_CustomerBase AS (
    SELECT
        h.CustomerID,
        c.PersonID,
        h.OrderDate,
        h.SubTotal,

        /* Canal de compra */
        CASE 
            WHEN h.OnlineOrderFlag = 0 THEN 'Offline'
            ELSE 'Online'
        END AS OrderChannel

    FROM AdventureWorks2022.Sales.SalesOrderHeader h

    /* CLIENTE */
    LEFT JOIN AdventureWorks2022.Sales.Customer c
        ON h.CustomerID = c.CustomerID
),

cte_ChannelAgg AS (
    SELECT
        CustomerID,

        /* Año de la orden */
        YEAR(OrderDate) AS OrderYear,

        /* Canal */
        OrderChannel,

        /* Métricas por cliente/año/canal */
        COUNT(*) AS TotalOrders,
        SUM(SubTotal) AS TotalSales,
        SUM(SubTotal) / COUNT(*) AS AverageOrderValue

    FROM cte_CustomerBase
    GROUP BY
        CustomerID,
        YEAR(OrderDate),
        OrderChannel
),

cte_ChannelType AS (
    SELECT
        CustomerID,

        /* Tipo de cliente por uso de canal */
        CASE 
            WHEN COUNT(DISTINCT OrderChannel) = 2 THEN 'Omnichannel'
            ELSE 'Single Channel'
        END AS CustomerChannelType

    FROM cte_CustomerBase
    GROUP BY CustomerID
)

SELECT
    a.CustomerID,

    /* Nombre */
    CASE
	    WHEN c.PersonID IS NOT NULL
	        THEN TRIM(CONCAT_WS(' ',
	            p.FirstName,
	            NULLIF(p.MiddleName, ''),
	            p.LastName,
	            NULLIF(p.Suffix, '')
	        ))
	    WHEN c.StoreID IS NOT NULL
	        THEN s.Name
	END AS FullName,

    a.OrderYear,

    /* Canal de la orden */
    a.OrderChannel,

    /* Métricas */
    a.TotalOrders,
    a.TotalSales,
    a.AverageOrderValue,

    /* Tipo de cliente (global) */
    ct.CustomerChannelType

FROM cte_ChannelAgg a

/* CLIENTE */
LEFT JOIN AdventureWorks2022.Sales.Customer c
    ON a.CustomerID = c.CustomerID

/* PERSONA */
LEFT JOIN AdventureWorks2022.Person.Person p
    ON c.PersonID = p.BusinessEntityID

/* STORE (para B2B) */
LEFT JOIN AdventureWorks2022.Sales.Store s
    ON c.StoreID = s.BusinessEntityID

/* CLASIFICACIÓN DE CANAL */
LEFT JOIN cte_ChannelType ct
    ON a.CustomerID = ct.CustomerID;
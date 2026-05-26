/* 
TITLE: Customer Analytical Dataset (B2B + B2C Enriquecido - Sin Duplicados)
DESCRIPTION: 
Dataset unificado con resolución de duplicados en Store:
- B2C → Person + Demographics
- B2B → Store limpio (una fila por cliente)
Fecha de simulación: 2014-12-31

DATE: 05/03/2026
*/

CREATE OR ALTER VIEW vw_CustomerInfo AS 
WITH  cte_Ref AS (
    SELECT CAST('2014-12-31' AS DATE) AS RefDate
),

cte_CustomerSales AS (
    SELECT
        CustomerID,

        /* Total de órdenes */
        COUNT(SalesOrderID) AS TotalOrders,

        /* Revenue total */
        SUM(SubTotal) AS TotalRevenue,

		/* Primera Compra */
		MIN(OrderDate) AS FirstOrderDate,   

		/* Ultima Compra */
        MAX(OrderDate) AS LastOrderDate
    FROM AdventureWorks2022.Sales.SalesOrderHeader
    GROUP BY CustomerID
),

cte_CustomerAOV AS (
	SELECT
        s.CustomerID,
        s.TotalOrders,
        s.TotalRevenue,
        s.FirstOrderDate,
        s.LastOrderDate,

        /* Ticket promedio */
        s.TotalRevenue / NULLIF(s.TotalOrders, 0) AS AverageOrderValue,

        /*
          Tenure en MESES desde primera orden hasta fecha de referencia.
          Se usa MESES porque en el universo 2014 la mayoría tiene 0-3 años
          de historial → años colapsa demasiados clientes en los mismos valores.
        */
        DATEDIFF(
            MONTH,
            s.FirstOrderDate,
            r.RefDate
        ) AS CustomerTenure_Months

    FROM cte_CustomerSales s
    CROSS JOIN cte_Ref r
),

/* STORE ADDRESS (SIN DUPLICADOS) */
cte_StoreAddress AS (
    SELECT
        sa.*,

        /* 
        Prioridad:
        1 = Main Office
        2 = Shipping
        */
        ROW_NUMBER() OVER (
            PARTITION BY sa.BusinessEntityID
            ORDER BY 
                CASE 
                    WHEN sa.AddressType = 'Main Office' THEN 1
                    WHEN sa.AddressType = 'Shipping' THEN 2
                    ELSE 3
                END
        ) AS rn

    FROM AdventureWorks2022.Sales.vStoreWithAddresses sa
),

/* CUSTOMER ADDRESS (SIN DUPLICADOS) */
cte_CustomerAddress AS( 
	SELECT 
		b.BusinessEntityID,
        a.AddressLine1,
        a.City,
        t.Name              AS AddressType,
        r2.CountryRegionName,
        ROW_NUMBER() OVER (
            PARTITION BY b.BusinessEntityID
            ORDER BY
                CASE t.Name
                    WHEN 'Home'        THEN 1
                    WHEN 'Main Office' THEN 2
                    ELSE                    3
                END
        ) AS rn
    FROM AdventureWorks2022.Person.BusinessEntityAddress b
    LEFT JOIN AdventureWorks2022.Person.Address a  
		ON b.AddressID = a.AddressID
    LEFT JOIN AdventureWorks2022.Person.AddressType t  
		ON b.AddressTypeID = t.AddressTypeID
    LEFT JOIN AdventureWorks2022.Person.vStateProvinceCountryRegion r2
		ON a.StateProvinceID = r2.StateProvinceID
),

/* STORE DEMOGRAPHICS */
cte_StoreDemo AS (
    SELECT
        sd.*,
        ROW_NUMBER() OVER (
            PARTITION BY sd.BusinessEntityID
            ORDER BY sd.AnnualRevenue DESC   -- criterio de negocio; ajustar si aplica otro
        ) AS rn
    FROM AdventureWorks2022.Sales.vStoreWithDemographics sd
)

SELECT 
    c.CustomerID,

	/* Ha comprado */
	CASE
		WHEN s.CustomerID IS NULL THEN 0
		ELSE 1
	END AS HasPurchases,

    /* Segmentación */
    CASE 
        WHEN c.StoreID IS NOT NULL AND c.PersonID IS NOT NULL	THEN 'B2B_Contact'
        WHEN c.StoreID IS NOT NULL								THEN 'B2B'
        WHEN c.PersonID IS NOT NULL								THEN 'B2C'
        ELSE 'Unclassified'
    END AS CustomerType,

    /* Nombre */
    CASE
        WHEN c.PersonID IS NOT NULL
            THEN TRIM(CONCAT_WS(' ',
                    p.FirstName,
                    NULLIF(p.MiddleName, ''),   -- evita doble espacio si MiddleName = ''
                    p.LastName,
                    NULLIF(p.Suffix, '')        -- evita espacio colgante si Suffix es NULL/vacío
                ))
        WHEN c.StoreID IS NOT NULL THEN sa.Name
    END AS FullName,

    /* Dirección */
	CASE
	    WHEN c.StoreID IS NOT NULL THEN COALESCE(sa.AddressLine1, 'Unknown') 
	    WHEN c.PersonID IS NOT NULL AND a.AddressLine1 IS NOT NULL THEN a.AddressLine1
	    ELSE 'Unknown'
	END AS AddressLine,

	CASE
		WHEN c.StoreID IS NOT NULL THEN COALESCE(sa.City, 'Unknown')
		WHEN c.PersonID IS NOT NULL THEN COALESCE(a.City, 'Unknown')
	END AS City,

	CASE
		WHEN c.StoreID IS NOT NULL THEN COALESCE(sa.CountryRegionName, 'Unknown')
		WHEN c.PersonID IS NOT NULL THEN COALESCE(a.CountryRegionName, 'Unknown')
	END AS Country,

    /* DEMOGRAFÍA B2C */
    CASE WHEN c.PersonID IS NOT NULL THEN d.Gender END AS Gender,

    CASE
        WHEN c.PersonID IS NOT NULL AND d.BirthDate IS NOT NULL
        THEN YEAR(r.RefDate) - YEAR(d.BirthDate)
    END AS Age,

	/*
      YearlyIncome: campo de texto con rangos (e.g. '75001-100000').
      NO es un valor numérico. En Power BI tratar como categoría ordinal
      o crear columna calculada DAX para extraer el valor medio del rango.
    */
    CASE WHEN c.PersonID IS NOT NULL THEN COALESCE(d.MaritalStatus, 'Unknown')	END AS MaritalStatus,
    CASE WHEN c.PersonID IS NOT NULL THEN COALESCE(d.Occupation, 'Unknown')		END AS Occupation,
    CASE WHEN c.PersonID IS NOT NULL THEN COALESCE(d.YearlyIncome, 'Unknown')	END AS YearlyIncome,

    /* DEMOGRAFÍA B2B */
    CASE WHEN c.StoreID IS NOT NULL THEN sd.AnnualRevenue	END AS StoreAnnualRevenue,
    CASE WHEN c.StoreID IS NOT NULL THEN sd.NumberEmployees END AS StoreEmployees,
    CASE 
	    WHEN c.StoreID IS NOT NULL THEN
	        CASE sd.BusinessType
	            WHEN 'OS' THEN 'Only Store'
	            WHEN 'BS' THEN 'Bike Store'
	            WHEN 'BM' THEN 'Bike Manufacturer'
	            ELSE 'Unknown Business Type'
	        END
	END AS StoreType,
    CASE WHEN c.StoreID IS NOT NULL THEN sd.YearOpened END AS StoreYearOpened,

    /* MÉTRICAS */
    s.FirstOrderDate,
    s.LastOrderDate,
    s.TotalOrders,
    s.TotalRevenue,
    s.AverageOrderValue,

	s.CustomerTenure_Months
FROM AdventureWorks2022.Sales.Customer c

CROSS JOIN cte_Ref r

/* Órdenes y métricas (LEFT: incluye clientes sin órdenes) */
LEFT JOIN cte_CustomerAOV  s   ON c.CustomerID  = s.CustomerID

/* Persona */
LEFT JOIN AdventureWorks2022.Person.Person p
    ON c.PersonID = p.BusinessEntityID

/* Demografía persona */
LEFT JOIN AdventureWorks2022.Sales.vPersonDemographics d
    ON c.PersonID = d.BusinessEntityID

/* Store address (rn=1: Main Office > Shipping > resto) */
LEFT JOIN cte_StoreAddress sa
    ON c.StoreID = sa.BusinessEntityID AND sa.rn = 1

/* Customer address (rn=1: Home > Main Office > resto) */
LEFT JOIN cte_CustomerAddress a
    ON c.PersonID = a.BusinessEntityID AND a.rn = 1

/* Store demographics (rn=1: mayor AnnualRevenue primero) */
LEFT JOIN cte_StoreDemo sd
    ON c.StoreID = sd.BusinessEntityID AND sd.rn = 1;
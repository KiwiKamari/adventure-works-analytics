/* 
TITLE: Pareto for B2B Customers
DESCRIPTION: 
- Pareto analysis for B2B Customers.

Fecha de simulación: 2014-12-31

DATE: 15/03/2026
*/

CREATE OR ALTER VIEW vw_ParetoB2B AS
WITH RankedCustomers AS (
    SELECT
        r.CustomerID,
        i.TotalRevenue,
        ROW_NUMBER() OVER (
			ORDER BY i.TotalRevenue DESC, r.CustomerID
		) AS CustomerRank
    FROM [AdventureWorks2022].[dbo].[vw_CustomerRFM_B2B] r
	LEFT JOIN [AdventureWorks2022].[dbo].[vw_CustomerInfo] i
		ON r.CustomerID = i.CustomerID
),

ParetoCalc AS (
    SELECT
        CustomerID,
        TotalRevenue,
        CustomerRank,
        SUM(TotalRevenue) OVER (
            ORDER BY TotalRevenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS CumulativeRevenue,
        SUM(TotalRevenue) OVER () AS TotalRevenueAll
    FROM RankedCustomers
)

SELECT
    CustomerID,
    TotalRevenue,
    CustomerRank,
    CumulativeRevenue,
    CAST(CumulativeRevenue * 1.0 / TotalRevenueAll AS DECIMAL(10,4)) AS ParetoPct,
    CASE
        WHEN CumulativeRevenue * 1.0 / TotalRevenueAll <= 0.8
            THEN 'Top 80%'
        ELSE 'Bottom 20%'
    END AS ParetoGroup
FROM ParetoCalc;

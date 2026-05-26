/* 
TITLE: Ventas anuales
DESCRIPTION: 
Crecimiento de ventas a través de los años (MoM y YoY)
DATE: 09/03/2026
*/

CREATE OR ALTER VIEW vw_AnnualSales AS
WITH cte_RevenueByMonth AS (
    SELECT
        /* Normalización a primer día del mes */
        DATEFROMPARTS(
            YEAR(h.OrderDate),
            MONTH(h.OrderDate),
            1
        ) AS YearMonth,

        /* Revenue mensual */
        SUM(d.LineTotal) AS Revenue

    FROM Sales.SalesOrderHeader h

    /* DETALLE DE VENTAS */
    JOIN Sales.SalesOrderDetail d
        ON h.SalesOrderID = d.SalesOrderID

    GROUP BY 
        YEAR(h.OrderDate), 
        MONTH(h.OrderDate)
),

cte_LagRevenue AS (
    SELECT
        YearMonth,

        /* Revenue actual */
        Revenue,

        /* Revenue del mes anterior */
        LAG(Revenue, 1) OVER (ORDER BY YearMonth) AS PrevMonthRevenue,

        /* Revenue del mismo mes año anterior */
        LAG(Revenue, 12) OVER (ORDER BY YearMonth) AS PrevYearRevenue

    FROM cte_RevenueByMonth
)

SELECT
    YearMonth,

    /* Métrica base */
    Revenue,

    PrevMonthRevenue,

    /* Crecimiento mes contra mes (%) */
    (Revenue - PrevMonthRevenue) * 1.0
        / NULLIF(PrevMonthRevenue, 0) AS MoM_Growth,

    PrevYearRevenue,

    /* Crecimiento año contra año (%) */
    (Revenue - PrevYearRevenue) * 1.0
        / NULLIF(PrevYearRevenue, 0) AS YoY_Growth

FROM cte_LagRevenue;



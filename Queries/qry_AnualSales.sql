/* 
TITLE: Ventas anuales
DESCRIPTION: 
Crecimiento de ventas a través de los años
DATE: 09/03/2026
*/

WITH cte_RevenueByMonth AS (
    SELECT
        DATEFROMPARTS(YEAR(h.OrderDate), MONTH(h.OrderDate), 1) AS YearMonth,
        SUM(d.LineTotal) AS Revenue
    FROM Sales.SalesOrderHeader h
    JOIN Sales.SalesOrderDetail d
        ON h.SalesOrderID = d.SalesOrderID
    GROUP BY YEAR(h.OrderDate), MONTH(h.OrderDate)
),
cte_LagRevenue AS (
    SELECT
        YearMonth,
        Revenue,
        LAG(Revenue,1) OVER (ORDER BY YearMonth) AS PrevMonthRevenue,
        LAG(Revenue,12) OVER (ORDER BY YearMonth) AS PrevYearRevenue
    FROM cte_RevenueByMonth
)
SELECT
    YearMonth,
    Revenue,
    PrevMonthRevenue,
    (Revenue - PrevMonthRevenue)
        / NULLIF(PrevMonthRevenue,0) * 100 AS MoM_Growth,
    PrevYearRevenue,
    (Revenue - PrevYearRevenue)
        / NULLIF(PrevYearRevenue,0) * 100 AS YoY_Growth
FROM cte_LagRevenue
ORDER BY YearMonth;



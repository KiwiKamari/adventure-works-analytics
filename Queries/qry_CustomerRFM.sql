/* 
TITLE: RFM Scoring de Clientes
DESCRIPTION: 
Valora a los clientes en base a su puntaución de RFM.
Esta valor 
R = Recency (Tiempo desde la última compra)
F = Frecuency (Número de órdenes)
M = Monetary (Dinero total gastado)
DATE: 05/03/2026
*/

WITH cte_CustomerRFM AS (
	SELECT
		h.CustomerID,
		DATEDIFF(day, MAX(OrderDate), '2014-12-31') AS Recency,
		COUNT(h.SalesOrderID) AS Frecuency,
		SUM(h.SubTotal) AS Monetary,
		NTILE(5) OVER (ORDER BY DATEDIFF(day, MAX(OrderDate), '2014-12-31') DESC) AS R_Score,
		NTILE(5) OVER (ORDER BY COUNT(h.SalesOrderID)) AS F_Score,
		NTILE(5) OVER (ORDER BY SUM(h.SubTotal)) AS M_Score
	FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] h
	GROUP BY
		h.CustomerID
),
cte_RFMScore AS (
	SELECT *,
		R_Score*100 + F_Score*10 + M_Score AS RFMScore
	FROM cte_CustomerRFM
)
SELECT
    CustomerID,
	R_Score,
	F_Score,
	M_Score,
	CASE 
		WHEN RFMScore = 555 THEN 'Champions'
		WHEN RFMScore BETWEEN 400 AND 554 THEN 'Loyal'
		WHEN RFMScore BETWEEN 300 AND 399 THEN 'Potencial'
		WHEN RFMScore BETWEEN 200 AND 299 THEN 'At Risk'
		ELSE 'Lost'
	END AS Segment
FROM cte_RFMScore 
ORDER BY RFMScore DESC

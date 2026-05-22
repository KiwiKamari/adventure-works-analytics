/* 
TITLE: RFM Scoring de Clientes B2C
DESCRIPTION: 
Segmentación de clientes basada en modelo RFM (Recency, Frequency, Monetary).

- R (Recency): Días desde la última compra respecto a una fecha de corte
- F (Frequency): Número total de órdenes realizadas
- M (Monetary): Ingreso total generado por el cliente

Se asignan scores del 1 al 5 usando NTILE (quintiles) para cada dimensión.
Posteriormente se construye un score compuesto (RFMScore) para clasificar clientes.

DATE: 05/03/2026

*/

/* ════════════════════════════════════════════════════════════════════
   VIEW 1 — vw_CustomerRFM_B2C
   Población: clientes con PersonID y sin StoreID (consumidores puros)
   Fecha de referencia: 2014-12-31
   ════════════════════════════════════════════════════════════════════ */

CREATE OR ALTER VIEW vw_CustomerRFM_B2C AS

WITH cte_Ref AS (
    SELECT CAST('2014-12-31' AS DATE) AS RefDate
),

cte_RFM AS (
    SELECT
        h.CustomerID,
        DATEDIFF(DAY, MAX(h.OrderDate), r.RefDate)	AS Recency,
        COUNT(h.SalesOrderID)						AS Frequency,
        SUM(h.SubTotal)								AS Monetary,

        /*
          NTILE calculado exclusivamente sobre la población B2C.
          Los quintiles son internamente comparables: un M=5 aquí
          significa top 20% de gasto dentro de consumidores, no
          compite contra transacciones B2B de $18K+.
        */
        NTILE(5) OVER (
            ORDER BY DATEDIFF(DAY, MAX(h.OrderDate), r.RefDate) DESC
        ) AS R_Score,

        NTILE(5) OVER (
            ORDER BY COUNT(h.SalesOrderID)
        ) AS F_Score,

        NTILE(5) OVER (
            ORDER BY SUM(h.SubTotal)
        ) AS M_Score

    FROM AdventureWorks2022.Sales.SalesOrderHeader h
    CROSS JOIN cte_Ref r

    /* B2C puro: tiene persona, no tiene tienda */
    INNER JOIN AdventureWorks2022.Sales.Customer c
        ON  h.CustomerID = c.CustomerID
        AND c.PersonID   IS NOT NULL
        AND c.StoreID    IS NULL

    GROUP BY h.CustomerID, r.RefDate
),

cte_Score AS (
    SELECT
        *,
        R_Score * 100 + F_Score * 10 + M_Score AS RFMScore
    FROM cte_RFM
)

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    RFMScore,

	CASE
		WHEN R_Score =  1 AND F_Score =  1 AND M_Score <= 2 THEN 'Lost'	

		/* TOP */
		WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'VIP'

		/* NUEVOS */
		WHEN R_Score = 5 AND F_Score = 1 THEN 'New'

		/* LEALES */
		WHEN R_Score >= 3 AND F_Score >= 4 THEN 'Loyal'

		/* POTENCIALES */
		WHEN R_Score >= 4 AND F_Score BETWEEN 2 AND 3 THEN 'Promising'

		/* EN RIESGO */
		WHEN R_Score <= 2 AND F_Score >= 3 THEN 'At Risk'

		/* BAJO VALOR RECIENTE */
		WHEN R_Score >= 3 AND M_Score <= 2 THEN 'Low Value Active'

		/* INACTIVOS */
		WHEN R_Score <= 2 AND F_Score <= 2 THEN 'Hibernating'

		/* RESTO CONTROLADO */
		ELSE 'Need Attention'
	END AS Segment,

    /* Etiqueta de población para cuando ambas CustomerRFM views se unan en Power BI */
    'B2C' AS CustomerPopulation

FROM cte_Score;

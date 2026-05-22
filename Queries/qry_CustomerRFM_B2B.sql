/* 
TITLE: RFM Scoring de Clientes B2B
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
   VIEW 2 — vw_CustomerRFM_B2B
   Población: B2B puro (StoreID sin PersonID)
            + B2B_Contact (StoreID + PersonID)
   Fecha de referencia: 2014-12-31
   ════════════════════════════════════════════════════════════════════ */

CREATE OR ALTER VIEW vw_CustomerRFM_B2B AS

WITH cte_Ref AS (
    SELECT CAST('2014-12-31' AS DATE) AS RefDate
),

cte_RFM AS (
    SELECT
        c.CustomerID,
        DATEDIFF(DAY, MAX(h.OrderDate), r.RefDate)	AS Recency,
        COUNT(h.SalesOrderID)						AS Frequency,
        SUM(h.SubTotal)								AS Monetary,

        /*
          NTILE calculado exclusivamente sobre la población B2B.
          Con AOV de ~$18K, el M_Score refleja valor real entre empresas,
          no se distorsiona por comparación con consumidores B2C.
        */
        NTILE(5) OVER (
            ORDER BY DATEDIFF(DAY, MAX(h.OrderDate), r.RefDate) DESC
        ) AS R_Score,

        /*
          F_Score B2B: en este universo, 6+ órdenes = cliente ancla.
          NTILE distribuye automáticamente, pero los umbrales del CASE
          están calibrados asumiendo que F=4-5 equivale a 4-6+ órdenes
          (vs 10-15+ en B2C). Ver segmentación abajo.
        */
        NTILE(5) OVER (
            ORDER BY COUNT(h.SalesOrderID)
        ) AS F_Score,

        NTILE(5) OVER (
            ORDER BY SUM(h.SubTotal)
        ) AS M_Score

    FROM AdventureWorks2022.Sales.SalesOrderHeader h
    CROSS JOIN cte_Ref r

    /*
      B2B + B2B_Contact: tiene StoreID (con o sin PersonID).
      Excluye explícitamente B2C puro (StoreID IS NULL AND PersonID IS NOT NULL).
    */
    INNER JOIN AdventureWorks2022.Sales.Customer c
        ON  h.CustomerID = c.CustomerID
        AND c.StoreID    IS NOT NULL

    GROUP BY c.CustomerID, r.RefDate
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
	
	    /* CLIENTES ESTRATÉGICOS */
	    WHEN R_Score >= 4 AND F_Score >= 3 AND M_Score >= 4 THEN 'VIP'
	
	    /* GRANDES PERO IRREGULARES */
	    WHEN M_Score >= 4 AND F_Score <= 2 THEN 'High Value - Low Frequency'
	
	    /* CLIENTES ACTIVOS */
	    WHEN R_Score >= 4 AND F_Score >= 3 THEN 'Active Loyal'
	
	    /* NUEVOS */
	    WHEN R_Score = 5 AND F_Score = 1 THEN 'New Account'
	
	    /* EN RIESGO (IMPORTANTE EN B2B) */
	    WHEN R_Score <= 2 AND M_Score >= 3 THEN 'At Risk'
	
	    /* BAJO VALOR */
	    WHEN M_Score <= 2 AND F_Score <= 2 THEN 'Low Value'
	
	    /* INACTIVOS */
	    WHEN R_Score <= 2 THEN 'Inactive'
	
	    ELSE 'Medium Value'
	
	END AS Segment,

    /* Etiqueta de población para cuando ambas CustomerRFM views se unan en Power BI */
    'B2B' AS CustomerPopulation

FROM cte_Score;

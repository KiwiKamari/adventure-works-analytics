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

    /*
      Segmentación B2B con mismos nombres que B2C para facilitar
      comparación en Power BI, pero umbrales ajustados al contexto:

        Champions     → Empresa reciente, frecuente y de alto valor
                        En B2B basta F>=3 porque 3-4 órdenes grandes
                        ya define una relación sólida
        Loyal         → Alto valor y frecuencia, aunque no tan reciente
        Promising     → Reciente pero aún con pocas órdenes
                        (relación nueva, potencial sin desarrollar)
        At Risk       → Antes valiosos, ahora inactivos
                        R<=2 = no compra hace tiempo en este universo
        Need Attention→ Recencia media, una sola transacción
        Lost          → Sin actividad reciente y sin historial relevante
        Others        → Casos intermedios (ej: R=2, F=2, M=4)
    */
	-- Aplica igual a B2C y B2B, solo cambian los umbrales numéricos


    /*-- Mejor cliente posible: reciente, frecuente y monetario alto
    WHEN R_Score >= 4 AND F_Score >= 3 AND M_Score >= 4 THEN 'Champions'   -- B2B

    -- Alto valor y frecuencia aunque no tan reciente
    WHEN F_Score >= 3 AND M_Score >= 4               THEN 'Loyal'           -- B2B

    -- Reciente y frecuente pero monetario aún bajo
    -- CLAVE: cubre el hueco de 542/541/442
    WHEN R_Score >= 4                                THEN 'Promising'        -- B2B (cualquier reciente no capturado arriba)

    -- Antes valiosos, ahora inactivos
    WHEN R_Score <= 2 AND M_Score >= 3                  THEN 'At Risk'

    -- Inactivos de bajo valor — no son Lost, son dormidos
    WHEN R_Score <= 2 AND M_Score <= 2                  THEN 'Hibernating'

    -- R medio, actividad baja — necesitan estímulo
    -- IMPORTANTE: R>=2 para no capturar R=1 que ya fue a Hibernating
    WHEN R_Score = 3  AND F_Score <= 2                  THEN 'Need Attention'

    -- Residual real: lo que queda aquí SÍ es Lost
    ELSE                                                     'Lost'
	END AS Segment,*/

    /*CASE
	    WHEN R_Score =  1 AND F_Score =  1 AND M_Score <= 2 THEN 'Lost'				-- Activo que ha generado poco, con nula frecuencia y ultima compra hace mucho tiempo
		WHEN R_Score =  5 AND F_Score =  1 AND M_Score <= 2 THEN 'New'				-- Nuevos Clientes
	    WHEN R_Score >= 4 AND F_Score >= 3 AND M_Score >= 4 THEN 'Champions'
	    WHEN F_Score >= 3 AND M_Score >= 4                  THEN 'Loyal'
	    WHEN R_Score >= 4 AND F_Score <  3                  THEN 'Promising'
	    WHEN R_Score <= 2 AND M_Score >= 3                  THEN 'At Risk'
	    WHEN R_Score <= 3 AND F_Score <= 2                  THEN 'Need Attention'
	    WHEN R_Score <= 2 AND M_Score <= 2                  THEN 'Hibernating' -- inactivos de bajo valor
		ELSE 'Others'
	END AS Segment,*/

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
### 4. Customer B2C Segmentation & RFM Analysis

Developed a B2C-focused RFM segmentation model to analyze consumer purchasing behavior, loyalty, and revenue contribution.

> [!IMPORTANT] 
> RFM models were computed exclusively using customers with transactional history available in `SalesOrderHeader`.  
> Customers without purchases were intentionally excluded from Recency, Frequency, and Monetary calculations to preserve analytical validity.

**Key Metrics**

- Recency
- Frequency
- Monetary Value
- RFM Scores
- Customer Segment
- Revenue Contribution
- Pareto Distribution

**Technical Approach**

- Built a dedicated B2C analytical model using:
  - Customers with `PersonID IS NOT NULL`
  - Customers with `StoreID IS NULL`
- Calculated:
  - `Recency` using `DATEDIFF`
  - `Frequency` using total order count
  - `Monetary` using aggregated customer revenue
- Used `NTILE(5)` window functions to generate:
  - `R_Score`
  - `F_Score`
  - `M_Score`
- Constructed a composite RFM score:
  - `R_Score * 100 + F_Score * 10 + M_Score`
- Developed consumer-oriented segmentation logic using `CASE`:
  - VIP
  - Loyal
  - Promising
  - New
  - At Risk
  - Hibernating
  - Low Value Active
  - Need Attention
  - Lost
- Used a fixed analytical reference date (`2014-12-31`) to maintain consistency across customer evaluations
- Separated B2C scoring logic from B2B populations to ensure meaningful percentile distribution within consumer purchasing behavior

***Pareto Analysis***

Implemented a Pareto revenue distribution model to identify revenue concentration among top consumer customers.

**Technical Approach**

- Ranked customers by revenue contribution using `ROW_NUMBER()`
- Calculated cumulative revenue with windowed `SUM() OVER`
- Computed Pareto percentage contribution:
  - `CumulativeRevenue / TotalRevenueAll`
- Classified customers into:
  - `Top 80%`
  - `Bottom 20%`
- Combined RFM segmentation with customer revenue analysis through analytical joins

**Business Value**

- Identifies high-value and loyal customers
- Detects inactive and at-risk consumers
- Reveals revenue concentration patterns within the B2C customer base
- Supports retention, loyalty, and targeting strategies
- Enables customer prioritization using Pareto-based analysis

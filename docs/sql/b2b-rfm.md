### 3. Customer B2B Segmentation & RFM Analysis

Developed a B2B-focused RFM segmentation model to analyze customer value, engagement, and revenue concentration across business accounts.

> **Methodological Note:**  
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

- Built a dedicated B2B analytical model using:
  - Customers with `StoreID IS NOT NULL`
  - Inclusion of `B2B_Contact` accounts
  - Exclusion of pure B2C customers
- Calculated:
  - `Recency` using `DATEDIFF`
  - `Frequency` using total order count
  - `Monetary` using total customer revenue
- Used `NTILE(5)` window functions to assign:
  - `R_Score`
  - `F_Score`
  - `M_Score`
- Generated a composite RFM score:
  - `R_Score * 100 + F_Score * 10 + M_Score`
- Created business-oriented segmentation logic using `CASE`:
  - VIP
  - Active Loyal
  - High Value - Low Frequency
  - At Risk
  - Inactive
  - Low Value
- Used a fixed reference date (`2014-12-31`) to simulate analytical consistency across the dataset
- Designed scoring independently from B2C customers to avoid distortion caused by significantly larger B2B transaction sizes

***Pareto Analysis***

Implemented a Pareto revenue model to identify the concentration of revenue among top-performing B2B customers.

**Technical Approach**

- Ranked customers by total revenue using `ROW_NUMBER()`
- Calculated cumulative revenue using windowed `SUM() OVER`
- Computed Pareto contribution percentage:
  - `CumulativeRevenue / TotalRevenueAll`
- Classified customers into:
  - `Top 80%`
  - `Bottom 20%`
- Integrated RFM and customer profitability datasets through analytical joins

**Business Value**

- Identifies the highest-value business accounts
- Detects strategic customers at risk of churn
- Highlights revenue concentration across the customer base
- Supports account prioritization and retention strategies
- Enables Pareto-based revenue optimization analysis



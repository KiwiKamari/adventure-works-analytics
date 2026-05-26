### 7. Time Series Analysis

Developed a time-series revenue model to analyze sales performance, growth trends, and seasonality over time.

**Key Metrics**

- Monthly Revenue
- Previous Month Revenue
- Previous Year Revenue
- Month-over-Month (MoM) Growth
- Year-over-Year (YoY) Growth

**Technical Approach**

- Built a monthly analytical dataset using:
  - `SalesOrderHeader`
  - `SalesOrderDetail`
- Normalized dates to monthly granularity using `DATEFROMPARTS`
- Aggregated monthly revenue using `SUM(LineTotal)`
- Applied `LAG()` window functions to retrieve:
  - Previous month revenue
  - Same month revenue from the previous year
- Calculated:
  - `MoM_Growth`
  - `YoY_Growth`
- Used `NULLIF` to prevent division-by-zero errors during growth calculations
- Structured the logic using layered CTEs for:
  - Monthly aggregation
  - Historical revenue comparison

**Business Value**

- Identifies revenue growth trends over time
- Detects seasonality patterns and performance fluctuations
- Enables monthly and yearly performance tracking
- Supports strategic forecasting and trend analysis
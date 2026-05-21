### 1. Product Profitability & Cost Analysis

Developed a product-level profitability model combining transactional sales data, historical production costs, and product categorization to evaluate financial performance over time.

**Key Metrics**

- Revenue
- Total Cost
- Profit
- Profit Margin %
- Quantity Sold
- Product Category & Subcategory
- Monthly Sales Performance

**Technical Approach**

- Used `OUTER APPLY` to retrieve the closest valid historical cost from `Production.ProductCostHistory`
- Matched historical costs using:
  - `StartDate <= ModifiedDate`
  - `TOP 1 ... ORDER BY StartDate DESC`
- Created monthly granularity using `DATEFROMPARTS`
- Aggregated transactional data by:
  - Product
  - Month
- Applied `COALESCE` and `NULLIF` to:
  - Prevent division-by-zero errors
  - Handle missing category and cost values
- Structured the solution using multiple CTEs:
  - Sales with historical cost resolution
  - Product-level aggregation
  - Product category enrichment

**Business Value**

- Identifies high-revenue but low-margin products
- Tracks profitability trends over time
- Enables category-level performance analysis
- Supports pricing and product portfolio decisions



### 2. Sales Channel Analysis (Online vs Offline)

Developed a customer-level sales channel analysis model to compare purchasing behavior between online and offline transactions.

**Key Metrics**

- Total Orders
- Total Sales
- Average Order Value (AOV)
- Sales Channel Classification
- Customer Channel Type

**Technical Approach**

- Classified transactions using `CASE` with `OnlineOrderFlag`
- Built a layered analytical model using multiple CTEs:
  - Base transactional dataset
  - Customer/year/channel aggregation
  - Omnichannel classification
- Aggregated metrics by:
  - Customer
  - Year
  - Sales Channel
- Calculated:
  - Order volume
  - Revenue
  - Average Order Value
- Identified customer channel behavior using `COUNT(DISTINCT OrderChannel)`:
  - `Omnichannel`
  - `Single Channel`
- Combined B2C and B2B customer naming logic using:
  - `Person.Person`
  - `Sales.Store`
- Used `TRIM`, `CONCAT_WS`, and `NULLIF` to standardize customer names and avoid formatting inconsistencies

**Business Value**

- Compares performance across online and offline channels
- Identifies omnichannel customer behavior
- Detects customer purchasing preferences
- Supports channel optimization and customer strategy decisions



### 3. Customer B2B Segmentation & RFM Analysis

Developed a B2B-focused RFM segmentation model to analyze customer value, engagement, and revenue concentration across business accounts.

**Key Metrics**

- Recency
- Frequency
- Monetary Value
- RFM Scores
- Customer Segment
- Revenue Contribution
- Pareto Distribution
- 
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



### 4. Customer B2C Segmentation & RFM Analysis

Developed a B2C-focused RFM segmentation model to analyze consumer purchasing behavior, loyalty, and revenue contribution.

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



### 5. Customer B2B Firmographics & Value Profitability

Developed an enriched B2B analytical dataset combining transactional performance, firmographic attributes, and customer value metrics.

**Key Metrics**

- Total Orders
- Total Revenue
- Average Order Value (AOV)
- Customer Tenure
- Store Annual Revenue
- Number of Employees
- Store Type
- Geographic Information
- Purchase Activity Status

**Technical Approach**

- Built a unified customer analytical dataset using multiple layered CTEs:
  - Customer sales aggregation
  - Average order value calculations
  - Store address prioritization
  - Store demographic enrichment
- Aggregated transactional metrics at customer level to prevent duplication
- Calculated:
  - Customer tenure in months
  - Average Order Value using `NULLIF`
  - Purchase activity indicators
- Used `ROW_NUMBER()` to resolve duplicate store-related records by prioritizing:
  - `Main Office`
  - `Shipping`
- Integrated firmographic information from:
  - `vStoreWithAddresses`
  - `vStoreWithDemographics`
- Standardized business classification using `CASE`:
  - Only Store
  - Bike Store
  - Bike Manufacturer
- Applied `COALESCE` to handle incomplete address and demographic data
- Included support for:
  - Pure B2B customers
  - B2B contact accounts

**Business Value**

- Enables firmographic segmentation of business customers
- Identifies high-value business accounts
- Supports account-based analysis and prioritization
- Provides geographic and organizational context for customer profitability
- Helps evaluate customer lifetime value and business potential



### 6. Customer B2C Demographics & Value Profitability

Developed an enriched B2C analytical dataset combining transactional performance, demographic attributes, and customer value metrics.

## Key Metrics

- Total Orders
- Total Revenue
- Average Order Value (AOV)
- Customer Tenure
- Age
- Gender
- Marital Status
- Occupation
- Yearly Income
- Geographic Information
- Purchase Activity Status

**Technical Approach**

- Built a unified customer analytical dataset using multiple layered CTEs:
  - Customer sales aggregation
  - Average order value calculations
  - Customer address prioritization
  - Demographic enrichment
- Aggregated transactional metrics at customer level to prevent duplicated customer records
- Calculated:
  - Customer tenure in months
  - Average Order Value using `NULLIF`
  - Purchase activity indicators
- Used `ROW_NUMBER()` to resolve duplicated address records by prioritizing:
  - `Home`
  - `Main Office`
- Integrated demographic information from:
  - `vPersonDemographics`
  - Address and regional datasets
- Standardized customer profile data using:
  - `TRIM`
  - `CONCAT_WS`
  - `COALESCE`
- Included customer classification logic for:
  - B2C customers
  - B2B contacts
  - Unclassified customers
- Managed incomplete demographic and geographic values using fallback handling

**Business Value**

- Enables demographic-based customer segmentation
- Identifies high-value consumer profiles
- Supports customer targeting and behavioral analysis
- Provides geographic and socioeconomic context for customer profitability
- Helps evaluate customer lifetime value and engagement patterns



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

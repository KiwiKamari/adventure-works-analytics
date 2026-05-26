# adventure-works-analytics (SQL Server + Power BI)

## Overview

This project is an end-to-end Business Intelligence solution built on the Microsoft AdventureWorks2022 transactional database.

The objective of the project is to transform raw enterprise transactional data into analytical datasets and interactive dashboards focused on:

- Product profitability analysis
- Sales channel performance
- Customer segmentation (B2B & B2C)
- RFM behavioral modeling
- Pareto revenue concentration analysis
- Firmographic and demographic profiling
- Time-series revenue analysis

The analytical layer was developed using advanced T-SQL in Microsoft SQL Server, where multiple SQL views were designed to support scalable business reporting and multidimensional analysis.

The solution was later integrated into Power BI to build a multi-page interactive dashboard environment optimized for business exploration, KPI tracking, customer analytics, and profitability evaluation.

## Technical Focus

This project emphasizes:

- Advanced SQL analytical modeling
- Window functions (`LAG`, `NTILE`, `ROW_NUMBER`)
- Historical cost matching using `OUTER APPLY`
- Customer-level aggregation strategies
- RFM segmentation models
- Pareto analysis
- Time-series calculations (MoM & YoY)
- Dimensional analytical design for Power BI
- Interactive dashboard development

## Technologies Used

- Microsoft SQL Server
- T-SQL
- Power BI
- DAX

## Power BI Dashboard

[SalesDashboard.pbix](https://raw.githubusercontent.com/KiwiKamari/adventure-works-analytics/refs/heads/main/SalesDashboard.pbix)

# Dataset

This project uses the AdventureWorks2022 sample database from Microsoft, a simulated enterprise transactional dataset designed for business intelligence, sales analytics, and enterprise reporting scenarios.

The analytical solution integrates transactional, product, customer, geographic, demographic, and firmographic information to support multidimensional business analysis across both B2B and B2C environments.

## Main Data Domains

The project combines data from multiple business areas, including:

- Sales
- Customers
- Products
- Production Costs
- Stores
- Customer Demographics
- Customer Firmographics
- Geographic Information

---

## Core Tables Used

### Sales

- `Sales.SalesOrderHeader`
- `Sales.SalesOrderDetail`
- `Sales.Customer`

### Products & Production

- `Production.Product`
- `Production.ProductSubcategory`
- `Production.ProductCategory`
- `Production.ProductCostHistory`

### Customer & Demographics

- `Person.Person`
- `Sales.Store`
- `Sales.vPersonDemographics`
- `Sales.vStoreWithDemographics`
- `Sales.vStoreWithAddresses`

### Geography & Addresses

- `Person.Address`
- `Person.BusinessEntityAddress`
- `Person.vStateProvinceCountryRegion`

---

## Dataset Scope

The analytical model was designed to support seven major business intelligence areas:

1. Product Profitability & Cost Analysis
2. Sales Channel Analysis (Online vs Offline)
3. Customer B2B Segmentation & RFM
4. Customer B2C Segmentation & RFM
5. Customer B2B Firmographics & Value Profitability
6. Customer B2C Demographics & Value Profitability
7. Time Series Analysis

The project includes both transactional-level analysis and aggregated analytical datasets optimized for dashboard performance and interactive business exploration.

---

## Analytical Dataset Architecture

The analytical layer was developed through multiple SQL views designed specifically for Power BI integration.

These views support:

- Product-level profitability analysis
- Historical production cost matching
- Customer segmentation models
- Revenue concentration analysis
- Geographic and demographic enrichment
- Customer profitability evaluation
- Time-series growth analysis

---

## Data Modeling Approach

The project follows an analytical modeling approach focused on dimensional consistency, aggregation control, and reporting scalability.

### Key Modeling Practices

- Aggregated analytical datasets
- Historical cost matching using `OUTER APPLY`
- Customer-level enrichment
- Time-series normalization
- RFM segmentation models
- Pareto revenue distribution analysis
- Address prioritization using `ROW_NUMBER()`
- Window-function-based analytical calculations
- Separation of B2B and B2C analytical populations
- Avoidance of duplicated transactional granularity

### Analytical SQL Features Used

- `CTEs`
- `LAG()`
- `NTILE()`
- `ROW_NUMBER()`
- `OUTER APPLY`
- `CASE`
- `COALESCE`
- `NULLIF`
- `DATEFROMPARTS`
- Windowed aggregations with `SUM() OVER`

# Project Workflow

1. Raw transactional extraction from AdventureWorks2022
2. SQL-based analytical transformations
3. Historical cost matching and customer enrichment
4. Aggregated analytical dataset creation
5. Power BI data modeling and DAX measures
6. Dashboard development and business analysis

# Key SQL Concepts Used

- Common Table Expressions (CTEs)
- Window Functions
- OUTER APPLY
- Historical Cost Matching
- RFM Segmentation Logic
- Pareto Analysis
- Time-Series Aggregation
- Conditional Classification with CASE
- Customer-Level Data Enrichment
- Data Normalization

# SQL Implementations

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



---
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



---
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



---
### 4. Customer B2C Segmentation & RFM Analysis

Developed a B2C-focused RFM segmentation model to analyze consumer purchasing behavior, loyalty, and revenue contribution.

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



---
### 5. Customer B2B Firmographics & Value Profitability

Developed an enriched B2B analytical dataset combining transactional performance, firmographic attributes, and customer value metrics.

> **Dataset Scope:**  
> This analysis includes both purchasing and non-purchasing customers available in the unified customer dataset (`vw_CustomerInfo`).

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



---
### 6. Customer B2C Demographics & Value Profitability

Developed an enriched B2C analytical dataset combining transactional performance, demographic attributes, and customer value metrics.

> **Dataset Scope:**  
> This analysis includes both purchasing and non-purchasing customers available in the unified customer dataset (`vw_CustomerInfo`).

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



---
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

---

# Power BI Integration

The analytical datasets developed in SQL Server were integrated into Power BI to create a fully interactive business intelligence solution focused on profitability analysis, customer segmentation, channel performance, and time-series analytics.

The Power BI layer was designed to support multidimensional exploration through dynamic filtering, drill-down navigation, KPI monitoring, and comparative visual analysis.

## Data Modeling Approach

The Power BI model was built using aggregated SQL analytical views specifically designed to optimize reporting performance and reduce duplicated transactional granularity.

### Modeling Principles

- Separation of analytical datasets by business domain
- Customer-level and product-level aggregation
- Time-series normalization at monthly granularity
- Historical cost integration for profitability analysis
- Independent B2B and B2C segmentation models
- Pareto analytical structures for revenue concentration analysis
- Prevention of many-to-many relationship conflicts

## DAX & Analytical Calculations

DAX measures were implemented to support dynamic calculations and interactive reporting behavior.

### Main DAX Applications

- Revenue calculations
- Profitability metrics
- Average Order Value (AOV)
- MoM Growth %
- YoY Growth %
- Dynamic KPI calculations
- Filter-responsive aggregations
- Pareto cumulative calculations

### Common Functions Used

- `SUM`
- `DIVIDE`
- `CALCULATE`
- `FILTER`
- `ALL`
- `IF`

## Interactive Reporting Features

The dashboards were designed to support interactive analytical exploration through:

- Dynamic slicers
- Drill-down navigation
- Cross-filtering between visuals
- Conditional formatting
- Geographic visualization
- Hierarchical product analysis
- Segment-based customer analysis
- Time-series trend exploration

## Dashboard Scope

The Power BI solution includes seven analytical dashboard pages:

1. Product Profitability & Cost Analysis
2. Sales Channel Analysis (Online vs Offline)
3. Customer B2B Segmentation & RFM
4. Customer B2C Segmentation & RFM
5. Customer B2B Firmographics & Value Profitability
6. Customer B2C Demographics & Value Profitability
7. Time Series Analysis

Each dashboard page was designed to address a specific analytical domain while maintaining consistent KPI logic, filtering behavior, and business reporting structure.



# Dashboard Pages

## Product Profitability & Cost Analysis

This dashboard page focuses on product-level profitability analysis by combining revenue, historical costs, margins, pricing, and product hierarchy dimensions into a single analytical view.

### Main Objectives

* Evaluate product profitability across categories and subcategories
* Compare revenue against historical production costs
* Identify high-profit and high-margin products
* Analyze pricing behavior and margin distribution
* Support drill-down analysis from category to product level

### Dashboard Components

#### KPI Cards

The top section contains executive KPI cards used to summarize overall product performance:

* Total Revenue
* Total Cost
* Total Profit
* Profit Margin %

These KPIs dynamically respond to all report filters.

### Filtering & Navigation

Interactive slicers were implemented to support multidimensional analysis:

* Year
* Month
* Category
* Subcategory
* Product Name
* Actual Price Range

This filtering structure enables hierarchical product exploration and temporal profitability analysis.

### Visual Analytics

#### Revenue vs Total Cost

Clustered bar chart used to compare:

* Revenue
* Total Cost

across product categories.

Purpose:

* Evaluate profitability at category level
* Compare operational cost structure against generated revenue
* Detect high-volume vs low-margin categories

---

#### Price vs Margin %

Scatter plot used to analyze the relationship between:

* Product price
* Profit margin %

Bubble distribution allows comparative analysis across product categories.

Purpose:

* Detect pricing efficiency
* Identify premium vs low-margin products
* Analyze margin dispersion by pricing segment

---

#### Margin % by Subcategory

Treemap visualization used to represent profit margin contribution by subcategory.

Purpose:

* Analyze margin distribution across product hierarchy
* Identify subcategories with stronger profitability contribution
* Improve comparative visualization of categorical performance

---

#### Top 10 Products by Profit

Horizontal bar chart ranking the most profitable products.

Purpose:

* Identify products generating the highest profit
* Compare product-level contribution to total profitability
* Highlight top-performing SKUs

---

#### Products Detail Matrix

Hierarchical matrix displaying:

* Category
* Revenue
* Total Cost
* Profit
* Margin %

Purpose:

* Provide detailed analytical breakdown
* Support drill-down exploration
* Validate aggregated KPI metrics
* Enable direct comparison between categories and products

Conditional formatting was applied to Margin % to improve visual interpretation of profitability levels.

---

## Sales Channel Analysis (Online vs Offline)

This dashboard page analyzes customer purchasing behavior across sales channels by comparing Online and Offline transactions through revenue, order activity, customer participation, and Average Order Value (AOV).

### Main Objectives

* Compare Online vs Offline sales performance
* Analyze customer purchasing behavior by channel
* Evaluate revenue contribution across channels
* Measure AOV differences between Online and Offline transactions
* Identify customer concentration by channel

### Dashboard Components

#### KPI Cards

The top section contains executive KPIs used to summarize channel performance:

* Total Revenue
* Average AOV
* Total Orders
* Total Customers

All KPIs dynamically respond to channel and year filters.

### Filtering & Navigation

Interactive slicers were implemented for channel-based analysis:

* Channel
* Year

These filters allow direct comparison between Online and Offline purchasing behavior over time.

### Visual Analytics

#### Orders YoY by Channel

Heatmap-style matrix displaying yearly order distribution across sales channels.

Purpose:

* Analyze order activity by year
* Compare transaction volume between channels
* Detect growth concentration across periods

Conditional formatting was applied to improve year-over-year comparison visibility.

---

#### Online vs Offline Sales by Year

Clustered column chart comparing total sales across channels by year.

Purpose:

* Compare annual revenue contribution by channel
* Evaluate sales growth trends
* Identify channel dominance over time

---

#### Top 20 Clients by Channel

Detailed ranking table displaying:

* Customer ID
* Customer Name
* Sales Channel
* Revenue
* Channel AOV

Purpose:

* Identify highest-value customers by channel
* Compare customer spending behavior
* Analyze customer concentration within each channel

---

#### AOV by Channel and Year

Area chart used to compare Average Order Value trends between Online and Offline channels across multiple years.

Purpose:

* Evaluate purchasing behavior differences
* Compare transaction size evolution over time
* Analyze channel purchasing efficiency

---

#### Participation by Channel

Donut chart representing total revenue participation by sales channel.

Purpose:

* Visualize revenue share distribution
* Compare overall contribution between Online and Offline sales
* Provide high-level channel participation overview

---


## Customer B2B Segmentation & RFM

This dashboard page focuses on B2B customer segmentation using an RFM analytical model combined with Pareto analysis to evaluate customer value concentration, purchasing behavior, and revenue contribution.

### Main Objectives

* Segment B2B customers based on purchasing behavior
* Analyze Recency, Frequency, and Monetary patterns
* Identify high-value and at-risk business customers
* Evaluate revenue concentration through Pareto analysis
* Compare customer segments using operational and financial metrics

### Dashboard Components

#### KPI Cards

The top section contains executive RFM KPIs:

* Average Recency
* Average Frequency
* Average Monetary
* Total Customers

These KPIs dynamically update according to all segment and demographic filters.

### Filtering & Navigation

Interactive slicers were implemented for multidimensional customer analysis:

* Segment
* Store Type
* Country

These filters support comparative analysis across B2B customer groups and geographic regions.

### Visual Analytics

#### Customers Distribution by Segment

Donut chart representing customer distribution across RFM segments.

Purpose:

* Visualize customer concentration by segment
* Compare relative segment sizes
* Evaluate customer population structure

---

#### Simplified RFM

Bubble scatter chart representing segment behavior using:

* Average Recency
* Average Frequency
* Segment grouping

Purpose:

* Simplify multidimensional RFM analysis
* Compare behavioral positioning between segments
* Identify customer activity and engagement patterns

Bubble size is used to improve comparative segment visibility.

---

#### Customers B2B who account for 80% of revenue

Pareto KPI section displaying:

* Count of customers responsible for 80% of revenue
* Percentage of total customers represented by that group

Purpose:

* Evaluate revenue concentration
* Identify strategic customer dependency
* Support Pareto-based business analysis

---

#### Average of AOV by Segment

Column chart comparing Average Order Value across customer segments.

Purpose:

* Analyze spending behavior by segment
* Compare purchasing value between customer groups
* Identify segments with stronger transactional value

---

#### Revenue & Pareto by Segment

Combined Pareto visualization integrating:

* Revenue by segment
* Cumulative Pareto percentage

Purpose:

* Evaluate revenue contribution by customer segment
* Identify segments driving business revenue concentration
* Analyze cumulative revenue distribution

The visual combines categorical revenue analysis with cumulative Pareto progression to improve strategic customer evaluation.

---


## Customer B2C Segmentation & RFM

This dashboard page focuses on B2C customer segmentation using an RFM analytical model combined with Pareto analysis to evaluate consumer purchasing behavior, loyalty patterns, and revenue concentration.

### Main Objectives

* Segment B2C customers based on purchasing behavior
* Analyze Recency, Frequency, and Monetary patterns
* Identify loyal, promising, and at-risk consumers
* Evaluate revenue concentration through Pareto analysis
* Compare customer segments using behavioral and financial metrics

### Dashboard Components

#### KPI Cards

The top section contains executive RFM KPIs:

* Average Recency
* Average Frequency
* Average Monetary
* Total Customers

These KPIs dynamically respond to all segment and demographic filters.

### Filtering & Navigation

Interactive slicers were implemented for customer segmentation analysis:

* Segment
* Marital Status
* Gender

These filters support demographic and behavioral comparison across customer groups.

### Visual Analytics

#### Customers Distribution by Segment

Donut chart representing customer distribution across RFM segments.

Purpose:

* Visualize customer concentration by segment
* Compare relative segment sizes
* Evaluate customer population structure

---

#### Simplified RFM

Bubble scatter chart representing customer segment behavior using:

* Average Recency
* Average Frequency
* Segment grouping

Purpose:

* Simplify multidimensional RFM analysis
* Compare engagement and purchasing activity across segments
* Identify active, loyal, and inactive customer groups

Bubble size improves comparative visualization between segment clusters.

---

#### Customers B2C who account for 80% of revenue

Pareto KPI section displaying:

* Count of customers responsible for 80% of revenue
* Percentage of total customers represented by that group

Purpose:

* Evaluate revenue concentration
* Identify high-impact customer groups
* Support Pareto-based customer analysis

---

#### Average of AOV by Segment

Column chart comparing Average Order Value across customer segments.

Purpose:

* Compare consumer purchasing value between segments
* Analyze spending behavior patterns
* Identify segments with stronger transactional contribution

---

#### Revenue & Pareto by Segment

Combined Pareto visualization integrating:

* Revenue by segment
* Cumulative Pareto percentage

Purpose:

* Evaluate revenue contribution by customer segment
* Analyze cumulative customer value concentration
* Identify segments driving overall business revenue

The visualization combines categorical revenue comparison with Pareto progression analysis for improved customer value evaluation.

---


## Customer B2B Firmographics & Value Profitability

This dashboard page focuses on B2B customer profiling by combining firmographic information, customer value metrics, geographic distribution, and purchasing behavior into a unified analytical view.

### Main Objectives

* Analyze B2B customer value and profitability
* Evaluate business customers using firmographic attributes
* Compare AOV contribution across industries and store types
* Analyze customer distribution by geography
* Identify high-value business customer groups

### Dashboard Components

#### KPI Cards

The top section contains executive customer profitability KPIs:

* Total Revenue
* Average Order Value
* Average Customer Tenure
* Total Customers

These KPIs dynamically respond to all firmographic and geographic filters.

### Filtering & Navigation

Interactive slicers were implemented for business customer analysis:

* Store Type
* Occupation
* Country

These filters support multidimensional exploration across business categories and geographic regions.

### Visual Analytics

#### Revenue by Store Type

Donut chart representing revenue distribution across business store categories.

Purpose:

* Compare revenue participation by store type
* Identify dominant business customer groups
* Analyze firmographic revenue concentration

---

#### Revenue by Country

Map visualization representing customer revenue distribution geographically.

Purpose:

* Analyze geographic revenue concentration
* Compare regional customer contribution
* Identify high-performing business markets

Bubble sizing improves comparative visibility between countries.

---

#### Revenue by Occupation

Horizontal bar chart ranking revenue contribution across occupational groups.

Purpose:

* Compare revenue generation by occupation category
* Identify customer groups with stronger purchasing contribution
* Support demographic-based customer analysis

---

#### B2B Customer Details Matrix

Detailed analytical matrix displaying:

* Customer Name
* Country
* Store Type
* Customer Tenure
* Total Orders
* Revenue
* Average Order Value

Purpose:

* Provide customer-level analytical detail
* Support drill-down exploration
* Validate aggregated business metrics
* Compare profitability and operational behavior across customers

Conditional formatting was applied to revenue-related metrics to improve comparative readability.

---
## Customer B2C Demographics & Value Profitability

This dashboard page focuses on B2C customer profiling by combining demographic information, customer value metrics, geographic distribution, and purchasing behavior into a unified analytical view.

### Main Objectives

* Analyze B2C customer value and profitability
* Evaluate consumer purchasing behavior using demographic attributes
* Compare revenue contribution across demographic groups
* Analyze customer distribution by geography
* Identify high-value consumer profiles

### Dashboard Components

#### KPI Cards

The top section contains executive customer profitability KPIs:

* Total Revenue
* Average Order Value
* Average Customer Tenure
* Total Customers

These KPIs dynamically respond to all demographic and geographic filters.

### Filtering & Navigation

Interactive slicers were implemented for demographic customer analysis:

* Gender
* Marital Status
* Country

These filters support multidimensional exploration across consumer demographic groups and geographic regions.

### Visual Analytics

#### Revenue by Gender

Donut chart representing revenue distribution across gender groups.

Purpose:

* Compare revenue participation between customer groups
* Analyze demographic contribution distribution
* Identify dominant consumer segments

---

#### Revenue by Country

Map visualization representing customer revenue distribution geographically.

Purpose:

* Analyze geographic revenue concentration
* Compare regional customer contribution
* Identify high-performing consumer markets

Bubble sizing improves comparative visibility between countries.

---

#### Revenue by Occupation

Horizontal bar chart ranking revenue contribution across occupational groups.

Purpose:

* Compare revenue generation by occupation category
* Identify customer groups with stronger purchasing contribution
* Support demographic-based customer analysis

---

#### B2C Customer Details Matrix

Detailed analytical matrix displaying:

* Customer Name
* Country
* Occupation
* Customer Tenure
* Total Orders
* Revenue
* Average Order Value

Purpose:

* Provide customer-level analytical detail
* Support drill-down exploration
* Validate aggregated business metrics
* Compare profitability and purchasing behavior across customers

Conditional formatting was applied to revenue-related metrics to improve comparative readability.

---



## Time Series Analysis

This dashboard page focuses on revenue evolution over time by analyzing monthly sales performance, growth behavior, and long-term business trends using time-series analytical techniques.

### Main Objectives

* Analyze monthly revenue evolution
* Evaluate business growth trends over time
* Compare Month-over-Month and Year-over-Year performance
* Detect seasonality and revenue fluctuations
* Support long-term performance monitoring

### Dashboard Components

#### KPI Cards

The top section contains executive time-series KPIs:

* Total Revenue
* Average Monthly Revenue
* Average MoM Growth %
* Average YoY Growth %

These KPIs dynamically respond to all temporal filters.

### Filtering & Navigation

Interactive slicers were implemented for temporal analysis:

* Year
* Month

These filters support comparative revenue analysis across different time periods.

### Visual Analytics

#### Monthly Revenue Trend

Line chart representing monthly revenue evolution over time.

Purpose:

* Analyze revenue growth trends
* Detect seasonality and business fluctuations
* Compare performance consistency across periods

---

#### MoM Growth %

Column chart displaying Month-over-Month revenue growth percentages.

Purpose:

* Evaluate short-term revenue variation
* Detect acceleration and slowdown periods
* Analyze monthly business momentum

---

#### YoY Growth %

Line chart representing Year-over-Year revenue growth trends.

Purpose:

* Compare annual business performance evolution
* Evaluate long-term growth consistency
* Detect structural revenue trend changes

---

#### Revenue vs Previous Year Revenue

Combined line chart comparing:

* Current revenue
* Previous year revenue

Purpose:

* Compare historical revenue performance
* Evaluate annual progression patterns
* Identify periods of business expansion or contraction

---

#### Monthly Revenue Detail Matrix

Detailed analytical matrix displaying:

* Year
* Month
* Revenue
* Previous Month Revenue
* Previous Year Revenue
* MoM Growth %
* YoY Growth %

Purpose:

* Provide detailed time-series analytical breakdown
* Validate aggregated trend metrics
* Support period-over-period comparison
* Enable granular business performance evaluation

Conditional formatting was applied to growth metrics to improve comparative readability.

---

# Power BI Features

- Interactive slicers
- Drill-down analysis
- Conditional formatting
- KPI cards
- Pareto visualizations
- Scatter analysis
- Geographic mapping
- Dynamic filtering
- DAX measures
- Cross-visual interactions

---

# Dashboards Preview

<p align="center">

  <a href="https://github.com/user-attachments/assets/0a911299-94c5-4176-9fd7-6c7414c9dded">
    <img width="55%" height="55%" alt="Product Profitability Dashboard"
    src="https://github.com/user-attachments/assets/0a911299-94c5-4176-9fd7-6c7414c9dded" />
  </a>

  <br>

  <a href="#product-profitability--cost-analysis">
    Product Profitability & Cost Analysis
  </a>

</p>

---

<p align="center">

  <a href="https://github.com/user-attachments/assets/524a18cf-a1f4-436d-9e21-9f97b27457a3">
    <img width="55%" height="55%" alt="Sales Channel Dashboard"
    src="https://github.com/user-attachments/assets/524a18cf-a1f4-436d-9e21-9f97b27457a3" />
  </a>

  <br>

  <a href="#sales-channel-analysis-online-vs-offline">
    Sales Channel Analysis (Online vs Offline)
  </a>

</p>

---

<p align="center">

  <a href="https://github.com/user-attachments/assets/9e0338d5-8a05-4e5d-9e07-79010eee138f">
    <img width="55%" height="55%" alt="B2B RFM Dashboard"
    src="https://github.com/user-attachments/assets/9e0338d5-8a05-4e5d-9e07-79010eee138f" />
  </a>

  <br>

  <a href="#customer-b2b-segmentation--rfm">
    Customer B2B Segmentation & RFM
  </a>

</p>

---

<p align="center">

  <a href="https://github.com/user-attachments/assets/9807db50-6b7a-4634-93f5-08295d108a2e">
    <img width="55%" height="55%" alt="B2C RFM Dashboard"
    src="https://github.com/user-attachments/assets/9807db50-6b7a-4634-93f5-08295d108a2e" />
  </a>

  <br>

  <a href="#customer-b2c-segmentation--rfm">
    Customer B2C Segmentation & RFM
  </a>

</p>

---

<p align="center">

  <a href="https://github.com/user-attachments/assets/f4e600fe-4101-41e2-b2cb-867999077340">
    <img width="55%" height="55%" alt="B2B Firmographics Dashboard"
    src="https://github.com/user-attachments/assets/fa5242bb-9d3b-4273-b2cb-6053f8fd626f" />
" />
  </a>

  <br>

  <a href="#customer-b2b-firmographics--value-profitability">
    Customer B2B Firmographics & Value Profitability
  </a>

</p>

---

<p align="center">

  <a href="https://github.com/user-attachments/assets/ca50c562-4519-4e37-94a0-d6f667816eaf">
    <img width="55%" height="55%" alt="B2C Demographics Dashboard"
    src="https://github.com/user-attachments/assets/ca50c562-4519-4e37-94a0-d6f667816eaf" />
  </a>

  <br>

  <a href="#customer-b2c-demographics--value-profitability">
    Customer B2C Demographics & Value Profitability
  </a>

</p>

---

<p align="center">

  <a href="https://github.com/user-attachments/assets/7036e5d1-37c6-45d0-8e27-aebfa8183a40">
    <img width="55%" height="55%" alt="Time Series Dashboard"
    src="https://github.com/user-attachments/assets/7036e5d1-37c6-45d0-8e27-aebfa8183a40" />
  </a>

  <br>

  <a href="#time-series-analysis">
    Time Series Analysis
  </a>

</p>




## Business Insights

Detailed analytical interpretations, business findings, and dashboard-driven insights are documented separately in the project case study.

[View Full Case Study](NOTION_LINK)









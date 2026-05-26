# adventure-works-analytics (SQL Server + Power BI)

## 🌟 Overview

This project is an end-to-end Business Intelligence solution built on the Microsoft [Adventure Works 2022](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak) transactional database.

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

## 🚀 Power BI Dashboard

[SalesDashboard.pbix](https://raw.githubusercontent.com/KiwiKamari/adventure-works-analytics/refs/heads/main/SalesDashboard.pbix)

# 💡 Dataset

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
- Duplicate Prevention Strategies
- Data Normalization
- Geographic & Demographic Enrichment

---

# 📝 Power BI Integration

The analytical datasets developed in SQL Server were integrated into Power BI to create an interactive business intelligence solution focused on profitability analysis, customer segmentation, channel performance, and time-series analytics.

The Power BI layer was designed to support:

- Dynamic filtering
- Drill-down exploration
- KPI monitoring
- Cross-visual interaction
- Geographic visualization
- Comparative analytical reporting

## Data Modeling Highlights

- Aggregated SQL analytical views
- Customer-level and product-level modeling
- Historical cost integration
- Independent B2B and B2C segmentation models
- Pareto analytical structures
- Monthly time-series normalization
- Prevention of many-to-many relationship conflicts

## DAX Features

Main DAX implementations include:

- Revenue calculations
- Profitability metrics
- Average Order Value (AOV)
- MoM Growth %
- YoY Growth %
- Dynamic KPI calculations
- Filter-responsive aggregations

---

# 📊 Dashboard Pages

### [1. Product Profitability & Cost Analysis](https://github.com/KiwiKamari/adventure-works-analytics/blob/main/docs/powerbi/1-product-profitability-dashboard.md)

Analyzes product-level profitability by combining revenue, historical costs, margins, pricing behavior, and product hierarchy analysis.

---

### [2. Sales Channel Analysis (Online vs Offline)](https://github.com/KiwiKamari/adventure-works-analytics/blob/main/docs/powerbi/2-sales-channel-analysis-dashboard.md)

Compares Online and Offline customer purchasing behavior through revenue, orders, customer participation, and Average Order Value analysis.

---

### [3. Customer B2B Segmentation & RFM](https://github.com/KiwiKamari/adventure-works-analytics/blob/main/docs/powerbi/3-b2b-rfm-dashboard.md)

Implements a B2B RFM segmentation model combined with Pareto analysis to evaluate customer value concentration and purchasing behavior.

---

### [4. Customer B2C Segmentation & RFM](https://github.com/KiwiKamari/adventure-works-analytics/blob/main/docs/powerbi/4-b2c-rfm-dashboard.md)

Implements a B2C RFM segmentation model focused on customer loyalty, behavioral segmentation, and revenue concentration analysis.

---

### [5. Customer B2B Firmographics & Value Profitability](https://github.com/KiwiKamari/adventure-works-analytics/blob/main/docs/powerbi/5-fimographics-b2b-dashboard.md)

Combines firmographic attributes, geographic information, business size, and transactional performance for B2B customer analysis.

---

### [6. Customer B2C Demographics & Value Profitability](https://github.com/KiwiKamari/adventure-works-analytics/blob/main/docs/powerbi/6-demographics-b2c-dashboard.md)

Combines demographic attributes, customer profitability metrics, and geographic analysis for B2C customer profiling.

---

### [7. Time Series Analysis](https://github.com/KiwiKamari/adventure-works-analytics/blob/main/docs/powerbi/7-time-series-analysis-dashboard.md)

Analyzes monthly revenue evolution, MoM growth, YoY growth, and long-term business performance trends.

---

# Dashboards Preview

<p align="center">

  <a href="https://github.com/user-attachments/assets/0a911299-94c5-4176-9fd7-6c7414c9dded">
    <img width="55%" height="55%" alt="Product Profitability Dashboard"
    src="https://github.com/user-attachments/assets/0a911299-94c5-4176-9fd7-6c7414c9dded" />
  </a>

  <br>

  <a href="#dashboard-pages">
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

  <a href="#dashboard-pages">
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

  <a href="#dashboard-pages">
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

  <a href="#dashboard-pages">
    Customer B2C Segmentation & RFM
  </a>

</p>

---

<p align="center">

  <a href="https://github.com/user-attachments/assets/fa5242bb-9d3b-4273-b2cb-6053f8fd626f">
    <img width="55%" height="55%" alt="B2B Firmographics Dashboard"
    src="https://github.com/user-attachments/assets/fa5242bb-9d3b-4273-b2cb-6053f8fd626f" />
  </a>

  <br>

  <a href="#dashboard-pages">
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

  <a href="#dashboard-pages">
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

  <a href="#dashboard-pages">
    Time Series Analysis
  </a>

</p>

---

# Extended Documentation

## <img width="3.5%" height="3.5%" alt="imagen" src="https://github.com/user-attachments/assets/6bf51316-d735-440c-aa93-f8a714a37dd8" /> SQL Documentation

Detailed SQL implementations and technical breakdowns:

- Product Profitability & Cost Analysis
- Sales Channel Analysis
- B2B & B2C RFM Models
- Pareto Revenue Analysis
- Firmographic & Demographic Modeling
- Time Series Analysis

[View SQL Documentation](docs/sql/)

---

## <img width="2.5%" height="2.5%" aalt="imagen" src="https://github.com/user-attachments/assets/12512802-b682-49f9-bc36-c07eaada6016" /> Power BI Documentation

Detailed dashboard explanations, DAX logic, and data modeling structure.

[View Power BI Documentation](docs/powerbi/)

---

## <img width="2.5%" height="2.5%" alt="imagen" src="https://github.com/user-attachments/assets/6b2ee20a-1f5c-4aca-929d-903872a91466" /> Business Insights & Case Study

Extended business insights, analytical interpretations, and strategic findings are documented separately in the project case study.

[View Full Case Study](https://mangrove-string-658.notion.site/Product-Profitability-Cost-Analysis-Case-Study-36c3df2b526e806e856fcb087b77ca57)



---

## ✨ Conclusion

This project demonstrates the ability to:

* Work with complex relational datasets
* Apply advanced SQL techniques (CTEs, window functions, OUTER APPLY)
* Handle real-world data challenges (cost history, missing values, aggregation issues)
* Translate raw data into actionable business insights
* Build structured and scalable BI solutions

---



### 🗃️  Personal Projects

Feel free to connect with me on the following platforms:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/luis-gerardo-espinosa-gonz%C3%A1lez-608139276/)

Check out my personal projects!
- ✅ **sql-data-analytics-project-main:** [GIT Repo](https://github.com/KiwiKamari/sql-data-analytics-project-main)
- ✅ **user_analytics:** [GIT Repo](https://github.com/KiwiKamari/user_analytics)

# adventure-works-analytics (SQL Server + Power BI)
## Overview

This project analyzes the [Adventure Works 2022](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak) transactional database to extract business insights related to product profitability, customer behavior, and sales performance over time.

The solution is built using advanced T-SQL queries on MSSQL and later integrated into Power BI for visualization and decision-making [SalesDashboard.pbix](https://raw.githubusercontent.com/KiwiKamari/adventure-works-analytics/refs/heads/main/SalesDashboard.pbix).


## Key SQL Implementations

### 1. Product Profitability & Cost Analysis

A complete KPI model was developed to evaluate product performance, including:

* Revenue
* Total Cost
* Profit
* Margin %

**Technical approach:**

* Used `OUTER APPLY` to retrieve the **most recent valid cost per transaction** from `ProductCostHistory`
* Ensured cost accuracy by matching cost records to the closest valid date (`StartDate <= ModifiedDate`)
* Aggregated transactional data at product level to avoid duplication
* Applied `COALESCE` and `NULLIF` to handle missing values and division errors

**Business value:**

* Identifies high-revenue but low-margin products
* Enables profitability-based product decisions

---

### 2. Sales Channel Analysis (Online vs Offline)

Sales were classified and analyzed based on transaction channel:

* Online vs Offline classification using `OnlineOrderFlag`
* Aggregation by:

  * Customer
  * Year
  * Sales channel

**Technical approach:**

* Conditional classification using `CASE`
* Grouped metrics:

  * Total Orders
  * Total Sales
  * Average Order Value

**Business value:**

* Compares performance across sales channels
* Identifies customer channel preferences

<p align="center">
  <img width="65%" height="65%" alt="imagen" src="https://github.com/user-attachments/assets/d2eebb1d-c43a-41e9-89ca-aff80597e97b" />
  <br>"Customer B2B Segmentation & RFM"<br>

  <img width="65%" height="65%" alt="imagen" src="https://github.com/user-attachments/assets/7da0186e-af5e-4fea-8e22-ba1e664f8983" />
  <br>"Customer B2B Segmentation & RFM"
</p>

---

### 3. Customer Segmentation (RFM Model)

Implemented a full RFM segmentation model:

* **Recency:** Days since last purchase
* **Frequency:** Number of orders
* **Monetary:** Total spending

**Technical approach:**

* Used `NTILE(5)` to assign scores for each dimension
* Built composite RFM score (`R_Score * 100 + F_Score * 10 + M_Score`)
* Segmented customers into:

  * Champions
  * Loyal
  * Potential
  * At Risk
  * Lost

**Business value:**

* Identifies high-value and at-risk customers
* Supports retention and targeting strategies

---

### 4. Customer Demographics & Value Profiling

Combined transactional and demographic data to build enriched customer profiles.

**Metrics included:**

* Total Orders
* Total Revenue
* Average Order Value
* Customer Tenure
* Customer Type (High/Low value)

**Technical approach:**

* Used `ROW_NUMBER()` with conditional ordering to prioritize primary addresses
* Built aggregated sales dataset (`cte_CustomerSales`) to avoid repeated calculations
* Joined demographic data from multiple sources

**Business value:**

* Enables segmentation by demographics and value
* Supports customer-centric decision-making

---

### 5. Time Series Analysis (MoM & YoY Growth)

Developed a time-based revenue model to analyze trends and growth.

**Technical approach:**

* Created a proper date column using `DATEFROMPARTS` for monthly granularity
* Used `LAG()` window function to calculate:

  * Month-over-Month (MoM) growth
  * Year-over-Year (YoY) growth
* Handled edge cases using `NULLIF` to prevent division errors

**Business value:**

* Identifies growth trends and seasonality
* Enables performance tracking over time

---

## Power BI Integration

The SQL datasets were directly integrated into Power BI to build an analytical dashboard with:

* Executive Overview (Revenue, Profit, Growth)
* Customer Analysis (RFM segmentation)
* Product Performance (Profitability & margins)
* Sales Channels (Online vs Offline trends)

**Key practices:**

* Measures created using DAX (`SUM`, `DIVIDE`, `CALCULATE`)
* Proper handling of filter context
* Avoidance of many-to-many relationship issues
* Separation of fact tables to prevent data duplication

---

## Key Insights

* A small segment of customers (Champions) contributes a significant portion of total revenue
* Some products generate high sales volume but low margins, indicating pricing or cost issues
* Online and offline channels show different growth behaviors
* Seasonal patterns are visible in monthly sales trends
* Customer retention opportunities exist within the “At Risk” segment

---

## Technologies Used

* SQL Server (T-SQL)
* Power BI
* Data Modeling
* DAX

---

## Conclusion

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


### 🌟 About Me

Hello there! I'm **Luis Espinosa**. I'm a **software developer** with an interest in data analysis and database management using Microsoft SQL Server, Python, and PowerBI. I also have experience developing with C# in Visual Studio and with the Unity game engine!


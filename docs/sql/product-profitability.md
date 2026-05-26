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
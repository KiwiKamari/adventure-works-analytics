## Product Profitability & Cost Analysis

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

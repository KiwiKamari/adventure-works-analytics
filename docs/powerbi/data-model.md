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
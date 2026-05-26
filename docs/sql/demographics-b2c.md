### 6. Customer B2C Demographics & Value Profitability

Developed an enriched B2C analytical dataset combining transactional performance, demographic attributes, and customer value metrics.

> [!NOTE]  
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

### 5. Customer B2B Firmographics & Value Profitability

Developed an enriched B2B analytical dataset combining transactional performance, firmographic attributes, and customer value metrics.

> [!NOTE]
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

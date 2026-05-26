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

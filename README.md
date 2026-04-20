# RetailIQ — Sales Performance Dashboard

> An end-to-end Power BI project simulating a real retail analytics use case, built from raw CSV data to a fully interactive 4-page business intelligence dashboard.

---

## 📸 Dashboard Preview

| Executive Summary | Product Analysis |
|---|---|
| KPI cards · Revenue trend · Category split | Top products · Margin analysis · Conditional table |

| Regional Performance | Trend Analysis |
|---|---|
| India map · City rankings · vs Target | MoM growth · YoY comparison · Revenue vs Target |

---

## 🏪 Business Scenario

ShopSmart is a fictional Indian retail chain selling Electronics, Clothing, and Home Appliances across 18 cities. The Sales Manager needs visibility into revenue, profit, regional performance, and target achievement.

**Business Questions Answered:**
- What is our total revenue and are we hitting our targets?
- Which products and categories drive the most profit?
- Which regions and cities are growing vs declining?
- How does this month compare to last month and last year?

---

## 📁 Project Structure

```
RetailIQ-PowerBI/
├── SQL Script/
│   ├── qury.sql
├── Raw_Data/
│   ├── Sales_Data.csv          # 2,000 transactions (Jan 2024 – Dec 2025)
│   ├── Products.csv            # 57 products across 3 categories
│   ├── Customers.csv           # 200 customer profiles
│   └── Sales_Targets.csv       # 288 monthly targets by region & category
├── RetailIQ_Dashboard.pbix     # Power BI Desktop file
└── README.md
```

---

## 🗂️ Dataset Overview

### Sales_Data.csv — Fact Table (2,000 rows)
| Column | Type | Description |
|--------|------|-------------|
| Order_ID | Text | Unique order identifier |
| Order_Date | Date | Transaction date |
| Customer_ID | Text | Foreign key → Customers |
| Product_ID | Text | Foreign key → Products |
| Quantity | Integer | Units ordered |
| Unit_Price | Decimal | Selling price (INR) |
| Discount | Decimal | Discount rate (0.10 = 10%) |
| Shipping_Cost | Decimal | Delivery charge (INR) |
| Revenue | Decimal | Qty × Price × (1-Discount) |
| Total_Cost | Decimal | Qty × Cost_Price |
| Profit | Decimal | Revenue − Cost − Shipping |
| Region | Text | North / South / East / West |
| City | Text | Customer city |
| Year | Integer | 2024 or 2025 |
| Month_Number | Integer | 1–12 |
| Month_Name | Text | January–December |
| Quarter | Text | Q1–Q4 |

### Products.csv — Dimension Table (57 rows)
Contains product name, category, sub-category, unit price, cost price (55–65% of unit price), and brand.

### Customers.csv — Dimension Table (200 rows)
Contains customer demographics: age, gender, segment (New/Regular/Premium), city, state, region, join date.

### Sales_Targets.csv — Target Table (288 rows)
Monthly sales targets by region and category for 2024 and 2025. Connected to Sales_Data via DAX (no direct relationship).

---

## ⭐ Data Model

Star Schema with Sales_Data as the central Fact Table.

```
Customers ──(Customer_ID)──► Sales_Data ◄──(Product_ID)── Products
                               (Fact)
                           Sales_Targets ── (DAX bridge, no relationship)
```

**Relationships:**
- Sales_Data → Products: Many-to-One on Product_ID ✅
- Sales_Data → Customers: Many-to-One on Customer_ID ✅
- Sales_Targets: No direct relationship — bridged via DAX CALCULATE()

---

## 🧮 DAX Measures (15 total)

### Basic KPIs
```dax
Total Revenue = SUM(Sales_Data[Revenue])
Total Cost    = SUM(Sales_Data[Total_Cost])
Total Profit  = SUM(Sales_Data[Profit])
Profit Margin % = DIVIDE([Total Profit], [Total Revenue], 0)
Total Orders  = COUNTROWS(Sales_Data)
Total Quantity = SUM(Sales_Data[Quantity])
Avg Order Value = DIVIDE([Total Revenue], [Total Orders], 0)
```

### Time Intelligence
```dax
Revenue LM   = CALCULATE([Total Revenue], PREVIOUSMONTH(Sales_Data[Order_Date]))
MoM Growth % = DIVIDE([Total Revenue] - [Revenue LM], [Revenue LM], 0)
Revenue SPLY = CALCULATE([Total Revenue], SAMEPERIODLASTYEAR(Sales_Data[Order_Date]))
YoY Growth % = DIVIDE([Total Revenue] - [Revenue SPLY], [Revenue SPLY], 0)
Revenue YTD  = TOTALYTD([Total Revenue], Sales_Data[Order_Date])
```

### Target Measures
```dax
Total Target =
  CALCULATE(
    SUM(Sales_Targets[Target_Amount]),
    FILTER(Sales_Targets,
      Sales_Targets[Year] >= MIN(Sales_Data[Year]) &&
      Sales_Targets[Year] <= MAX(Sales_Data[Year])
    )
  )

Target Achievement % = DIVIDE([Total Revenue], [Total Target], 0)
Revenue vs Target    = [Total Revenue] - [Total Target]
```

---

## 📊 Dashboard Pages

### Page 1 — Executive Summary
KPI cards (Revenue · Profit · Orders · Target %) · Monthly revenue trend line · Revenue by category donut · Revenue by region bar chart · Revenue by customer segment

### Page 2 — Product Analysis
Top 5 products by revenue · Profit margin % by sub-category · Product performance table with conditional formatting (color scale on margin %) · Sub-category slicer

### Page 3 — Regional Performance
India map (bubble size = revenue, color = profit margin) · Revenue by city bar chart · Actual vs Target by region · Region × Category matrix

### Page 4 — Trend Analysis
Revenue vs Target line chart · MoM Growth % columns (green/red conditional color) · 2024 vs 2025 YoY comparison · Revenue YTD KPI card

---

## 💡 Key Business Insights

| Insight | Finding | Recommendation |
|---------|---------|----------------|
| Category Concentration | Electronics = 88%+ of revenue | Diversify — high dependency risk |
| Profit Efficiency | Clothing margin 38% vs Electronics 33% | Promote high-margin Clothing |
| Regional Gap | West leads, East lags by 64% | Invest marketing budget in East |
| Seasonal Peaks | Oct–Dec spike 40% above average | Pre-build inventory by September |
| YoY Growth | 2025 revenue +10.1% vs 2024 | On track — maintain strategy |
| Customer Segments | Regular customers outspend Premium | Launch upsell / loyalty programme |

---

## 🛠️ Tools & Technologies

| Tool | Usage |
|------|-------|
| Power BI Desktop | Report development and publishing |
| Power Query (M) | Data cleaning and transformation |
| DAX | All KPI measures and calculations |
| Star Schema | Data modeling pattern |
| Python (pandas) | Dataset generation and validation |

---

## 📈 Data Summary

| Metric | Value |
|--------|-------|
| Total Transactions | 2,000 |
| Date Range | Jan 2024 – Dec 2025 |
| Total Revenue | ₹12.62 Crore |
| Total Profit | ₹4.35 Crore |
| Avg Profit Margin | 34.5% |
| Products | 57 (across 3 categories) |
| Customers | 200 |
| Cities | 18 |
| Regions | 4 (North, South, East, West) |

---

## 🚀 How to Use

1. Clone this repository or download the ZIP
2. Open `RetailIQ_Dashboard.pbix` in Power BI Desktop (free download from Microsoft)
3. If prompted, update the data source path to your local `Raw_Data/` folder
4. Click **Refresh** to reload the data
5. Explore all 4 dashboard pages using the slicers and navigation buttons

---

## 📚 What I Learned

- How to design a Star Schema data model for retail analytics
- Writing DAX time intelligence functions (PREVIOUSMONTH, SAMEPERIODLASTYEAR, TOTALYTD)
- Why DIVIDE() is safer than the / operator in DAX
- How to bridge tables without a direct relationship using CALCULATE()
- Applying UI/UX best practices: color encodes meaning, slicers at top, max 5 visuals per page
- How to translate data patterns into actionable business recommendations

---

## 📄 License

This project is for educational and portfolio purposes. All data is synthetically generated.

---

*Built as part of a structured Power BI learning curriculum | 2024–2025*

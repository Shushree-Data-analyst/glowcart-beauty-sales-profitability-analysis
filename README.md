# 💄 GlowCart Beauty — Sales & Profitability Analysis

<div align="center">

![Python](https://img.shields.io/badge/Python-3.x-blue?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Wrangling-150458?style=for-the-badge&logo=pandas&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-SQL%20Analysis-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![NumPy](https://img.shields.io/badge/NumPy-Computation-013243?style=for-the-badge&logo=numpy&logoColor=white)

**An end-to-end data analytics project covering ETL, Feature Engineering, SQL Analysis, and Business Intelligence for a multi-channel beauty brand.**

</div>

---

## 📌 Table of Contents

- [Business Problem](#-business-problem)
- [What I Did](#-what-i-did)
- [Actions Taken](#️-actions-taken--project-workflow)
- [Results & Insights](#-results--insights)
- [A/B Testing — Discount Impact Validation](#-ab-testing--discount-impact-validation)
- [Business Recommendations & Impact](#-business-recommendations--projected-impact)
- [Project Structure](#-project-structure)
- [Tech Stack & Concepts](#-tech-stack--concepts-used)
- [How to Run](#-how-to-run)
- [Key Learnings](#-key-learnings)

---

## 🔴 Business Problem

> *GlowCart Beauty operates across **5 regions**, **5 sales channels**, **20 product SKUs**, and **15 sales representatives** — but had no consolidated, data-driven view of where the business was actually profitable.*

The leadership team was making decisions on product stocking, discount approvals, sales rep incentives, and regional resource allocation **without a profitability lens**. Revenue was being generated — but whether that revenue was efficient, where the margins were leaking, and which combinations of region × channel × product were worth doubling down on — remained completely invisible.

**The one primary business question this project set out to answer:**

> *"Which products, regions, sales channels, and sales representatives are driving profitable growth — and how is discounting silently eroding the bottom line?"*

---

## 🎯 What I Did

As the sole data analyst on this project, I was responsible for building the **complete analytical pipeline from scratch** — from raw Excel data to a business-ready SQL query bank and an interactive Power BI dashboard.

The scope covered:
- Ingesting and cleaning raw transactional data (5,000 records across FY2023)
- Engineering 7 new financial and temporal features from 10 raw fields
- Designing and pushing the dataset to a MySQL database
- Authoring **19 structured SQL queries** answering key business questions
- Building a Power BI dashboard for stakeholder consumption
- Running statistical A/B testing to validate discount impact on revenue, margin, and volume
- Translating findings into 6 prioritised business recommendations

---

## ⚙️ Actions Taken — Project Workflow

### Step 1 — Data Ingestion
- Source: `GlowCart_Beauty.xlsx` with 10 raw fields: `Order_ID`, `Order_Date`, `Region`, `Sales_Channel`, `Product_Name`, `Qty_Sold`, `Unit_Price`, `Discount_Percent`, `COGS_Per_Unit`, `Sales_Rep`
- Loaded into Python using **Pandas** from CSV

### Step 2 — Data Cleaning

| Check | Method | Result |
|-------|--------|--------|
| Null Values | `isnull().sum()` + `dropna()` | ✅ Zero nulls after cleaning |
| Duplicates | `duplicated().sum()` | ✅ No duplicates found |
| Data Types | `dtypes` + `pd.to_datetime()` | ✅ `Order_Date` corrected to datetime64 |
| Column Names | `.str.lower()` | ✅ Standardised for SQL compatibility |
| Unique Values | `unique()` loop across all columns | ✅ No anomalies detected |

### Step 3 — Feature Engineering

7 new columns were derived to power the profitability analysis:

```python
# Revenue Features
df['Gross_Revenue']       = df['Qty_Sold'] * df['Unit_Price']
df['Discount_Amount']     = df['Gross_Revenue'] * (df['Discount_Percent'] / 100)
df['Net_Revenue']         = df['Gross_Revenue'] - df['Discount_Amount']

# Cost & Profit Features
df['Total_COGS']          = df['Qty_Sold'] * df['COGS_Per_Unit']
df['Gross_Profit']        = df['Net_Revenue'] - df['Total_COGS']
df['Gross_Margin_Percent']= (df['Gross_Profit'] / df['Net_Revenue']) * 100

# Temporal Features
df['Year']    = df['Order_Date'].dt.year
df['Month']   = df['Order_Date'].dt.month_name()
df['Quarter'] = df['Order_Date'].dt.quarter
```

### Step 4 — ETL to MySQL

```python
from sqlalchemy import create_engine

engine = create_engine('mysql+pymysql://root:yourpass@localhost:3306/glowcart_db')
df.to_sql('glowcart_sales', engine, if_exists='replace', index=False)
```

Cleaned dataset exported as `cleaned_glowcart.csv` and pushed to MySQL table `glowcart_sales`.

### Step 5 — SQL Analysis (19 Business Queries)

Queries were grouped into four analytical layers:

**KPI Layer**
```sql
-- Total Transactions
SELECT COUNT(*) AS total_records FROM glowcart_sales;

-- Total Net Revenue
SELECT ROUND(SUM(net_revenue), 2) AS total_revenue FROM glowcart_sales;

-- Total Gross Profit
SELECT ROUND(SUM(gross_profit), 2) AS total_profit FROM glowcart_sales;

-- Average Gross Margin %
SELECT ROUND(AVG(gross_margin_percent), 2) AS avg_margin FROM glowcart_sales;
```

**Dimensional Layer** — Revenue/Profit/Orders by Region, Channel Performance

**Product Layer** — Top 10 Revenue Products, Top 10 Profit Products, Least Profitable Products, Highest Discount Products, Best Products by Region

**People & Time Layer** — Top Revenue/Profit Sales Reps, Revenue by Month/Quarter, Region + Channel Profit combinations

### Step 6 — A/B Testing (Statistical Validation)

To move beyond descriptive trends, an independent-samples **Welch's t-test** was run in Python using `scipy.stats` to statistically validate whether discount level causes a real difference in revenue, margin, and volume outcomes. Full methodology and results are documented below in [A/B Testing — Discount Impact Validation](#-ab-testing--discount-impact-validation).

### Step 7 — Power BI Dashboard
Built an interactive dashboard (`GlowCart Beauty Sales Analysis.pbix`) covering all dimensions with drill-down capability across region, channel, product, and rep.

---

## 📊 Results & Insights

### 🔢 Business KPIs at a Glance

| Metric | Value |
|--------|-------|
| 📦 Total Transactions | **5,000** |
| 💰 Gross Revenue | **₹8.62 Cr** |
| 🏷️ Total Discount Erosion | **₹1.43 Cr** |
| 💵 Net Revenue | **₹7.19 Cr** |
| 📈 Gross Profit | **₹3.89 Cr** |
| 🧾 Total COGS | **₹3.30 Cr** |
| 📉 Avg Discount % | **16.53%** |
| 📊 Avg Gross Margin % | **55.94%** |

---

### 🗺️ Regional Performance

| Region | Net Revenue (₹) | Gross Profit (₹) | Profit Share |
|--------|----------------|------------------|--------------|
| North | 1,59,48,335 | 91,44,045 | 23.5% |
| Central | 1,58,96,658 | 91,93,514 | **23.6% 🏆** |
| East | 1,52,41,073 | 87,47,232 | 22.5% |
| South | 1,36,17,904 | 69,45,918 | 17.9% |
| West | 1,11,91,379 | 48,52,322 | ⚠️ 12.5% |

> **Insight:** West generates the lowest revenue AND the lowest profit — contributing only 12.5% of total profit. The gap between North and West in profit is **₹42.9 L**, an addressable business opportunity.

---

### 📡 Sales Channel Performance

| Channel | Net Revenue (₹) | Gross Profit (₹) |
|---------|----------------|------------------|
| Online | 1,46,66,695 | 79,38,534 |
| Pharmacy | 1,46,19,548 | **80,03,377 🏆** |
| Modern Trade | 1,45,56,457 | 77,79,231 |
| General Trade | 1,40,96,059 | 75,56,691 |
| Salon Wholesale | 1,39,56,591 | 76,05,199 |

> **Insight:** Pharmacy leads in gross profit despite being #2 in revenue — making it the most margin-efficient channel. Online leads in revenue but trails in profit efficiency.

---

### 🛍️ Product Portfolio

**Top 5 by Revenue:**

| Rank | Product | Net Revenue (₹) |
|------|---------|----------------|
| 1 | Perfume 100ml EDP | **1,20,97,386** |
| 2 | Night Repair Cream 50ml | 64,04,011 |
| 3 | Eyeshadow Palette 9-shade | 48,45,826 |
| 4 | Under Eye Cream 15ml | 47,16,820 |
| 5 | Blush Palette | 46,49,947 |

**Top 5 by Profit:**

| Rank | Product | Gross Profit (₹) |
|------|---------|-----------------|
| 1 | Perfume 100ml EDP | **54,56,264** |
| 2 | Night Repair Cream 50ml | 35,64,597 |
| 3 | Under Eye Cream 15ml | 28,03,159 |
| 4 | Vitamin C Face Serum 30ml | 26,23,089 |
| 5 | Eyeshadow Palette 9-shade | 22,82,409 |

> **Critical Insight:** Perfume 100ml EDP is the **#1 product in EVERY single region** — North (₹32.32 L), South (₹25.52 L), Central (₹24.46 L), East (₹21.66 L), West (₹17.02 L). It contributes **16.8% of total net revenue** from a 20-SKU portfolio. True hero product status.

**Bottom 5 by Profit (Underperformers):**

| Product | Gross Profit (₹) | Flag |
|---------|-----------------|------|
| Kajal Eye Pencil | 7,02,634 | 🔴 Lowest in portfolio |
| Lip Gloss | 10,54,182 | 🟡 High discount drag |
| Hair Oil 200ml | 11,51,023 | 🟡 Low margin category |
| Face Wash 100ml | 11,81,139 | 🟡 Commoditised SKU |
| Rose Water Toner 200ml | 12,41,653 | 🟡 Highest avg discount (17.71%) |

---

### 💸 Discount Impact Analysis

| Metric | Value |
|--------|-------|
| Avg Discount Offered | **16.53%** |
| Total Revenue Lost to Discounts | **₹1,42,73,820** |
| Revenue Lost as % of Gross Revenue | **14.2%** |
| Highest Discounted Product | Rose Water Toner 200ml (17.71%) |
| 2nd Highest | Night Repair Cream 50ml (17.30%) |

> **Insight:** ₹1.43 Cr is being surrendered annually in discounts. Night Repair Cream — a top-profit product — is carrying a 17.30% average discount, meaning its margins are being voluntarily compressed without business necessity.

---

## 🧪 A/B Testing — Discount Impact Validation

To statistically validate whether discount level causes a real, measurable difference in business outcomes (rather than just an observed trend), an **independent samples t-test (Welch's t-test)** was run comparing low-discount vs high-discount transactions.

### Experiment Design

| Group | Definition | Role |
|-------|-----------|------|
| **Group A** | Discount ≤ 10% | Control (low discount) |
| **Group B** | Discount > 20% | Treatment (high discount) |

**Method:** `scipy.stats.ttest_ind(a, b, equal_var=False)` — Welch's t-test, chosen over the standard t-test because group sizes and variances are not assumed equal.

**Metrics tested:** Net Revenue, Gross Margin %, Quantity Sold

### Results

| Metric | Mean (Group A) | Mean (Group B) | t-statistic | p-value | Significant (p<0.05)? |
|--------|----------------|-----------------|-------------|---------|-------------------------|
| Net Revenue | ₹15,782.85 | ₹12,089.01 | 7.841 | 0.00000 | ✅ True |
| Gross Margin % | 60.81% | 48.44% | 42.717 | 0.00000 | ✅ True |
| Qty Sold | 30.53 | 30.88 | -0.590 | 0.55503 | ❌ False |

### Insight

> High-discount transactions (Group B) show a **statistically significant drop** in both average net revenue (₹12,089 vs ₹15,783) and gross margin (48.44% vs 60.81%) compared to low-discount transactions — confirmed with extremely strong significance (p < 0.00001) on both metrics. However, quantity sold shows **no statistically significant difference** between groups (p = 0.555) — meaning bigger discounts are **not** meaningfully driving higher unit sales.
>
> **This is a critical finding:** the data disproves the common assumption that "discounting drives volume." In this dataset, high discounts erode revenue and margin **without a corresponding lift in units sold** — directly reinforcing the case for **REC 2 (Rationalise the Discount Policy)**. The discount strategy is not paying for itself in volume terms.

---

### 📅 Temporal Trends

| Quarter | Net Revenue (₹) | vs Portfolio Avg |
|---------|----------------|-----------------|
| Q1 (Jan–Mar) | 1,76,33,290 | -0.8% |
| Q2 (Apr–Jun) | 1,76,15,203 | -0.9% |
| Q3 (Jul–Sep) | **1,85,61,210** | **+4.4% 🏆** |
| Q4 (Oct–Dec) | 1,80,85,646 | +1.7% |

**Peak Months:** September (₹65.64 L) → March (₹65.29 L) → April (₹63.63 L)

---

### 🏆 Top Region × Channel Combinations (Profit)

| Region | Channel | Gross Profit (₹) |
|--------|---------|-----------------|
| Central | Pharmacy | **21,40,734 🏆** |
| North | Pharmacy | 19,99,741 |
| Central | Online | 19,85,872 |
| North | Modern Trade | 19,33,133 |
| Central | Salon Wholesale | 18,37,100 |

---

### 👤 Sales Rep Performance

| Rep | Net Revenue (₹) | Gross Profit (₹) | Profit Rank |
|-----|----------------|-----------------|-------------|
| Meena G | **58,95,950** | 32,92,749 | #3 |
| Vikram N | 58,53,934 | **34,10,422** | **#1 🏆** |
| Deepa S | 56,73,540 | 33,27,179 | #2 |
| Anjali M | 53,49,819 | 30,14,569 | #5 |
| Suresh K | 53,25,100 | 30,28,095 | #4 |

> **Key Insight:** Meena G generates the **highest revenue** but ranks **#3 in profit**. Vikram N generates slightly less revenue but is the **most profitable rep** — a classic revenue vs. margin trade-off that incentive structures should address.

---

## 💡 Business Recommendations & Projected Impact

### REC 1 — Double Down on Perfume 100ml EDP
Perfume 100ml EDP contributes 16.8% of net revenue from a 20-SKU portfolio and ranks #1 in every region. Increasing availability, marketing investment, and channel penetration — especially in West (lowest at ₹17.02 L vs North's ₹32.32 L) — could drive a **5–8% uplift in total revenue.**
> 💰 **Estimated Impact: +₹35–57 L annually**

### REC 2 — Rationalise the Discount Policy
₹1.43 Cr is being lost to discounts annually (14.2% of gross revenue). The A/B test above statistically confirms that high-discount transactions show significantly lower revenue and margin (p < 0.00001) with **no significant gain in quantity sold** (p = 0.555) — meaning the current discount depth is not being "earned back" through volume. Reducing average discount from 16.53% to ~12% on top-profit SKUs (Night Repair Cream, Under Eye Cream, Vitamin C Serum) — which have demonstrated margin strength — would recover significant net revenue without meaningful demand destruction.
> 💰 **Estimated Impact: +₹30–40 L in recovered net revenue**

### REC 3 — Invest in Central + North via Pharmacy Channel
Central-Pharmacy (₹21.4 L profit) and North-Pharmacy (₹20.0 L profit) are the top two most profitable region × channel intersections. Prioritising stock availability, targeted promotions, and rep attention in these combinations compounds an existing structural advantage.
> 📈 **Estimated Impact: +2–3 percentage points in margin for these zones**

### REC 4 — Turnaround Plan for West Region
West contributes only 12.5% of total profit — a ₹42.9 L gap vs North. A targeted diagnostic on West (pricing strategy, rep effectiveness, channel mix shift toward Pharmacy) could bring it closer to the portfolio average.
> 💰 **Estimated Impact: ₹15–25 L in recoverable profit**

### REC 5 — Portfolio Review for Bottom 5 SKUs
Kajal Eye Pencil (₹7.03 L), Lip Gloss (₹10.54 L), and Hair Oil 200ml (₹11.51 L) generate minimal returns. Options: COGS renegotiation with suppliers, de-listing, or repositioning as bundled/complementary products with hero SKUs.
> 💰 **At-risk value: ₹43–53 L tied in low-yield inventory**

### REC 6 — Restructure Sales Rep Incentives Around Profit, Not Revenue
The current revenue-first view obscures the fact that Meena G (top revenue rep) delivers lower profit than Vikram N (top profit rep). Shifting incentive structures from revenue targets to profit-weighted targets would naturally redirect the team toward higher-margin SKUs.
> 📈 **Estimated Impact: ₹8–12 L in margin improvement across the 15-rep team**

---

### 🎯 Total Projected Business Impact

> If all six recommendations are implemented, the projected incremental impact is **₹85–130 L in recovered revenue, profit, or cost optimisation annually** — a **2.2–3.3% improvement** on the current ₹3.89 Cr gross profit base.

---

## 📁 Project Structure

```
Beauty_sales/
│
├── 📓 Beauty-Sales-&-Profitability-Analysis.ipynb   # Main EDA & Feature Engineering notebook
│
├── 📂 Data(Raw & Cleaned)/
│   ├── GlowCart_Beauty.xlsx                          # Raw source data
│   └── cleaned_glowcart.csv                          # Cleaned + engineered dataset (5,000 rows × 19 cols)
│
├── 📂 Queries/                                       # 19 SQL business queries
│   ├── Total Transactions.sql
│   ├── Total Revenue.sql
│   ├── Total Profit.sql
│   ├── Average Margin %.sql
│   ├── Orders by Region.sql
│   ├── Revenue by Region.sql
│   ├── Profit by Region.sql
│   ├── Channel Performance.sql
│   ├── Top 10 Revenue Products.sql
│   ├── Top 10 Profit Products.sql
│   ├── Least Profitable Products.sql
│   ├── Top Revenue Sales Reps.sql
│   ├── Top Profit Sales Reps.sql
│   ├── Revenue by Month.sql
│   ├── Revenue by Quarter.sql
│   ├── Discount Analysis.sql
│   ├── Highest Discount Products.sql
│   ├── Best Products by Region.sql
│   └── Top Region + Channel Profit.sql
│
└── 📊 GlowCart Beauty Sales Analysis.pbix            # Power BI interactive dashboard
```

---

## 🛠️ Tech Stack & Concepts Used

| Category | Tools / Techniques |
|----------|-------------------|
| **Language** | Python 3.x |
| **Data Wrangling** | Pandas, NumPy |
| **Data Cleaning** | Null handling, duplicate detection, dtype correction, column standardisation |
| **Feature Engineering** | 7 derived financial & temporal metrics |
| **Statistical Testing** | Welch's t-test (`scipy.stats.ttest_ind`) for A/B discount impact validation |
| **ETL Pipeline** | SQLAlchemy + PyMySQL → MySQL |
| **Database** | MySQL (glowcart_db → glowcart_sales table) |
| **SQL Analytics** | Aggregate functions, GROUP BY, ORDER BY, LIMIT, multi-dimensional ranking |
| **Business Analytics** | Revenue vs Profit decomposition, discount impact, regional benchmarking, rep bifurcation |
| **Visualisation** | Power BI (interactive dashboard with drill-downs) |
| **IDE** | Jupyter Notebook |

---

## ▶️ How to Run

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/GlowCart-Beauty-Sales-Analysis.git
cd GlowCart-Beauty-Sales-Analysis
```

### 2. Install Dependencies
```bash
pip install pandas numpy scipy sqlalchemy pymysql openpyxl
```

### 3. Run the Notebook
Open `Beauty-Sales-&-Profitability-Analysis.ipynb` in Jupyter and run all cells.

> Update the file path in cell 2 to point to your local `cleaned_glowcart.csv`.

### 4. Set Up MySQL (Optional — for SQL queries)
```bash
# Create the database
mysql -u root -p
CREATE DATABASE glowcart_db;
```
Then update the connection string in the notebook:
```python
engine = create_engine('mysql+pymysql://root:YOUR_PASSWORD@localhost:3306/glowcart_db')
```
Run the notebook to push the cleaned data to MySQL, then execute any `.sql` file from the `Queries/` folder.

### 5. Power BI Dashboard
Open `GlowCart Beauty Sales Analysis.pbix` in Power BI Desktop. Reconnect the data source to your local `cleaned_glowcart.csv` if prompted.

---

## 📌 Key Learnings

- A product contributing **16.8% of revenue** from a 20-SKU portfolio is a strategic asset, not just a top seller — it deserves dedicated investment.
- **Revenue ≠ Profit.** Three separate findings (reps, channels, products) showed high-revenue entities underperforming on profit — the most dangerous blind spot in a data-poor business.
- **Discounting at 16.53% average is not a strategy** — ₹1.43 Cr/year in erosion with no systematic model for which products actually need discounting is a policy gap, not a pricing strategy.
- **Statistical testing beats assumption.** The A/B test proved that higher discounts significantly hurt revenue and margin (p < 0.00001) while producing **no significant increase in quantity sold** (p = 0.555) — the data disproved the common "discount to drive volume" assumption outright.
- The **ETL → SQL → BI workflow** is the real-world analytics stack. Building each layer with clean handoffs (cleaned CSV → MySQL → Power BI) made the analysis reproducible, scalable, and audit-ready.

---

## 👩‍💻 Author

**Shushree Swain**
Data Analyst | Python · SQL · Power BI
---

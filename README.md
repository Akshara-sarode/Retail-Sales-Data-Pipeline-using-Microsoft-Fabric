
# **Retail Sales Data Pipeline using Microsoft Fabric**

**Microsoft Fabric | Power BI | PySpark | SQL**

A production-style **retail analytics pipeline built with Microsoft Fabric**, processing **913K+ retail transactions** using a **Medallion Lakehouse architecture**, dimensional warehouse modeling, and **Power BI dashboards** for executive decision-making.

---


# 📌 **Business Problem**

Retail organizations generate massive volumes of transactional data but often lack structured pipelines to convert raw data into **actionable insights**.

This project demonstrates how a **modern analytics platform (Microsoft Fabric)** can transform raw retail transaction data into business intelligence through a complete pipeline including:

* 📥 Data ingestion
* 🔄 Data transformation
* 🏗️ Dimensional modeling
* 📊 Semantic analytics
* 📈 Interactive dashboard reporting

---

# 📊 **Dataset**

| **Attribute**  | **Value**                              |
| -------------- | -------------------------------------- |
| **Source**     | Kaggle – Store Item Demand Forecasting |
| **Records**    | 913,000+                               |
| **Stores**     | 10                                     |
| **Items**      | 50                                     |
| **Date Range** | Jan 2013 – Dec 2017                    |
| **Data Type**  | Retail sales transactions              |

🔗 **Dataset Link**

[https://www.kaggle.com/competitions/demand-forecasting-kernels-only/data](https://www.kaggle.com/competitions/demand-forecasting-kernels-only/data)

---

# 🏗️ **Architecture Overview**

The project implements a modern **Medallion Lakehouse Architecture** using **Microsoft Fabric**.

```
Raw CSV (Kaggle)
      │
      ▼
Bronze Layer (Raw Data Ingestion)
      │
      ▼
Silver Layer (Cleaned & Enriched Data)
      │
      ▼
Gold Layer (Business Aggregations)
      │
      ▼
Fabric Warehouse (Star Schema)
      │
      ▼
Power BI Semantic Model (DAX Measures)
      │
      ▼
Power BI Executive Dashboard
```

---

# ⚙️ **Technology Stack**

| **Layer**          | **Technology**                  | **Purpose**                 |
| ------------------ | ------------------------------- | --------------------------- |
| **Storage**        | Fabric Lakehouse + Delta Tables | Medallion architecture      |
| **Processing**     | PySpark (Fabric Notebooks)      | Data transformation         |
| **Warehouse**      | Fabric Warehouse + T-SQL        | Dimensional modeling        |
| **Semantic Layer** | Power BI Dataset                | Relationships & analytics   |
| **Analytics**      | DAX                             | Time intelligence & metrics |
| **Visualization**  | Power BI                        | Executive dashboard         |

---

# 🔄 **Data Pipeline**

## 1️⃣ **Data Ingestion — Bronze Layer**

Raw CSV files are ingested into the **Fabric Lakehouse Bronze layer**.

### 🎯 Purpose

* Preserve raw data
* Enable full reproducibility
* Maintain data lineage

### Example Notebook Step

```python
df = spark.read.table("bronze_sales_raw")
```

### Schema

```
date
store
item
sales
```

### Dataset Validation Checks

* Null value validation
* Duplicate validation
* Row count verification

📊 **Total records:** 913,000+

---

## 2️⃣ **Data Transformation — Silver Layer**

The **Silver layer cleans and enriches the dataset**.

### Additional Attributes Extracted

* `year`
* `month`
* `day_of_week`

### Example Transformation

```python
from pyspark.sql.functions import year, month, dayofweek

df_silver = df \
    .withColumn("year", year("date")) \
    .withColumn("month", month("date")) \
    .withColumn("day_of_week", dayofweek("date"))
```

### Partitioning Strategy

Partitioned by:

```
year
month
```

### Benefits

* Faster query performance
* Reduced scan cost

---

## 3️⃣ **Gold Layer — Business Aggregations**

The **Gold layer contains analytics-ready datasets** used directly by BI tools.

| **Table**                      | **Purpose**          |
| ------------------------------ | -------------------- |
| `gold_daily_sales`             | Sales trend analysis |
| `gold_store_sales`             | Store performance    |
| `gold_item_sales`              | Product performance  |
| `gold_day_of_week_performance` | Weekly sales pattern |

### Example Aggregation

```sql
SELECT
date,
SUM(sales) AS total_sales
FROM silver_sales
GROUP BY date;
```

---

# 🏢 **Fabric Warehouse — Dimensional Modeling**

A **Star Schema warehouse** was implemented for BI analytics.

---

## 📌 Fact Table

```
FactSales
---------
date_key
store_key
item_key
sales
```

---

## 📌 Dimension Tables

```
DimDate
DimStore
DimItem
```

---

## 📌 Relationship Structure

```
DimDate   1 ─── * FactSales
DimStore  1 ─── * FactSales
DimItem   1 ─── * FactSales
```

### Benefits

* Optimized BI queries
* Simplified relationships
* Reduced data redundancy

---

# 🧾 **SQL Views for Reporting**

Views simplify analytics queries.

### Example View

```sql
CREATE OR ALTER VIEW vw_store_sales AS
SELECT
store_key,
SUM(sales) AS total_sales
FROM FactSales
GROUP BY store_key;
```

### Additional Views

```
vw_daily_sales
vw_monthly_sales
vw_dayofweek_sales
vw_item_sales
```

---

# 📊 **Semantic Model & DAX Analytics**

A **Power BI Semantic Model** was built on top of the warehouse.

---

## 📌 Key DAX Measures

### Total Sales

```DAX
Total Sales =
SUM(FactSales[sales])
```

### Average Daily Sales

```DAX
Avg Daily Sales =
AVERAGEX(
VALUES(DimDate[date_key]),
[Total Sales]
)
```

### Previous Year Sales

```DAX
Previous Year Sales =
CALCULATE(
[Total Sales],
SAMEPERIODLASTYEAR(DimDate[date_key])
)
```

### YoY Growth %

```DAX
YoY Growth % =
DIVIDE(
[Total Sales] - [Previous Year Sales],
[Previous Year Sales]
)
```

### Store Rank

```DAX
Store Rank =
RANKX(
ALL(DimStore),
[Total Sales],
,
DESC
)
```

---

# 📊 **Power BI Dashboard**

The final **Executive Dashboard** provides business insights.

### Dashboard Visuals

| **Visual**        | **Purpose**                            |
| ----------------- | -------------------------------------- |
| KPI Cards         | Total Sales, Avg Daily Sales, Best Day |
| Sales Trend       | Time series sales analysis             |
| Store Performance | Ranking of stores                      |
| Weekly Pattern    | Day-of-week analysis                   |
| YoY Growth        | Growth trend analysis                  |

---

### Example Metrics

| **Metric**      | **Value** |
| --------------- | --------- |
| Total Revenue   | $48M      |
| Avg Daily Sales | $26.13K   |
| Best Day        | Sunday    |
| Best Store      | Store 2   |

---

# 📈 **Key Insights**

| **Insight**          | **Finding**     |
| -------------------- | --------------- |
| Peak Growth          | 15% YoY in 2014 |
| Growth Stabilization | ~3.6% by 2017   |
| Best Sales Day       | Sunday          |
| Weakest Day          | Monday          |
| Best Store           | Store 2         |
| Lowest Store         | Store 7         |

### Business Implications

* Increase staffing during weekends
* Investigate low-performing stores
* Optimize seasonal inventory planning
* Promote Monday sales campaigns

---

# 📈 **Scalability Considerations**

The architecture was designed with **scalability in mind**.

### Key Optimizations

* Delta tables for ACID transactions
* Partitioning by year/month
* Star schema for optimized joins
* Pre-aggregated Gold tables for faster dashboards

---

# 🎯 **Skills Demonstrated**

## ⚙️ Data Engineering

* Medallion Lakehouse architecture
* PySpark transformations
* Delta table management
* Data pipeline design

---

## 🏗️ Data Modeling

* Star schema warehouse design
* Fact and dimension modeling
* SQL view creation

---

## 📊 Business Intelligence

* Power BI dashboard development
* DAX analytics
* Time intelligence calculations
* KPI design

---

# 🚀 **How to Run This Project**

1️⃣ Download dataset from Kaggle

2️⃣ Create a **Microsoft Fabric workspace**

3️⃣ Create a **Lakehouse and upload the dataset**

4️⃣ Run the **PySpark notebook**

5️⃣ Create **warehouse tables**

6️⃣ Create **SQL views**

7️⃣ Build **semantic model**

8️⃣ Create **Power BI dashboard**

---

# ⭐ **Project Outcome**

This project demonstrates a **complete end-to-end modern data analytics architecture** using **Microsoft Fabric**, combining:

* Lakehouse data engineering
* Data warehouse modeling
* Semantic analytics
* Executive-level reporting

# 👨‍💻 Author

**Akshara Avinash Sarode**

**LinkedIn: https://www.linkedin.com/in/akshara-avinash-sarode/**


-- Create Dimension Tables
CREATE TABLE dbo.DimDate (
    date_key DATE NOT NULL,
    year INT,
    month INT,
    day_of_week INT,
    day_name VARCHAR(20)
);

CREATE TABLE dbo.DimStore (
    store_key INT NOT NULL
);

CREATE TABLE dbo.DimItem (
    item_key INT NOT NULL
);

-- Create Fact Table
CREATE TABLE dbo.FactSales (
    date_key DATE NOT NULL,
    store_key INT NOT NULL,
    item_key INT NOT NULL,
    sales INT
);
--------
INSERT INTO dbo.DimDate
SELECT DISTINCT
    date AS date_key,
    year,
    month,
    day_of_week,
    DATENAME(WEEKDAY, date) AS day_name
FROM retail_lakehouse.dbo.silver_sales;

---
INSERT INTO dbo.DimStore
SELECT DISTINCT store AS store_key
FROM retail_lakehouse.dbo.silver_sales;

SELECT COUNT(*) AS store_rows FROM dbo.DimStore;
-------
INSERT INTO dbo.DimItem
SELECT DISTINCT item AS item_key
FROM retail_lakehouse.dbo.silver_sales;
---
INSERT INTO dbo.FactSales
SELECT
    date AS date_key,
    store AS store_key,
    item AS item_key,
    sales
FROM retail_lakehouse.dbo.silver_sales;

SELECT COUNT(*) AS fact_rows FROM dbo.FactSales;
---
SELECT COUNT(*) AS date_rows FROM dbo.DimDate;
-----
SELECT COUNT(*) AS store_rows FROM dbo.DimStore;
SELECT COUNT(*) AS item_rows FROM dbo.DimItem;
SELECT COUNT(*) AS fact_rows FROM dbo.FactSales;
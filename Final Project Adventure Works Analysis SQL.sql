########  SQL FINAL PROJECT  ######

CREATE DATABASE IF NOT EXISTS FinalProject;
use finalproject;
SHOW tables;
#### QUES - 0 ######
CREATE TABLE Combinedsales AS
SELECT 
    *
FROM
    fact_internet_sales 
UNION   SELECT 
    *
FROM
    fact_internet_sales_new;

##### QUES - 1 #####
Select * from combinedsales;
Select * from dim_product;

SELECT 
    S.*, P.EnglishProductName
FROM
    combinedsales AS S
        JOIN
    dim_product AS P ON S.ProductKey = P.ProductKey;
    
##### QUES - 2 #####
SELECT 
    *
FROM
    dim_customer;
SELECT 
    *
FROM
    union_fact_internet_sales;
SELECT 
    S.*, P.`Unit Price` AS unitprice, C.CustomerFullName
FROM
    combinedsales AS S
        LEFT JOIN
    dim_customer AS C ON S.CustomerKey = C.CustomerKey
        LEFT JOIN
    dim_product AS P ON S.ProductKey = P.ProductKey;

##### QUES - 3 - A,B,C  #####
SELECT 
    *,
    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS orderdate,
    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year,
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthFullName
FROM
  combinedsales;

#### QUES-D ###
SELECT 
    *,
    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS orderdate,
    CASE
        WHEN MONTH(OrderDateKey) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(OrderDateKey) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(OrderDateKey) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(OrderDateKey) BETWEEN 10 AND 12 THEN 'Q4'
    END AS Quarter
FROM
    combinedsales;

#### QUES - E #####
SELECT 
    *,
    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS orderdate,
    CONCAT(YEAR(OrderDateKey),
            '-',
            UPPER(DATE_FORMAT(OrderDateKey, '%b'))) AS YearMonth
FROM
    combinedsales;
    
##### QUES - F,G #####
SELECT 
    *,
    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS orderdate,
    DAYOFWEEK(OrderDateKey) AS Weekdayno,
    DAYNAME(OrderDateKey) AS Weekdayname
FROM
    combinedsales;
    
##### QUES - H #####
SELECT 
    *,
    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS orderdate,
    CASE
        WHEN MONTH(OrderDateKey) >= 4 THEN MONTH(OrderDateKey) - 3
        ELSE MONTH(OrderDateKey) + 9
    END AS FinancialMonth
FROM
    combinedsales;
    
##### QUES - I #####
SELECT 
    *,
    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS orderdate,
   CASE
        WHEN MONTH(OrderDateKey) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(OrderDateKey) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(OrderDateKey) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4' 
        END AS FinancialQuarter
FROM
    combinedsales;
	
##### QUES - 4 #####
SELECT 
    *,
    (UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS SalesAmount
FROM
    combinedsales;
    
##### QUES - 5 #####
SELECT 
    *, (ProductStandardCost * OrderQuantity) AS ProductionCost
FROM
    combinedsales;
    
##### QUES - 6 #####
SELECT 
    *,
    (UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) - (ProductStandardCost * OrderQuantity) AS Profit
FROM
   combinedsales;
    
##### QUES - 8 #####
SELECT 
    YEAR(STR_TO_DATE(TRIM(OrderDateKey), '%Y%m%d')) AS Year,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS TotalSales
FROM combinedsales
GROUP BY YEAR(STR_TO_DATE(TRIM(OrderDateKey), '%Y%m%d'))
ORDER BY Year;

##### QUES - 9 #####

SELECT 
    date_format(STR_TO_DATE(OrderDateKey, '%Y%m%d'),'%b') AS MonthName,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS TotalSales
FROM combinedsales
GROUP BY MonthName
ORDER BY STR_TO_DATE(CONCAT(MonthName, ' 2010'), '%b %Y');

##### QUES - 10 #####

SELECT 
CONCAT('Q', QUARTER(STR_TO_DATE(OrderDateKey, '%Y%m%d'))) AS Quarter,
 SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS TotalSales
FROM combinedsales
Group by quarter
Order by Quarter;

##### QUES - 11 #####

SELECT 
    P.EnglishProductName,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS SalesAmount,
    SUM(ProductStandardCost * OrderQuantity) AS ProductionCost
FROM combinedsales AS S
LEFT JOIN dim_product AS P
    ON S.ProductKey = P.ProductKey
GROUP BY P.EnglishProductName
ORDER BY SalesAmount DESC;

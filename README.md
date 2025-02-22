### What is RFM Segmentation?

RFM (Recency, Frequency, Monetary) segmentation is a data-driven technique used in customer analytics to categorize customers based on their purchasing behavior. It helps businesses identify their most valuable customers and tailor marketing strategies accordingly.

- **Recency (R):** How recently a customer has made a purchase.
- **Frequency (F):** How often a customer makes purchases within a given period.
- **Monetary (M):** The total amount a customer has spent.

### How is RFM Segmentation Used?

RFM segmentation is widely used in industries like retail, e-commerce, and automotive sales to enhance customer relationship management. Some key applications include:

- **Customer Retention:** Identifying inactive customers and re-engaging them through targeted marketing.
- **Personalized Marketing:** Offering special deals and promotions based on customer purchasing patterns.
- **Sales Strategy Optimization:** Prioritizing high-value customers for loyalty programs and exclusive offers.
- **Churn Prediction:** Detecting potential customer churn and taking proactive measures to retain them.

In the context of **car sales**, RFM segmentation can help dealerships and manufacturers understand customer behavior, target frequent buyers with exclusive offers, and re-engage customers who haven't made a purchase recently.

## Create Database 
```sql
create database if not exists rfm_segmentation;
use `rfm_segmentation`;

-- Create Sales table in Database --
 
CREATE TABLE if not exists`sales_data` (
  `ORDERNUMBER` int DEFAULT NULL,
  `QUANTITYORDERED` int DEFAULT NULL,
  `PRICEEACH` double DEFAULT NULL,
  `ORDERLINENUMBER` int DEFAULT NULL,
  `SALES` double DEFAULT NULL,
  `ORDERDATE.1` text,
  `STATUS` text,
  `QTR_ID` int DEFAULT NULL,
  `MONTH_ID` int DEFAULT NULL,
  `YEAR_ID` int DEFAULT NULL,
  `PRODUCTLINE` text,
  `MSRP` int DEFAULT NULL,
  `PRODUCTCODE` text,
  `CUSTOMERNAME` text,
  `PHONE` text,
  `ADDRESSLINE1` text,
  `ADDRESSLINE2` text,
  `CITY` text,
  `STATE` text,
  `POSTALCODE` text,
  `COUNTRY` text,
  `TERRITORY` text,
  `CONTACTLASTNAME` text,
  `CONTACTFIRSTNAME` text,
  `DEALSIZE` text);
  ```
  ## Load Data in table
  ```sql
  LOAD DATA INFILE 'C:\Users\Admin\Downloads\Sales Data for RFM Segmentation.csv' 
INTO TABLE `sales_data`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```
## Dataset Exploration

```sql
SELECT * FROM sales_data LIMIT 5;
```
-- OUTPUT --
| ORDERNUMBER | QUANTITYORDERED | PRICEEACH | ORDERLINENUMBER | SALES   | ORDERDATE | STATUS  | QTR_ID | MONTH_ID | YEAR_ID | PRODUCTLINE | MSRP | PRODUCTCODE | CUSTOMERNAME          | PHONE       | ADDRESSLINE1            | ADDRESSLINE2 | CITY          | STATE | POSTALCODE | COUNTRY | TERRITORY | CONTACTLASTNAME | CONTACTFIRSTNAME | DEALSIZE |
|-------------|------------------|-----------|------------------|---------|-----------|---------|--------|----------|---------|-------------|------|-------------|-----------------------|-------------|-------------------------|--------------|---------------|-------|------------|---------|-----------|-----------------|------------------|----------|
| 10107       | 30.00            | 95.70     | 2                | 2871.00 | 24/2/03   | Shipped | 1      | 2        | 2003    | Motorcycles | 95   | S10_1678    | Land of Toys Inc.     | 2125557818  | 897 Long Airport Avenue |              | NYC           | NY    | 10022      | USA     | NA        | Yu              | Kwai             | Small    |
| 10121       | 34.00            | 81.35     | 5                | 2765.90 | 7/5/03    | Shipped | 2      | 5        | 2003    | Motorcycles | 95   | S10_1678    | Reims Collectables    | 26.47.1555  | 59 rue de l'Abbaye     |              | Reims         |       | 51100      | France  | EMEA       | Henriot         | Paul             | Small    |
| 10134       | 41.00            | 94.74     | 2                | 3884.34 | 1/7/03    | Shipped | 3      | 7        | 2003    | Motorcycles | 95   | S10_1678    | Lyon Souveniers       | +33 1 46 62 7555 | 27 rue du Colonel Pierre Avia |              | Paris         |       | 75508      | France  | EMEA       | Da Cunha        | Daniel           | Medium   |
| 10145       | 45.00            | 83.26     | 6                | 3746.70 | 25/8/03   | Shipped | 3      | 8        | 2003    | Motorcycles | 95   | S10_1678    | Toys4GrownUps.com     | 6265557265  | 78934 Hillside Dr.     |              | Pasadena      | CA    | 90003      | USA     | NA        | Young           | Julie            | Medium   |
| 10159       | 49.00            | 100.00    | 14               | 5205.27 | 10/10/03  | Shipped | 4      | 10       | 2003    | Motorcycles | 95   | S10_1678    | Corporate Gift Ideas Co. | 6505551386  | 7734 Strong St.        |              | San Francisco | CA    |            | USA     | NA        | Brown           | Julie            | Medium   |

```sql
SELECT COUNT(*) FROM sales_data;-- 2823
```
-- OUTPUT --
| COUNT(*) |
|----------|
| 2823     |

## Checking unique values
```sql
select distinct status from sales_data;
```
-- OUTPUT --
| status     |
|------------|
| Shipped    |
| Disputed   |
| In Process |
| Cancelled  |
| On Hold    |
| Resolved   |

```sql
select distinct year_id from sales_data;
```
-- OUTPUT --
| year_id |
|---------|
| 2003    |
| 2004    |
| 2005    |

```sql
select distinct PRODUCTLINE from sales_data;
```
-- OUTPUT --
| PRODUCTLINE      |
|------------------|
| Motorcycles      |
| Classic Cars     |
| Trucks and Buses |
| Vintage Cars     |
| Planes           |
| Ships            |
| Trains           |

```sql
select distinct COUNTRY from sales_data;
```
-- OUTPUT --
| COUNTRY     |
|-------------|
| USA         |
| France      |
| Norway      |
| Australia   |
| Finland     |
| Austria     |
| UK          |
| Spain       |
| Sweden      |
| Singapore   |
| Canada      |
| Japan       |
| Italy       |
| Denmark     |
| Belgium     |
| Philippines |
| Germany     |
| Switzerland |
| Ireland     |



```sql
select distinct TERRITORY from sales_data;
```
-- OUTPUT --
| TERRITORY |
|-----------|
| NA        |
| EMEA      |
| APAC      |
| Japan     |


## RFM_ANALYSIS
**This SQL query calculates the RFM (Recency, Frequency, Monetary) values for each customer in the dataset**
```sql
select `CUSTOMERNAME`,round(sum(`Sales`),0) as Monetary,count(`ORDERNUMBER`) as frequency,timestampdiff(day,(select max(`ORDERDATE.1`)from `sales_data`),max(`ORDERDATE.1`))*-1 as recency from `sales_data`
group by `CUSTOMERNAME`
```
--Output--
|CUSTOMERNAME            |Monetary|frequency|recency|
|------------------------|--------|---------|-------|
|Land of Toys Inc.       |164069  |49       |197    |
|Reims Collectables      |135043  |41       |62     |
|Lyon Souveniers         |78570   |20       |75     |
|Toys4GrownUps.com       |104562  |30       |139    |
|Corporate Gift Ideas Co.|149882  |41       |97     |


**This SQL code creates a view named SEGMENT_RFM, which calculates the RFM (Recency, Frequency, Monetary) scores and combines them into a single RFM category combination for each customer and assigns a customer segment label based on their RFM category combination**
```sql
create view Segment_RFM as
with RFM AS (With Rf as(with R as(select `CUSTOMERNAME`,round(sum(`Sales`),0) as Monetary,count(`ORDERNUMBER`) as frequency,timestampdiff(day,(select max(`ORDERDATE.1`)from `sales_data`),max(`ORDERDATE.1`))*-1 as recency from `sales_data`
group by `CUSTOMERNAME`)
select *, 
ntile(4) over (order by Monetary asc) as mone,
ntile(4) over (order by frequency asc) as fre,
ntile(4) over (order by recency desc) as rec,
concat(ntile(4) over (order by Monetary asc),ntile(4) over (order by frequency asc),ntile(4) over (order by recency desc)) as concat_,
(ntile(4) over (order by Monetary asc)+ntile(4) over (order by frequency asc)+ntile(4) over (order by recency desc)) as Total_sum 
from R)
select *,
case when concat_ in ('111','211','121')  then 'Churned Customers'
 when concat_ in ('112','212','441','341','331')  then 'Hibernating' 
 when  concat_ in ('113','114','122','123','124','131','132','133','141','142','422','242')   then 'At Risk'
 when concat_ in ('213','214','221','222','223','144','143','134','432')   then 'Potential Loyalists' 
 when concat_ in ('224','231','232','233','234','321','322',244)   then 'Loyal Customers' 
 when concat_ in ('311','312','313',413,'442')  then 'Promising' 
 when concat_ in ('314','323','324','332','333','334','342','343','344','444','443','434')   then 'Champions' 
 else 'Others' end AS `Customer_category` from Rf)
 
 select  * from RFM;
```
--output--
|CUSTOMERNAME            |Monetary|frequency|recency|mone|fre|rec|concat_|Total_sum|Customer_category  |
|------------------------|--------|---------|-------|----|---|---|-------|---------|-------------------|
|Men 'R' US Retailers, Ltd.|48048   |14       |508    |1   |1  |1  |111    |3        |Churned Customers  |
|Double Decker Gift Stores, Ltd|36019   |12       |495    |1   |1  |1  |111    |3        |Churned Customers  |
|West Coast Collectables Co.|46085   |13       |488    |1   |1  |1  |111    |3        |Churned Customers  |
|Signal Collectibles Ltd.|50219   |15       |476    |1   |1  |1  |111    |3        |Churned Customers  |
|Daedalus Designs Imports|69052   |20       |465    |1   |2  |1  |121    |4        |Churned Customers  |
|Collectable Mini Designs Co.|87489   |25       |460    |3   |2  |1  |321    |6        |Loyal Customers    |
|Saveley & Henriot, Co.  |142874  |41       |455    |4   |4  |1  |441    |9        |Hibernating        |
|CAF Imports             |49642   |13       |438    |1   |1  |1  |111    |3        |Churned Customers  |


## Distinct Customer Category ##
``` sql
select distinct Customer_category from `segment_rfm`;
```
--Output--
|Customer_category       |
|------------------------|
|Churned Customers       |
|Loyal Customers         |
|Hibernating             |
|Potential Loyalists     |
|At Risk                 |
|Champions               |
|Promising               |


## Category wise customer number ##
```sql
select  Customer_category, count(`CUSTOMERNAME`) from `segment_rfm` 
 group by Customer_category;
```
--Output--
|Customer_category       |Customer_Number|
|------------------------|---------------------|
|Churned Customers       |15                   |
|Loyal Customers         |12                   |
|Hibernating             |8                    |
|Potential Loyalists     |12                   |
|At Risk                 |8                    |
|Champions               |33                   |
|Promising               |4                    |




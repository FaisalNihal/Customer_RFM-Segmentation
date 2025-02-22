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
  LOAD DATA INFILE 'C:\Users\Admin\Downloads\Sales Data for RFM Segmentation.csv' 
INTO TABLE `sales_data`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

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
SELECT COUNT(*) FROM SALES_SAMPLE_DATA;-- 2823
```
-- OUTPUT --
| COUNT(*) |
|----------|
| 2823     |

## Checking unique values
```sql
select distinct status from SALES_SAMPLE_DATA;
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
select distinct year_id from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| year_id |
|---------|
| 2003    |
| 2004    |
| 2005    |

```sql
select distinct PRODUCTLINE from SALES_SAMPLE_DATA;
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
select distinct COUNTRY from SALES_SAMPLE_DATA;
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
select distinct DEALSIZE from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| DEALSIZE |
|----------|
| Small    |
| Medium   |
| Large    |

```sql
select distinct TERRITORY from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| TERRITORY |
|-----------|
| NA        |
| EMEA      |
| APAC      |
| Japan     |

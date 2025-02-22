-- Create Database --

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
  
  -- Load Data in table --
  LOAD DATA INFILE 'C:\Users\Admin\Downloads\Sales Data for RFM Segmentation.csv' 
INTO TABLE `sales_data`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


 -- Inspect the data table -- 
  select * from  `sales_data`
limit 10;

-- null values in related columns --
select `ORDERNUMBER`,`SALES`,`ORDERDATE.1`,`CUSTOMERNAME` from `sales_data`
where `ORDERNUMBER` is null or `SALES`is null or `ORDERDATE.1` is null or `CUSTOMERNAME` is null ; -- No null value in these columns--

-- convert the date column from string to date --
update `sales_data`
set`ORDERDATE.1`=str_to_date(`ORDERDATE.1`,'%Y-%m-%d')
where `ORDERDATE.1` is not null;

-- Time period of dataset --
select min(`ORDERDATE.1`),max(`ORDERDATE.1`) from sales_data; -- Start= 2003-01-06, End= 2005-05-31--

-- Distinct value of different variable column --
select distinct `STATUS` from `sales_data`; -- 6 --
select distinct `PRODUCTLINE` from `sales_data`; -- 7 --
select Count(distinct `CUSTOMERNAME`) from `sales_data`; -- 92 --
select Count(distinct `CITY`) from `sales_data`; -- 73 --
select Count(distinct `COUNTRY`) from `sales_data`; -- 19 --
select Count(distinct `TERRITORY`) from `sales_data`; -- 4 --

-- EDA of Sales_data--

-- Sales over time --
select year(`ORDERDATE.1`),monthname(`ORDERDATE.1`), round(sum(`SALES`),0) from `sales_data`
group by year(`ORDERDATE.1`),monthname(`ORDERDATE.1`)
order by round(sum(`SALES`),0) desc;   -- Highest sales= November 2004 , Lowest sales= January 2003 --

select YEAR_, avg(SUM_)  from  (select year(`ORDERDATE.1`) as YEAR_,monthname(`ORDERDATE.1`), round(sum(`SALES`),0) as SUM_ from `sales_data`
group by year(`ORDERDATE.1`),monthname(`ORDERDATE.1`)
order by round(sum(`SALES`),0) desc ) as t1 
group by YEAR_; -- Highest avg sales= 2004, Lowest avg sales= 2003

-- Top 5 Customer --
select `CUSTOMERNAME`, sum(`SALES`)    from `sales_data`
group by `CUSTOMERNAME`
order by sum(`SALES`) desc
limit 5;

-- Top 3 Country--
select `Country`, sum(`SALES`)    from `sales_data`
group by `Country`
order by sum(`SALES`) desc
limit 3;

-- Product line wise sales --
select distinct`PRODUCTLINE`, sum(`QUANTITYORDERED`) over (order by `PRODUCTLINE`) from `sales_data`; -- Highest Sales= Vintage Cars , Lowest Sales= Classic Cars--

-- Status wise sales --
select distinct `STATUS`, sum(`QUANTITYORDERED`) over (order by `STATUS`) from `sales_data`; -- Cancelled = 2038, Shipped= 99067 --


-- Customer Classification with RFM Segmentation --
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
 
 select  Customer_category, count(`CUSTOMERNAME`) from `segment_rfm` 
 group by Customer_category;   -- Champion customers= 33, Churned customer =15 --


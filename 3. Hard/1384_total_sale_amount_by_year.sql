Table: Sales

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | date    |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+
product_id is the primary key for this table. 
period_start and period_end indicate the start and end date for the sales period, and both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.
The dates of the sales years are between 2018 to 2020.
 

Write an SQL query to report the total sales amount of each item for each year, with corresponding product_name, product_id, product_name, and report_year.

Return the result table ordered by product_id and report_year.

The query result format is in the following example.



Example 1:

Input: 
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 1          | LC Phone     |
| 2          | LC T-Shirt   |
| 3          | LC Keychain  |
+------------+--------------+
Sales table:
+------------+--------------+-------------+---------------------+
| product_id | period_start | period_end  | average_daily_sales |
+------------+--------------+-------------+---------------------+
| 1          | 2019-01-25   | 2019-02-28  | 100                 |
| 2          | 2018-12-01   | 2020-01-01  | 10                  |
| 3          | 2019-12-01   | 2020-01-31  | 1                   |
+------------+--------------+-------------+---------------------+
Output: 
+------------+--------------+-------------+--------------+
| product_id | product_name | report_year | total_amount |
+------------+--------------+-------------+--------------+
| 1          | LC Phone     |    2019     | 3500         |
| 2          | LC T-Shirt   |    2018     | 310          |
| 2          | LC T-Shirt   |    2019     | 3650         |
| 2          | LC T-Shirt   |    2020     | 10           |
| 3          | LC Keychain  |    2019     | 31           |
| 3          | LC Keychain  |    2020     | 31           |
+------------+--------------+-------------+--------------+
Explanation: 
LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.


-- My Answer 
WITH SalesByYear AS 
(SELECT S.*, CASE WHEN period_start <= '2018-12-31' THEN DATEDIFF(IF(period_end>'2018-12-31','2018-12-31',period_end), period_start)+1 ELSE 0 END 2018_sales, 
CASE WHEN period_start>='2020-01-01' THEN 0 ELSE  DATEDIFF(IF(period_end>'2019-12-31','2019-12-31',period_end),IF(period_start<'2019-01-01','2019-01-01',period_start))+1 END 2019_sales, 
CASE WHEN period_start>='2021-01-01' THEN 0 ELSE DATEDIFF(IF(period_end>'2020-12-31','2020-12-31',period_end),IF(period_start<'2020-01-01','2020-01-01',period_start))+1 END 2020_sales
FROM Sales S),
SalesByYearPos AS 
(SELECT SBY.product_id, SBY.average_daily_sales, IF(SBY.2018_sales<0,0,SBY.2018_sales) 2018_sales, IF(SBY.2019_sales<0,0,SBY.2019_sales) 2019_sales, IF(SBY.2020_sales<0,0,SBY.2020_sales) 2020_sales
FROM SalesByYear SBY),
SalesTable AS 
(SELECT SBYP.product_id, P.product_name,"2018" AS report_year, 2018_sales*average_daily_sales AS total_amount
FROM SalesByYearPos SBYP, Product P 
WHERE SBYP.product_id = P.product_id 
AND SBYP.2018_sales !=0
GROUP BY SBYP.product_id, P.product_name
UNION 
SELECT SBYP.product_id, P.product_name,"2019" AS report_year, 2019_sales*average_daily_sales AS total_amount
FROM SalesByYearPos SBYP, Product P 
WHERE SBYP.product_id = P.product_id 
AND SBYP.2019_sales !=0
GROUP BY SBYP.product_id, P.product_name
UNION
SELECT SBYP.product_id, P.product_name,"2020" AS report_year, 2020_sales*average_daily_sales AS total_amount
FROM SalesByYearPos SBYP, Product P 
WHERE SBYP.product_id = P.product_id 
AND SBYP.2020_sales !=0
GROUP BY SBYP.product_id, P.product_name)

SELECT *
FROM SalesTable 
ORDER BY product_id ASC, report_year ASC 


-- What I learned 
1) DATEDIFF is not inclusive, you have to add 1 if you want it to be inclusive. 
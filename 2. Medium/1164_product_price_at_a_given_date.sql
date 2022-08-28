Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+

-- My Answer
WITH MaxDate AS 
(SELECT product_id, MAX(change_date) as max_date 
FROM Products P
WHERE change_date <= "2019-08-16"
GROUP BY P.product_id),
MaxDatewithPrice AS 
(SELECT P.product_id, new_price
FROM Products P, MaxDate M 
WHERE P.product_id = M.product_id 
AND P.change_date = M.max_date) 

SELECT P.product_id, CASE WHEN M.new_price THEN M.new_price ELSE 10 END AS price
FROM (SELECT DISTINCT product_Id FROM Products) P
LEFT OUTER JOIN MaxDatewithPrice M  
ON P.product_id = M.product_id


-- What I learned 
1) PARTITION BY/ OVER: conduct aggregation function even though it's not in the GROUP BY Clause' 
SELECT Customercity, 
       AVG(Orderamount) OVER (PARTITION BY Customercity) AS AvgOrderAmount, 
       MIN(OrderAmount) OVER (PARTITION BY Customercity) AS MinOrderAmount, 
       SUM(Orderamount) OVER (PARTITION BY Customercity) TotalOrderAmount
FROM [dbo].[Orders];

2) RANK() should be used with OVER (PARTITION BY ... (ORDER BY )): 
- it shows the rank of the row based on the PARTITION BY Column 
3) RANK() : if there are n multiple rows with same rank, next rank starts from +n rank 
3) DENSE_RANK() : if there are n multiple rows with same rank, next rank starts from +1 rank 
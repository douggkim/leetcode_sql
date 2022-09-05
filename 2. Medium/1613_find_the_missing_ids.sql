Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the primary key for this table.
Each row of this table contains the name and the id customer.
 

Write an SQL query to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but are in the range between 1 and the maximum customer_id present in the table.

Notice that the maximum customer_id will not exceed 100.

Return the result table ordered by ids in ascending order.

The query result format is in the following example.

SELECT id%MAX(customer_id)+1 generated_ints
FROM Customers 
GROUP BY generated_ints

Example 1:

Input: 
Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Alice         |
| 4           | Bob           |
| 5           | Charlie       |
+-------------+---------------+
Output: 
+-----+
| ids |
+-----+
| 2   |
| 3   |
+-----+
Explanation: 
The maximum customer_id present in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.


-- My Answer 
WITH DIGITS (N) AS (
  SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
  SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
  SELECT 8 UNION ALL SELECT 9),
NumTable AS 
(SELECT DISTINCT (UNITS.N + TENS.N*10) AS digits_cnt
FROM DIGITS AS UNITS, DIGITS AS TENS)

SELECT digits_cnt ids 
FROM NumTable NT
LEFT OUTER JOIN Customers C 
ON NT.digits_cnt = C.customer_id 
WHERE C.customer_name IS NULL
AND digits_cnt <= (SELECT MAX(C.customer_id)
                    FROM Customers C)
AND digits_cnt >=1                
ORDER BY digits_cnt ASC 


-- 
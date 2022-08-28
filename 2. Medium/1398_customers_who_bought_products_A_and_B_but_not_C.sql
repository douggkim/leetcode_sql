Table: Customers

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| customer_id         | int     |
| customer_name       | varchar |
+---------------------+---------+
customer_id is the primary key for this table.
customer_name is the name of the customer.
 

Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_name  | varchar |
+---------------+---------+
order_id is the primary key for this table.
customer_id is the id of the customer who bought the product "product_name".
 

Write an SQL query to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them to purchase this product.

Return the result table ordered by customer_id.

The query result format is in the following example.

 

Example 1:

Input: 
Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Diana         |
| 3           | Elizabeth     |
| 4           | Jhon          |
+-------------+---------------+
Orders table:
+------------+--------------+---------------+
| order_id   | customer_id  | product_name  |
+------------+--------------+---------------+
| 10         |     1        |     A         |
| 20         |     1        |     B         |
| 30         |     1        |     D         |
| 40         |     1        |     C         |
| 50         |     2        |     A         |
| 60         |     3        |     A         |
| 70         |     3        |     B         |
| 80         |     3        |     D         |
| 90         |     4        |     C         |
+------------+--------------+---------------+
Output: 
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 3           | Elizabeth     |
+-------------+---------------+
Explanation: Only the customer_id with id 3 bought the product A and B but not the product C.

-- My Answer 
SELECT O.customer_id customer_id,C.customer_name customer_name
FROM Customers C, Orders O 
WHERE C.customer_id = O.customer_id
GROUP BY O.customer_id
HAVING  MAX(CASE WHEN O.product_name = 'A' THEN 1 ELSE 0 END) * MAX(CASE WHEN O.product_name = 'B' THEN 1 ELSE 0 END) *MIN(CASE WHEN O.product_name != 'C' THEN 1 ELSE 0 END)=1 


SELECT C.customer_id,C.customer_name
FROM Customers C, Orders O 
WHERE C.customer_id = O.customer_id
GROUP BY O.customer_id
HAVING MAX(CASE WHEN O.product_name = 'A' THEN 1 ELSE 0 END)=1 
AND MAX(CASE WHEN O.product_name = 'B' THEN 1 ELSE 0 END)=1 
AND MAX(CASE WHEN O.product_name = !'C' THEN 1 ELSE 0 END)=0

-- What I learned 
1) This problem could also be solved using GROUP_CONCAT
2) This problem could also be solved using multiple joins 
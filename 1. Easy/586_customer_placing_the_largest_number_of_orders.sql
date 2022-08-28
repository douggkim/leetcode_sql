Table: Orders

+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
order_number is the primary key for this table.
This table contains information about the order ID and the customer ID.
 

Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.

The test cases are generated so that exactly one customer will have placed more orders than any other customer.

The query result format is in the following example.






Example 1:

Input: 
Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+
Output: 
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+
Explanation: 
The customer with number 3 has two orders, which is greater than either customer 1 or 2 because each of them only has one order. 
So the result is customer_number 3.
 

Follow up: What if more than one customer has the largest number of orders, can you find all the customer_number in this case?


-- My Answer 
SELECT customer_number
FROM 
(SELECT customer_number, COUNT(order_number) AS order_count
FROM Orders 
GROUP BY customer_number 
ORDER BY order_count DESC
LIMIT 1) AS order_count_table 

-- Alternative Answer 
SELECT customer_number 
FROM Orders 
GROUP BY customer_number 
ORDER BY COUNT(*) DESC
LIMIT 1

-- Additional Question 
SELECT customer_number 
FROM Orders 
GROUP BY customer_number 
HAVING COUNT(*) = (
SELECT COUNT(order_number)
FROM Orders 
GROUP BY customer_number
ORDER BY COUNT(order_number) DESC 
LIMIT 1)


-- What I have Learned 
1) You do not have to include COUNT(*) in the select statement to use it in the WHERE clause 
SELECT customer_number 
FROM Orders 
GROUP BY customer_number 
ORDER BY COUNT(*) DESC
LIMIT 1
2) You use HAVING for GROUP BY Clauses 
3) In MySQL you do not have to use the {column} which is used in GROUP BY clause 
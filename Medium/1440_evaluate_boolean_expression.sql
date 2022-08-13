Table Variables:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| name          | varchar |
| value         | int     |
+---------------+---------+
name is the primary key for this table.
This table contains the stored variables and their values.
 

Table Expressions:

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| left_operand  | varchar |
| operator      | enum    |
| right_operand | varchar |
+---------------+---------+
(left_operand, operator, right_operand) is the primary key for this table.
This table contains a boolean expression that should be evaluated.
operator is an enum that takes one of the values ('<', '>', '=')
The values of left_operand and right_operand are guaranteed to be in the Variables table.
 

Write an SQL query to evaluate the boolean expressions in Expressions table.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Variables table:
+------+-------+
| name | value |
+------+-------+
| x    | 66    |
| y    | 77    |
+------+-------+
Expressions table:
+--------------+----------+---------------+
| left_operand | operator | right_operand |
+--------------+----------+---------------+
| x            | >        | y             |
| x            | <        | y             |
| x            | =        | y             |
| y            | >        | x             |
| y            | <        | x             |
| x            | =        | x             |
+--------------+----------+---------------+
Output: 
+--------------+----------+---------------+-------+
| left_operand | operator | right_operand | value |
+--------------+----------+---------------+-------+
| x            | >        | y             | false |
| x            | <        | y             | true  |
| x            | =        | y             | false |
| y            | >        | x             | true  |
| y            | <        | x             | false |
| x            | =        | x             | true  |
+--------------+----------+---------------+-------+
Explanation: 
As shown, you need to find the value of each boolean expression in the table using the variables table.



-- My Answer 
WITH Expressions_with_xy
AS 
(SELECT (SELECT value FROM Variables V WHERE v.name=E.left_operand) AS new_left, operator, (SELECT value FROM Variables V WHERE V.name=E.right_operand) AS new_right, left_operand, right_operand
FROM Expressions E)

SELECT left_operand, operator, right_operand,
CASE WHEN operator='>' THEN 
IF(new_left >new_right, 'true','false')
WHEN operator='<' THEN 
IF(new_left<new_right, 'true','false')
WHEN operator='=' THEN 
IF(new_left=new_right, 'true','false')
END AS value 
FROM Expressions_with_xy

-- Alternative Answers 
# Write your MySQL query statement below
select E.left_operand, E.operator, E.right_operand, 
case when operator = ">" then IF(V1.value > V2.value, "true", "false")
     when operator = "<" then IF(V1.value < V2.value, "true", "false")
     else IF(V1.value = V2.value, "true", "false")
     end value 
from Expressions E, Variables V1, Variables V2 
where E.left_operand = V1.name and E.right_operand = V2.name 


-- What I Learned 
1) You could use two tables, each for one variable 
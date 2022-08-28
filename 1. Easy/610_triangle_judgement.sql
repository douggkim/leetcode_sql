Table: Triangle

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
(x, y, z) is the primary key column for this table.
Each row of this table contains the lengths of three line segments.
 

Write an SQL query to report for every three line segments whether they can form a triangle.

Return the result table in any order.

The query result format is in the following example.


Example 1:

Input: 
Triangle table:
+----+----+----+
| x  | y  | z  |
+----+----+----+
| 13 | 15 | 30 |
| 10 | 20 | 15 |
+----+----+----+
Output: 
+----+----+----+----------+
| x  | y  | z  | triangle |
+----+----+----+----------+
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |
+----+----+----+----------+

-- My Answer
SELECT T.x, T.y, T.z, (CASE WHEN T.x>=T.y AND T.x>=T.z AND T.x<T.y+T.z THEN 'Yes'
WHEN T.y>=T.x AND T.y>=T.z AND T.y<T.x+T.z THEN 'Yes'
WHEN T.z>=T.x AND T.z>=T.y AND T.z<T.x+T.y THEN 'Yes'
ELSE 'No' END) AS triangle 
FROM Triangle T 

-- What I learned 
1) I left out the case when some segments had the same length 
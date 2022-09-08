Table: Numbers

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
| frequency   | int  |
+-------------+------+
num is the primary key for this table.
Each row of this table shows the frequency of a number in the database.
 

The median is the value separating the higher half from the lower half of a data sample.

Write an SQL query to report the median of all the numbers in the database after decompressing the Numbers table. Round the median to one decimal point.

The query result format is in the following example.
WITH RevisedTable AS 
(SELECT N.*, SUM(frequency) OVER (ORDER BY num ASC) accum, SUM(frequency) OVER () total 
FROM Numbers N)


SELECT ROUND(AVG(RT.num),1) AS median 
FROM RevisedTable RT 
WHERE total/2 <= accum
AND total/2 >= accum-frequency


Example 1:

Input: 
Numbers table:
+-----+-----------+
| num | frequency |
+-----+-----------+
| 0   | 7         |
| 1   | 1         |
| 2   | 3         |
| 3   | 1         |
+-----+-----------+
Output: 
+--------+
| median |
+--------+
| 0.0    |
+--------+
Explanation: 
If we decompress the Numbers table, we will get [0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3], so the median is (0 + 0) / 2 = 0.


-- My Answer 
WITH AccumTable AS 
(SELECT num, SUM(frequency) OVER (ORDER BY num ASC) AS accumul, SUM(frequency) OVER () AS total, frequency
FROM Numbers Num) 



SELECT ROUND(AVG(AT.num),1) AS median 
FROM AccumTable AT
WHERE AT.total/2 <= AT.accumul
 AND AT.total/2 >= AT.accumul - frequency



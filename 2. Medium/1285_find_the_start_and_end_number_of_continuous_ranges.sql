Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
log_id is the primary key for this table.
Each row of this table contains the ID in a log Table.
 

Write an SQL query to find the start and end number of continuous ranges in the table Logs.

Return the result table ordered by start_id.

The query result format is in the following example.

WITH IdTable AS 
(SELECT ROW_NUMBER() OVER (ORDER BY log_id ASC) id, log_id, 1 log_group
FROM Logs), 
GroupTable AS 
(SELECT log_id, (CASE WHEN I2.log_id=I1.log_id+1 OR I2.log_id=I1.log_id THEN I1.log_group ELSE I1.log_group+1 END) log_group
FROM IdTable I1, IdTable I2
WHERE I1.id = I2.id-1) 

SELECT MIN(log_id) start_id, MAX(log_id) end_id
FROM GroupTable GT
GROUP BY log_group 



 

Example 1:

Input: 
Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+
Output: 
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
Explanation: 
The result table should contain all ranges in table Logs.
From 1 to 3 is contained in the table.
From 4 to 6 is missing in the table
From 7 to 8 is contained in the table.
Number 9 is missing from the table.
Number 10 is contained in the table.

-- My Answer 
WITH IdTable AS 
(SELECT log_id - ROW_NUMBER() OVER (ORDER BY log_id ASC) id, log_id
FROM Logs)

SELECT MIN(log_id) start_id, MAX(log_id) end_id
FROM IdTable
GROUP BY id 

-- What I learned 
1) You could use Window function with other columns (e.g. log_id - ROW_NUMBER() OVER (ORDER BY log_id ASC))

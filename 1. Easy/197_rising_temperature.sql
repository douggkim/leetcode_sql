Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature on a certain day.
 

Write an SQL query to find all dates'' Id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).


-- My Answer
SELECT A.id 
FROM Weather A
WHERE A.temperature > (
    SELECT B.temperature
    FROM Weather B
    WHERE B.recordDate = A.recordDate - INTERVAL 1 DAY)
ORDER BY A.id ASC

SELECT A.id 
FROM Weather A, Weather B
WHERE A.temperature > B.temperature
AND B.recordDate = A.recordDate - INTERVAL 1 DAY


-- What I leanrned
1) This is how you calculate date 
NOW() - INTERVAL 1 DAY / WEEK / MONTH 
2) First Query is much slower because it queries twice
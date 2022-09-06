Table: Tasks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| task_id        | int     |
| subtasks_count | int     |
+----------------+---------+
task_id is the primary key for this table.
Each row in this table indicates that task_id was divided into subtasks_count subtasks labeled from 1 to subtasks_count.
It is guaranteed that 2 <= subtasks_count <= 20.

WITH RECURSIVE DigitsTable AS 
(SELECT 1 num
UNION ALL 
SELECT num+1 
FROM DigitsTable 
WHERE num<(SELECT MAX(subtask_id) FROM Executed)
)

SELECT *
FROM DigitsTable DT, Executed 
WHERE DT.num < E.subtask_id
Table: Executed

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| task_id       | int     |
| subtask_id    | int     |
+---------------+---------+
(task_id, subtask_id) is the primary key for this table.
Each row in this table indicates that for the task task_id, the subtask with ID subtask_id was executed successfully.
It is guaranteed that subtask_id <= subtasks_count for each task_id.
 

Write an SQL query to report the IDs of the missing subtasks for each task_id.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Tasks table:
+---------+----------------+
| task_id | subtasks_count |
+---------+----------------+
| 1       | 3              |
| 2       | 2              |
| 3       | 4              |
+---------+----------------+
Executed table:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 2          |
| 3       | 1          |
| 3       | 2          |
| 3       | 3          |
| 3       | 4          |
+---------+------------+
Output: 
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 1          |
| 1       | 3          |
| 2       | 1          |
| 2       | 2          |
+---------+------------+
Explanation: 
Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, so we include (1, 1) and (1, 3) in the answer.
Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so we include (2, 1) and (2, 2) in the answer.
Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.


-- My Answer 
WITH RECURSIVE DigitsTable AS 
(SELECT 1 num
UNION ALL 
SELECT num+1 
FROM DigitsTable 
WHERE num<=(SELECT MAX(subtasks_count) FROM Tasks)
), CompareTable AS 
(SELECT task_id, num task_range, subtasks_count
FROM DigitsTable DT, Tasks T
WHERE DT.num <= T.subtasks_count)

SELECT CT.task_id, task_range subtask_id 
FROM CompareTable CT
LEFT OUTER JOIN Executed E 
ON E.task_id = CT.task_id 
AND E.subtask_id = CT.task_range 
WHERE E.subtask_id IS NULL 
ORDER BY task_id ASC, subtask_id ASC

-- What I learned
1) You could create numbers from RECURSIVE cte 
2) You could use CROSS JOIN to join a table for each row. 
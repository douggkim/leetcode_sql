Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| company      | varchar |
| salary       | int     |
+--------------+---------+
id is the primary key column for this table.
Each row of this table indicates the company and the salary of one employee.
 

Write an SQL query to find the rows that contain the median salary of each company. While calculating the median, when you sort the salaries of the company, break the ties by id.

Return the result table in any order.

The query result format is in the following example.
Example 1:

Input: 
Employee table:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 1  | A       | 2341   |
| 2  | A       | 341    |
| 3  | A       | 15     |
| 4  | A       | 15314  |
| 5  | A       | 451    |
| 6  | A       | 513    |
| 7  | B       | 15     |
| 8  | B       | 13     |
| 9  | B       | 1154   |
| 10 | B       | 1345   |
| 11 | B       | 1221   |
| 12 | B       | 234    |
| 13 | C       | 2345   |
| 14 | C       | 2645   |
| 15 | C       | 2645   |
| 16 | C       | 2652   |
| 17 | C       | 65     |
+----+---------+--------+
Output: 
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 5  | A       | 451    |
| 6  | A       | 513    |
| 12 | B       | 234    |
| 9  | B       | 1154   |
| 14 | C       | 2645   |
+----+---------+--------+
Explanation: 
For company A, the rows sorted are as follows:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 3  | A       | 15     |
| 2  | A       | 341    |
| 5  | A       | 451    | <-- median
| 6  | A       | 513    | <-- median
| 1  | A       | 2341   |
| 4  | A       | 15314  |
+----+---------+--------+
For company B, the rows sorted are as follows:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 8  | B       | 13     |
| 7  | B       | 15     |
| 12 | B       | 234    | <-- median
| 11 | B       | 1221   | <-- median
| 9  | B       | 1154   |
| 10 | B       | 1345   |
+----+---------+--------+
For company C, the rows sorted are as follows:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 17 | C       | 65     |
| 13 | C       | 2345   |
| 14 | C       | 2645   | <-- median
| 15 | C       | 2645   | 
| 16 | C       | 2652   |
+----+---------+--------+


-- My Answer 
WITH RankTable AS 
(SELECT E.*, RANK() OVER (PARTITION BY company ORDER BY salary ASC) salary_rank, COUNT(id) OVER (PARTITION BY company) employee_count
FROM Employee E),
TieTable1 AS 
(SELECT DISTINCT RT.salary, RT.id, RT.company, ROW_NUMBER() OVER (PARTITION BY company ORDER BY RT.id ASC) AS id_rank
FROM RankTable RT 
WHERE employee_count %2!=0
AND salary_rank = CEIL(employee_count/2)),
TieTable2 AS 
(SELECT DISTINCT RT.salary,  RT.id, RT.company,ROW_NUMBER() OVER (PARTITION BY company ORDER BY RT.id ASC) AS id_rank
FROM RankTable RT 
WHERE employee_count %2=0
AND (salary_rank = employee_count/2
OR salary_rank = employee_count/2+1)
ORDER BY salary_rank DESC)

SELECT TT1.id, TT1.company, TT1.salary
FROM TieTable1 TT1
WHERE TT1.id_rank =1
UNION 
SELECT TT2.id, TT2.company, TT2.salary
FROM TieTable2 TT2
WHERE TT2.id_rank <=2

-- Alternative Answer 
WITH RankTable AS 
(SELECT E.*, RANK() OVER (PARTITION BY company ORDER BY salary ASC) salary_rank, COUNT(id) OVER (PARTITION BY company) employee_count
FROM Employee E)

SELECT RT.id, RT.company, RT.salary 
FROM RankTable RT 
WHERE (employee_count%2=1 
AND salary_rank=CEIL(employee_count/2))
OR (employee_count%2=0
AND salary_rank IN (employee_count/2,salary_rank=employee_count/2+1))


-- What I learned 
1) You have to use RANK() for medians 
2) You could include id in ORDER BY to filter the same records (salaries)
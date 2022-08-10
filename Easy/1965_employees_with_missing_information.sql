Table: Employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
+-------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates the name of the employee whose ID is employee_id.
 

Table: Salaries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| salary      | int     |
+-------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates the salary of the employee whose ID is employee_id.
 

Write an SQL query to report the IDs of all the employees with missing information. The information of an employee is missing if:

The employee's name is missing, or
The employee's salary is missing.
Return the result table ordered by employee_id in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Employees table:
+-------------+----------+
| employee_id | name     |
+-------------+----------+
| 2           | Crew     |
| 4           | Haven    |
| 5           | Kristian |
+-------------+----------+
Salaries table:
+-------------+--------+
| employee_id | salary |
+-------------+--------+
| 5           | 76071  |
| 1           | 22517  |
| 4           | 63539  |
+-------------+--------+
Output: 
+-------------+
| employee_id |
+-------------+
| 1           |
| 2           |
+-------------+
Explanation: 
Employees 1, 2, 4, and 5 are working at this company.
The name of employee 1 is missing.
The salary of employee 2 is missing.

-- My Answer 
SELECT employee_id
FROM 
(SELECT E.employee_id, E.name, S.salary 
FROM Employees as E
LEFT OUTER JOIN  Salaries as S 
ON E.employee_id = S.employee_id
UNION 
SELECT S.employee_id, E.name, S.salary 
FROM Employees as E
RIGHT OUTER JOIN  Salaries as S 
ON E.employee_id = S.employee_id) as comb_table
WHERE name IS NULL OR salary IS NULL
ORDER BY employee_id ASC

-- What I learned 
1) if there are same column in two joined tables, you have to specify the name 
2) In MySQL, to use FULL OUTER JOIN you have to UNION left/right OUTER JOIN: 
{SELECT A.{primary key} 
A LEFT OUTER JOIN B}
UNION
{SELECT B.{primary key}
A RIGHT OUTER JOIN B}

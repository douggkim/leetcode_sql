Table: Employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
| salary      | int     |
+-------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates the employee ID, employee name, and salary.
 

Write an SQL query to calculate the bonus of each employee. The bonus of an employee is 100% of their salary if the ID of the employee is an odd number and the employee name does not start with the character 'M'. The bonus of an employee is 0 otherwise.

Return the result table ordered by employee_id.

The query result format is in the following example.

 

Example 1:

Input: 
Employees table:
+-------------+---------+--------+
| employee_id | name    | salary |
+-------------+---------+--------+
| 2           | Meir    | 3000   |
| 3           | Michael | 3800   |
| 7           | Addilyn | 7400   |
| 8           | Juan    | 6100   |
| 9           | Kannon  | 7700   |
+-------------+---------+--------+
Output: 
+-------------+-------+
| employee_id | bonus |
+-------------+-------+
| 2           | 0     |
| 3           | 0     |
| 7           | 7400  |
| 8           | 0     |
| 9           | 7700  |
+-------------+-------+
Explanation: 
The employees with IDs 2 and 8 get 0 bonus because they have an even employee_id.
The employee with ID 3 gets 0 bonus because their name starts with 'M'.
The rest of the employees get a 100% bonus.


-- My Answer 
SELECT * FROM (
SELECT employee_id, 0 bonus 
FROM Employees
WHERE employee_id NOT IN 
(SELECT employee_id
FROM Employees E
WHERE E.name NOT LIKE 'M%'
AND E.employee_id%2!=0)
UNION ALL 
SELECT employee_id, salary*1 bonus 
FROM Employees
WHERE employee_id IN 
(SELECT employee_id
FROM Employees E
WHERE E.name NOT LIKE 'M%'
AND E.employee_id%2!=0) 
) bonus_table
ORDER BY employee_id ASC



SELECT employee_id, CASE 
WHEN employee_id%2!=0 AND name NOT LIKE 'M%'
THEN salary 
ELSE 0 
END 
AS bonus 
FROM Employees
ORDER BY employee_id 


-- What I learned 
-- > There are two types of CASE Clause 
1) CASE {Column name} WHEN {Target value} THEN {New Value} ...
2) CASE WHEN {Condition} THEN {NEW Value} ... 
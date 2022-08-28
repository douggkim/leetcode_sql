Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key column for this table.
Each row of this table contains information about the salary of an employee.
 

Write an SQL query to report the second highest salary from the Employee table. If there is no second highest salary, the query should report null.

The query result format is in the following example.

SELECT IF(salary!='', salary, NULL) AS SecondHighestSalary
FROM (SELECT salary 
FROM 
(SELECT * 
FROM Employee 
ORDER BY salary DESC) AS desc_salary
LIMIT 1,1) AS second_row


SELECT IF(salary!='' OR salary IS NULL, salary, NULL) AS SecondHighestSalary
FROM 
(SELECT salary as SecondHighestSalary
FROM Employee 
ORDER BY salary DESC AS desc_salary
LIMIT 1,1)
UNION
SELECT NULL as SecondHighestSalary
LIMIT1

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+

-- My Answer 
(SELECT DISTINCT salary as SecondHighestSalary
FROM Employee 
ORDER BY salary DESC
LIMIT 1,1)
UNION
SELECT NULL as SecondHighestSalary
LIMIT 1


-- Other Answers 
SELECT MAX(Salary) AS SecondHighestSalary
FROM Employee
WHERE Salary < (SELECT MAX(Salary) FROM Employee)

SELECT
    (SELECT DISTINCT
            Salary
        FROM
            Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1) AS SecondHighestSalary
;

SELECT
    IFNULL(
      (SELECT DISTINCT Salary
       FROM Employee
       ORDER BY Salary DESC
        LIMIT 1 OFFSET 1),
    NULL) AS SecondHighestSalary

    
-- What I Learned

1) LIMIT 1,1 : select 2nd-3rd data 
2) How to print default value 
(SELECT salary as SecondHighestSalary
FROM Employee 
ORDER BY salary DESC
LIMIT 1,1)
UNION
SELECT NULL as SecondHighestSalary
LIMIT 1

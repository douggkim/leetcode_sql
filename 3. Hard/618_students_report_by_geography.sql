Table: Student

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
+-------------+---------+
There is no primary key for this table. It may contain duplicate rows.
Each row of this table indicates the name of a student and the continent they came from.
 

A school has students from Asia, Europe, and America.

Write an SQL query to pivot the continent column in the Student table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia, and Europe, respectively.

The test cases are generated so that the student number from America is not less than either Asia or Europe.

The query result format is in the following example.

 

Example 1:

Input: 
Student table:
+--------+-----------+
| name   | continent |
+--------+-----------+
| Jane   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jack   | America   |
+--------+-----------+
Output: 
+---------+------+--------+
| America | Asia | Europe |
+---------+------+--------+
| Jack    | Xi   | Pascal |
| Jane    | null | null   |
+---------+------+--------+


-- My Answer 
# Write your MySQL query statement below
WITH AmericaTable AS 
(SELECT DISTINCT S.name America, ROW_NUMBER() OVER (ORDER BY S.name ASC) id
FROM Student S 
WHERE continent='America'
ORDER BY S.name ASC),
AsiaTable AS
(SELECT DISTINCT S.name Asia, ROW_NUMBER() OVER (ORDER BY S.name ASC) id
FROM Student S 
WHERE continent='Asia'
ORDER BY S.name ASC),
EuropeTable AS 
(SELECT DISTINCT S.name Europe, ROW_NUMBER() OVER (ORDER BY S.name ASC) id
FROM Student S 
WHERE continent='Europe'
ORDER BY S.name ASC)

SELECT IT.America, IT.Asia, ET.Europe
FROM
(SELECT AT.America, AST.Asia, AT.id 
FROM AmericaTable AT 
LEFT OUTER JOIN AsiaTable AST 
ON AT.id = AST.id) IT
LEFT OUTER JOIN EuropeTable ET 
ON ET.id = IT.id 


-- Alternative Answer 
WITH RowTable AS 
(SELECT name, continent, ROW_NUMBER() OVER (PARTITION BY continent ORDER BY name ASC) row_num
FROM Student S)


SELECT 
MAX(CASE WHEN continent='America' THEN name END) America,
MAX(CASE WHEN continent='Asia' THEN name END) Asia,
MAX(CASE WHEN continent='Europe' THEN name END) Europe
FROM RowTable 
GROUP BY row_num 


-- What I learned 
1) MAX(CASE ...) GROUP BY allows the user to pivot multiple columns for each row. 
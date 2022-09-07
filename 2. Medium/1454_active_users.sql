Table: Accounts

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
This table contains the account id and the user name of each account.
 

Table: Logins

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

Active users are those who logged in to their accounts for five or more consecutive days.

Write an SQL query to find the id and the name of active users.

Return the result table ordered by id.

The query result format is in the following example.


Example 1:

Input: 
Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+
Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+
Output: 
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
Explanation: 
User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user


-- My Answer 
WITH AlignedTable AS  
(SELECT DISTINCT login_date, id, ROW_NUMBER() OVER (PARTITION BY id ORDER BY login_date) row_number, LAG(login_date,4) OVER (PARTITION BY id ORDER BY login_date) minus_4
FROM Logins L 
ORDER BY id, login_date ASC) 

SELECT DISTINCT AT1.id, A.name
FROM AlignedTable AT1, AlignedTable AT2, AlignedTable AT3, AlignedTable AT4, AlignedTable AT5, Accounts A
WHERE AT1.id = AT2.id 
AND AT2.id=AT3.id 
AND AT3.id=AT4.id 
AND AT4.id=AT5.id
AND DATE_ADD(AT1.login_date, INTERVAL 1 DAY) = AT2.login_date
AND DATE_ADD(AT2.login_date, INTERVAL 1 DAY) = AT3.login_date
AND DATE_ADD(AT3.login_date, INTERVAL 1 DAY) = AT4.login_date
AND DATE_ADD(AT4.login_date, INTERVAL 1 DAY) = AT5.login_date
AND A.id = AT1.id
ORDER BY AT1.id

-- Alternative Answer
WITH AlignedTable AS  
(SELECT DISTINCT login_date, id, LAG(login_date, 5) OVER (PARTITION BY id ORDER BY login_date) minus_5
FROM Logins L 
ORDER BY id, login_date ASC)

SELECT AT.id, A.name
FROM AlignedTable AT, Accounts A 
WHERE 1=1
AND DATEDIFF(login_date,AT.minus_5) = 4
AND AT.id = A.id

-- What I learned 
1) To compare consecutive numbers, you can use ROW_NUMBER() AND DATE_DIFF together 
->if DATE_DIFF = ROW_NUMBER = 4, these are four consecutive data 
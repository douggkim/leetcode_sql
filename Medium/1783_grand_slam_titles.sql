Table: Players

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| player_id      | int     |
| player_name    | varchar |
+----------------+---------+
player_id is the primary key for this table.
Each row in this table contains the name and the ID of a tennis player.
 

Table: Championships

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| year          | int     |
| Wimbledon     | int     |
| Fr_open       | int     |
| US_open       | int     |
| Au_open       | int     |
+---------------+---------+
year is the primary key for this table.
Each row of this table contains the IDs of the players who won one each tennis tournament of the grand slam.
 

Write an SQL query to report the number of grand slam tournaments won by each player. Do not include the players who did not win any tournament.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Players table:
+-----------+-------------+
| player_id | player_name |
+-----------+-------------+
| 1         | Nadal       |
| 2         | Federer     |
| 3         | Novak       |
+-----------+-------------+
Championships table:
+------+-----------+---------+---------+---------+
| year | Wimbledon | Fr_open | US_open | Au_open |
+------+-----------+---------+---------+---------+
| 2018 | 1         | 1       | 1       | 1       |
| 2019 | 1         | 1       | 2       | 2       |
| 2020 | 2         | 1       | 2       | 2       |
+------+-----------+---------+---------+---------+
Output: 
+-----------+-------------+-------------------+
| player_id | player_name | grand_slams_count |
+-----------+-------------+-------------------+
| 2         | Federer     | 5                 |
| 1         | Nadal       | 7                 |
+-----------+-------------+-------------------+
Explanation: 
Player 1 (Nadal) won 7 titles: Wimbledon (2018, 2019), Fr_open (2018, 2019, 2020), US_open (2018), and Au_open (2018).
Player 2 (Federer) won 5 titles: Wimbledon (2020), US_open (2019, 2020), and Au_open (2019, 2020).
Player 3 (Novak) did not win anything, we did not include them in the result table.

-- My Answer 
With UnionTable AS 
(SELECT Wimbledon winner 
FROM Championships C 
UNION ALL
SELECT Fr_open winner 
FROM Championships C 
UNION ALL
SELECT US_open winner
FROM Championships C 
UNION ALL 
SELECT Au_open winner
FROM Championships C),
CountTable AS 
(SELECT winner, COUNT(*) wincount 
FROM UnionTable U 
GROUP BY winner)


SELECT P.player_id, P.player_name, C.wincount grand_slams_count
FROM CountTable C, Players P 
WHERE P.player_id = C.winner

-- What I learned 
1) UNION vs UNION ALL 
-> UNION Only collects distinct values from each table 
-> UNION ALL collects all the values from the table 
-> In this case, use UNION ALL ! 
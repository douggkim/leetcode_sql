Table: Friendship

+-------------+------+
| Column Name | Type |
+-------------+------+
| user1_id    | int  |
| user2_id    | int  |
+-------------+------+
(user1_id, user2_id) is the primary key for this table.
Each row of this table indicates that the users user1_id and user2_id are friends.
Note that user1_id < user2_id.
 

A friendship between a pair of friends x and y is strong if x and y have at least three common friends.

Write an SQL query to find all the strong friendships.

Note that the result table should not contain duplicates with user1_id < user2_id.

Return the result table in any order.

The query result format is in the following example.

Example 1:

Input: 
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 2        | 3        |
| 1        | 4        |
| 2        | 4        |
| 1        | 5        |
| 2        | 5        |
| 1        | 7        |
| 3        | 7        |
| 1        | 6        |
| 3        | 6        |
| 2        | 6        |
+----------+----------+
Output: 
+----------+----------+---------------+
| user1_id | user2_id | common_friend |
+----------+----------+---------------+
| 1        | 2        | 4             |
| 1        | 3        | 3             |
+----------+----------+---------------+
Explanation: 
Users 1 and 2 have 4 common friends (3, 4, 5, and 6).
Users 1 and 3 have 3 common friends (2, 6, and 7).
We did not include the friendship of users 2 and 3 because they only have two common friends (1 and 6).


-- My Answer 
WITH FriendshipTotal AS 
(SELECT user2_id AS "user1_id", user1_id AS "user2_id"
From FriendShip F
UNION 
SELECT * 
FROM Friendship F),
FriendTable AS 
(SELECT F1.user1_id, F2.user1_id AS "user2_id", COUNT(*) AS common_friend 
FROM FriendshipTotal F1, FriendshipTotal F2 
WHERE 1=1 
AND F1.user2_id = F2.user2_id 
AND F1.user1_id < F2.user1_id
GROUP BY F1.user1_id, F2.user1_id)

SELECT DISTINCT FT.user1_id, FT.user2_id, common_friend
FROM FriendTable FT
WHERE FT.common_friend >= 3 
AND CONCAT(FT.user1_id, ",", FT.user2_Id) IN (SELECT CONCAT(FTT.user1_id, ",", FTT.user2_id) FROM FriendShip FTT)

-- Alternative Answers 
WITH t AS (SELECT user1_id, user2_id FROM Friendship
           UNION
           SELECT user2_id, user1_id FROM Friendship),
t2 AS (SELECT t.user1_id AS user1_id, t.user2_id AS user2_id, 
       CASE WHEN (t.user1_id, t1.user2_id) IN (SELECT* FROM t) 
       THEN t1.user2_id ELSE null END AS common
       FROM t
       LEFT JOIN t AS t1 ON (t.user2_id=t1.user1_id)
       HAVING user1_id < user2_id AND common IS NOT NULL)

SELECT user1_id , user2_id, COUNT(*) AS common_friend
FROM t2
GROUP BY user1_id, user2_id
HAVING common_friend >= 3

-- What I learned 
1) Be aware when using CONCAT because there could be cases like this: 
1,51 <-> 15,1

2) You could compare multiple variables with IN clause
CASE WHEN (t.user1_id, t1.user2_id) IN (SELECT* FROM t) 
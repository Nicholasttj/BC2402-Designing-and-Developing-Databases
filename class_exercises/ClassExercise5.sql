/*
BC2402 Class Exercise 5
Name: Tang Te Jie, Nicholas
Matric No: U2310817H
*/

SHOW tables;
SELECT * FROM `User`;
SELECT * FROM `User-Group`;
SELECT * FROM `Album`;

/* Case: Sociogram */
/* 1 */
SELECT DISTINCT u.Name as name
FROM `User` u
JOIN `User-Group` ug ON u.UserID = ug.UserID
WHERE ug.isModerator = 'Y';


/* 2 */
SELECT DISTINCT u.Name as name
FROM `User` u
JOIN `User-Group` ug ON u.UserID = ug.UserID
WHERE ug.isBanned = 'Y';


/* 3 */
SELECT DISTINCT u.Name AS name, SUM(p.FileSize) AS totalFileSize
FROM `Photo` p
JOIN `User-Photo` up ON p.PhotoID = up.PhotoID
JOIN `User` u ON up.UserID = u.UserID
GROUP BY u.Name
HAVING SUM(p.FileSize) > 1000;


/* 4 */
SELECT * FROM `album`;

SELECT a.AlbumName, COUNT(DISTINCT up.UserID) AS total_users
FROM `Album` a
JOIN `User-Photo` up ON a.PhotoID = up.PhotoID
GROUP BY a.AlbumName
HAVING COUNT(DISTINCT a.UserID) > 1;


/* 5 */
-- List all pairs of users who follow each other
SELECT 
    u1.UserID AS userid,
	u1.Name AS userName,
	u2.UserID AS following_userid,
    u2.Name AS following_userName
FROM 
    User AS u1
JOIN 
    `User-Following` AS uf1 ON u1.UserID = uf1.UserID
JOIN 
    User AS u2 ON uf1.FollowingUserID = u2.UserID
JOIN 
    `User-Following` AS uf2 ON u2.UserID = uf2.UserID
WHERE 
    uf2.FollowingUserID = u1.UserID
    AND u1.UserID <> u2.UserID
ORDER BY 
    u1.UserID, u2.UserID;


/* 6 */
SELECT 
    u1.Name AS User1,
    u2.Name AS User2,
    u3.Name AS User3
FROM 
    User AS u1
JOIN 
    `User-Following` AS uf1 ON u1.UserID = uf1.UserID
JOIN 
    User AS u2 ON uf1.FollowingUserID = u2.UserID
JOIN 
    `User-Following` AS uf2 ON u2.UserID = uf2.UserID
JOIN 
    User AS u3 ON uf2.FollowingUserID = u3.UserID
JOIN 
    `User-Following` AS uf3 ON u3.UserID = uf3.UserID
WHERE 
    uf3.FollowingUserID = u1.UserID
    AND u1.UserID <> u2.UserID
    AND u2.UserID <> u3.UserID
    AND u3.UserID <> u1.UserID
ORDER BY 
    User1, User2, User3;


/* Case: The Steps Challenge */
/* 1 */
SHOW tables;
SELECT * FROM `Participant-WeeklyChallenge`;

SELECT DISTINCT Name
FROM Participant;

/* 2 */
-- List names of participants who have enrolled in more than 2 weekly challenges
SELECT 
    p.Name
FROM 
    Participant p
JOIN 
    `Participant-WeeklyChallenge` pwc ON p.ParticipantID = pwc.ParticipantID
GROUP BY 
    p.ParticipantID, p.Name
HAVING 
    COUNT(pwc.WeeklyChallengeID) > 2;
    

/* 3 */
SELECT * FROM Redemption;
SELECT * FROM Reward;
# Car Wash is RewardID 1

SELECT COUNT(DISTINCT p.ParticipantID) AS PartAmt
FROM Participant p
JOIN 
	Redemption r ON p.ParticipantID = r.ParticipantID
JOIN 
    Reward rw ON r.RewardID = rw.RewardID
WHERE 
    rw.RewardName = 'Car Wash at Caltex';
    

/* 4 */
SELECT DISTINCT p.Name AS Name
FROM Participant p
JOIN 
	Redemption r ON p.ParticipantID = r.ParticipantID
JOIN 
    Reward rw ON r.RewardID = rw.RewardID
JOIN
	SCPoint sc ON p.ParticipantID = sc.ParticipantID
WHERE 
    rw.RewardName = 'Car Wash at Caltex' AND sc.BasicPointsEarned > 10000; 
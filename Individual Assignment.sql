/*
BC2402 Class Exercise 1
Name: Tang Te Jie, Nicholas
Matric No: U2310817H
*/


/* 1 */
SELECT DISTINCT COUNT(*) KFlyerID
from customertbl;
/*
Select distinct count for the customers ID
Answer: 1090 customers
*/


/* 2 */
SELECT DISTINCT LTRIM(MembershipType)
FROM customertbl
ORDER BY LTRIM(MembershipType) DESC;
/*
There are spaces before the SolitairePPS membership types.
Therefore, I used LTRIM to remove the spaces to clean the data.
*/


/* 3 */
SELECT 
	LTRIM(MembershipType) AS MembershipType, 
	COUNT(*) AS CustomerCount
FROM 
	customertbl
GROUP BY 
	LTRIM(MembershipType)
ORDER BY 
	LTRIM(MembershipType) DESC;
/*
After viewing the table, I saw that there were whitespaces before the different 
MembershipType strings so I used LTRIM to remove any leading spaces before the string.

Answer: 51 SoilitairePPS, 168 PPS, 533 KFlyerSilver, 338 KFlyerGold
*/


/* 4 */
SELECT 
    p.GeneralLoc,
    LTRIM(c.MembershipType) AS MembershipType,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN c.CustGen = 'MALE' THEN 1 ELSE 0 END) AS MaleCustomers,
    SUM(CASE WHEN c.CustGen = 'FEMALE' THEN 1 ELSE 0 END) AS FemaleCustomers
FROM 
	customerTBL c
JOIN 
	postalsectTBL p ON c.PostalSect = p.PostalSect
GROUP BY 
	p.GeneralLoc, LTRIM(c.MembershipType)
ORDER BY 
	p.GeneralLoc, LTRIM(c.MembershipType);
/*
Selected GeneralLoc from postalsecttbl. I selected MembershipType from customertbl but
I removed any leading spaces before grouping it. Since we need to display the total number of
customers for each location for each membership type, we use count. As for the breakdown, I
use 'sum' so when the value matches 'MALE' or 'FEMALE', it will add 1 if it's true and 0 if
it's false. I joined both tables with the common column condition which is PostalSect using
inner join. Lastly, I grouped by GeneralLoc for location and LTRIM(c.MembershipType) for 
the membership type that has the leading spaces removed. Lastly, I used ORDER BY to order
the output by GeneralLoc, followed by the updated MembershipType*/


/* 5 */
SELECT 
    p.GeneralLoc,
    LTRIM(c.MembershipType) AS MembershipType,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN c.CustGen = 'MALE' THEN 1 ELSE 0 END) AS MaleCustomers,
    SUM(CASE WHEN c.CustGen = 'FEMALE' THEN 1 ELSE 0 END) AS FemaleCustomers
FROM 
    customerTBL c
JOIN 
    postalsectTBL p ON c.PostalSect = p.PostalSect
WHERE 
	c.MemeberSince_y >= '2000'
GROUP BY 
	p.GeneralLoc, LTRIM(c.MembershipType)
ORDER BY 
	p.GeneralLoc, LTRIM(c.MembershipType); 
/*
With continuation from the previous question, I added a condition where c.MemberSince_y
is more than or equals to 2000. This will help me filter out the customers who have been 
members since year 2000 and later.
*/


/* 6 */
SELECT 
    LTRIM(c.MembershipType) AS MembershipType,
    SUM(d.Dist) AS Total_Trip_Distance
FROM 
    customertbl c
INNER JOIN 
    tripstbl t ON c.KFlyerID = t.KFlyerID
INNER JOIN 
    desttbl d ON t.RouteID = d.DestID
WHERE 
    t.Trip_y BETWEEN 2020 AND 2022
GROUP BY 
    LTRIM(c.MembershipType)
ORDER BY 
    Total_Trip_Distance DESC;
/*
For presentation purposes, I trimmed the leading spaces before MembershipType and 
used multipled the distance per trip while using elite miles mod. Afterwards, I sum
up all the values  of the trips combined. Following which, I joined the tables using 
INNER JOIN to keep the relevant column data only. Lastly, I use GROUP BY for the 
MembershipType to segregate based on the different memberships and sort by 
descending order.
*/


/* 7 */
WITH TotalDistances AS (
    SELECT
        t.KFlyerID, CONVERT(d.Aircode, CHAR(3)) AS AirCode, COUNT(*) AS TripAmt, SUM(d.Dist) AS TotalDist,
        CASE 
            WHEN t.Trip_m IN (7, 8, 11, 12) THEN 'Holiday'
            ELSE 'Non-Holiday'
        END AS Season
    FROM 
		tripstbl t
    JOIN 
		desttbl d ON t.RouteID = d.DestID
    WHERE 
        t.Outbound = 1
        AND CONVERT(d.AirCode, CHAR(3)) NOT IN ('NRT', 'MAN', 'LGW')
    GROUP BY 
        t.KFlyerID, d.AirCode,
        CASE 
            WHEN t.Trip_m IN (7, 8, 11, 12) THEN 'Holiday'
            ELSE 'Non-Holiday'
        END
),
/*
The first CTE computes total distances, number of trips, and classifies trips into 'Holiday' or 'Non-Holiday'
I converted AirCode to CHAR(3) in case it's stored in a different format. Afterwards, I classified the 
trip as 'Holiday' or 'Non-Holiday' based on the month. I joined trip and destination tables and 
included t.Outbound = 1  to filter for outbound trips only. I also excluded the different Aircode locations.
Lastly, I further group into 'Holiday' or 'Non-Holiday'.
*/

RankedDistances AS (
    SELECT
        KFlyerID, AirCode, TripAmt, TotalDist, Season,
        ROW_NUMBER() OVER (
            PARTITION BY Season ORDER BY TotalDist DESC
        ) AS RowNum
    FROM 
        TotalDistances
)
SELECT
    KFlyerID, AirCode, TripAmt, TotalDist
FROM 
	RankedDistances
WHERE 
	RowNum <= 2
ORDER BY 
    CASE WHEN Season = 'Holiday' THEN 1 ELSE 2 END,
    RowNum;

/*
The second CTE ranks travelers based on the total distance within each season and assigns a row number
based on the total distance within each season. I queried to select the top 2 travelers for both 
'Holiday' and 'Non-Holiday' seasons. Next, I order it by 'Holiday and ' first then order within 
each season by ranking.
*/


/* 8 */
/* PART 1: Find the most frequent chatbot user by membership type */
WITH NewLogtbl AS (
    SELECT DISTINCT *
    FROM fulllogtbl
    WHERE 
        ChatID IS NOT NULL
        AND UserID IS NOT NULL
        AND ChatSource IS NOT NULL
        AND Date_d IS NOT NULL
        AND Time_hh BETWEEN 0 AND 23
),
SustainedConversations AS (
    SELECT
        UserID, 
        COUNT(*) AS ConversationCount
    FROM 
		NewLogtbl
    WHERE 
		ChatSource = 'human'
    GROUP BY 
		UserID, Date_y, Date_m, Date_d
    HAVING COUNT(*) > 1
),
MembershipConversations AS (
    SELECT 
        LTRIM(c.MembershipType) AS MembershipType, 
        COUNT(sc.UserID) AS SustainedConvCount 
    FROM 
		SustainedConversations sc
    JOIN 
		customerTBL c ON sc.UserID = c.KFlyerID 
    GROUP BY 
		LTRIM(c.MembershipType)
)
SELECT 
    MembershipType, SustainedConvCount 
FROM 
	MembershipConversations
ORDER BY 
	SustainedConvCount DESC
LIMIT 1;

/*
Firstly, I cleaned the data by removing null values and ensure time (hour) is valid (0-23).
Secondly, I identified sustained conversations and only considered customer-side messages.
I grouped by user and date, and only included sustained conversations (more than 1 message).
Thirdly, I linked sustained conversations with customer membership information.
Lastly, I displayed the membership type with the highest count of sustained conversations
and sort by the most sustained conversations and returning the top membership type with the 
highest conversation count.
*/

/* PART 2: For each membership type, display the number of sustained conversations */

WITH NewLogtbl AS (
    SELECT DISTINCT *
    FROM fulllogtbl
    WHERE 
        ChatID IS NOT NULL
        AND UserID IS NOT NULL
        AND ChatSource IS NOT NULL
        AND Date_d IS NOT NULL
        AND Time_hh BETWEEN 0 AND 23
),
SustainedConversations AS (
    SELECT
        UserID, COUNT(*) AS ConversationCount
    FROM 
		NewLogtbl
    WHERE 
		ChatSource = 'human'
    GROUP BY 
		UserID, Date_y, Date_m, Date_d
    HAVING 
		COUNT(*) > 1 
),
MembershipConversations AS (
    SELECT 
		LTRIM(c.MembershipType) AS MembershipType, COUNT(sc.UserID) AS SustainedConvCount
    FROM 
		SustainedConversations sc
    JOIN 
		customerTBL c ON sc.UserID = c.KFlyerID
    GROUP BY 
        LTRIM(c.MembershipType)
)
SELECT 
    MembershipType, SustainedConvCount  
FROM 
	MembershipConversations
ORDER BY 
	SustainedConvCount DESC; 

/*
Notes:
NewLogtbl filters the fulllogtbl to remove null values and invalid time entries.
SustainedConversations identifies users with more than one conversation on a given day.
MembershipConversations links the sustained conversations to customer membership types.
The final output displays the count of sustained conversations for each membership type,
sorted in descending order.
*/


/* 9 */

/*
1. Calculate Average Emotions for Each User.
2. Calculate Modified Miles for Each User.
3. Combine Average Emotions with Modified Miles.
4. Generate Ratios for Emotions Against Modified Miles.
5. Determine Customer Types (Happy, Upset, Sentimental, Confused).
6. Combine Results into Final Output.
*/
-- Step 1: Generate a list of UserID and corresponding emotion averages
WITH EmotionAverages AS (
    SELECT 
        UserID,  -- Identifier for users
        -- Averaging emotional values to get a sense of overall user emotion
        AVG(Joy) AS Avg_Joy, 
        AVG(Anger) AS Avg_Anger, 
        AVG(Disgust) AS Avg_Disgust, 
        AVG(Surprise) AS Avg_Surprise, 
        AVG(Fear) AS Avg_Fear, 
        AVG(Sadness) AS Avg_Sadness, 
        AVG(Contempt) AS Avg_Contempt, 
        AVG(Sentimentality) AS Avg_Sentimentality, 
        AVG(Confusion) AS Avg_Confusion
    FROM 
        fulllogTBL  -- Assuming this table stores emotion logs
    WHERE 
        UserID IS NOT NULL  -- Exclude NULL UserIDs to avoid invalid groupings
        AND Joy IS NOT NULL 
        AND Anger IS NOT NULL 
        AND Disgust IS NOT NULL
        -- Assuming that some emotion columns might have NULL values
        -- for some entries in fulllogTBL. NULLs in emotion columns can indicate missing or incomplete data.
        -- Decided to filter out any rows where critical emotions (Joy, Anger, Disgust, etc.) are NULL.
        -- This ensures we only calculate averages where we have complete emotion data.
    GROUP BY 
        UserID
),

-- Step 2: Generate a list of KFlyerID with corresponding Modified Miles
ModifiedMiles AS (
    SELECT 
        KFlyerID, 
        SUM(Dist * EliteMilesMod) AS ModifiedMiles  -- Calculating modified miles
    FROM 
        tripsTBL
    JOIN 
        destTBL ON tripsTBL.RouteID = destTBL.DestID
    WHERE
        Dist IS NOT NULL AND EliteMilesMod IS NOT NULL  -- Filtering NULL values to ensure calculations are valid
    GROUP BY 
        KFlyerID
),

-- Step 3: Combine EmotionAverages and ModifiedMiles based on UserID = KFlyerID
CombinedResults AS (
    SELECT 
        e.UserID, 
        e.Avg_Joy, e.Avg_Anger, e.Avg_Disgust, e.Avg_Surprise, 
        e.Avg_Fear, e.Avg_Sadness, e.Avg_Contempt, e.Avg_Sentimentality, e.Avg_Confusion, 
        m.ModifiedMiles
    FROM 
        EmotionAverages e
    JOIN 
        ModifiedMiles m ON e.UserID = m.KFlyerID  -- Assuming UserID and KFlyerID are the same
    WHERE 
        m.ModifiedMiles > 0  -- Exclude entries with 0 or negative miles as they can skew ratios
        -- Also excluding cases where ModifiedMiles is 0 to avoid division by zero in subsequent ratio calculations
),

-- Step 4: Generate a list of KFlyerID and corresponding emotions
EmotionResults AS (
    SELECT 
        UserID AS KFlyerID,  -- Aligning UserID with KFlyerID
        Avg_Joy AS PositiveEmotions,  -- Only positive emotions are based on joy for simplicity
        (Avg_Anger + Avg_Disgust + Avg_Fear + Avg_Sadness)/4 AS NegativeEmotions,  -- Summing key negative emotions
        Avg_Sentimentality, 
        Avg_Confusion, 
        ModifiedMiles
    FROM 
        CombinedResults
),
-- Step 5: Calculate emotion ratios using logarithmic scaling
EmotionRatios AS (
    SELECT 
        KFlyerID, 
        -- Logarithmic ratios help deal with large variations in miles and emotions
        ROUND(LOG(PositiveEmotions) / LOG(ModifiedMiles), 3) AS PositiveEmotionsRatio, 
        ROUND(LOG(NegativeEmotions) / LOG(ModifiedMiles), 3) AS NegativeEmotionsRatio, 
        ROUND(LOG(Avg_Sentimentality) / LOG(ModifiedMiles), 3) AS SentimentalityRatio, 
        ROUND(LOG(Avg_Confusion) / LOG(ModifiedMiles), 3) AS ConfusionRatio
    FROM 
        EmotionResults
    WHERE 
        PositiveEmotions > 0 AND NegativeEmotions > 0  -- Ensure valid inputs for logarithmic calculations
        AND Avg_Sentimentality > 0 AND Avg_Confusion > 0
        -- Decided to exclude any cases where emotions are 0 or negative because log(0) is undefined
),
-- Step 6: Classify customers into different categories based on emotion ratios
HappyCustomers AS (
    SELECT 
        KFlyerID, PositiveEmotionsRatio, NegativeEmotionsRatio, SentimentalityRatio, ConfusionRatio
    FROM 
        EmotionRatios
    WHERE 
        PositiveEmotionsRatio > NegativeEmotionsRatio 
        AND PositiveEmotionsRatio > SentimentalityRatio 
        AND PositiveEmotionsRatio > ConfusionRatio
),
UpsetCustomers AS (
    SELECT 
        KFlyerID, PositiveEmotionsRatio, NegativeEmotionsRatio, SentimentalityRatio, ConfusionRatio
    FROM 
        EmotionRatios
    WHERE 
        NegativeEmotionsRatio > PositiveEmotionsRatio 
        AND NegativeEmotionsRatio > SentimentalityRatio 
        AND NegativeEmotionsRatio > ConfusionRatio
),
SentimentalCustomers AS (
    SELECT 
        KFlyerID, PositiveEmotionsRatio, NegativeEmotionsRatio, SentimentalityRatio, ConfusionRatio
    FROM 
        EmotionRatios
    WHERE 
        SentimentalityRatio > PositiveEmotionsRatio 
        AND SentimentalityRatio > NegativeEmotionsRatio 
        AND SentimentalityRatio > ConfusionRatio
),

ConfusedCustomers AS (
    SELECT 
        KFlyerID, PositiveEmotionsRatio, NegativeEmotionsRatio, SentimentalityRatio, ConfusionRatio
    FROM 
        EmotionRatios
    WHERE 
        ConfusionRatio > PositiveEmotionsRatio 
        AND ConfusionRatio > NegativeEmotionsRatio 
        AND ConfusionRatio > SentimentalityRatio
)
-- Step 7: Union the classified customer groups and count the results
SELECT 
    'Happy Customers' AS CustomerType, COUNT(*) AS CustomerCount
FROM 
    HappyCustomers
UNION ALL
SELECT 
    'Upset Customers' AS CustomerType, COUNT(*) AS CustomerCount
FROM 
    UpsetCustomers
UNION ALL
SELECT 
    'Sentimental Customers' AS CustomerType, COUNT(*) AS CustomerCount
FROM 
    SentimentalCustomers
UNION ALL
SELECT 
    'Confused Customers' AS CustomerType, COUNT(*) AS CustomerCount
FROM 
    ConfusedCustomers;
    

/* 10 */
-- Step 1: Clean up data by removing records with NULL or empty content
CREATE VIEW CleanedLogTBL AS
SELECT * 
FROM fulllogTBL
WHERE Content IS NOT NULL
  AND Content != '';  -- Remove empty content records

-- Step 2: Extract the SOUNDEX string and group by the last 4 characters
-- Store the frequencies of each soundex suffix
CREATE VIEW SoundexFrequencies AS
SELECT 
    RIGHT(SOUNDEX(Content), 4) AS SoundexSuffix,  -- Extract the last 4 characters (the soundex suffix)
    COUNT(*) AS Frequency  -- Count occurrences of each soundex suffix
FROM 
    CleanedLogTBL
GROUP BY 
    SoundexSuffix  -- Group by the soundex suffix
ORDER BY
	Frequency DESC;

-- Step 3: Identify the most frequent soundex suffix
CREATE VIEW MostFrequentSoundex AS
SELECT SoundexSuffix
FROM SoundexFrequencies
GROUP BY SoundexSuffix
ORDER BY Frequency DESC  -- Order by frequency, descending
LIMIT 1;  -- Get the most frequent soundex suffix

-- Step 4: Retrieve records that match the most frequent soundex suffix in the Content field
SELECT * 
FROM CleanedLogTBL 
WHERE SOUNDEX(Content) LIKE CONCAT('%', (SELECT SoundexSuffix FROM MostFrequentSoundex), '%');
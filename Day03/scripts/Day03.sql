-- ====================================================
-- 30-DAY DATA ANALYTICS CHALLENGE
-- DAY 03: Do Critics Affect Product Sales?
-- Tool Stack : SQL Server + Power BI
-- Datasets   : movies_final_analysis.csv
-- Author     : Toluwalase
-- ====================================================

-- ====================================================
-- PHASE 1 : DATABASE + SCHEMA + TABLE SETUP
-- ====================================================

USE [30_Days_Analytics_ChallengeDB];
GO

-- Drop tables first (must go before schema drop)
IF OBJECT_ID('Challenge_day03.movies_clean', 'U') IS NOT NULL DROP TABLE Challenge_day03.movies_clean;
IF OBJECT_ID('Challenge_day03.movies_raw',   'U') IS NOT NULL DROP TABLE Challenge_day03.movies_raw;
GO

-- Now the schema is empty and can be dropped
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Challenge_day03')
	DROP SCHEMA Challenge_day03;
GO

CREATE SCHEMA Challenge_day03;
GO

-- --------------------------------------------------------------
-- TABLE 1 : movies_raw
-- Source  : movies_final_analysis.csv (74 rows, 13 columns)
-- Purpose : Financials and critical scores for top films
-- --------------------------------------------------------------

CREATE TABLE Challenge_day03.movies_raw (
	[Film]					VARCHAR(255),
	[Genre]					VARCHAR(50),
	[Lead Studio]			VARCHAR(100),
	[Year]					VARCHAR(10),
	[Worldwide Gross]		VARCHAR(50),
	[Profitability]			VARCHAR(50),
	[box_office]			VARCHAR(50),
	[rt_score_omdb]			VARCHAR(20),
	[metacritic_clean]		VARCHAR(20),
	[imdb_rating]			VARCHAR(20),
	[imdb_votes_clean]		VARCHAR(50),
	[rated]					VARCHAR(20),
	[runtime]				VARCHAR(20)
);
GO

-- << CHANGE THIS PATH to wherever you saved movies_final_analysis.csv >>
BULK INSERT Challenge_day03.movies_raw
FROM 'C:\Users\Admin\Downloads\movies_final_analysis.csv'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR   = '0x0a',
	FIRSTROW		= 2,
	TABLOCK
);
GO

-- Confirm row counts
SELECT 'movies_raw' AS tbl, COUNT(*) AS rows FROM Challenge_day03.movies_raw;
GO

-- =========================================================
-- PHASE 2 : DATA UNDERSTANDING
-- =========================================================

/*
============================================
DATA DICTIONARY
============================================

TABLE 1 - movies_raw
	Film				: Title of the movie
	Genre				: Primary categorical genre (Comedy, Drama, etc.)
	Lead Studio			: The production company financing the film
	Year				: Calendar year of release
	Worldwide Gross		: Total global revenue in millions (proxy multiplier)
	Profitability		: ROI metric (Revenue / Budget)
	box_office			: Total US domestic box office in raw dollars
	rt_score_omdb		: Rotten Tomatoes critic percentage (0-100)
	metacritic_clean	: Metacritic weighted average score (0-100)
	imdb_rating			: IMDb audience rating (0-10)
	imdb_votes_clean	: Volume of audience ratings on IMDb
	rated				: Age classification (PG-13, R, etc.)
	runtime				: Length of the movie in minutes
*/

-- ============================================================
-- PHASE 3: DATA QUALITY CHECKS
-- ============================================================

-- ----------------------------------------------------------------
-- NULL / BLANK CHECK 
-- ----------------------------------------------------------------

DECLARE @sql	NVARCHAR(MAX) = '';
DECLARE @table	NVARCHAR(100) = 'Challenge_day03.movies_raw';

SELECT @sql = @sql + 
	'SUM(CASE WHEN [' + COLUMN_NAME + '] IS NULL OR [' + COLUMN_NAME + '] = '''' THEN 1 ELSE 0 END) AS [' + COLUMN_NAME + '_nulls],' + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Challenge_day03'
 AND  TABLE_NAME   = 'movies_raw'
ORDER BY ORDINAL_POSITION;

SET @sql = 'SELECT COUNT(*) AS total_rows, ' + CHAR(10) + LEFT(@sql, LEN(@sql) - 2)
		 + CHAR(10) + 'FROM ' + @table + ';';

PRINT @sql
EXEC sp_executesql @sql;
GO

-- ----------------------------------------------------------
-- Duplicate check
-- ----------------------------------------------------------

-- movies_raw: one row per film
WITH cte AS (
	SELECT
		Film,
		ROW_NUMBER() OVER (PARTITION BY Film ORDER BY Year) AS rn
	FROM Challenge_day03.movies_raw
)
SELECT COUNT(*) AS duplicate_rows
FROM cte
WHERE rn > 1;
GO

-- ============================================================
-- PHASE 4: DATA CLEANING — TYPED CLEAN TABLES
-- ============================================================

-- ----------------------------------------------------------------
-- CLEAN TABLE: movies_clean
-- Casting strings to numeric types for math operations, and 
-- stripping the ' min' string from runtime.
-- ----------------------------------------------------------------

SELECT
	Film,
	Genre,
	[Lead Studio],
	TRY_CAST(Year AS INT)							AS Release_Year,
	TRY_CAST([Worldwide Gross] AS FLOAT)			AS Worldwide_Gross_M,
	TRY_CAST(Profitability AS FLOAT)				AS Profitability_ROI,
	TRY_CAST(box_office AS BIGINT)					AS US_Box_Office,
	TRY_CAST(rt_score_omdb AS FLOAT)				AS Rotten_Tomatoes,
	TRY_CAST(metacritic_clean AS FLOAT)				AS Metacritic,
	TRY_CAST(imdb_rating AS FLOAT)					AS IMDb_Rating,
	TRY_CAST(imdb_votes_clean AS BIGINT)			AS IMDb_Votes,
	rated											AS Content_Rating,
	TRY_CAST(REPLACE(runtime, ' min', '') AS INT)	AS Runtime_Mins
INTO Challenge_day03.movies_clean
FROM Challenge_day03.movies_raw
WHERE TRY_CAST(Year AS INT) IS NOT NULL;
GO

-- Add categorization flags for critic tiers to make grouping easier

ALTER TABLE Challenge_day03.movies_clean ADD Critic_Tier VARCHAR(20);
GO

UPDATE Challenge_day03.movies_clean
SET Critic_Tier = CASE
	WHEN Rotten_Tomatoes >= 75 THEN 'Acclaimed'
	WHEN Rotten_Tomatoes >= 60 THEN 'Fresh'
	ELSE 'Rotten'
END;
GO

-- Preview clean table
SELECT TOP 5 * FROM Challenge_day03.movies_clean;
GO

-- Business Logic Validation: box office should not be negative
SELECT COUNT(*) AS Invalid_Revenue_Rows
FROM Challenge_day03.movies_clean
WHERE US_Box_Office <= 0;
GO

-- ============================================================
-- PHASE 5: FOUNDATIONAL ANALYSIS
-- ============================================================

-- Average box office and scores by Genre

SELECT
	Genre,
	COUNT(Film)									AS Total_Films,
	ROUND(AVG(CAST(US_Box_Office AS FLOAT)), 0)	AS Avg_Box_Office,
	ROUND(AVG(Profitability_ROI), 2)			AS Avg_ROI,
	ROUND(AVG(Rotten_Tomatoes), 1)				AS Avg_Critic_Score,
	ROUND(AVG(IMDb_Rating), 1)					AS Avg_Audience_Score
FROM Challenge_day03.movies_clean
GROUP BY Genre
ORDER BY Avg_Box_Office DESC;
GO

-- Top 10 most profitable films and their scores

SELECT TOP 10
	Film,
	Genre,
	Profitability_ROI,
	US_Box_Office,
	Rotten_Tomatoes,
	IMDb_Rating
FROM Challenge_day03.movies_clean
ORDER BY Profitability_ROI DESC;
GO

-- ============================================================
-- PHASE 6: CORE BUSINESS ANALYSIS
-- ============================================================

-- Do critics affect sales? (Box Office by Critic Tier)
-- This directly answers the challenge question.

SELECT
	Critic_Tier,
	COUNT(Film)									AS Film_Count,
	ROUND(AVG(CAST(US_Box_Office AS FLOAT)), 0)	AS Avg_US_Box_Office,
	ROUND(AVG(Worldwide_Gross_M), 2)			AS Avg_Worldwide_Gross_M,
	ROUND(AVG(Profitability_ROI), 2)			AS Avg_Profitability_ROI
FROM Challenge_day03.movies_clean
GROUP BY Critic_Tier
ORDER BY Avg_US_Box_Office DESC;
GO

-- The Audience vs. Critic Divide
-- Finding movies where critics loved it but audiences were meh, or vice versa.
-- (Assuming an IMDb of 7.0 is roughly equivalent to a 70% RT score)

SELECT
	Film,
	Genre,
	Rotten_Tomatoes,
	(IMDb_Rating * 10) AS IMDb_Converted,
	ROUND(Rotten_Tomatoes - (IMDb_Rating * 10), 1) AS Critic_Audience_Gap,
	US_Box_Office,
	Profitability_ROI
FROM Challenge_day03.movies_clean
WHERE ABS(Rotten_Tomatoes - (IMDb_Rating * 10)) > 20 -- 20 point gap minimum
ORDER BY Critic_Audience_Gap DESC;
GO

/*
    Q1 — Critic Tier vs Box Office
         This is the crux of Day 3. If 'Acclaimed' films have a 
         significantly higher Avg_US_Box_Office than 'Rotten' films, 
         you have proven the correlation.
         
    Q2 — The Divide
         Positive gap = Critics loved it, audiences didn't.
         Negative gap = Audiences loved it, critics hated it (e.g., Twilight).
         Check the box office of the negative gap films—if they made millions 
         despite terrible reviews, that's your nuance for the LinkedIn post.
*/

-- ============================================================
-- PHASE 7: ADVANCED ANALYSIS — WINDOW FUNCTIONS
-- ============================================================

-- Rank the highest grossing movies per year alongside their scores

WITH Ranked_Movies AS (
	SELECT
		Release_Year,
		Film,
		Genre,
		US_Box_Office,
		Rotten_Tomatoes,
		RANK() OVER(PARTITION BY Release_Year ORDER BY US_Box_Office DESC) AS Box_Office_Rank
	FROM Challenge_day03.movies_clean
)
SELECT * 
FROM Ranked_Movies
WHERE Box_Office_Rank <= 3
ORDER BY Release_Year, Box_Office_Rank;
GO

-- Cumulative box office dominance by Studio over time

SELECT
	Release_Year,
	[Lead Studio],
	SUM(US_Box_Office) AS Annual_Studio_Box_Office,
	SUM(SUM(US_Box_Office)) OVER(
		PARTITION BY [Lead Studio] 
		ORDER BY Release_Year
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS Cumulative_Box_Office
FROM Challenge_day03.movies_clean
GROUP BY Release_Year, [Lead Studio]
ORDER BY [Lead Studio], Release_Year;
GO

/*
    Q1 — Ranked Movies
         Do the #1 box office hits of each year also hold the highest 
         Rotten Tomatoes scores of that year? If the #1 movie is constantly 
         'Rotten', critics don't drive peak sales, marketing does.
*/

-- ============================================================
-- PHASE 8: BUSINESS INSIGHT QUERIES
-- ============================================================

-- Flops with great reviews (Critical Darlings, Commercial Failures)

SELECT
	Film,
	[Lead Studio],
	Rotten_Tomatoes,
	Profitability_ROI,
	US_Box_Office
FROM Challenge_day03.movies_clean
WHERE Rotten_Tomatoes >= 80 
  AND Profitability_ROI < 2.0 -- Barely broke even or lost money
ORDER BY US_Box_Office ASC;
GO

-- Blockbusters with terrible reviews (Critic Proof Films)

SELECT
	Film,
	[Lead Studio],
	Rotten_Tomatoes,
	Profitability_ROI,
	US_Box_Office
FROM Challenge_day03.movies_clean
WHERE Rotten_Tomatoes <= 40
  AND US_Box_Office > 100000000 -- Made over $100M domestically
ORDER BY US_Box_Office DESC;
GO

-- ============================================================
-- PHASE 9: REPORTING QUERIES (Power BI Ready)
-- ============================================================

-- Visual 1: Scatter Plot (Critic Score vs Box Office Revenue)
SELECT 
	Film, 
	Genre, 
	Rotten_Tomatoes, 
	Metacritic,
	US_Box_Office, 
	Critic_Tier 
FROM Challenge_day03.movies_clean;
GO

-- Visual 2: Bar Chart (Average Profitability by Critic Tier)
SELECT 
	Critic_Tier, 
	ROUND(AVG(Profitability_ROI), 2) AS Avg_Profitability,
	ROUND(AVG(CAST(US_Box_Office AS FLOAT)), 0) AS Avg_Box_Office
FROM Challenge_day03.movies_clean
GROUP BY Critic_Tier
ORDER BY Avg_Profitability DESC;
GO

-- Visual 3: KPI Cards (Overall market stats)
SELECT
	COUNT(Film) AS Total_Films,
	ROUND(AVG(Rotten_Tomatoes), 1) AS Average_Market_Score,
	SUM(US_Box_Office) AS Total_Market_Revenue,
	ROUND(AVG(Profitability_ROI), 2) AS Average_Market_ROI
FROM Challenge_day03.movies_clean;
GO
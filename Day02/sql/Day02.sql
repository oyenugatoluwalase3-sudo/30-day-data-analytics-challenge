-- ====================================================
-- 30-DAY DATA ANALYTICS CHALLENGE
-- DAY 02: What Makes a Club the Big Six?
-- Tool Stack : SQL Server + Power BI
-- Datasets   : club_financials.csv | transfers_history.csv
--				record_transfers.csv ! 2020-2021.txt to 2024-2025.txt
-- Author	  : Toluwalase
-- ====================================================

-- ====================================================
-- PHASE 1 : DATABASE + SCHEMA + TABLE SETUP
-- ====================================================

USE [30_Days_Analytics_ChallengeDB];
GO

-- Drop tabless first (must go before schema drop)

IF OBJECT_ID('Challenge_day02.pl_season_stats_clean',		'U') IS NOT NULL DROP TABLE Challenge_day02.pl_season_stats_clean;
IF OBJECT_ID('Challenge_day02.transfers_history_clean',		'U') IS NOT NULL DROP TABLE Challenge_day02.transfers_history_clean;
IF OBJECT_ID('Challenge_day02.club_financials_clean',		'U') IS NOT NULL DROP TABLE Challenge_day02.club_financials_clean;
IF OBJECT_ID('Challenge_day02.record_transfers',			'U') IS NOT NULL DROP TABLE Challenge_day02.record_transfers;
IF OBJECT_ID('Challenge_day02.transfers_history',			'U') IS NOT NULL DROP TABLE Challenge_day02.transfers_history;
IF OBJECT_ID('Challenge_day02.club_financials',				'U') IS NOT NULL DROP TABLE Challenge_day02.club_financials;
IF OBJECT_ID('Challenge_day02.pl_season_stats',				'U') IS NOT NULL DROP TABLE Challenge_day02.pl_season_stats;
GO

-- Now the schema is empty and can be dropped

IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Challenge_day02')
	DROP SCHEMA Challenge_day02;
GO

CREATE SCHEMA Challenge_day02;
GO

-- --------------------------------------------------------------
-- TABLE 1 : club_financials
-- Source  : club_financials.csv (884 rows, 10 columns)
-- Purpose : Revenue, wages, transfer spend, operating profit
--			 for top 50 clubs, 2010-2026
-- --------------------------------------------------------------

CREATE TABLE Challenge_day02.club_financials (
	year						VARCHAR(10),
	club_name					VARCHAR(100),
	league						VARCHAR(50),
	country						VARCHAR(10),
	stadium_capacity			VARCHAR(20),
	revenue_eur_m				VARCHAR(20),
	wage_bill_eur_m				VARCHAR(20),
	wages_to_revenue_pct		VARCHAR(20),
	net_transfer_spend_eur_m	VARCHAR(20),
	operating_profit_eur_m		VARCHAR(20)
);
GO

--  << CHANGE THIS PATHt o wherever you saved club_financials.csv  >>
BULK INSERT Challenge_day02.club_financials
FROM 'C:\Users\Admin\Downloads\Day02\club_financials.csv'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR   = '0x0a',
	FIRSTROW		= 2,
	TABLOCK
);
GO

-- ---------------------------------------------------------------
-- TABLE 2: transfers_history
-- Source : transfers_history.csv (~ 14,990 rows, 19 columns)
-- Purpose : All transfer activity 2010 - 2026 across all clubs
-- ----------------------------------------------------------------

CREATE TABLE Challenge_day02.transfers_history (
	transfer_id			VARCHAR(20),
	year				VARCHAR(10),
	date				VARCHAR(20),
	season				VARCHAR(20),
	transfer_window		VARCHAR(10),
	player_name			VARCHAR(100),
	position			VARCHAR(10),
	age					VARCHAR(10),
	from_club			VARCHAR(100),
	from_league			VARCHAR(50),
	from_country		VARCHAR(10),
	to_club				VARCHAR(100),
	to_league			VARCHAR(50),
	to_country			VARCHAR(10),
	fee_eur_m			VARCHAR(20),
	is_free_transfer	VARCHAR(5),
	is_loan				VARCHAR(5),
	is_intra_league		VARCHAR(5),
	is_intra_country	VARCHAR(5)
);
GO

-- << CHANGE THIS PATH >>

BULK INSERT Challenge_day02.transfers_history
FROM 'C:\Users\Admin\Downloads\Day02\transfers_history.csv'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	FIRSTROW = 2,
	TABLOCK
);
GO

-- ------------------------------------------------------------
-- TABLE 3 : record_transfers
-- Source   : record_transfers.csv (57 rows, 13 columns)
-- Purpose  : The biggest individual transfer deals in history
-- -------------------------------------------------------------

CREATE TABLE Challenge_day02.record_transfers (
	transfer_id			VARCHAR(20),
	date				VARCHAR(20),
	year				VARCHAR(10),
	season				VARCHAR(20),
	player_name			VARCHAR(100),
	position			VARCHAR(10),
	age_at_transfer		VARCHAR(10),
	from_club			VARCHAR(100),
	to_club				VARCHAR(100),
	fee_eur_m			VARCHAR(20),
	is_free_transfer	VARCHAR(5),
	is_loan				VARCHAR(5),
	is_extension		VARCHAR(5)
);
GO

-- << CHANGE THIS PATH >>

BULK INSERT Challenge_day02.record_transfers
FROM 'C:\Users\Admin\Downloads\Day02\record_transfers.csv'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	FIRSTROW = 2,
	TABLOCK
);
GO

-- ----------------------------------------------------------------------
-- TABLE 4 : pl_season_stats
-- SOurce	: 2020-2021.txt throught 2024-2025.txt (5 files x 20 rows)
-- Purpose	: On-pitch Performance - Points, goals, xG, Possession
--			  for every PL club across 5 seasons
-- NOTE		: Load each file seperately into the SAME table.
--			  The Season column already tells you which year each
--			  row belongs to, so you do not need five tables.
-- ----------------------------------------------------------------------

CREATE TABLE Challenge_day02.pl_season_stats (
	Rk			VARCHAR(5),
	Season		VARCHAR(20),
	Team		VARCHAR(100),
	Comp		VARCHAR(50),
	xG			VARCHAR(20),
	MP			VARCHAR(5),
	W			VARCHAR(5),
	D			VARCHAR(5),
	L			VARCHAR(5),
	Pts			VARCHAR(10),
	Pts_MP		VARCHAR(10),
	Min			VARCHAR(10),
	Subs		VARCHAR(10),
	LgRank		VARCHAR(5),
	GF			VARCHAR(10),
	GA			VARCHAR(10),
	GD			VARCHAR(10),
	Poss		VARCHAR(10),
	CS			VARCHAR(10),
	CS_pct		VARCHAR(10),
	G_PK		VARCHAR(10),
	PK			VARCHAR(10),
	PKatt		VARCHAR(10),
	PKm			VARCHAR(10),
	xG2			VARCHAR(10),
	npxG		VARCHAR(10),
	xGD			VARCHAR(10),
	npxGD		VARCHAR(10),
	xAG			VARCHAR(10),
	xA			VARCHAR(10),
	G_xG		VARCHAR(10),
	np_G_xG		VARCHAR(10),
	A_xAG		VARCHAR(10),
	npxG_Sh		VARCHAR(10),
	Sh			VARCHAR(10),
	G_Sh		VARCHAR(10),
	G_SoT		VARCHAR(10),
	SoT			VARCHAR(10),
	SoT_pct		VARCHAR(10),
	Dist		VARCHAR(10),
	FK			VARCHAR(10)
);
GO

-- Load all 5 seasons files one by one into the same table
-- << CHANGE EACH PATH >>

BULK INSERT Challenge_day02.pl_season_stats
FROM 'C:\Users\Admin\Downloads\2020-2021.txt'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	FIRSTROW = 2,
	TABLOCK
);
GO

BULK INSERT Challenge_day02.pl_season_stats
FROM 'C:\Users\Admin\Downloads\2021-2022.txt'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR	 = '0x0a',
	FIRSTROW		 = 2,
	TABLOCK
);
GO

BULK INSERT Challenge_day02.pl_season_stats
FROM 'C:\Users\Admin\Downloads\2022-2023.txt'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR   = '0x0a',
	FIRSTROW        = 2,
	TABLOCK
);
GO

BULK INSERT Challenge_day02.pl_season_stats
FROM 'C:\Users\Admin\Downloads\2023-2024.txt'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR   = '0x0a',
	FIRSTROW		= 2,
	TABLOCK
);
GO

BULK INSERT Challenge_day02.pl_season_stats
FROM 'C:\Users\Admin\Downloads\2024-2025.txt'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR	= '\n',
	FIRSTROW		= 2,
	TABLOCK
);
GO

-- Confirm row counts

SELECT 'club_financials' AS tbl, COUNT(*) AS rows FROM Challenge_day02.club_financials UNION ALL
SELECT 'transfer_history' AS tbl, COUNT(*) AS rows FROM Challenge_day02.transfers_history UNION ALL
SELECT 'record_transfers' AS tbl, COUNT(*) AS rows FROM Challenge_day02.record_transfers UNION ALL
SELECT 'pl_season_stats' AS tbl, COUNT(*) AS rows FROM Challenge_day02.pl_season_stats
GO

-- =========================================================
-- PHASE 2 : DATA UNDERSTANDING
-- =========================================================

/*
============================================
DATA DICTIONARY
============================================

TABLE 1 - club_financials
	year							: Calendar year the financial figures apply to (2010 to 2026)
	club_name						: Name of the club
	league							: League the club plays in (e.g. Premier_League, La_Liga)
	country							: Country code (ENG, ESP, GER, etc. )
	stadium_capacity				: Maximum seating capacity of the club's home ground
	revenue_eur_m					: Total annual club revenue in millioons of euros
	wages_to_revenue_pct			: wage bill as a percentage of revenue - UEFA's key financial health ratio
	net_transfer_spend_eur_m		: Transfer spend minus transfer income - positive = net bonus
	operating profit_eur_m			: Revenue minus operating costs before interest and tax

TABLE 2 — transfers_history
    transfer_id             : Unique identifier for each transfer
    year                    : Calendar year the transfer occurred
    season                  : Season label (e.g. 2022-2023)
    transfer_window         : Whether the deal happened in the summer or winter window
    player_name             : Name of the player transferred
    position                : Player's position code (FW, CM, CB, GK, etc.)
    age                     : Player's age at time of transfer
    from_club / to_club     : Selling and buying clubs
    from_league / to_league : Leagues involved in the deal
    fee_eur_m               : Transfer fee paid in millions of euros
    is_free_transfer        : 1 = no fee paid
    is_loan                 : 1 = temporary loan move
    is_intra_league         : 1 = both clubs in the same league
    is_intra_country        : 1 = both clubs in the same country

TABLE 3 — record_transfers
    Subset of transfers_history containing only the biggest landmark
    deals in football history — includes fees, player details,
    clubs involved, and whether the deal was a loan or extension.

TABLE 4 — pl_season_stats
    Rk / LgRank             : Final league position that season
    Season                  : Season label (e.g. 2020-2021)
    Team                    : Club name as used in the FBref source
    MP / W / D / L          : Matches played, won, drawn, lost
    Pts / Pts_MP            : Total points and points per match
    GF / GA / GD            : Goals for, against, and goal difference
    xG / npxG               : Expected goals (total and non-penalty)
    xGD / npxGD             : Expected goal difference
    Poss                    : Average possession percentage
    CS / CS_pct             : Clean sheets and clean sheet percentage
    Sh / SoT / SoT_pct      : Shots, shots on target, and shot accuracy
*/


-- ============================================================
-- PHASE 3: DATA QUALITY CHECKS
-- ============================================================

-- ----------------------------------------------------------------
-- NULL / BLANK CHECK 
-- ----------------------------------------------------------------

-- TABLE : 'Club_financials'

DECLARE @sql	NVARCHAR(MAX) = '';
DECLARE @table	NVARCHAR(100) = 'Challenge_day02.club_financials';

SELECT @sql = @sql + 
	'SUM(CASE WHEN [' + COLUMN_NAME + '] IS NULL THEN 1 ELSE 0 END) AS [' + COLUMN_NAME + '_nulls],' + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Challenge_day02'
 AND  TABLE_NAME   = 'club_financials'
ORDER BY ORDINAL_POSITION;

SET @sql = 'SELECT COUNT(*) AS total_rows, ' + CHAR(10) + LEFT(@sql, LEN(@sql) - 2)
		 + CHAR(10) + 'FROM ' + @table + ';';

PRINT @sql

EXEC sp_executesql @sql;
GO

-- TABLE : 'transfers_history'

DECLARE @sql	NVARCHAR(MAX) = '';
DECLARE @table	NVARCHAR(100) = 'Challenge_day02.transfers_history';

SELECT @sql = @sql +
	'SUM(CASE WHEN [' + COLUMN_NAME + '] IS NULL THEN 1 ELSE 0 END) AS [' + COLUMN_NAME + '_nulls],' + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Challenge_day02'
  AND TABLE_NAME   = 'transfers_history'
ORDER BY ORDINAL_POSITION;

SET @sql = 'SELECT COUNT(*) AS total_rows, ' + CHAR(10) + LEFT(@sql, LEN(@sql) - 2)
		 + CHAR(10) + ' FROM ' + @table + ';';

PRINT @sql

EXEC sp_executesql @sql;
GO

-- TABLE : 'record_transfers'

DECLARE @sql	NVARCHAR(MAX) = '';
DECLARE @table	NVARCHAR(100) = 'Challenge_day02.record_transfers';

SELECT @sql = @sql + 
	'SUM(CASE WHEN [' + COLUMN_NAME + '] IS NULL THEN 1 ELSE 0 END) AS  [' + COLUMN_NAME + '_nulls],'+ CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Challenge_day02'
  AND TABLE_NAME   = 'record_transfers'
ORDER BY ORDINAL_POSITION;

SET @sql = 'SELECT COUNT(*) AS total_rows, ' + CHAR(10) + LEFT(@sql, LEN(@sql) - 2)
		   + CHAR(10) + 'FROM ' + @table + ';';

PRINT @sql

EXEC sp_executesql @sql;
GO

-- TABLE - 'pl_season_stats'

DECLARE @sql	NVARCHAR(MAX) = '';
DECLARE @table	NVARCHAR(100) = 'Challenge_day02.pl_season_stats'

SELECT @sql = @sql +
	'SUM(CASE WHEN [' + COLUMN_NAME + '] IS NULL THEN 1 ELSE 0 END) AS [' + COLUMN_NAME + '_nulls],' + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Challenge_day02'
  AND TABLE_NAME   = 'pl_season_stats'
ORDER BY ORDINAL_POSITION

SET @sql = 'SELECT COUNT(*) AS total_rows, ' + CHAR(10) + LEFT(@sql, LEN(@sql) - 2)
		 + CHAR(10) + 'FROM ' + @table + ';';

PRINT @sql

EXEC sp_executesql @sql;
GO

-- ----------------------------------------------------------
-- Duplicate check
-- ----------------------------------------------------------

-- club_financials: one row per club per year
WITH cte AS (
	SELECT
		year,
		club_name,
		ROW_NUMBER() OVER (PARTITION BY Year, club_name ORDER BY Year) AS rn
	FROM Challenge_day02.club_financials
)
	SELECT 
		COUNT(*) AS duplicate_rows
	FROM cte
	WHERE rn > 1;
GO

-- transfers_history : one row per transfer_id
WITH cte AS (
	SELECT
		transfer_id,
		ROW_NUMBER() OVER (PARTITION BY transfer_id ORDER BY Transfer_id) AS rn
	FROM Challenge_day02.transfers_history
)
	SELECT 
		COUNT(*) AS duplicate_rows
	FROM cte
	WHERE rn > 1;
GO

-- 'record_tranfers': one row per transfer_id
WITH cte AS (
	SELECT
		transfer_id,
		ROW_NUMBER() OVER (PARTITION BY transfer_id ORDER BY transfer_id) AS rn
	FROM Challenge_day02.record_transfers
)
	SELECT COUNT(*) AS duplicate_rows
	FROM cte
	WherE rn > 1;
GO

-- 'pl_season_stats' : one row per team per season
WITH cte AS (
	SELECT
		Season,
		Team,
		ROW_NUMBER() OVER (PARTITION BY Season, Team ORDER BY Season) AS rn
	FROM Challenge_day02.pl_season_stats
)
	SELECT COUNT(*) AS duplicate_rows
	FROM cte
	WHERE rn > 1;
GO

-- ============================================================
-- PHASE 4: DATA CLEANING — TYPED CLEAN TABLES
-- ============================================================

-- ----------------------------------------------------------------
-- CLEAN TABLE 1: club_financials_clean
-- Casting all numeric VARCHAR columns to proper types.
-- net_transfer_spend_eur_m can be negative (net sellers) — FLOAT
-- handles both positive and negative values correctly.
-- ----------------------------------------------------------------

SELECT
	TRY_CAST(year							AS INT)		AS year,
	club_name,
	league,
	country,
	TRY_CAST(stadium_capacity				AS INT)		AS stadium_capacity,
	TRY_CAST(revenue_eur_m					AS FLOAT)	AS revenue_eur_m,
	TRY_CAST(wage_bill_eur_m				AS FLOAT)	AS wage_bill_eur_m,
	TRY_CAST(wages_to_revenue_pct			AS FLOAT)	AS wages_to_revenue_pct,
	TRY_CAST(net_transfer_spend_eur_m		AS FLOAT)	AS net_transfer_spend_eur_m,
	TRY_CAST(operating_profit_eur_m			AS FLOAT)	AS operating_profit_eur_m

INTO Challenge_day02.club_financials_clean

FROM Challenge_day02.club_financials

WHERE
	TRY_CAST(year							AS INT)			IS NOT NULL
	AND club_name IS NOT NULL AND club_name != ''
	AND TRY_CAST(stadium_capacity				AS INT)		IS NOT NULL
	AND TRY_CAST(revenue_eur_m					AS FLOAT)	IS NOT NULL
	AND TRY_CAST(wage_bill_eur_m				AS FLOAT)	IS NOT NULL
	AND TRY_CAST(net_transfer_spend_eur_m		AS FLOAT)	IS NOT NULL
	AND TRY_CAST(operating_profit_eur_m			AS FLOAT)	IS NOT NULL;
GO

-- ----------------------------------------------------------------
-- CLEAN TABLE 2: pl_season_stats_clean
-- Keeping only the columns we need for the Big Six analysis:
-- season, team, final league rank, points, goals, xG, possession.
-- ----------------------------------------------------------------

SELECT
	Season,
	Team,
	TRY_CAST(LgRank	AS INT)		AS LgRank,
	TRY_CAST(MP		AS INT)		AS MP,
	TRY_CAST(W		AS INT)		AS W,
	TRY_CAST(D		AS INT)		AS D,
	TRY_CAST(L		AS INT)		AS L,
	TRY_CAST(Pts	AS INT)		AS Pts,
	TRY_CAST(Pts_MP AS FLOAT)	AS Pts_MP,
	TRY_CAST(GF		AS INT)		AS GF,
	TRY_CAST(GA		AS INT)		AS GA,
	TRY_CAST(GD		AS INT)		AS GD,
	TRY_CAST(Poss	AS FLOAT)	AS Poss,
	TRY_CAST(xG		AS FLOAT)	AS xG,
	TRY_CAST(CS		AS INT)		AS CS

INTO Challenge_day02.pl_season_stats_clean

FROM Challenge_day02.pl_season_stats

WHERE
	TRY_CAST(LgRank	AS INT)		IS NOT NULL
	AND TRY_CAST(Pts	AS INT)	IS NOT NULL
	AND TRY_CAST(GF		AS INT)	IS NOT NULL
	AND TRY_CAST(GA		AS INT)	IS NOT NULL
	AND TRY_CAST(xG		AS FLOAT) IS NOT NULL
	AND Team IS NOT NULL AND Team != '';
GO

-- ----------------------------------------------------------------
-- CLEAN TABLE 3: transfers_history_clean
-- Filter to non-loan, paid transfers only for spend analysis.
-- ----------------------------------------------------------------

SELECT
	transfer_id,
	TRY_CAST(year				AS INT)			AS year,
	season,
	transfer_window,
	player_name,
	position,
	TRY_CAST(age				AS INT)			AS age,
	from_club,
	to_club,
	from_league,
	to_league,
	TRY_CAST(fee_eur_m			AS FLOAT)		AS fee_eur_m,
	TRY_CAST(is_free_transfer	AS INT)			AS is_free_transfer,
	TRY_CAST(is_loan			AS INT)			AS is_loan,
	TRY_CAST(is_intra_league	AS INT)			AS intra_league

INTO Challenge_day02.transfers_history_clean

FROM Challenge_day02.transfers_history

WHERE
	TRY_CAST(year			AS INT)		IS NOT NULL
	AND TRY_CAST(fee_eur_m	AS FLOAT)	IS NOT NULL
	AND to_club IS NOT NULL AND to_club != '';
GO

-- Preview all three clean tables

SELECT TOP 5 * FROM Challenge_day02.club_financials_clean;
GO

SELECT TOP 5 * FROM Challenge_day02.transfers_history_clean;
GO

SELECT TOP 5 * FROM Challenge_day02.pl_season_stats_clean;
GO

-- ----------------------------------------------------------------
-- NAME STANDARDISATION
-- The txt files use shortened names that will break the JOIN.
-- Standardise them in pl_season_stats_clean BEFORE joining.
--
-- Mismatches identified from the raw data:
--   'Manchester Utd'   → 'Manchester United'
--   'Newcastle Utd'    → 'Newcastle United'
--   "Nott'ham Forest"  → 'Nottingham Forest'
-- All other Big Six names already match club_financials exactly.
-- ----------------------------------------------------------------

UPDATE Challenge_day02.pl_season_stats_clean
SET TEAM = CASE
	WHEN Team = 'Manchester Utd'	THEN 'Manchester United'
	WHEN Team = 'Newcastle Utd'		THEN 'Newcastle United'
	WHEN Team = 'Nott''ham Forest'	THEN 'Nottingham Forest'
	ELSE Team
END
WHERE Team IN ('Manchester Utd', 'Newcastle Utd', 'Nott''ham Forest');
GO

-- Add the Big Six flag to club_financials_clean and pl_season_stats_clean

ALTER TABLE Challenge_day02.club_financials_clean
ADD is_big_six BIT;
GO

UPDATE Challenge_day02.club_financials_clean
SET is_big_six = CASE
	WHEN club_name IN (
		'Manchester City', 'Manchester United', 'Arsenal',
		'Chelsea', 'Liverpool', 'Tottenham')
	THEN 1
	ELSE 0
	END;
GO

ALTER TABLE Challenge_day02.pl_season_stats_clean
ADD is_big_six BIT;
GO

UPDATE Challenge_day02.pl_season_stats_clean
SET is_big_six = CASE
	WHEN Team IN (
		'Manchester City', 'Manchester United', 'Arsenal',
		'Chelsea', 'Liverpool', 'Tottenham')
	THEN 1
	ELSE 0 
END;
GO

-- Business Logic Validation: revenue must be positive

SELECT COUNT(*) AS Invalid_Revenue_Rows
FROM Challenge_day02.club_financials_clean
WHERE revenue_eur_m <= 0
GO

-- Business logic validation: wage bill cannot exceed revenue by more than 150%
-- (anything beyond that is a data anomaly)

SELECT COUNT(*) AS Extreme_Wage_Ratio_Rows
FROM Challenge_day02.club_financials_clean
WHERE wages_to_revenue_pct > 150;
GO

-- ============================================================
-- PHASE 5: FOUNDATIONAL ANALYSIS
-- ============================================================

-- Overall revenue gap: Big Six vs the rest of the PL (2020–2024)

SELECT
	is_big_six,
	COUNT(DISTINCT club_name)			AS club_count,
	ROUND(AVG(revenue_eur_m), 2)		AS avg_revenue,
	ROUND(MAX(revenue_eur_m), 2)		AS max_revenue,
	ROUND(MIN(revenue_eur_m), 2)		AS min_revenue,
	ROUND(AVG(wage_bill_eur_m), 2)		AS avg_wage_bill,
	ROUND(AVG(wages_to_revenue_pct), 2)	AS avg_wage_ratio_pct
FROM Challenge_day02.club_financials_clean
WHERE league = 'Premier_League'
	AND year BETWEEN 2020 AND 2024
GROUP BY is_big_six;
GO

-- Revenue trend per Big Six club (2010–2024)

SELECT
	club_name,
	year,
	revenue_eur_m,
	wage_bill_eur_m,
	net_transfer_spend_eur_m,
	operating_profit_eur_m
FROM Challenge_day02.club_financials_clean
WHERE is_big_six = 1
ORDER BY club_name , year;
GO

-- How many times did each Big Six club finish top 6 in the PL (2020–2024)?

SELECT
	Team,
	COUNT(*) AS seasons_in_top6
FROM Challenge_day02.pl_season_stats_clean
WHERE is_big_six = 1
	AND LgRank <= 6
GROUP BY Team
ORDER BY seasons_in_top6 DESC;
GO

-- Points average per Big Six club across 5 seasons

SELECT
	Team,
	ROUND(AVG(CAST(Pts	AS FLOAT)), 1)	AS avg_points,
	ROUND(AVG(CAST(GF	AS FLOAT)), 1)	AS avg_goals_scored,
	ROUND(AVG(CAST(GD	AS FLOAT)), 1)	AS avg_goal_diff,
	ROUND(AVG(Poss), 1)					AS avcg_possesion
FROM Challenge_day02.pl_season_stats_clean
WHERE is_big_six = 1
GROUP BY Team
ORDER BY avg_points DESC;
GO

-- ============================================================
-- PHASE 6: CORE BUSINESS ANALYSIS
-- ============================================================

-- Does revenue predict league position? (JOIN across both tables)
-- This is the key query of Day 02.

SELECT
	s.Season,
	s.Team,
	s.LgRank,
	s.Pts,
	S.GF,
	s.GD,
	s.Poss,
	f.revenue_eur_m,
	f.wage_bill_eur_m,
	f.wages_to_revenue_pct,
	f.net_transfer_spend_eur_m,
	s.is_big_six
FROM Challenge_day02.pl_season_stats_clean AS s
JOIN Challenge_day02.club_financials_clean AS f
	ON f.club_name = s.Team
	-- The season in pl_season_stats is '2020-2021'.
    -- The year in club_financials is '2021' (end-of-season year).
    -- So we extract the last 4 characters of Season to match.
	AND f.year	   = TRY_CAST(RIGHT(s.season, 4) AS INT)
WHERE s.Season IN ('2020-2021', '2021-2022', '2022-2023', '2023-2024', '2024-2025')
ORDER BY s.season, s.LgRank;
GO

-- Transfer arms race: total spend per Big Six club (2020–2024)

SELECT
	to_club									AS club,
	COUNT(*)								AS total_transfers_in,
	ROUND(SUM(fee_eur_m), 2)				AS total_spend_eur_m,
	ROUND(AVG(fee_eur_m), 2)				AS avg_fee_eur_m,
	SUM(CASE WHEN is_free_transfer = 1 THEN 1 END)	AS free_transfers,
	SUM(CASE WHEN is_loan = 1			THEN 1 END)	AS loans_in
FROM Challenge_day02.transfers_history_clean
WHERE to_club IN (
	'Manchester City', 'Manchester United',
	'Arsenal', 'Chelsea', 'Liverpool', 'Tottenham'
	)
	AND year BETWEEN 2020 AND 2024
GROUP BY to_club
ORDER BY total_spend_eur_m DESC;
GO

-- Which Big Six club earns the most from selling players?

SELECT
	from_club									AS club,
	COUNT(*)									AS total_players_sold,
	ROUND(SUM(fee_eur_m), 2)					AS total_income_eur_m,
	ROUND(AVG(fee_eur_m), 2)					AS avg_sale_eur_m
FROM Challenge_day02.transfers_history_clean
WHERE from_club IN (
	'Manchester_City', 'Manchester United',
	'Arsenal', 'Chelsea', 'Liverpool', 'Tottenham')
	AND is_free_transfer = 0
	AND is_loan = 0
	AND year BETWEEN 2020 AND 2024
GROUP BY from_club
ORDER BY total_income_eur_m DESC;
GO

-- Wage efficiency: which Big Six club gets the most points per £M wages?

SELECT
    f.club_name,
    ROUND(AVG(f.wage_bill_eur_m), 2)         AS avg_wage_bill,
    ROUND(AVG(CAST(s.Pts AS FLOAT)), 1)      AS avg_points,
    ROUND(
        AVG(CAST(s.Pts AS FLOAT)) /
        AVG(f.wage_bill_eur_m)
    , 4)                                     AS pts_per_eur_m_wages
FROM Challenge_day02.club_financials_clean   f
JOIN Challenge_day02.pl_season_stats_clean   s
    ON  s.Team   = f.club_name
    AND f.year   = TRY_CAST(RIGHT(s.Season, 4) AS INT)
WHERE f.is_big_six = 1
  AND f.year BETWEEN 2020 AND 2024
GROUP BY f.club_name
ORDER BY pts_per_eur_m_wages DESC;
GO

-- Does higher net transfer spend lead to better finishing position?

SELECT
    s.Season,
    s.Team,
    s.LgRank,
    f.net_transfer_spend_eur_m,
    CASE
        WHEN f.net_transfer_spend_eur_m > 50  THEN 'Heavy Buyer (>€50M net)'
        WHEN f.net_transfer_spend_eur_m > 0   THEN 'Net Buyer (€0–€50M)'
        WHEN f.net_transfer_spend_eur_m < 0   THEN 'Net Seller'
        ELSE 'Break Even'
    END AS transfer_stance
FROM Challenge_day02.pl_season_stats_clean   s
JOIN Challenge_day02.club_financials_clean   f
    ON  f.club_name = s.Team
    AND f.year      = TRY_CAST(RIGHT(s.Season, 4) AS INT)
WHERE f.is_big_six = 1
ORDER BY s.Season, s.LgRank;
GO

/*
    Q1 — Revenue vs league position JOIN
         This single query powers your main dashboard visual.
         Plot LgRank (y-axis) against revenue_eur_m (x-axis) as a
         scatter — you will see a clear negative correlation:
         higher revenue, lower (better) rank number.

    Q2 — Transfer spend per club
         Chelsea typically leads total spend. Man City leads
         in consistent spend over time. This is your "arms race" angle.

    Q3 — Player sales income
         Liverpool historically sells well (Coutinho, Salah almost,
         etc.). Arsenal and Chelsea reinvest. Expect strong contrast.

    Q4 — Wage efficiency (pts per €M wages)
         Liverpool and Arsenal will score high here — they get
         more points per euro spent on wages. Man United will
         score low — paying the most, getting the least. Strong story.

    Q5 — Transfer stance vs finishing
         Expect 'Heavy Buyer' rows to cluster in the top 4 but NOT
         always. Man City 2021-22 (93 pts) was relatively restrained.
         That breaks the narrative and makes it interesting.
*/


-- ============================================================
-- PHASE 7: ADVANCED ANALYSIS — WINDOW FUNCTIONS
-- ============================================================

-- Revenue rank among Premier League clubs each year

WITH PL_Revenue_Ranked AS (
    SELECT
        year,
        club_name,
        revenue_eur_m,
        RANK() OVER (PARTITION BY year ORDER BY revenue_eur_m DESC) AS revenue_rank
    FROM Challenge_day02.club_financials_clean
    WHERE league = 'Premier_League'
)
SELECT *
FROM PL_Revenue_Ranked
WHERE year BETWEEN 2020 AND 2024
ORDER BY year, revenue_rank;
GO

-- Revenue growth YoY for each Big Six club

SELECT
    club_name,
    year,
    revenue_eur_m,
    LAG(revenue_eur_m) OVER (PARTITION BY club_name ORDER BY year) AS prev_year_revenue,
    ROUND(
        revenue_eur_m -
        LAG(revenue_eur_m) OVER (PARTITION BY club_name ORDER BY year)
    , 2) AS revenue_change,
    ROUND(
        (revenue_eur_m -
         LAG(revenue_eur_m) OVER (PARTITION BY club_name ORDER BY year))
         / NULLIF(LAG(revenue_eur_m) OVER (PARTITION BY club_name ORDER BY year), 0)
         * 100
    , 2) AS revenue_growth_pct
FROM Challenge_day02.club_financials_clean
WHERE is_big_six = 1
ORDER BY club_name, year;
GO

-- Running total of transfer spend for each Big Six club (2010–2024)

SELECT
    year,
    to_club                                                AS club,
    ROUND(SUM(fee_eur_m), 2)                               AS annual_spend,
    ROUND(SUM(SUM(fee_eur_m)) OVER (
        PARTITION BY to_club ORDER BY year
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2)                                                  AS cumulative_spend
FROM Challenge_day02.transfers_history_clean
WHERE to_club IN (
        'Manchester City','Manchester United',
        'Arsenal','Chelsea','Liverpool','Tottenham'
      )
  AND is_free_transfer = 0
  AND is_loan = 0
GROUP BY year, to_club
ORDER BY to_club, year;
GO

-- How has each Big Six club's league rank moved season to season?

SELECT
    Team,
    Season,
    LgRank,
    LAG(LgRank) OVER (PARTITION BY Team ORDER BY Season) AS prev_season_rank,
    LgRank -
    LAG(LgRank) OVER (PARTITION BY Team ORDER BY Season) AS rank_change,
    CASE
        WHEN LgRank < LAG(LgRank) OVER (PARTITION BY Team ORDER BY Season)
            THEN 'Improved'
        WHEN LgRank > LAG(LgRank) OVER (PARTITION BY Team ORDER BY Season)
            THEN 'Declined'
        ELSE 'Same'
    END AS direction
FROM Challenge_day02.pl_season_stats_clean
WHERE is_big_six = 1
ORDER BY Team, Season;
GO

/*
    Q1 — Revenue rank per year
         You should see the Big Six occupy positions 1–6 every
         single year without exception. That is your headline proof.

    Q2 — YoY revenue growth
         Look for the COVID dip in 2020 (all clubs drop).
         Man City and Arsenal show the steepest recovery.
         Man United flatlines post-2019 — a red flag.

    Q3 — Cumulative transfer spend
         Chelsea's cumulative line will be the steepest.
         Arsenal's will be the most restrained of the six.
         This is a great line chart for Power BI.

    Q4 — Rank movement
         Tottenham and Man United will show the most volatility.
         Man City will show consistent improvement then plateau.
         Use this for a bump chart in Power BI.
*/


-- ============================================================
-- PHASE 8: BUSINESS INSIGHT QUERIES
-- ============================================================

-- The €1 billion revenue club: who has crossed it and when?

SELECT
    club_name,
    year,
    revenue_eur_m
FROM Challenge_day02.club_financials_clean
WHERE revenue_eur_m >= 1000
ORDER BY year, revenue_eur_m DESC;
GO

-- Record transfers involving Big Six clubs

SELECT
    player_name,
    position,
    from_club,
    to_club,
    fee_eur_m,
    year,
    season
FROM Challenge_day02.record_transfers
WHERE to_club IN (
        'Manchester City','Manchester United',
        'Arsenal','Chelsea','Liverpool','Tottenham'
      )
   OR from_club IN (
        'Manchester City','Manchester United',
        'Arsenal','Chelsea','Liverpool','Tottenham'
      )
ORDER BY fee_eur_m DESC;
GO

-- Which Big Six club has the best operating profit trend?
-- (A club that makes money despite high wages is financially sustainable)

SELECT
    club_name,
    year,
    revenue_eur_m,
    wage_bill_eur_m,
    operating_profit_eur_m,
    CASE
        WHEN operating_profit_eur_m > 50  THEN 'Strong Profit'
        WHEN operating_profit_eur_m > 0   THEN 'Modest Profit'
        WHEN operating_profit_eur_m < 0   THEN 'Operating Loss'
    END AS financial_health
FROM Challenge_day02.club_financials_clean
WHERE is_big_six = 1
  AND year BETWEEN 2018 AND 2024
ORDER BY club_name, year;
GO

-- Final verdict: the three metrics that define a Big Six club

SELECT
    f.club_name,
    ROUND(AVG(f.revenue_eur_m), 1)                          AS avg_revenue_eur_m,
    ROUND(AVG(f.wage_bill_eur_m), 1)                        AS avg_wage_bill_eur_m,
    ROUND(AVG(CAST(s.Pts AS FLOAT)), 1)                     AS avg_points,
    ROUND(AVG(CAST(s.LgRank AS FLOAT)), 1)                  AS avg_league_position,
    ROUND(
        SUM(CASE WHEN s.LgRank <= 4 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*)
    , 1)                                                    AS top4_finish_rate_pct,
    ROUND(AVG(f.wages_to_revenue_pct), 1)                   AS avg_wage_ratio_pct
FROM Challenge_day02.club_financials_clean   f
JOIN Challenge_day02.pl_season_stats_clean   s
    ON  s.Team = f.club_name
    AND f.year = TRY_CAST(RIGHT(s.Season, 4) AS INT)
WHERE f.is_big_six = 1
  AND f.year BETWEEN 2020 AND 2024
GROUP BY f.club_name
ORDER BY avg_revenue_eur_m DESC;
GO

/*
    Q1 — €1 billion revenue club
         Check which clubs (if any) cross €1B in this dataset.
         Real Madrid and Bayern typically lead globally.
         Among the Big Six, Man City and Man United are closest.
         Great context for your LinkedIn post.

    Q2 — Record transfers
         Chelsea dominates the expensive buys (Enzo Fernandez €121M,
         Caicedo €133M). Liverpool's Wirtz at €130M (2025) is notable.
         Man City's Haaland at €60M is the most efficient buy of the era.

    Q3 — Operating profit / financial health
         Arsenal has been quietly profitable while competing at the top.
         Chelsea and Man United have posted repeated losses.
         This is the financial discipline story.

    Q4 — Final verdict query
         This is the table you post on LinkedIn.
         Three things define a Big Six club:
           1. Revenue consistently above €400M
           2. Average points above 65 per season
           3. Top-4 finish rate above 50%
         Any club that meets all three belongs. Any that misses one
         is on the edge — Tottenham and Man United are your edge cases.
*/


-- ============================================================
-- PHASE 9: REPORTING QUERIES (Power BI Ready)
-- ============================================================

-- Visual 1: Revenue vs League Position scatter (main chart)

SELECT
    s.Season,
    s.Team,
    s.LgRank,
    s.Pts,
    f.revenue_eur_m,
    f.wage_bill_eur_m,
    f.net_transfer_spend_eur_m,
    s.is_big_six
FROM Challenge_day02.pl_season_stats_clean   s
JOIN Challenge_day02.club_financials_clean   f
    ON  f.club_name = s.Team
    AND f.year      = TRY_CAST(RIGHT(s.Season, 4) AS INT)
ORDER BY s.Season, s.LgRank;
GO

-- Visual 2: Big Six revenue over time (line chart)

SELECT
    year,
    club_name,
    revenue_eur_m,
    wage_bill_eur_m,
    operating_profit_eur_m
FROM Challenge_day02.club_financials_clean
WHERE is_big_six = 1
ORDER BY club_name, year;
GO

-- Visual 3: Cumulative transfer spend by club (area/line chart)

SELECT
    t.year,
    t.to_club                                              AS club,
    ROUND(SUM(t.fee_eur_m), 2)                             AS annual_spend_eur_m,
    ROUND(SUM(SUM(t.fee_eur_m)) OVER (
        PARTITION BY t.to_club ORDER BY t.year
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2)                                                  AS cumulative_spend_eur_m
FROM Challenge_day02.transfers_history_clean t
WHERE t.to_club IN (
        'Manchester City','Manchester United',
        'Arsenal','Chelsea','Liverpool','Tottenham'
      )
  AND t.is_free_transfer = 0
  AND t.is_loan          = 0
GROUP BY t.year, t.to_club
ORDER BY t.to_club, t.year;
GO

-- Visual 4: Wage efficiency table (bar chart)

SELECT
    f.club_name,
    ROUND(AVG(f.wage_bill_eur_m), 2)                     AS avg_wage_bill,
    ROUND(AVG(CAST(s.Pts AS FLOAT)), 1)                  AS avg_points,
    ROUND(
        AVG(CAST(s.Pts AS FLOAT)) /
        AVG(f.wage_bill_eur_m)
    , 4)                                                 AS pts_per_eur_m_wages,
    ROUND(AVG(f.wages_to_revenue_pct), 1)                AS avg_wage_ratio_pct
FROM Challenge_day02.club_financials_clean   f
JOIN Challenge_day02.pl_season_stats_clean   s
    ON  s.Team = f.club_name
    AND f.year = TRY_CAST(RIGHT(s.Season, 4) AS INT)
WHERE f.is_big_six = 1
  AND f.year BETWEEN 2020 AND 2024
GROUP BY f.club_name
ORDER BY pts_per_eur_m_wages DESC;
GO

-- Visual 5: Financial health status per club per year (conditional table)

SELECT
    club_name,
    year,
    revenue_eur_m,
    operating_profit_eur_m,
    wages_to_revenue_pct,
    CASE
        WHEN operating_profit_eur_m > 50 AND wages_to_revenue_pct < 60
            THEN 'Financially Healthy'
        WHEN operating_profit_eur_m > 0
            THEN 'Stable'
        ELSE
            'Under Pressure'
    END AS financial_status
FROM Challenge_day02.club_financials_clean
WHERE is_big_six = 1
  AND year BETWEEN 2018 AND 2024
ORDER BY club_name, year;
GO

-- Visual 6: KPI summary cards

SELECT
    ROUND(MAX(revenue_eur_m), 0)        AS peak_revenue_big6,
    ROUND(AVG(revenue_eur_m), 0)        AS avg_revenue_big6,
    ROUND(AVG(wage_bill_eur_m), 0)      AS avg_wages_big6,
    ROUND(AVG(wages_to_revenue_pct), 1) AS avg_wage_ratio_pct
FROM Challenge_day02.club_financials_clean
WHERE is_big_six = 1
  AND year BETWEEN 2020 AND 2024;
GO

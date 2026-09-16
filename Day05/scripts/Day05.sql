-- ====================================================
-- 30-DAY DATA ANALYTICS CHALLENGE
-- DAY 05: Do Fashion Shows Actually Make Designers Money?
-- Tool Stack : SQL Server + Power BI
-- Datasets   : Fashion_company_data_set.csv
--              fashion_boutique_dataset.csv  (or .db)
--              fashion_show_benchmarks       (manually seeded — industry benchmarks)
-- Author     : Toluwalase
-- ====================================================
 
 
-- ====================================================
-- PHASE 1 : DATABASE + SCHEMA + TABLE SETUP
-- ====================================================
 
USE [30_Days_Analytics_ChallengeDB];
GO

 -- Drop Clean Tables first, then raw tables, then schema

IF OBJECT_ID('Challenge_day05.fashion_master',			'U') IS NOT NULL DROP TABLE Challenge_day05.fashion_master;
IF OBJECT_ID('Challenge_day05.boutique_clean',			'U') IS NOT NULL DROP TABLE Challenge_day05.boutique_clean;
IF OBJECT_ID('Challenge_day05.companies_clean',			'U') IS NOT NULL DROP TABLE Challenge_day05.companies_clean;
IF OBJECT_ID('Challenge_day05.fashion_show_benchmarks',	'U') IS NOT NULL DROP TABLE Challenge_day05.fashion_show_benchmarks;
IF OBJECT_ID('Challenge_day05.boutique_raw',			'U') IS NOT NULL DROP TABLE Challenge_day05.boutique_raw;
IF OBJECT_ID('CHallenge_day05.companies_raw',			'U') IS NOT NULL DROP TABLE Challenge_day05.companies_raw;
GO

IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Challenge_day05')
	DROP SCHEMA Challenge_day05;
GO

CREATE SCHEMA Challenge_day05;
GO

-- --------------------------------------------------------------
-- TABLE 1  : companies_raw
-- Source   : Fashion_company_data_set.csv
-- Purpose  : Longitudinal corporate revenue data for 13 major
--            fashion brands from 2012 to 2023.
--            Used to track how revenue scales across brands
--            that do and do not invest in runway shows.
-- Rows     : 156 (13 brands x 12 years)
-- --------------------------------------------------------------
 
 CREATE TABLE Challenge_day05.companies_raw (
	company_id								VARCHAR(100),
	company_name							VARCHAR(100),
	total_revenue							VARCHAR(100),
	fashion_style							VARCHAR(100),
	company_regions							NVARCHAR(400),
	company_operated_retail_stores			VARCHAR(100),
	founding_year							VARCHAR(100),
	country_of_origin						NVARCHAR(100),
	revenue_year							VARCHAR(100),
	annual_revenue							VARCHAR(100)
 );
 GO

 -- << CHANGE THIS PATH >>

 BULK INSERT Challenge_day05.companies_raw
 FROM 'C:\Users\Admin\Downloads\Day05Data\Fashion_company_data_set - Fashion_company_data_set.csv.tsv'
 WITH (
	FIELDTERMINATOR = '\t',
	ROWTERMINATOR	= '\n',
	FIRSTROW		= 2,
	TABLOCK,
    CODEPAGE = '65001'
);
GO

-- --------------------------------------------------------------
-- TABLE 2  : boutique_raw
-- Source   : fashion_boutique_dataset.csv
-- Purpose  : Retail-level transaction data — seasonal purchasing
--            behaviour, markdown strategies, inventory movement,
--            customer ratings and return reasons.
--            Used to measure retail health across brands and map
--            markdown depth against post-show release windows.
-- Rows     : 2,176
-- --------------------------------------------------------------

CREATE TABLE Challenge_day05.boutique_raw (
	product_id					VARCHAR(15),
	category					VARCHAR(30),
	brand						VARCHAR(40),
	season						VARCHAR(10),
	size						VARCHAR(5),
	color						VARCHAR(20),
	original_price				VARCHAR(15),
	markdown_percentage			VARCHAR(10),
	current_price				VARCHAR(10),
	purchase_date				VARCHAR(15),
	stock_quantity				VARCHAR(10),
	customer_rating				VARCHAR(10),
	is_returned					VARCHAR(5),
	return_reason				VARCHAR(40)
);
GO

-- << CHANGE THIS PATH >>

BULK INSERT Challenge_day05.boutique_raw
FROM 'C:\Users\Admin\Downloads\Day05Data\fashion_boutique_dataset.csv'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR	= '0x0a',
	FIRSTROW		= 2,
	TABLOCK
);
GO

-- --------------------------------------------------------------
-- TABLE 3 : fashion_show_benchmarks
-- Source   : Manually seeded — Industry benchmark data
-- Purpose  : Bridge table that seeds known runway economics:
--            estimated show cost, Media Impact Value (MIV from
--            Launchmetrics), wholesale multiplier, and
--            post-show sales window per brand.
--            This is the key table that lets us connect corporate
--            revenue and retail data to fashion show investment.
-- Rows     : 13
-- Reference: Launchmetrics MIV framework, Vogue Business 2022,
--            Business of Fashion industry benchmarks
-- --------------------------------------------------------------

CREATE TABLE Challenge_day05.fashion_show_benchmarks (
	benchmark_id						INT			PRIMARY KEY,
	brand_name							VARCHAR(60),
	brand_tier							VARCHAR(20),	-- 'Luxury'	|  'Premium'	|	'Fast Fashion'	|	'Athleisure'
	show_type							VARCHAR(20),	-- 'Runway' |  'Digital'	|	'No Show'
	est_show_cost_usd					BIGINT,			--  estimated cost to produce one show (USD)
	miv_usd								BIGINT,			--	Media Impact Value per show (Launchmetrics)
	wholesale_multiplier				DECIMAL(3,1),	--	typical 2.5x to 4.0x of production cost
	post_show_sales_window_months		INT,			--	months between show and retail availability
	source_note							VARCHAR(200)
);
GO

INSERT INTO Challenge_day05.fashion_show_benchmarks VALUES
	(1,  'Prada',              'Luxury',        'Runway',   3500000,  15000000, 4.0, 5, 'Launchmetrics MIV; Vogue Business 2022'),
	(2,  'Yves Saint Laurent', 'Luxury',        'Runway',   4000000,  14000000, 4.0, 5, 'Launchmetrics MIV; Business of Fashion 2022'),
	(3,  'Bottega Veneta',     'Luxury',        'Runway',   2800000,  12000000, 3.5, 6, 'Launchmetrics MIV estimate'),
	(4,  'Ralph Lauren',       'Premium',       'Runway',   1500000,   6000000, 3.0, 4, 'Industry avg for premium tier'),
	(5,  'Tommy Hilfiger',     'Premium',       'Runway',   1200000,   5000000, 3.0, 4, 'Industry avg for premium tier'),
	(6,  'Levi''s',            'Premium',       'No Show',        0,    500000, 2.5, 0, 'No runway; marketing-driven model'),
	(7,  'Lululemon',          'Athleisure',    'No Show',        0,    800000, 2.5, 0, 'Community and athlete marketing model'),
	(8,  'Gap',                'Fast Fashion',  'No Show',        0,    300000, 2.5, 0, 'Promotional marketing only'),
	(9,  'H&M',                'Fast Fashion',  'Digital',   200000,   2000000, 2.5, 3, 'Occasional collab shows; Launchmetrics'),
	(10, 'Zara',               'Fast Fashion',  'No Show',        0,   1000000, 2.5, 0, 'Trend-response model; no runway'),
	(11, 'Uniqlo',             'Fast Fashion',  'No Show',        0,    600000, 2.5, 0, 'Functional marketing; no runway'),
	(12, 'Nike',               'Athleisure',    'No Show',        0,  10000000, 2.5, 0, 'Athlete sponsorship model'),
	(13, 'Adidas',             'Athleisure',    'No Show',        0,   8000000, 2.5, 0, 'Collab drops model; no runway');
GO

-- Confirm raw counts

SELECT 'companies_raw'				AS tbl, COUNT(*) AS rows FROM Challenge_day05.companies_raw		UNION ALL
SELECT 'boutique_raw'				AS tbl, COUNT(*) AS rows FROM Challenge_day05.boutique_raw		UNION ALL
SELECT 'fashion_show_benchmarks'	AS tbl, COUNT(*) AS rows FROM Challenge_day05.fashion_show_benchmarks;
GO

-- ====================================================
-- PHASE 2 : DATA UNDERSTANDING
-- ====================================================
 
/*
============================================
DATA DICTIONARY
============================================
 
TABLE 1 — companies_raw
    company_id                     : Numeric ID per brand (1–13)
    company_name                   : Brand name (Uniqlo, Zara, Prada, etc.)
    total_revenue                  : Brand's all-time / peak reported revenue (USD)
    fashion_style                  : Style classification (CASUAL WEAR, FAST FASHION,
                                     MINIMALISM, ATHLEISURE, PREPPY, CHIC)
    company_regions                : Comma-separated list of operating regions
    company_operated_retail_stores : Number of brand-owned retail stores
    founding_year                  : Year the brand was founded
    country_of_origin              : HQ or founding country
    revenue_year                   : Label of the fiscal year (e.g. 'company_revenue_2022')
    annual_revenue                 : Actual revenue for that fiscal year (USD)
 
TABLE 2 — boutique_raw
    product_id          : Unique SKU identifier (FB000001 … FB002176)
    category            : Product type (Outerwear, Tops, Bottoms, Dresses,
                          Shoes, Accessories)
    brand               : Retail brand (Zara, Uniqlo, H&M, Gap, Mango,
                          Ann Taylor, Banana Republic, Forever21)
    season              : Season of sale (Spring, Summer, Fall, Winter)
    size                : Size label (XS, S, M, L, XL, XXL) — 491 nulls
    color               : Color name (Red, Blue, Black, White, etc.)
    original_price      : Full retail price before any markdown (USD)
    markdown_percentage : Discount applied as a percentage (0–59.9%)
    current_price       : Actual selling price after markdown (USD)
    purchase_date       : Date of transaction (2025 data)
    stock_quantity      : Units remaining in stock at time of record
    customer_rating     : Rating out of 5.0 — 362 nulls (unrated items)
    is_returned         : 1 = returned, 0 = kept (320 returned of 2,176)
    return_reason       : Reason for return when is_returned = 1 —
                          Color Mismatch | Size Issue | Damaged |
                          Quality Issue | Changed Mind | Wrong Item
 
TABLE 3 — fashion_show_benchmarks  (seeded — not from CSV)
    benchmark_id                  : Primary key (1–13)
    brand_name                    : Matches company_name and boutique brand
    brand_tier                    : Luxury | Premium | Fast Fashion | Athleisure
    show_type                     : Runway | Digital | No Show
    est_show_cost_usd             : Estimated production cost per show (USD)
    miv_usd                       : Media Impact Value per show (Launchmetrics USD)
    wholesale_multiplier          : Expected wholesale order uplift (2.5x – 4.0x)
    post_show_sales_window_months : Months from show to retail availability (0 = no show)
    source_note                   : Benchmark source reference
*/

-- ====================================================
-- PHASE 3 : DATA QUALITY CHECKS
-- ====================================================
 
-- -------------------------------------------------------
-- NULL / BLANK CHECK
-- -------------------------------------------------------
 
-- TABLE : companies_raw

DECLARE @sql		NVARCHAR(MAX) = '';
DECLARE @table		NVARCHAR(100) = 'Challenge_day05.companies_raw';

SELECT @sql = @sql +
	'SUM(CASE WHEN [' + COLUMN_NAME +  '] IS NULL OR TRY_CAST([' + COLUMN_NAME + '] AS VARCHAR) = '''' THEN 1 ELSE 0 END) AS [' + COLUMN_NAME + '_nulls],' + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA	= 'Challenge_day05'
  AND TABLE_NAME	= 'companies_raw'
ORDER BY ORDINAL_POSITION;

SET @SQL = 'SELECT COUNT(*) AS total_rows,' + CHAR(10) + LEFT(@sql, LEN(@sql) - 2)
		 + CHAR(10) + 'FROM ' + @table + ';';

PRINT @sql;
EXEC sp_executesql @sql;
GO

-- TABLE : boutique_raw

DECLARE @sql		NVARCHAR(MAX) = '';
DECLARE @table		NVARCHAR(100) =	'Challenge_day05.boutique_raw';

SELECT @sql = @sql +
	   'SUM(CASE WHEN [' + COLUMN_NAME + '] IS NULL OR TRY_CAST([' + COLUMN_NAME + '] AS VARCHAR) = '''' THEN 1 ELSE 0 END) AS [' + COLUMN_NAME + '_nulls],' + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA	= 'Challenge_day05'
  AND TABLE_NAME	= 'boutique_raw'
ORDER BY ORDINAL_POSITION;

SET @sql = 'SELECT COUNT(*) AS total_rows,' + CHAR(10) + LEFT(@sql, LEN(@sql) - 2)
		 + CHAR(10) + 'FROM ' + @table + ';';

PRINT @sql
EXEC sp_executesql @sql;
GO

-- -------------------------------------------------------
-- DUPLICATE CHECK
-- -------------------------------------------------------

-- companies_raw: one row per brand per year

WITH CTE AS (
	SELECT
		company_name,
		revenue_year,
		ROW_NUMBER() OVER ( PARTITION BY company_name, revenue_year ORDER BY company_name ) AS rn
	FROM Challenge_day05.companies_raw
)
	SELECT
		COUNT(*) AS duplicate_rows_tbl1
	FROM CTE
	WHERE rn > 1;
GO

-- boutique_raw: one raw per product_id

WITH CTE AS (
	SELECT
		product_id,
		ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY product_id) AS rn
	FROM Challenge_day05.boutique_raw
)
	SELECT
		COUNT(*) AS duplicate_rows_tbl2
	FROM CTE
	WHERE rn > 1;
	GO

-- -------------------------------------------------------
-- RANGE CHECKS
-- -------------------------------------------------------
 
-- Annual revenue must be positive

SELECT COUNT(*) AS invalid_revenue
FROM Challenge_day05.companies_raw
WHERE TRY_CAST(annual_revenue AS BIGINT) <= 0;
GO

-- Retail store count must be positive

SELECT COUNT(*) AS invalid_store_count
FROM Challenge_day05.companies_raw
WHERE TRY_CAST(company_operated_retail_stores AS FLOAT) <= 0;
GO

-- Markdown Percentage must be between 0 and 100

SELECT COUNT(*) AS out_of_range_rating
FROM Challenge_day05.boutique_raw
WHERE TRY_CAST(markdown_percentage AS FLOAT) NOT BETWEEN 0 AND 100;
GO

-- Customer rating must be between 0 and 5

SELECT COUNT(*) AS out_of_range_rating
FROM Challenge_day05.boutique_raw
WHERE TRY_CAST(customer_rating AS FLOAT) NOT BETWeEN 0 AND 5
  AND customer_rating IS NOT NULL 
  AND customer_rating !=  '';
GO

-- Original price must be positive

SELECT COUNT(*) AS [invalid price]
FROM Challenge_day05.boutique_raw
WHERE TRY_CAST(original_price AS FLOAT) <= 0;
GO

-- is_returned must be 0 or 1

SELECT COUNT(*) AS invalid_return_flag
FROM Challenge_day05.boutique_raw
WHERE TRY_CAST(is_returned AS INT) NOT IN (0, 1);
GO

-- -------------------------------------------------------
-- CONSISTENCY CHECK
-- -------------------------------------------------------
 
-- Confirm current_price is always <= original_price

SELECT COUNT(*) AS current_exceeds_original
FROM Challenge_day05.boutique_raw
WHERE TRY_CAST(current_price AS FLOAT) > TRY_CAST(original_price AS FLOAT);
GO

-- Confirm return_reason is only populated when is_returned = 1

SELECT COUNT(*) AS return_reason_on_non_return
FROM Challenge_day05.boutique_raw
WHERE return_reason IS NOT NULL
  AND return_reason != ''
  AND TRY_CAST(is_returned AS INT) = 0;
GO

-- Brand overlap check: which boutique brands match company dataset?

SELECT DIsTINCT	
	br.brand					AS boutique_brand,
	cr.company_name				AS company_match,
	CASE WHEN cr.company_name IS NULL
		 THEN 'No match in companies_raw'
		 ELSE 'Matched'
	END							AS match_status
FROM Challenge_day05.boutique_raw AS br
LEFT JOIN Challenge_day05.companies_raw AS cr
	ON LOWER(LTRIM(RTRIM(br.brand))) = LOWER(LTRIM(RTRIM(cr.company_name)));
GO
 
-- ====================================================
-- PHASE 4 : DATA CLEANING — TYPED CLEAN TABLES
-- ====================================================
 
-- -------------------------------------------------------
-- CLEAN TABLE 1 : companies_clean
--
-- CORRECTIONS APPLIED:
--
-- 1. fashion_style  — Strip trailing period so 'CASUAL WEAR.'
--                     becomes 'CASUAL WEAR'. Done via REPLACE + RTRIM.
--
-- 2. years          — Extract 4-digit fiscal year as INT from the
--                     label string 'company_revenue_YYYY' using RIGHT().
--                     Original label kept as revenue_year for reference.
--
-- 3. company_regions — Embedded-comma blob expanded into:
--                      - region_count      (INT)  : comma count + 1
--                      - has_north_america (BIT)
--                      - has_europe        (BIT)
--                      - has_asia          (BIT)  : Asia | China | Japan | south-east Asia
--                      - has_latin_america (BIT)  : Latin America | South America
--                      - has_africa        (BIT)
--                      - has_oceania       (BIT)  : Oceania | Australia | Asia-pacific
--                      Original string kept as company_regions for reference.
--
-- 4. country_of_origin — Mixed 'city,country' string split into:
--                        - hq_city    (VARCHAR 40)
--                        - hq_country (VARCHAR 40)
--                        Trailing periods and extra spaces stripped from both.
--
-- 5. company_operated_retail_stores — Float averages (e.g. 62.41666667)
--                                     rounded to nearest INT.
--
-- 6. total_revenue  — Renamed to peak_reported_revenue to prevent
--                     confusion with the per-year revenue column.
--                     This value is the same across all 12 rows per brand.
--
-- 7. revenue        — Renamed to annual_revenue — this is the real
--                     analysis column (changes per fiscal year).
-- -------------------------------------------------------
 
SELECT 
    TRY_CAST(company_id					AS INT)													AS [Company ID],
	LTRIM(RTRIM(company_name))																	AS [Company Name],
	TRY_CAST(total_revenue				AS BIGINT)												AS [Peak Reported Revenue],
	LTRIM(RTRIM(REPLACE(fashion_style, '.', '')))												AS [Fashion Style],
	LTRIM(RTRIM(REPLACE(company_regions, '.', '')))												AS [Company Regions],
	LEN(LTRIM(RTRIM(company_regions)))
		- LEN(REPLACE(LTRIM(RTRIM(company_regions)), ',', ''))
		+ 1																						AS [Region Count],
	CAST(CASE WHEN company_regions LIKE '%North America%'		THEN 1 ELSE 0 END AS BIT)		AS [has north america],
	CAST(CASE WHEN company_regions LIKE '%Europe%'				THEN 1 ELSE 0 END AS BIT)		AS [has europe],
	CAST(CASE WHEN company_regions LIKE '%Asia%'
				OR company_regions LIKE '%China%'
				OR company_regions LIKE '%Japan%'
				OR company_regions LIKE '%south-east Asia%'		THEN 1 ELSE 0 END AS BIT)		AS [has asia],
	CAST(CASE WHEN company_regions LIKE '%Latin America%'
				OR company_regions LIKE '%South America%'
				OR company_regions LIKE '%South america%'		THEN 1 ELSE 0 END AS BIT)		AS [has latin america],
	CAST(CASE WHEN company_regions LIKE '%Africa%'				THEN 1 ELSE 0 END AS BIT)		AS [has africa],
	CAST(CASE WHEN company_regions LIKE '%Oceania%'
				OR company_regions LIKE '%Australia%'
				OR company_regions LIKE '%Asia-pacific%'		THEN 1 ELSE 0 END AS BIT)		AS [has oceania],
	CAST(ROUND(TRY_CAST(company_operated_retail_stores AS FLOAT), 0) AS INT)					AS [retail store count],
	TRY_CAST(founding_year AS INT)																AS [founding year],
	LTRIM(RTRIM(country_of_origin))																AS [country of origin],
	LTRIM(RTRIM(REPLACE(
		LEFT(REPLACE(country_of_origin, ' in ', ','),
			CHARINDEX(',', REPLACE(country_of_origin, ' in ', ',') + ',') - 1),
	'.', '')))																					AS [hq city],
	LTRIM(RTRIM(REPLACE(
		SUBSTRING(REPLACE(country_of_origin, ' in ', ','),
			CHARINDEX(',', REPLACE(country_of_origin, ' in ', ',')) + 1,
			LEN(REPLACE(country_of_origin, ' in ', ','))),
	'.', '')))																					AS [hq country],
	LTRIM(RTRIM(revenue_year))																	AS [revenue year],
	TRY_CAST(RIGHT(LTRIM(RTRIM(revenue_year)), 4) AS INT)										AS [fiscal year],
	TRY_CAST(REPLACE(LTRIM(RTRIM(annual_revenue)), CHAR(13), '')  AS BIGINT)					AS [annual revenue]

INTO Challenge_day05.companies_clean

FROM Challenge_day05.companies_raw

WHERE
    company_name  IS NOT NULL AND company_name  != ''
    AND TRY_CAST(REPLACE(LTRIM(RTRIM(annual_revenue)), CHAR(13), '')  AS BIGINT)	IS NOT NULL
    AND TRY_CAST(total_revenue      AS BIGINT)										IS NOT NULL
    AND TRY_CAST(founding_year      AS INT)											IS NOT NULL
    AND TRY_CAST(RIGHT(LTRIM(RTRIM(revenue_year)), 4) AS INT)						IS NOT NULL
    AND TRY_CAST(company_operated_retail_stores AS FLOAT)							IS NOT NULL;

GO

-- -------------------------------------------------------
-- CLEAN TABLE 2 : boutique_clean
--
-- CORRECTIONS APPLIED:
-- 1. size and customer_rating — genuine NULLs preserved via NULLIF
--    (491 null sizes, 362 null ratings — do not impute)
-- 2. return_reason — NULL for all non-returned items; preserved.
-- 3. is_returned — cast from '0'/'1' string to BIT
-- 4. purchase_date — cast from string to DATE
-- 5. Two derived columns added:
--    markdown_savings = original_price - current_price
--    inventory_value  = original_price * stock_quantity
-- -------------------------------------------------------

SELECT
	LTRIM(RTRIM(product_id))												AS [product ID],
	LTRIM(RTRIM(category))													AS [category],
	LTRIM(RTRIM(brand))														AS [brand],
	LTRIM(RTRIM(season))													AS [season],
	NULLIF(NULLIF(REPLACE(LTRIM(RTRIM(size)), CHAR(13), ''), ''), 'NULL')	AS [size],
	LTRIM(RTRIM(color))														AS [color],
	TRY_CAST(original_price			AS DECIMAL(10,2))						AS [original price],
	TRY_CAST(markdown_percentage	AS DECIMAL(5,2))						AS [markdown percentage],
	TRY_CAST(current_price			AS DECIMAL(10,2))						AS [current price],
	TRY_CAST(purchase_date			AS DATE)								AS [purchase date],
	TRY_CAST(stock_quantity			AS INT)									AS [stock quantity],
	TRY_CAST(NULLIF(LTRIM(RTRIM(customer_rating)), 'NULL') AS DECIMAL(3,1)) AS [customer rating],
	TRY_CAST(is_returned			AS BIT)									AS [is returned],
	NULLIF(REPLACE(LTRIM(RTRIM(return_reason)), CHAR(13), ''), ' ')			AS [return reason],
	ROUND(
		TRY_CAST(original_price AS DECIMAL(10,2)) -
		TRY_CAST(current_price	AS DECIMAL(10,2)),
	2)																		AS [markdown savings],
	ROUND(
		TRY_CAST(original_price AS DECIMAL(10,2)) *
		TRY_CAST(stock_quantity	AS INT),
	2)																		AS [inventory value]

INTO Challenge_day05.boutique_clean

FROM Challenge_day05.boutique_raw

WHERE 
	product_id		IS NOT NULL AND product_id	!= ''
	AND brand		IS NOT NULL AND brand		!= ''
	AND category	IS NOT NULL AND category	!= ''
	AND season		IS NOT NULL AND season		!= ''
	AND TRY_CAST(original_price			AS DECIMAL(10,2))	IS NOT NULL
	AND TRY_CAST(markdown_percentage	AS DECIMAL(5,2))	IS NOT NULL
	AND TRY_CAST(current_price			AS DECIMAL(10,2))	IS NOT NULL
	AND TRY_CAST(purchase_date			AS DATE)			IS NOT NULL
	AND TRY_CAST(stock_quantity			AS INT)				IS NOT NULL
	AND TRY_CAST(is_returned			AS BIT)				IS NOT NULL;
GO

UPDATE Challenge_day05.companies_clean
SET [retail store count] = 86
WHERE [Company Name] = 'Nike'
  AND [fiscal year]  = 2012;
GO

UPDATE Challenge_day05.companies_clean
SET [hq city]	= 'New York City'
WHERE [hq city] = 'New York';
GO

-- Preview both clean tables
SELECT TOP 5 * FROM Challenge_day05.companies_clean;
GO
SELECT TOP 5 * FROM Challenge_day05.boutique_clean;
GO

-- ====================================================
-- PHASE 5 : MERGE — BUILD THE MASTER TABLE
-- ====================================================

SELECT
    c.[Company ID],
    c.[Company Name],
    c.[Fashion Style],
    c.[hq city],           
    c.[hq country],
    c.[founding year],
    c.[Company Regions],
    c.[Region Count],
    c.[has north america],
    c.[has europe],
    c.[has asia],
    c.[has latin america],
    c.[has africa],
    c.[has oceania],
    c.[retail store count],
    c.[revenue year],
    c.[fiscal year],
    c.[annual revenue],
    c.[Peak Reported Revenue],

    b.brand_tier,
    b.show_type,
    b.est_show_cost_usd,
    b.miv_usd,
    b.wholesale_multiplier,
    b.post_show_sales_window_months,

    CASE
        WHEN c.[retail store count] > 0
        THEN CAST(ROUND(c.[annual revenue] * 1.0 / c.[retail store count], 0) AS BIGINT)
        ELSE NULL
    END                                                         AS revenue_per_store,

    CASE
        WHEN b.est_show_cost_usd > 0
        THEN ROUND(b.miv_usd * 1.0 / b.est_show_cost_usd, 2)
        ELSE NULL
    END                                                         AS miv_roi_ratio,

    CASE
        WHEN b.est_show_cost_usd > 0
        THEN CAST(ROUND(b.est_show_cost_usd * b.wholesale_multiplier, 0) AS BIGINT)
        ELSE NULL
    END                                                         AS est_wholesale_pipeline_usd,

    CAST(
        (c.[annual revenue] -
            LAG(c.[annual revenue]) OVER (
                PARTITION BY c.[Company Name] ORDER BY c.[fiscal year])
        ) * 100.0 /
        NULLIF(
            LAG(c.[annual revenue]) OVER (
                PARTITION BY c.[Company Name] ORDER BY c.[fiscal year])
        , 0)
    AS DECIMAL(5,2))                                                        AS yoy_growth_pct

INTO Challenge_day05.fashion_master

FROM Challenge_day05.companies_clean        AS c
LEFT JOIN Challenge_day05.fashion_show_benchmarks AS b
    ON LOWER(LTRIM(RTRIM(c.[Company Name]))) = LOWER(LTRIM(RTRIM(b.brand_name)));
GO

SELECT COUNT(*) AS master_rows FROM Challenge_day05.fashion_master;
GO
SELECT TOP 10 * FROM Challenge_day05.fashion_master ORDER BY [company name], [fiscal year];
GO
 
SELECT
    COUNT(*)                                                                AS total_rows,
    SUM(CASE WHEN brand_tier                 IS NOT NULL THEN 1 ELSE 0 END) AS has_benchmark,
    SUM(CASE WHEN miv_roi_ratio              IS NOT NULL THEN 1 ELSE 0 END) AS has_miv_roi,
    SUM(CASE WHEN est_wholesale_pipeline_usd IS NOT NULL THEN 1 ELSE 0 END) AS has_wholesale_est,
    SUM(CASE WHEN yoy_growth_pct             IS NOT NULL THEN 1 ELSE 0 END) AS has_yoy_growth,
    SUM(CASE WHEN revenue_per_store          IS NOT NULL THEN 1 ELSE 0 END) AS has_rev_per_store
FROM Challenge_day05.fashion_master;
GO

-- ====================================================
-- PHASE 6 : FOUNDATIONAL ANALYSIS
-- ====================================================
 
SELECT
	MIN([annual revenue])									AS min_revenue,
	MAX([annual revenue])									AS max_revenue,
	ROUND(AVG(CAST([annual revenue] AS FLOAT)), 0)			AS avg_revenue,
	MIN([retail store count])								AS min_stores,
	MAX([retail store count])								AS max_stores,
	ROUND(AVG(CAST([retail store count] AS FLOAT)), 0)		AS avg_stores
FROM Challenge_day05.fashion_master;
GO

SELECT TOP 10
	[Company Name], brand_tier, show_type, [fiscal year],
	[annual revenue], [retail store count], revenue_per_store, yoy_growth_pct
FROM Challenge_day05.fashion_master
ORDER BY [annual revenue] DESC;
GO

SELECT
	[Company Name], brand_tier, show_type,[hq city], [hq country],
	[fiscal year], [annual revenue], [retail store count], revenue_per_store,
	est_show_cost_usd, miv_usd, miv_roi_ratio,est_wholesale_pipeline_usd, [Region Count]
FROM Challenge_day05.fashion_master
WHERE [fiscal year] = 2022
ORDER BY [annual revenue] DESC;
GO

SELECT
	[Fashion Style],
	COUNT(DISTINCT [Company Name])								AS brand_count,
	ROUND(AVG(CAST([annual revenue] AS FLOAT)), 0)				AS avg_annual_revenue,
	ROUND(AVG(CAST([retail store count] AS FLOAT)), 0)			AS avg_stores,
	ROUND(AVG(revenue_per_store), 0)							AS avg_revenue_per_store
FROM Challenge_day05.fashion_master
GROUP BY [Fashion Style]
ORDER BY avg_annual_revenue DESC;
GO

SELECT
	[Company Name], brand_tier, show_type, [Region Count],
	[has north america], [has europe], [has asia],
	[has latin america], [has africa], [has oceania]
FROM Challenge_day05.fashion_master
WHERE [fiscal year] = 2022
ORDER BY [Region Count] DESC;
GO

SELECT
	[brand], [category],
	COUNT(*)										AS sku_count,
	ROUND(AVG([original price]), 2)					AS avg_price,
	ROUND(AVG([markdown percentage]), 2)			AS avg_markdown_pct,
	ROUND(AVG(CAST([customer rating] AS FLOAT)), 2)	AS avg_rating,
	SUM(CAST([is returned] AS INT))					AS total_returns
FROM Challenge_day05.boutique_clean
GROUP BY [brand], [category]
ORDER BY [brand], avg_price DESC;
GO

-- ====================================================
-- PHASE 7 : CORE BUSINESS ANALYSIS
-- ====================================================
 
-- The central question: do runway brands grow faster?

SELECT
	show_type,
	brand_tier,
	COUNT(DISTINCT [Company Name])						AS brand_count,
	ROUND(AVG(CAST([annual revenue] AS FLOAT)), 0)		AS avg_annual_revenue,
	ROUND(AVG(CAST(est_show_cost_usd AS FLOAT)), 0)		AS avg_show_cost,
	ROUND(AVG(CAST(miv_usd AS FLOAT)) , 0)				AS avg_miv,
	ROUND(AVG(miv_roi_ratio), 2)						AS avg_miv_roi,
	ROUND(AVG(yoy_growth_pct), 2)						AS avg_yoy_growth_pct,
	ROUND(MAX(yoy_growth_pct), 2)						AS best_yoy_growth_pct,
	ROUND(MIN(yoy_growth_pct), 2)						AS worst_yoy_growth_pct
FROM Challenge_day05.fashion_master
WHERE yoy_growth_pct IS NOT NULL
GROUP BY show_type, brand_tier
ORDER BY avg_annual_revenue DESC;
GO

-- MIV ROI: media return per dollar of show spend

SELECT
	[Company Name], brand_tier, show_type,
	est_show_cost_usd									AS show_cost,
	miv_usd												AS earned_media_value,
	miv_usd - est_show_cost_usd							AS net_media_gain,
	miv_roi_ratio										AS miv_return_per_dollar,
	est_wholesale_pipeline_usd,
	wholesale_multiplier,
	post_show_sales_window_months
FROM Challenge_day05.fashion_master
WHERE [fiscal year] = 2022
  AND show_type = 'Runway'
ORDER BY miv_roi_ratio DESC;
GO

-- Contrarian test: no-show brands that outgrew runway brands

SELECT
	[Company Name], brand_tier, show_type, [fiscal year],
	[annual revenue], yoy_growth_pct, [retail store count], revenue_per_store
FROM Challenge_day05.fashion_master
WHERE show_type = 'No Show' 
  AND yoy_growth_pct IS NOT NULL
ORDER BY yoy_growth_pct DESC;
GO

-- Revenue per store: runway luxury vs fast fashion no-show

SELECT
	[Company Name], brand_tier, show_type, [hq country],
	[fiscal year], [annual revenue], [retail store count], revenue_per_store
FROM Challenge_day05.fashion_master
WHERE [fiscal year] IN (2020, 2021, 2022, 2023)
ORDER BY [fiscal year], revenue_per_store DESC;
GO

-- Markdown depth: do show brands discount less?

SELECT
	bc.[brand], fm.brand_tier, fm.show_type,
	COUNT(*)												AS products,
	ROUND(AVG(bc.[markdown percentage]), 2)					AS avg_markdown_pct,
	ROUND(AVG(bc.[original price]), 2)						AS avg_original_price,
	ROUND(AVG(bc.[current price]), 2)						AS avg_selling_price,
	ROUND(AVG(CAST(bc.[customer rating] AS FLOAT)), 2)		AS avg_customer_rating,
	ROUND(SUM(bc.[markdown savings]), 2)					AS total_markdown_given
FROM Challenge_day05.boutique_clean AS bc
JOIN Challenge_day05.fashion_show_benchmarks AS fm
	ON LOWER(LTRIM(RTRIM(bc.[brand]))) = LOWER(LTRIM(RTRIM(fm.brand_name)))
GROUP BY bc.brand, fm.brand_tier, fm.show_type
ORDER BY avg_markdown_pct;
GO

-- Return rates by brand and show type

SELECT
    bc.brand, fm.brand_tier, fm.show_type,
    COUNT(*)                                                            AS total_items,
    SUM(CAST(bc.[is returned] AS INT))                                  AS returned_items,
    ROUND(SUM(CAST(bc.[is returned] AS INT)) * 100.0 / COUNT(*), 2)     AS return_rate_pct,
    COUNT(CASE WHEN bc.[return reason] = 'Quality Issue'  THEN 1 END)   AS quality_returns,
    COUNT(CASE WHEN bc.[return reason] = 'Size Issue'     THEN 1 END)   AS size_returns,
    COUNT(CASE WHEN bc.[return reason] = 'Color Mismatch' THEN 1 END)   AS color_returns,
    COUNT(CASE WHEN bc.[return reason] = 'Damaged'        THEN 1 END)   AS damaged_returns,
    COUNT(CASE WHEN bc.[return reason] = 'Changed Mind'   THEN 1 END)   AS changed_mind_returns,
    COUNT(CASE WHEN bc.[return reason] = 'Wrong Item'     THEN 1 END)   AS wrong_item_returns
FROM Challenge_day05.boutique_clean bc
JOIN Challenge_day05.fashion_show_benchmarks fm
    ON LOWER(LTRIM(RTRIM(bc.brand))) = LOWER(LTRIM(RTRIM(fm.brand_name)))
GROUP BY bc.brand, fm.brand_tier, fm.show_type
ORDER BY return_rate_pct DESC;
GO 

-- ====================================================
-- PHASE 8 : ADVANCED ANALYSIS — WINDOW FUNCTIONS
-- ====================================================
 
-- Rank brands by revenue within tier per year

WITH tier_ranked AS (
	SELECT
		[Company Name], brand_tier, show_type, [hq country],
		[fiscal year], [annual revenue], yoy_growth_pct, revenue_per_store,
		RANK () OVER (
			PARTITION BY brand_tier, [fiscal year]
			ORDER BY [annual revenue] DESC
			) AS rank_in_tier
	FROM Challenge_day05.fashion_master
)
SELECT *
FROM tier_ranked
ORDER BY [fiscal year], brand_tier, rank_in_tier;
GO

-- Cumulative growth from 2012 baseline

WITH base AS (
	SELECT
		[Company Name], brand_tier, show_type, [fiscal year], [annual revenue],
		FIRST_VALUE([annual revenue]) OVER (
			PARTITION BY [Company Name] ORDER BY [fiscal year]
		) AS base_revenue_2012
	FROM Challenge_day05.fashion_master
)
SELECT
	[Company Name], brand_tier, show_type, [fiscal year],
	[annual revenue], base_revenue_2012,
	ROUND(
		([annual revenue] - base_revenue_2012) * 100.0 / 
		NULLIF(base_revenue_2012, 0)
	, 2)	AS cumulative_growth_pct
FROM base
ORDER BY [Company Name], [fiscal year];
GO

-- Rolling 3-year average revenue — smooths COVID dip

SELECT
	[Company Name], brand_tier, show_type, [fiscal year],
	[annual revenue], yoy_growth_pct,
	ROUND(AVG(CAST([annual revenue] AS FLOAT)) OVER (
		PARTITION BY [Company Name]
		ORDER BY [fiscal year]
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
	), 0) AS rolling_3yr_avg_revenue
FROM Challenge_day05.fashion_master
ORDER BY [Company Name], [fiscal year];
GO

-- COVID impact: runway vs no-show brands 2019-2021

SELECT
	show_type, brand_tier, [fiscal year],
	COUNT(DISTINCT [Company Name])						AS brand_count,
	ROUND(AVG(CAST([annual revenue] AS FLOAT)), 0)		AS avg_revenue,
	ROUND(AVG(yoy_growth_pct), 2)						AS avg_yoy_growth_pct
FROM Challenge_day05.fashion_master
WHERE [fiscal year] IN (2019, 2020, 2021)
GROUP BY show_type, brand_tier, [fiscal year]
ORDER BY [fiscal year], show_type;
GO

-- Global reach vs revenue (2022)

SELECT
	[Company Name], brand_tier, show_type, [fiscal year],
	[Region Count], [has north america], [has europe], [has asia],
	[has latin america], [has africa], [has oceania],
	[annual revenue], revenue_per_store, yoy_growth_pct
FROM Challenge_day05.fashion_master
WHERE [fiscal year] = 2022
ORDER BY [Region Count] DESC, [annual revenue] DESC;
GO

-- Inventory health: brands with most stock value at risk

SELECT
	bc.brand, fm.brand_tier, fm.show_type, bc.category, bc.season,
	ROUND(SUM(bc.[inventory value]), 2)								AS total_inventory_value,
	ROUND(AVG(bc.[stock quantity]), 1)								AS avg_stock_per_sku,
	COUNT(*)														AS sku_count,
	RANK() OVER (
		PARTITION BY bc.season
		ORDER BY SUM(bc.[inventory value]) DESC
	) AS rank_in_season
FROM Challenge_day05.boutique_clean AS bc
JOIN Challenge_day05.fashion_show_benchmarks AS fm
	ON LOWER(LTRIM(RTRIM(bc.brand))) = LOWER(LTRIM(RTRIM(fm.brand_name)))
GROUP BY bc.brand, fm.brand_tier, fm.show_type, bc.category, bc.season
ORDER BY bc.season, total_inventory_value DESC;
GO

-- Season markdown: does post-show season carry heavier doscounting?

SELECT
	bc.season, fm.show_type,
	COUNT(*)															AS products,
	CAST(ROUND(AVG(bc.[markdown percentage]), 2) AS DECIMAL(5, 2))		AS avg_markdown_pct,
	CAST(ROUND(AVG(bc.[original price]), 2)	AS DECIMAL(5, 2))			AS avg_original_price,
	ROUND(SUM(bc.[markdown savings]), 2)								AS total_markdown_given,
	ROUND(AVG(CAST(bc.[customer rating] AS FLOAT)), 2)					AS avg_customer_rating
FROM Challenge_day05.boutique_clean AS bc
JOIN Challenge_day05.fashion_show_benchmarks AS fm
	ON LOWER(LTRIM(RTRIM(bc.brand))) = LOWER(LTRIM(RTRIM(fm.brand_name)))
GROUP BY bc.season, fm.show_type
ORDER BY bc.season, avg_markdown_pct DESC;
GO

-- ====================================================
-- PHASE 9 : BUSINESS INSIGHT QUERIES
-- ====================================================
 
-- The verdict query

SELECT
    [Company Name], brand_tier, show_type, [hq country],
    [fiscal year], [annual revenue], est_show_cost_usd,
    miv_usd, miv_roi_ratio, est_wholesale_pipeline_usd, yoy_growth_pct,
    CASE
        WHEN show_type = 'Runway'  AND yoy_growth_pct >= 10              THEN 'Show Paid Off'
        WHEN show_type = 'Runway'  AND yoy_growth_pct BETWEEN 0 AND 9.99 THEN 'Show Broke Even'
        WHEN show_type = 'Runway'  AND yoy_growth_pct < 0                THEN 'Show Did Not Pay'
        WHEN show_type = 'No Show' AND yoy_growth_pct >= 10              THEN 'Grew Without Show'
        WHEN show_type = 'No Show' AND yoy_growth_pct BETWEEN 0 AND 9.99 THEN 'Stable Without Show'
        WHEN show_type = 'No Show' AND yoy_growth_pct < 0                THEN 'Declined Without Show'
        ELSE 'Digital / Inconclusive'
    END AS show_verdict
FROM Challenge_day05.fashion_master
WHERE yoy_growth_pct IS NOT NULL
ORDER BY
    CASE show_type WHEN 'Runway' THEN 1 WHEN 'Digital' THEN 2 ELSE 3 END,
    yoy_growth_pct DESC;
GO
 
-- Revenue per store aggregated by show type
SELECT
    show_type, brand_tier, [fiscal year],
    ROUND(AVG(revenue_per_store), 0)                        AS avg_revenue_per_store,
    ROUND(AVG(CAST([annual revenue] AS FLOAT)), 0)            AS avg_total_revenue,
    COUNT(DISTINCT [company name])                            AS brand_count
FROM Challenge_day05.fashion_master
WHERE revenue_per_store IS NOT NULL
GROUP BY show_type, brand_tier, [fiscal year]
ORDER BY [fiscal year], avg_revenue_per_store DESC;
GO
 
-- Wholesale pipeline payoff (2022 runway brands)
SELECT
    [Company Name], brand_tier, show_type, [fiscal year],
    [annual revenue], est_show_cost_usd, wholesale_multiplier,
    est_wholesale_pipeline_usd,
    ROUND(est_wholesale_pipeline_usd * 100.0 / NULLIF([annual revenue], 0), 2)
        AS wholesale_as_pct_of_revenue
FROM Challenge_day05.fashion_master
WHERE [fiscal year] = 2022 AND show_type = 'Runway'
ORDER BY est_wholesale_pipeline_usd DESC;
GO
 
-- Three-way commercial verdict — the LinkedIn post table
SELECT
    [Company Name], brand_tier, show_type, [hq country],
    [fiscal year], [annual revenue], yoy_growth_pct, miv_roi_ratio, [Region Count],
    CASE
        WHEN show_type IN ('Runway','Digital')
             AND [annual revenue] >= 5000000000
             AND yoy_growth_pct >= 5              THEN 'Show Justified — Growth + Revenue'
        WHEN show_type IN ('Runway','Digital')
             AND ([annual revenue] < 5000000000
                  OR yoy_growth_pct < 5)          THEN 'Show Questionable — Weak Returns'
        WHEN show_type = 'No Show'
             AND [annual revenue] >= 5000000000
             AND yoy_growth_pct >= 5              THEN 'No Show Needed — Already Winning'
        WHEN show_type = 'No Show'
             AND [annual revenue] >= 5000000000
             AND yoy_growth_pct < 5               THEN 'No Show — Plateauing'
        ELSE                                           'No Show — Developing'
    END AS commercial_verdict
FROM Challenge_day05.fashion_master
WHERE [fiscal year] IN (2021, 2022, 2023) AND yoy_growth_pct IS NOT NULL
ORDER BY [fiscal year], [annual revenue] DESC; 
GO
 
/*
    INSIGHT NOTES
 
    Q1 — Show type vs avg YoY growth (Phase 7, Query 1)
         Compare Runway vs No Show avg_yoy_growth_pct across all years.
         If No Show brands (Zara, Nike, Adidas) average higher growth
         the data argues operational speed beats runway theatre.
 
    Q2 — MIV ROI (Phase 7, Query 2)
         Prada: $3.5M show → $15M MIV = 4.3x earned media return.
         YSL:   $4.0M show → $14M MIV = 3.5x return.
         These are marketing campaigns dressed as art events.
 
    Q3 — Contrarian test (Phase 7, Query 3)
         Zara grew from ~$22B (2019) to ~$34B (2022) with zero show spend.
         Nike crossed $51B in 2023 with zero runway investment.
         These are the headline contrarian numbers.
 
    Q4 — Revenue per store (Phase 9, Query 2)
         Prada: ~27 stores, ~$1.6B revenue = ~$62M per store (2022).
         Gap:   ~364 stores at much lower revenue per door.
         The runway brand earns far more revenue per physical door —
         that density is the show premium made visible.
 
    Q5 — COVID analysis (Phase 8, Query 4)
         2020: Physical shows cancelled for all runway brands.
         Did runway brands bounce harder in 2021 when shows returned?
         That rebound gap is your strongest evidence either way.
 
    Q6 — Wholesale pipeline (Phase 9, Query 3)
         Prada: $3.5M show × 4.0x multiplier = $14M estimated wholesale.
         That $14M flows as orders ~5 months after the show date.
         This is why luxury houses treat shows as sales infrastructure.
 
    Q7 — YSL data note
         YSL founding year (1961) and country (France) are now clean.
         hq_city = 'Pierre Bergé' reflects the raw data as-is —
         this is the founder name, not a city. You can manually UPDATE
         this to 'Paris' if preferred:
         UPDATE Challenge_day05.companies_clean
         SET hq_city = 'Paris' WHERE company_name = 'Yves Saint Laurent';
*/
 
 
-- ====================================================
-- PHASE 10 : REPORTING QUERIES (Power BI Ready)
-- ====================================================
 
-- Visual 1: Line chart — Revenue trend 2012–2023
 
SELECT
    [Company Name], brand_tier, show_type, [hq country], [fiscal year],
    ROUND(CAST([annual revenue] AS FLOAT) / 1000000000.0, 3) AS annual_revenue_bn,
    yoy_growth_pct,
    ROUND(AVG(CAST([annual revenue] AS FLOAT)) OVER (
        PARTITION BY [company name]
        ORDER BY [fiscal year]
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) / 1000000000.0, 3) AS rolling_3yr_avg_revenue_bn
FROM Challenge_day05.fashion_master
ORDER BY [Company Name], [fiscal year];
GO
 
-- Visual 2: Clustered bar — Avg YoY growth by show type and tier
 
SELECT
    show_type, brand_tier,
    COUNT(DISTINCT [Company Name])                                    AS brand_count,
    ROUND(AVG(yoy_growth_pct), 2)                                   AS avg_yoy_growth_pct,
    ROUND(AVG(CAST([annual revenue] AS FLOAT)) / 1000000000.0, 3)    AS avg_revenue_bn
FROM Challenge_day05.fashion_master
WHERE yoy_growth_pct IS NOT NULL
GROUP BY show_type, brand_tier
ORDER BY avg_yoy_growth_pct DESC;
GO
 
-- Visual 3: Scatter — Show cost vs Revenue (bubble = MIV)
 
SELECT
    [Company Name], brand_tier, show_type, [hq country], [fiscal year],
    ROUND(CAST([annual revenue] AS FLOAT) / 1000000000.0, 3) AS annual_revenue_bn,
    est_show_cost_usd, miv_usd, miv_roi_ratio,
    yoy_growth_pct, revenue_per_store, [Region Count]
FROM Challenge_day05.fashion_master
WHERE [fiscal year] = 2022
ORDER BY annual_revenue_bn DESC;
GO
 
-- Visual 4: KPI summary cards
 
SELECT
    COUNT(DISTINCT [Company Name])                                        AS total_brands,
    ROUND(AVG(CAST([annual revenue] AS FLOAT)) / 1000000000.0, 3)        AS avg_revenue_bn,
    ROUND(AVG(CASE WHEN show_type = 'Runway'
                   THEN CAST([annual revenue] AS FLOAT) END)
          / 1000000000.0, 3)                                            AS avg_revenue_runway_bn,
    ROUND(AVG(CASE WHEN show_type = 'No Show'
                   THEN CAST([annual revenue] AS FLOAT) END)
          / 1000000000.0, 3)                                            AS avg_revenue_no_show_bn,
    ROUND(AVG(yoy_growth_pct), 2)                                       AS overall_avg_growth_pct,
    ROUND(AVG(CASE WHEN show_type = 'Runway'
                   THEN yoy_growth_pct END), 2)                         AS runway_avg_growth_pct,
    ROUND(AVG(CASE WHEN show_type = 'No Show'
                   THEN yoy_growth_pct END), 2)                         AS no_show_avg_growth_pct,
    ROUND(AVG(CASE WHEN show_type = 'Runway'
                   THEN miv_roi_ratio END), 2)                          AS avg_miv_roi_runway
FROM Challenge_day05.fashion_master
WHERE yoy_growth_pct IS NOT NULL;
GO
 
-- Visual 5: Retail health matrix
 
SELECT
    bc.brand, fm.brand_tier, fm.show_type,
    COUNT(*)                                                        AS total_skus,
    ROUND(AVG(bc.[markdown percentage]), 2)                          AS avg_markdown_pct,
    ROUND(AVG(bc.[original price]), 2)                               AS avg_price,
    ROUND(AVG(CAST(bc.[customer rating] AS FLOAT)), 2)               AS avg_rating,
    SUM(CAST(bc.[is returned] AS INT))                               AS total_returns,
    ROUND(SUM(CAST(bc.[is returned] AS INT)) * 100.0 / COUNT(*), 2)  AS return_rate_pct,
    ROUND(SUM(bc.[inventory value]), 2)                              AS total_inventory_value
FROM Challenge_day05.boutique_clean bc
JOIN Challenge_day05.fashion_show_benchmarks fm
    ON LOWER(LTRIM(RTRIM(bc.brand))) = LOWER(LTRIM(RTRIM(fm.brand_name)))
GROUP BY bc.brand, fm.brand_tier, fm.show_type
ORDER BY avg_markdown_pct ASC;
GO
 
-- Visual 6: Show verdict donut
 
SELECT
    show_verdict,
    COUNT(*)                                                        AS record_count,
    COUNT(DISTINCT [Company Name])                                    AS brand_count,
    ROUND(AVG(CAST([annual revenue] AS FLOAT)) / 1000000000.0, 3)    AS avg_revenue_bn,
    ROUND(AVG(yoy_growth_pct), 2)                                   AS avg_growth_pct
FROM (
    SELECT
        [Company Name], [annual revenue], yoy_growth_pct,
        CASE
            WHEN show_type = 'Runway'  AND yoy_growth_pct >= 10              THEN 'Show Paid Off'
            WHEN show_type = 'Runway'  AND yoy_growth_pct BETWEEN 0 AND 9.99 THEN 'Show Broke Even'
            WHEN show_type = 'Runway'  AND yoy_growth_pct < 0                THEN 'Show Did Not Pay'
            WHEN show_type = 'No Show' AND yoy_growth_pct >= 10              THEN 'Grew Without Show'
            WHEN show_type = 'No Show' AND yoy_growth_pct BETWEEN 0 AND 9.99 THEN 'Stable Without Show'
            WHEN show_type = 'No Show' AND yoy_growth_pct < 0                THEN 'Declined Without Show'
            ELSE 'Digital / Inconclusive'
        END AS show_verdict
    FROM Challenge_day05.fashion_master
    WHERE yoy_growth_pct IS NOT NULL
) v
GROUP BY show_verdict
ORDER BY avg_revenue_bn DESC;
GO
 
-- Visual 7: Global reach map (2022)
 
SELECT
    [Company Name], brand_tier, show_type,
    [hq city], [hq country], [Region Count],
    [has north america], [has europe], [has asia],
    [has latin america], [has africa], [has oceania],
    [annual revenue], revenue_per_store
FROM Challenge_day05.fashion_master
WHERE [fiscal year] = 2022
ORDER BY [Region Count] DESC, [annual revenue] DESC;
GO
 
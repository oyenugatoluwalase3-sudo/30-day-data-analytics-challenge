-- ====================================================
-- 30-DAY DATA ANALYTICS CHALLENGE
-- DAY 04: Can a School Predict Which Student Will Fail
--         Before the Semester Ends?
-- Tool Stack : SQL Server + Power BI
-- Datasets   : Maths.csv (397 rows) | Portuguese.csv (651 rows)
-- Author     : Toluwalase
-- ====================================================

-- ====================================================
-- PHASE 1 : DATABASE + SCHEMA + TABLE SETUP
-- ====================================================

USE [30_Days_Analytics_ChallengeDB];
GO

-- Drop view and tables first (must go before schema drop)
IF OBJECT_ID('Challenge_day04.vw_StudentDashboard', 'V') IS NOT NULL DROP VIEW Challenge_day04.vw_StudentDashboard;
IF OBJECT_ID('Challenge_day04.StudentPerformance',  'U') IS NOT NULL DROP TABLE Challenge_day04.StudentPerformance;
IF OBJECT_ID('Challenge_day04.Portuguese_Raw',      'U') IS NOT NULL DROP TABLE Challenge_day04.Portuguese_Raw;
IF OBJECT_ID('Challenge_day04.Maths_Raw',           'U') IS NOT NULL DROP TABLE Challenge_day04.Maths_Raw;
GO

-- Now the schema is empty and can be dropped 
IF EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'Challenge_day04')
    DROP SCHEMA Challenge_day04;
GO

CREATE SCHEMA Challenge_day04;
GO

-- -----------------------------------------------------------
-- TABLE 1	: Maths_Raw
-- Source	: Maths.csv (397 rows, 33 columns)
-- Purpose	: Student demographics, support flags & grade
--			  progression for Mathematics subject
-- -----------------------------------------------------------

CREATE TABLE Challenge_day04.Maths_Raw (
	[school]		VARCHAR(100),
	[sex]			VARCHAR(1),
	[age]			INT,
	[address]		VARCHAR(1),
	[famsize]		VARCHAR(5),
	[Pstatus]		VARCHAR(1),
	[Medu]			INT,
	[Fedu]			INT,
	[Mjob]			VARCHAR(20),
	[Fjob]			VARCHAR(20),
	[reason]		VARCHAR(20),
	[guardian]		VARCHAR(10),
	[traveltime]	INT,
	[studytime]		INT,
	[failures]		INT,
	[schoolsup]		VARCHAR(3),
	[famsup]		VARCHAR(3),
	[paid]			VARCHAR(3),
	[activities]		VARCHAR(3),
	[nursery]		VARCHAR(3),
	[higher]		VARCHAR(3),
	[internet]		VARCHAR(3),
	[romantic]		VARCHAR(3),
	[famrel]		INT,
	[freetime]		INT,
	[goout]			INT,
	[Dalc]			INT,
	[Walc]			INT,
	[health]		INT,
	[absences]		INT,
	[G1]			INT,
	[G2]			INT,
	[G3]			INT
);
GO

-- ------------------------------------------------------------------
-- TABLE 2	: Portugese_Raw
-- Source	: Portugese.csv (651 rows, 33 columns)
-- Purpose	: Same schema as Maths_Raw but for Portugese Subject
-- ------------------------------------------------------------------

CREATE TABLE Challenge_day04.Portuguese_Raw (
	[school]			VARCHAR(5),
	[sex]				VARCHAR(1),
	[age]				INT,
	[address]			VARCHAR(1),
	[famsize]			VARCHAR(5),
	[Pstatus]			VARCHAR(1),
	[Medu]				INT,
	[Fedu]				INT,
	[Mjob]				VARCHAR(20),
	[Fjob]				VARCHAR(20),
	[reason]			VARCHAR(20),
	[guardian]			VARCHAR(10),
	[traveltime]		INT,
	[studytime]			INT,
	[failures]			INT,
	[schoolsup]			VARCHAR(3),
	[famsup]			VARCHAR(3),
	[paid]				VARCHAR(3),
	[activities]		VARCHAR(3),
	[nursery]			VARCHAR(3),
	[higher]			VARCHAR(3),
	[internet]			VARCHAR(3),
	[romantic]			VARCHAR(3),
	[famrel]			INT,
	[freetime]			INT,
	[goout]				INT,
	[Dalc]				INT,
	[Walc]				INT,
	[health]			INT,
	[absences]			INT,
	[G1]				INT,
	[G2]				INT,
	[G3]				INT
);
GO

-- << CHANGE THESE PATHS to wherever you saved your CSV files >>

BULK INSERT Challenge_day04.Maths_Raw
FROM 'C:\Users\Admin\Downloads\Day04Data\Maths.csv'
WITH (        
	FIELDTERMINATOR	= ',',
	ROWTERMINATOR	= '0x0a',
	FIRSTROW		= 2,
	TABLOCK
);
GO

BULK INSERT Challenge_day04.Portuguese_Raw
FROM 'C:\Users\Admin\Downloads\Day04Data\Portuguese.csv'
WITH (        
	FIELDTERMINATOR	= ',',
	ROWTERMINATOR	= '0x0a',
	FIRSTROW		= 2,
	TABLOCK
);
GO

-- Confirm row counts
SELECT 'Maths_Raw'      AS tbl, COUNT(*) AS rows FROM Challenge_day04.Maths_Raw
UNION ALL
SELECT 'Portuguese_Raw' AS tbl, COUNT(*) AS rows FROM Challenge_day04.Portuguese_Raw;
-- Expected: 397 | 651
GO

-- ====================================================
-- PHASE 2 : DATA UNDERSTANDING
-- ====================================================

/*
============================================
DATA DICTIONARY
============================================

TABLES: Maths_Raw & Portuguese_Raw (identical schema)

    school      : School attended — GP (Gabriel Pereira) or MS (Mousinho da Silveira)
    sex         : Student gender — F (Female) or M (Male)
    age         : Student age — ranges from 15 to 22
    address     : Home location — U (Urban) or R (Rural)
    famsize     : Family size — GT3 (greater than 3) or LE3 (3 or less)
    Pstatus     : Parent cohabitation status — T (Together) or A (Apart)
    Medu        : Mother education level — 0 (none) to 4 (higher education)
    Fedu        : Father education level — 0 (none) to 4 (higher education)
    Mjob        : Mother occupation — at_home, health, other, services, teacher
    Fjob        : Father occupation — at_home, health, other, services, teacher
    reason      : Reason for choosing school — course, home, reputation, other
    guardian    : Primary guardian — mother, father, other
    traveltime  : Home-to-school travel time — 1 (<15 min) to 4 (>1 hour)
    studytime   : Weekly study hours — 1 (<2 hrs) to 4 (>10 hrs)
    failures    : Number of past class failures — 0 to 3
    schoolsup   : Extra educational school support — yes / no
    famsup      : Family educational support — yes / no
    paid        : Extra paid tutoring classes — yes / no
    activities  : Extracurricular activities — yes / no
    nursery     : Attended nursery school — yes / no
    higher      : Wants to pursue higher education — yes / no
    internet    : Internet access at home — yes / no
    romantic    : Currently in a romantic relationship — yes / no
    famrel      : Family relationship quality — 1 (very bad) to 5 (excellent)
    freetime    : Free time after school — 1 (very low) to 5 (very high)
    goout       : Time spent going out with friends — 1 (very low) to 5 (very high)
    Dalc        : Workday alcohol consumption — 1 (very low) to 5 (very high)
    Walc        : Weekend alcohol consumption — 1 (very low) to 5 (very high)
    health      : Current health status — 1 (very bad) to 5 (very good)
    absences    : Number of school absences — ranges from 0 to 75
    G1          : First period grade — 0 to 20
    G2          : Second period grade — 0 to 20
    G3          : Final grade (target variable) — 0 to 20

NOTE: G3 = 0 does NOT always mean the student scored zero.
      It may indicate a dropout or student absent for the final exam.
      Maths has 39 such cases; Portuguese has 15.
*/


-- ====================================================
-- PHASE 3 : DATA QUALITY CHECKS
-- ====================================================

-- ----------------------------------------------------------
-- NULL / BLANK CHECK
-- ----------------------------------------------------------

DECLARE @sql	NVARCHAR(MAX) = '';
DECLARE @table	NVARCHAR(100) = 'Challenge_day04.Maths_Raw';

SELECT @sql = @sql + 
	'SUM(CASE WHEN [' + COLUMN_NAME + '] IS NULL OR TRY_CAST([' + COLUMN_NAME + '] AS  VARCHAR) = '''' THEN 1 ELSE 0 END) AS [' + COLUMN_NAME + '_nulls],' + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Challenge_day04'
	AND TABLE_NAME = 'Maths_Raw'
ORDER BY ORDINAL_POSITION;

SET @SQL = 'SELECT COUNT(*) AS total_rows,' + CHAR(10) + LEFT(@sql, LEN(@sql) - 2)
		 + CHAR(10) + 'FROM ' + @table + ';'


PRINT @sql
EXEC sp_executesql @sql
GO

-- ----------------------------------------------------------
-- Duplicate check (one row per student per subject)
-- ----------------------------------------------------------

WITH cte_maths AS (
    SELECT school, sex, age, Medu, Fedu, Mjob, absences, G1, G2, G3,
           ROW_NUMBER() OVER (PARTITION BY school, sex, age, Medu, Fedu, G1, G2, G3 ORDER BY absences) AS rn
    FROM Challenge_day04.Maths_Raw
)
SELECT COUNT(*) AS maths_duplicate_rows FROM cte_maths WHERE rn > 1;
GO

WITH cte_por AS (
    SELECT school, sex, age, Medu, Fedu, Mjob, absences, G1, G2, G3,
           ROW_NUMBER() OVER (PARTITION BY school, sex, age, Medu, Fedu, G1, G2, G3 ORDER BY absences) AS rn
    FROM Challenge_day04.Portuguese_Raw
)
SELECT COUNT(*) AS portuguese_duplicate_rows FROM cte_por WHERE rn > 1;
GO

-- ----------------------------------------------------------
-- G3 = 0 audit (potential dropouts vs genuine zero scorers)
-- ----------------------------------------------------------

SELECT 'Maths'      AS subject, COUNT(*) AS zero_final_grade FROM Challenge_day04.Maths_Raw      WHERE G3 = 0
UNION ALL
SELECT 'Portuguese' AS subject, COUNT(*) AS zero_final_grade FROM Challenge_day04.Portuguese_Raw WHERE G3 = 0;
-- Maths: 39 | Portuguese: 15
-- These rows are kept — they represent the At-Risk population we are studying
GO

-- ----------------------------------------------------------
-- Age range sanity check
-- ----------------------------------------------------------

SELECT
    MIN(age) AS youngest,
    MAX(age) AS oldest,
    ROUND(AVG(CAST(age AS FLOAT)), 2) AS avg_age
FROM Challenge_day04.Maths_Raw;
-- Expected: 15 | 22 | ~16.7
GO


-- ====================================================
-- PHASE 4 : COMBINE & CLEAN — MASTER TABLE
-- ====================================================

-- --------------------------------------------------------------
-- TABLE 3 : StudentPerformance
-- Purpose  : Combined master table with subject label,
--            clean column names, and all derived bands/flags
--            ready for Power BI connection
-- Note     : Dalc, Walc, romantic excluded — not relevant
--            to the school retention narrative
-- --------------------------------------------------------------

CREATE TABLE Challenge_day04.StudentPerformance (
    student_id          INT IDENTITY(1,1) PRIMARY KEY,
    subject             VARCHAR(15),
    school              VARCHAR(5),
    gender              VARCHAR(1),
    age                 INT,
    location_type       VARCHAR(1),
    famsize             VARCHAR(5),
    Pstatus             VARCHAR(1),
    mother_edu_score    INT,
    father_edu_score    INT,
    mother_job          VARCHAR(20),
    father_job          VARCHAR(20),
    school_choice_reason VARCHAR(20),
    guardian            VARCHAR(10),
    traveltime          INT,
    studytime           INT,
    prior_failures      INT,
    school_extra_support VARCHAR(3),
    family_support      VARCHAR(3),
    extra_paid_classes  VARCHAR(3),
    extracurricular     VARCHAR(3),
    attended_nursery    VARCHAR(3),
    wants_higher_edu    VARCHAR(3),
    has_internet        VARCHAR(3),
    family_rel_score    INT,
    health_score        INT,
    absences            INT,
    term1_grade         INT,
    term2_grade         INT,
    final_grade         INT
);
GO

INSERT INTO Challenge_day04.StudentPerformance (
    subject, school, gender, age, location_type, famsize, Pstatus,
    mother_edu_score, father_edu_score, mother_job, father_job,
    school_choice_reason, guardian, traveltime, studytime, prior_failures,
    school_extra_support, family_support, extra_paid_classes, extracurricular,
    attended_nursery, wants_higher_edu, has_internet,
    family_rel_score, health_score, absences,
    term1_grade, term2_grade, final_grade
)
SELECT
    'Maths', school, sex, age, address, famsize, Pstatus,
    Medu, Fedu, Mjob, Fjob,
    reason, guardian, traveltime, studytime, failures,
    schoolsup, famsup, paid, activities,
    nursery, higher, internet,
    famrel, health, absences,
    G1, G2, G3
FROM Challenge_day04.Maths_Raw

UNION ALL

SELECT
    'Portuguese', school, sex, age, address, famsize, Pstatus,
    Medu, Fedu, Mjob, Fjob,
    reason, guardian, traveltime, studytime, failures,
    schoolsup, famsup, paid, activities,
    nursery, higher, internet,
    famrel, health, absences,
    G1, G2, G3
FROM Challenge_day04.Portuguese_Raw;
GO

-- Confirm combined load
SELECT subject, COUNT(*) AS total_students
FROM Challenge_day04.StudentPerformance
GROUP BY subject;
-- Expected: Maths 397 | Portuguese 651 | Grand Total 1,048
GO

-- Preview
SELECT TOP 5 * FROM Challenge_day04.StudentPerformance;
GO

-- ----------------------------------------------------------
-- ADD DERIVED COLUMNS
-- ----------------------------------------------------------

-- Performance band (G3 is scored out of 20)
ALTER TABLE Challenge_day04.StudentPerformance ADD performance_band VARCHAR(15);
GO
UPDATE Challenge_day04.StudentPerformance
SET performance_band = CASE
    WHEN final_grade >= 16 THEN 'Excellent'
    WHEN final_grade >= 12 THEN 'Good'
    WHEN final_grade >= 8  THEN 'Average'
    WHEN final_grade >= 1  THEN 'Below Average'
    ELSE                        'At Risk'       -- final_grade = 0
END;
GO

-- Parent combined education level
ALTER TABLE Challenge_day04.StudentPerformance ADD parent_edu_level VARCHAR(25);
GO
UPDATE Challenge_day04.StudentPerformance
SET parent_edu_level = CASE
    WHEN (mother_edu_score + father_edu_score) >= 7 THEN 'Highly Educated'
    WHEN (mother_edu_score + father_edu_score) >= 4 THEN 'Moderately Educated'
    ELSE                                                  'Low Education'
END;
GO

-- Absence band
ALTER TABLE Challenge_day04.StudentPerformance ADD absence_band VARCHAR(20);
GO
UPDATE Challenge_day04.StudentPerformance
SET absence_band = CASE
    WHEN absences = 0               THEN 'No Absences'
    WHEN absences BETWEEN 1 AND 5   THEN '1-5 Absences'
    WHEN absences BETWEEN 6 AND 15  THEN '6-15 Absences'
    ELSE                                 '15+ Absences'
END;
GO

-- Grade trend G1 → G3
ALTER TABLE Challenge_day04.StudentPerformance ADD grade_trend VARCHAR(10);
GO
UPDATE Challenge_day04.StudentPerformance
SET grade_trend = CASE
    WHEN final_grade > term1_grade THEN 'Improving'
    WHEN final_grade < term1_grade THEN 'Declining'
    ELSE                                'Stable'
END;
GO

-- Readable label columns for Power BI slicers
ALTER TABLE Challenge_day04.StudentPerformance ADD location_label    VARCHAR(10);
ALTER TABLE Challenge_day04.StudentPerformance ADD family_size_label VARCHAR(15);
ALTER TABLE Challenge_day04.StudentPerformance ADD parent_status     VARCHAR(15);
ALTER TABLE Challenge_day04.StudentPerformance ADD study_time_label  VARCHAR(15);
GO

UPDATE Challenge_day04.StudentPerformance
SET
    location_label    = CASE WHEN location_type = 'U' THEN 'Urban'       ELSE 'Rural'        END,
    family_size_label = CASE WHEN famsize = 'GT3'      THEN 'Large (>3)'  ELSE 'Small (<=3)'  END,
    parent_status     = CASE WHEN Pstatus = 'T'        THEN 'Together'    ELSE 'Apart'        END,
    study_time_label  = CASE
                            WHEN studytime = 1 THEN 'Under 2hrs'
                            WHEN studytime = 2 THEN '2-5hrs'
                            WHEN studytime = 3 THEN '5-10hrs'
                            ELSE                    'Over 10hrs'
                        END;
GO

-- Business Logic Validation: final grade must be 0-20
SELECT COUNT(*) AS Invalid_Grade_Rows
FROM Challenge_day04.StudentPerformance
WHERE final_grade < 0 OR final_grade > 20;
GO


-- ====================================================
-- PHASE 5 : FOUNDATIONAL ANALYSIS
-- ====================================================

-- Average grades and absences per subject
SELECT
    subject,
    COUNT(*)                                    AS total_students,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 2)   AS avg_final_grade,
    ROUND(AVG(CAST(term1_grade AS FLOAT)), 2)   AS avg_term1,
    ROUND(AVG(CAST(term2_grade AS FLOAT)), 2)   AS avg_term2,
    ROUND(AVG(CAST(absences AS FLOAT)), 1)      AS avg_absences
FROM Challenge_day04.StudentPerformance
GROUP BY subject;
GO

-- Performance band breakdown per subject
SELECT
    subject,
    performance_band,
    COUNT(*)                                                                    AS students,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY subject), 1)     AS pct_of_subject
FROM Challenge_day04.StudentPerformance
GROUP BY subject, performance_band
ORDER BY subject, students DESC;
GO


-- ====================================================
-- PHASE 6 : CORE BUSINESS ANALYSIS
-- ====================================================

-- Does attendance affect final grade?
-- This directly answers one arm of the challenge question.

SELECT
    subject,
    absence_band,
    COUNT(*)                                        AS students,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 2)       AS avg_final_grade
FROM Challenge_day04.StudentPerformance
GROUP BY subject, absence_band
ORDER BY subject, avg_final_grade DESC;
GO

-- Does parental education level affect performance?

SELECT
    parent_edu_level,
    subject,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 2)   AS avg_grade,
    ROUND(AVG(CAST(absences AS FLOAT)), 1)      AS avg_absences,
    COUNT(*)                                    AS students
FROM Challenge_day04.StudentPerformance
GROUP BY parent_edu_level, subject
ORDER BY avg_grade DESC;
GO

-- Does internet access affect grades?
-- Financial angle: budget case for school device/connectivity programs

SELECT
    has_internet,
    subject,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 2)   AS avg_grade,
    COUNT(*)                                    AS students
FROM Challenge_day04.StudentPerformance
GROUP BY has_internet, subject
ORDER BY subject;
GO

-- Does study time translate to better grades?
-- Sweet spot analysis: is more always better?

SELECT
    study_time_label,
    subject,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 2)   AS avg_grade,
    COUNT(*)                                    AS students
FROM Challenge_day04.StudentPerformance
GROUP BY study_time_label, subject
ORDER BY subject, avg_grade DESC;
GO

/*
    Q1 — Attendance vs Grade
         If students with no absences consistently outscore the 15+ group
         by 3+ points, absence is your #1 predictor flag.

    Q2 — Parent Education
         Compounding effect — highly educated households show the steepest
         G1 → G3 improvement. This is the financial intervention ROI angle.

    Q3 — Internet Access
         A gap of 1.5+ grade points between yes/no groups = a budget case
         for a district-funded device programme. That is your revenue angle.

    Q4 — Study Time
         If 2–5hrs outperforms 10+ hrs, the story is quality over quantity.
         Flag that as the insight — it goes viral on LinkedIn.
*/


-- ====================================================
-- PHASE 7 : ADVANCED ANALYSIS — WINDOW FUNCTIONS
-- ====================================================

-- Rank students within each subject by final grade
-- and show how their term1 grade compared

WITH Ranked_Students AS (
    SELECT
        subject,
        student_id,
        gender,
        location_label,
        term1_grade,
        term2_grade,
        final_grade,
        absences,
        performance_band,
        RANK() OVER (PARTITION BY subject ORDER BY final_grade DESC) AS grade_rank
    FROM Challenge_day04.StudentPerformance
)
SELECT *
FROM Ranked_Students
WHERE grade_rank <= 10
ORDER BY subject, grade_rank;
GO

-- Grade trend analysis: who is improving vs declining per subject?

SELECT
    subject,
    grade_trend,
    COUNT(*)                                                                AS students,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY subject), 1) AS pct
FROM Challenge_day04.StudentPerformance
GROUP BY subject, grade_trend
ORDER BY subject;
GO

-- Cumulative student count by performance band (for waterfall/funnel visual)

SELECT
    subject,
    performance_band,
    COUNT(*) AS students,
    SUM(COUNT(*)) OVER (
        PARTITION BY subject
        ORDER BY
            CASE performance_band
                WHEN 'Excellent'     THEN 1
                WHEN 'Good'          THEN 2
                WHEN 'Average'       THEN 3
                WHEN 'Below Average' THEN 4
                ELSE                      5
            END
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM Challenge_day04.StudentPerformance
GROUP BY subject, performance_band
ORDER BY subject, running_total;
GO

/*
    Q1 — Top 10 Ranked Students
         Do the top 10 in Maths also rank highly in Portuguese?
         Use Query 13 (cross-subject join) in Phase 8 to verify.
         If the same cohort tops both — family/home environment
         is the real driver, not subject-specific ability.

    Q2 — Grade Trend
         If over 40% of students are Declining G1 → G3, that is a
         systemic problem — not individual failure. That is your
         headline for the district superintendent audience.
*/


-- ====================================================
-- PHASE 8 : BUSINESS INSIGHT QUERIES
-- ====================================================

-- High-risk students: prior failures + high absences (Early Warning System)
-- These are the students who can still be saved with intervention

SELECT
    student_id,
    subject,
    gender,
    age,
    location_label,
    parent_edu_level,
    prior_failures,
    absences,
    term1_grade,
    term2_grade,
    final_grade,
    grade_trend,
    performance_band
FROM Challenge_day04.StudentPerformance
WHERE performance_band = 'At Risk'
ORDER BY subject, final_grade ASC;
GO

-- Cross-subject performance: do weak Maths students also struggle in Portuguese?
-- Approximate join on shared demographic fingerprint (~382 matched students)

SELECT
    m.student_id                AS maths_id,
    m.term1_grade               AS maths_term1,
    m.final_grade               AS maths_final,
    m.performance_band          AS maths_band,
    p.term1_grade               AS por_term1,
    p.final_grade               AS por_final,
    p.performance_band          AS por_band,
    m.absences                  AS maths_absences,
    p.absences                  AS por_absences,
    m.parent_edu_level
FROM Challenge_day04.StudentPerformance m
JOIN Challenge_day04.StudentPerformance p
    ON  m.gender             = p.gender
    AND m.age                = p.age
    AND m.location_type      = p.location_type
    AND m.mother_edu_score   = p.mother_edu_score
    AND m.father_edu_score   = p.father_edu_score
    AND m.mother_job         = p.mother_job
    AND m.school             = p.school
    AND m.subject            = 'Maths'
    AND p.subject            = 'Portuguese'
ORDER BY maths_final ASC;
GO

-- Urban vs Rural performance gap

SELECT
    location_label,
    subject,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 2)   AS avg_grade,
    ROUND(AVG(CAST(absences AS FLOAT)), 1)      AS avg_absences,
    COUNT(*)                                    AS students
FROM Challenge_day04.StudentPerformance
GROUP BY location_label, subject
ORDER BY subject, avg_grade DESC;
GO

-- Gender performance gap per subject

SELECT
    gender,
    subject,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 2)   AS avg_grade,
    COUNT(*)                                    AS students
FROM Challenge_day04.StudentPerformance
GROUP BY gender, subject
ORDER BY subject;
GO


-- ====================================================
-- PHASE 9 : REPORTING QUERIES (Power BI Ready)
-- ====================================================

-- Visual 1 : KPI Cards (overall market stats)
SELECT
    COUNT(*)                                        AS Total_Students,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 1)       AS Avg_Final_Grade,
    ROUND(AVG(CAST(absences AS FLOAT)), 1)          AS Avg_Absences,
    SUM(CASE WHEN performance_band = 'At Risk'
             THEN 1 ELSE 0 END)                     AS Total_At_Risk_Students,
    ROUND(SUM(CASE WHEN performance_band = 'At Risk'
                   THEN 1.0 ELSE 0 END)
          / COUNT(*) * 100, 1)                      AS Pct_At_Risk
FROM Challenge_day04.StudentPerformance;
GO

-- Visual 2 : Bar Chart (average grade by absence band)
SELECT
    absence_band,
    subject,
    ROUND(AVG(CAST(final_grade AS FLOAT)), 2)   AS avg_grade,
    COUNT(*)                                    AS students
FROM Challenge_day04.StudentPerformance
GROUP BY absence_band, subject
ORDER BY subject, avg_grade DESC;
GO

-- Visual 3 : Line Chart (grade progression G1 → G2 → G3 per subject)
SELECT
    subject,
    ROUND(AVG(CAST(term1_grade  AS FLOAT)), 2)  AS avg_term1,
    ROUND(AVG(CAST(term2_grade  AS FLOAT)), 2)  AS avg_term2,
    ROUND(AVG(CAST(final_grade  AS FLOAT)), 2)  AS avg_final
FROM Challenge_day04.StudentPerformance
GROUP BY subject;
GO

-- Visual 4 : Donut Chart (performance band distribution per subject)
SELECT
    subject,
    performance_band,
    COUNT(*)                                                                    AS students,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY subject), 1)     AS pct
FROM Challenge_day04.StudentPerformance
GROUP BY subject, performance_band
ORDER BY subject, students DESC;
GO

-- Visual 5 : Table (At-Risk student tracker with conditional formatting in Power BI)
SELECT
    student_id,
    subject,
    gender,
    age,
    location_label,
    parent_edu_level,
    prior_failures,
    absences,
    term1_grade,
    term2_grade,
    final_grade,
    grade_trend,
    performance_band
FROM Challenge_day04.StudentPerformance
WHERE performance_band IN ('At Risk', 'Below Average')
ORDER BY subject, final_grade ASC;
GO

-- Visual 6 : Full table for Power BI model (connect directly to this view)
CREATE OR ALTER VIEW Challenge_day04.vw_StudentDashboard AS
SELECT
    student_id,
    subject,
    school,
    gender,
    age,
    location_label,
    family_size_label,
    parent_status,
    parent_edu_level,
    mother_edu_score,
    father_edu_score,
    mother_job,
    father_job,
    school_choice_reason,
    guardian,
    study_time_label,
    school_extra_support,
    family_support,
    extra_paid_classes,
    extracurricular,
    has_internet,
    wants_higher_edu,
    family_rel_score,
    health_score,
    absence_band,
    absences,
    term1_grade,
    term2_grade,
    final_grade,
    performance_band,
    grade_trend
FROM Challenge_day04.StudentPerformance;
GO

-- Verify the view
SELECT TOP 5 * FROM Challenge_day04.vw_StudentDashboard;
GO
SELECT COUNT(*) AS total_records FROM Challenge_day04.vw_StudentDashboard;
-- Expected: 1,048
GO

# ⚽ Day 02 — What Makes a Club the Big Six?

## The Question

As a Manchester City fan, I've heard the phrase **"Big Six"** countless times.

But I started wondering:

**What actually makes a club part of the Big Six?**

Is it trophies?

History?

Money?

League performance?

Or is it a combination of all of them?

Instead of getting into another football argument, I decided to let the data answer the question. 😂

---

# 🎯 What I Wanted to Find Out

I wanted to understand whether the traditional "Big Six" clubs actually look different from the rest of the Premier League when we look at:

- 💰 Revenue
- 💵 Wage spending
- ⚽ League performance
- 🏆 Top-four finishes
- 🔄 Transfer spending
- 📈 Long-term financial growth

I also wanted to see whether spending more money actually translated into better performance.

---

# 📊 The Data

I combined several datasets for the analysis.

### Club Financials

**884 records** covering major clubs from **2010–2026**.

This provided financial information such as club revenue and wages.

### Transfer History

Around **15,000 transfer records** covering historical player transfers.

### Record Transfers

**57 major transfer deals** used to provide additional context around transfer spending.

### Premier League Performance

I used FBref Premier League season statistics covering **5 seasons**, with 20 clubs per season.

---

# 🧹 Data Preparation

Before trying to answer the football questions, I had to make sure the data was actually usable.

The SQL analysis went through several stages:

### 1. Database & Schema Setup

Created the database structure and imported the datasets into SQL Server.

### 2. Data Understanding

Explored the tables and created a data dictionary to understand what each column represented.

### 3. Data Quality Checks

Checked for issues such as missing values and used dynamic SQL with `INFORMATION_SCHEMA` to inspect columns across the database.

### 4. Data Cleaning

Cleaned the data and converted fields into appropriate data types.

### 5. Foundational Analysis

Started with basic aggregations to understand revenue, wages, transfers, and performance.

### 6. Core Business Analysis

Joined financial and performance data to investigate relationships such as:

**Revenue ↔ League Position**

### 7. Advanced Analysis

Used SQL window functions including:

- `LAG()`
- `RANK()`
- Running totals

These helped me look at changes over time and compare clubs against each other.

### 8. Business Insights

Turned the analysis into questions that could actually tell a story.

### 9. Power BI Reporting Queries

Prepared the final datasets used to build the Power BI dashboard.

---

# 🔎 What Did the Data Say?

## 💰 The Big Six have a serious financial advantage

From 2020–2024, the traditional Big Six occupied the **top six Premier League revenue positions every single year** in the dataset.

The average annual revenue of the Big Six was around:

### **€476M**

That's roughly **2.2× the revenue of the next tier of Premier League clubs.**

So the financial gap isn't a small difference.

It's a completely different level of financial power.

---

# 🔵 Manchester City's Growth

This was probably the most interesting one for me personally.

Manchester City's revenue grew from:

**€154M in 2010**

to

**€809M in 2024**

That's a **424% increase**.

As a City fan, I obviously knew the club had grown massively.

But seeing the growth as a number makes it much easier to appreciate.

What started as a football success story also became a huge business growth story.

---

# 🔴 Arsenal: Getting More From Their Money

Arsenal had the **lowest average revenue among the Big Six** in my analysis.

But they had the **highest points per €M spent on wages**, at approximately:

### **0.32 points per €M**

That makes Arsenal particularly interesting.

They weren't simply spending the most.

They were getting more league points relative to their wage spending.

---

# 🔴 Manchester United: More Money ≠ Better Results

Manchester United spent approximately:

### **€4.5B on wages across four seasons**

Yet averaged only:

### **66.8 points per season**

That was the weakest wage efficiency among the Big Six in my analysis.

And this is where the data becomes more interesting than simply saying:

> "They need better players."

The bigger question becomes:

**What is the club getting in return for all that spending?**

---

# 🔵 Chelsea: Spending Without the Same Return

Chelsea recorded the highest cumulative transfer spending in the 15-year transfer dataset.

But their on-pitch return didn't increase proportionally with that spending.

This doesn't mean spending money is bad.

It means:

> **Money alone doesn't guarantee success.**

How the money is spent matters.

---

# 📈 So What Actually Defines the Big Six?

After comparing financial and performance measures, three numbers stood out in my analysis:

| Measure | Benchmark |
|---|---:|
| Annual Revenue | **€400M+** |
| Average Points | **65+** |
| Top-4 Finish Rate | **50%+** |

These aren't meant to be a universal definition of the Big Six.

They're the benchmarks that emerged from **my analysis of the data**.

And that's an important distinction.

---

# ⚪ What About Tottenham?

Tottenham clears the financial benchmark.

Their revenue is above **€400M**.

But when we look at the other two measures, the picture isn't quite as strong.

So financially, they look like a Big Six club.

Performance-wise, the data gives a more complicated answer.

---

# 💡 My Biggest Takeaway

Before doing this analysis, I thought the Big Six conversation would mostly come down to trophies and history.

But the data made me look at it differently.

Being a "big club" isn't just about what happens on the pitch.

There is a feedback loop:

**More revenue → Better ability to attract players → More competitive squads → Better performance → More revenue**

And once a club gets into that cycle, the gap between them and everyone else can become very difficult to close.

---

# 📊 Power BI Dashboard

The final dashboard brings together the financial, transfer, and performance analysis.

![Day 02 Dashboard](./dashboard/day02_dashboard.png)

---

# 🛠️ Tools Used

**SQL Server**

Used for:

- Data cleaning
- Data quality checks
- Joins
- Aggregations
- Window functions
- Financial analysis
- Performance analysis
- Reporting queries

**Power BI**

Used to turn the SQL analysis into an interactive dashboard.

---

# 📁 Files

```text
Day02/
│
├── sql/
│   └── day02_big_six_analysis.sql
│
├── dashboard/
│   ├── day02_dashboard.png
│   └── day02_dashboard.pbix
│
├── data/
│   ├── club_financials.csv
│   ├── transfers_history.csv
│   ├── record_transfers.csv
│   ├── 2020-2021.txt
│   ├── 2021-2022.txt
│   ├── 2022-2023.txt
│   ├── 2023-2024.txt
│   └── 2024-2025.txt
│
└── README.md

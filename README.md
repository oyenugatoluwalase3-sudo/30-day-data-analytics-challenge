# 30-Day Data Analytics Challenge

**Author:** Toluwalase
**Institution:** Federal University of Technology Akure (FUTA) | WorldQuant University
**Tools:** SQL Server · Power BI · Python
**Focus:** Data Analytics · Business · Finance · Sports · Entertainment

---

## 🚀 What is this challenge?

I'm spending 30 days answering questions that I genuinely find interesting using data.

Every day, I pick a question, find the data, clean it, analyse it, build a Power BI dashboard, and share what I discover.

Some questions are about business.

Some are about money.

Some are about football.

And now, some are about movies. 🎬

The goal isn't to make the analysis look complicated.

**The goal is to use data to answer questions that people actually care about.**

No made-up insights.
No "pretty dashboard = good analysis."

Just data, SQL, Python, Power BI, and hopefully a few interesting discoveries along the way.

---

## 📅 The Challenge

| **Day** | **Question**                            | **Tools**                      | **Status**   |
| ------- | --------------------------------------- | ------------------------------ | ------------ |
| Day 01  | Does Advertising Actually Work?         | SQL Server · Power BI          | ✅ Completed  |
| Day 02  | What Makes a Club the Big Six?          | SQL Server · Power BI          | ✅ Completed  |
| Day 03  | Do Critics Actually Affect Movie Sales? | Python · SQL Server · Power BI | ✅ Completed  |
| Day 04  | Coming soon...                          | —                              | 🔄           |
| ...     | ...                                     | —                              | 🔄           |
| Day 30  | Coming soon...                          | —                              | 🔄           |

---

## 📌 Day 01 — Does Advertising Actually Work?

### The question

**Does advertising actually generate a return, or are companies just spending money and hoping for the best?**

### The data

I analysed a marketing campaign dataset containing **200,000 campaign records**.

### What I found

Every campaign in the dataset had an ROI above 1, meaning each campaign generated more revenue than it cost.

Facebook had the highest average ROI at **5.02**.

But the more interesting finding was that **spending more didn't automatically mean getting better returns**.

The difference in average ROI between high-spend and low-spend campaigns was less than **0.02**.

That suggests something important:

> **The channel you choose may matter more than simply increasing the budget.**

### Tools

`SQL Server` → `Power BI`

📁 [View Day 01](https://github.com/oyenugatoluwalase3-sudo/30-day-analytics-challenge)

---

## ⚽ Day 02 — What Makes a Club the Big Six?

As a Manchester City fan, I've heard "Big Six" thrown around countless times.

But I started wondering:

**What actually makes a club part of the Big Six?**

Is it trophies?

History?

Money?

League performance?

Or a combination of all of them?

So I decided to stop arguing about it and let the data have a say. 😂

I combined club financial data, transfer data, and Premier League performance data to investigate the question.

### Some of the things I found

🔵 Manchester City's revenue grew from **€154M in 2010 to €809M in 2024**.

🔴 Manchester United spent around **€4.5B on wages across four seasons**, but averaged only **66.8 points per season**.

🔴 Arsenal had the highest points per €M spent on wages among the Big Six in my analysis.

🔵 Chelsea had the highest cumulative transfer spending across the 15-year transfer dataset.

And three numbers stood out when I tried to define what "Big Six" actually looks like financially and competitively:

**€400M+ revenue**
**65+ average points**
**50%+ top-four finish rate**

But there's more to the story than those three numbers.

📁 [View the full Day 02 analysis](https://github.com/oyenugatoluwalase3-sudo/30-day-data-analytics-challenge/blob/main/Day02)

---

## 🎬 Day 03 — Do Critics Actually Affect Movie Sales?

This time, I moved from football to Hollywood.

The question was simple:

**If critics give a movie a good review, does that actually translate into more money at the box office?**

I looked at **74 romantic comedy films released between 2007 and 2011** and combined movie information with critic scores from Rotten Tomatoes, Metacritic, and IMDb.

I used Python to collect and clean the additional data, SQL Server to analyse it, and Power BI to turn the results into a dashboard.

### And the answer?

**Not really.**

The correlation between critic scores and US box office revenue was just:

### **0.04**

That's extremely close to zero.

Some of the individual movies made the finding even more interesting.

🍅 **The Twilight Saga: New Moon**
**28% Rotten Tomatoes → $298M US box office**

🎭 **I Love You Phillip Morris**
**71% Rotten Tomatoes → $2M US box office**

And perhaps the strangest result:

Movies with **"Good" reviews (61–80%)** averaged around **$48M** at the box office.

Movies with **"Mixed" reviews (41–60%)** averaged around **$71M**.

So, at least in this dataset:

> **Better reviews didn't necessarily mean more money.**

This doesn't mean critics don't matter.

It means that for these romantic comedies, **critic scores alone weren't a strong predictor of box office success.**

### Tools

`Python` → `Pandas` → `SQL Server` → `Power BI`

📁 [View the full Day 03 analysis](https://github.com/oyenugatoluwalase3-sudo/30-day-data-analytics-challenge/tree/main/Day03)

---

## 🛠️ My Main Tools

### SQL Server

I use SQL for:

- Data cleaning
- Data quality checks
- Data transformation
- Joins
- Aggregations
- Window functions
- Business analysis
- Creating datasets for Power BI

### Python

I use Python when the data needs a little more work before it gets to SQL or Power BI.

For example, in Day 03 I used Python to collect movie information from an external API, combine different datasets, and clean the critic scores.

### Power BI

I use Power BI to turn the analysis into dashboards that make the findings easier to understand.

The goal isn't simply to create charts.

**The goal is to make the important part of the analysis obvious.**

---

## 📂 Repository Structure

```text
30-day-data-analytics-challenge/
│
├── Day01/
│   ├── sql/
│   │   └── day01_does_ads_work.sql
│   ├── dashboard/
│   │   └── day01_dashboard.png
│   └── README.md
│
├── Day02/
│   ├── sql/
│   │   └── day02_big_six_analysis.sql
│   ├── dashboard/
│   │   ├── day02_dashboard.png
│   │   └── day02_dashboard.pbix
│   ├── data/
│   │   ├── club_financials.csv
│   │   ├── transfers_history.csv
│   │   ├── record_transfers.csv
│   │   ├── 2020-2021.txt
│   │   ├── 2021-2022.txt
│   │   ├── 2022-2023.txt
│   │   ├── 2023-2024.txt
│   │   └── 2024-2025.txt
│   └── README.md
│
├── Day03/
│   ├── data/
│   │   ├── Hollywood_s_Most_Profitable_Stories.csv
│   │   ├── omdb_raw.csv
│   │   └── movies_final_analysis.csv
│   ├── scripts/
│   │   ├── 01_omdb_fetch.py
│   │   ├── 02_merge_and_clean.py
│   │   └── 03_day03_analysis.sql
│   ├── dashboard/
│   │   └── day03_critics_vs_cash.png
│   └── README.md
│
└── README.md
```

---

## 🔭 What's Next?

Day 03 is done.

**27 days to go.**

More questions, more datasets, more dashboards, and hopefully more results that don't turn out the way I expected.

Let's see what the data says next.

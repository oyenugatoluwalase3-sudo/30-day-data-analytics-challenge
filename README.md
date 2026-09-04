# 📊 30-Day Data Analytics Challenge

**Author:** Toluwalase  
**Institution:** Federal University of Technology Akure (FUTA) | WorldQuant University  
**Tools:** SQL Server · Power BI  
**Focus:** Data Analytics · Business · Finance · Sports

---

## 🚀 What is this challenge?

I'm spending 30 days answering questions that I genuinely find interesting using data.

Every day, I pick a question, find the data, clean it, analyse it with SQL, build a Power BI dashboard, and share what I discover.

Some questions are about business.

Some are about money.

Some are about football.

The goal isn't to make the analysis look complicated.

**The goal is to use data to answer questions that people actually care about.**

No made-up insights.  
No "pretty dashboard = good analysis."

Just data, SQL, Power BI, and hopefully a few interesting discoveries along the way.

---

## 📅 The Challenge

| Day | Question | Tools | Status |
|---|---|---|---|
| Day 01 | Does Advertising Actually Work? | SQL Server · Power BI | ✅ Completed |
| Day 02 | What Makes a Club the Big Six? | SQL Server · Power BI | ✅ Completed |
| Day 03 | Coming soon... | — | 🔄 |
| Day 04 | Coming soon... | — | 🔄 |
| ... | ... | ... | 🔄 |
| Day 30 | Coming soon... | — | 🔄 |

---

# 📌 Day 01 — Does Advertising Actually Work?

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

📁 [View Day 01](./Day01/)

---

# ⚽ Day 02 — What Makes a Club the Big Six?

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

### Some of the things I found:

🔵 Manchester City's revenue grew from **€154M in 2010 to €809M in 2024**.

🔴 Manchester United spent around **€4.5B on wages across four seasons**, but averaged only **66.8 points per season**.

🔴 Arsenal had the highest points per €M spent on wages among the Big Six in my analysis.

🔵 Chelsea had the highest cumulative transfer spending across the 15-year transfer dataset.

And three numbers stood out when I tried to define what "Big Six" actually looks like financially and competitively:

**€400M+ revenue**  
**65+ average points**  
**50%+ top-four finish rate**

But there's more to the story than those three numbers.

📁 [View the full Day 02 analysis](./Day02/)

---

# 🛠️ My Main Tools

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

### Power BI

I use Power BI to turn the analysis into dashboards that make the findings easier to understand.

---

# 📂 Repository Structure

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
└── README.md

# 30-Day Data Analytics Challenge

**Author:** Toluwalase  
**Institution:** Federal University of Technology Akure (FUTA) | WorldQuant University  
**Tools:** SQL Server · Power BI · Python  
**Focus:** Data Analytics · Business · Finance · Sports · Entertainment · Education

---

## 🚀 What is this challenge?

I'm spending 30 days answering questions that I genuinely find interesting using data.

Every day, I pick a question, find the data, clean it, analyse it, build a Power BI dashboard, and share what I discover.

Some questions are about business.

Some are about money.

Some are about football.

Some are about movies.

And now, some are about education. 🎓

The goal isn't to make the analysis look complicated.

**The goal is to use data to answer questions that people actually care about.**

No made-up insights.  
No "pretty dashboard = good analysis."

Just data, SQL, Python, Power BI, and hopefully a few interesting discoveries along the way.

---

## 📅 The Challenge

| **Day** | **Question** | **Tools** | **Status** |
| ------- | ------------ | --------- | ---------- |
| Day 01 | Does Advertising Actually Work? | SQL Server · Power BI | ✅ Completed |
| Day 02 | What Makes a Club the Big Six? | SQL Server · Power BI | ✅ Completed |
| Day 03 | Do Critics Actually Affect Movie Sales? | Python · SQL Server · Power BI | ✅ Completed |
| Day 04 | Can a School Identify Students Who Might Be At Risk Before the Semester Ends? | SQL Server · Power BI | ✅ Completed |
| ... | Coming soon... | — | 🔄 |
| Day 30 | Coming soon... | — | 🔄 |

---

# 📌 Day 01 — Does Advertising Actually Work?

## The question

**Does advertising actually generate a return, or are companies just spending money and hoping for the best?**

## The data

I analysed a marketing campaign dataset containing **200,000 campaign records**.

## What I found

Every campaign in the dataset had an ROI above 1, meaning each campaign generated more revenue than it cost.

Facebook had the highest average ROI at **5.02**.

But the more interesting finding was that **spending more didn't automatically mean getting better returns**.

The difference in average ROI between high-spend and low-spend campaigns was less than **0.02**.

That suggests something important:

> **The channel you choose may matter more than simply increasing the budget.**

## Tools

`SQL Server` → `Power BI`

📁 [View Day 01](https://github.com/oyenugatoluwalase3-sudo/30-day-analytics-challenge)

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

## Some of the things I found

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

# 🎬 Day 03 — Do Critics Actually Affect Movie Sales?

This time, I moved from football to Hollywood.

The question was simple:

**If critics give a movie a good review, does that actually translate into more money at the box office?**

I looked at **74 romantic comedy films released between 2007 and 2011** and combined movie information with critic scores from Rotten Tomatoes, Metacritic, and IMDb.

I used Python to collect and clean the additional data, SQL Server to analyse it, and Power BI to turn the results into a dashboard.

## And the answer?

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

## Tools

`Python` → `Pandas` → `SQL Server` → `Power BI`

📁 [View the full Day 03 analysis](https://github.com/oyenugatoluwalase3-sudo/30-day-data-analytics-challenge/tree/main/Day03)

---

# 🎓 Day 04 — Can a School Identify Students Who Might Be At Risk Before the Semester Ends?

For Day 4, I moved away from business, football, and movies and looked at something completely different:

**student performance.**

The question I wanted to explore was:

> **Can a school use information available early in the semester to identify students who might be at risk of failing?**

I worked with **1,048 student records** from Mathematics and Portuguese classes.

I used **SQL Server** to clean and analyse the data and **Power BI** to turn the findings into a dashboard.

And honestly, some of the results surprised me.

## 📊 What I found

### Maths and Portuguese had very different grade trends

About **40.3% of Maths students had lower final grades than their Term 1 grades**, compared with about **18.4% of Portuguese students**.

Around **9.8% of Maths students** were classified as At Risk compared with **2.3% in Portuguese**.

This doesn't prove that there is a systemic problem with Maths, but the difference was large enough to make me curious about what other factors could be involved.

---

### 📉 Attendance wasn't as straightforward as I expected

I initially expected students with fewer absences to always have better grades.

But in Maths:

- Students with **0 absences** averaged **8.37**
- Students with **1–5 absences** averaged **11.65**

Portuguese showed more of the pattern I expected, with higher absences generally associated with lower grades.

This was a good reminder that **one variable doesn't always explain the whole story**.

---

### 🏠 Parental education showed a noticeable difference

In Maths:

- Higher parental education group → **11.29 average**
- Lower parental education group → **8.94 average**

That's roughly a **2.35-point difference**.

This doesn't mean parental education causes higher grades.

It simply shows an association in this dataset and raises questions about what factors outside the classroom may be connected to academic performance.

---

### 💻 Internet access also stood out

Students without internet access at home had lower average grades:

- **Maths:** about **1.40 points lower**
- **Portuguese:** about **1.14 points lower**

There were also **68 Maths students without internet access at home**.

This made me think about how access to learning resources outside school could potentially affect performance.

---

### 📚 More study time didn't always mean better results

Students studying around **5–10 hours per week** performed better on average than some students reporting **10+ hours**.

That surprised me.

It was another reminder that spending more time on something doesn't automatically mean better results.

There could be other factors involved, such as study methods, motivation, previous performance, or the difficulty of the subject.

---

## 🚨 The At-Risk Students

One of the biggest things I noticed was that **54 students finished with a final grade of zero**.

When I looked at their earlier grades, all of them showed a declining trend from Term 1.

That made me ask:

> **What if a school could identify students who may need support earlier instead of waiting until the end of the semester?**

A simple early-warning approach could potentially use information such as:

- Term 1 grades
- Grade trends
- Previous failures
- Absence patterns
- Other available student information

The goal wouldn't be to perfectly predict who will fail.

Instead, it could help schools identify students who **might need a closer look or additional support**.

---

## 💰 The Business / Financial Angle

Although this is an education dataset, I wanted to keep the business-thinking approach I've been using throughout the challenge.

The question becomes:

> **Could identifying students earlier be more practical than waiting until the end of the semester?**

Possible interventions could include:

| Possible Intervention | Potential Consideration |
|---|---|
| Early teacher check-in | Relatively low cost |
| Targeted tutoring | Requires additional teacher time |
| Counselling/support | Staff and time required |
| Device/internet support | Higher upfront cost |
| Waiting until the end | Potentially higher remediation cost |

I didn't calculate an actual ROI because the dataset doesn't contain school costs, staffing costs, tuition costs, or intervention outcomes.

So rather than claiming a specific financial return, I used the data to identify **areas where further investigation could be useful**.

---

## 🛠️ Tools

`SQL Server` → Data cleaning + analysis  
`Power BI` → Dashboard + visualization

---

## 📊 Dashboard

I built a three-page Power BI dashboard:

### Page 1 — Overview

- KPI cards
- Performance distribution
- Grade progression
- Subject comparison

### Page 2 — Insights

- Absence analysis
- Parental education
- Study time
- Internet access

### Page 3 — At-Risk Tracker

- Student-level records
- Grade trends
- Conditional formatting
- Potential intervention flags

The dashboard connects to:

`Challenge_day04.vw_StudentDashboard`

---

## ⚠️ A Few Important Limitations

There are some things I had to be careful about when interpreting the results.

### Cross-subject matching

There isn't a shared student ID between the Maths and Portuguese datasets.

So cross-subject matching was done using demographic information such as gender, age, school, and parental education.

Because of this, those matches are **approximate**.

### Duplicate records

I found:

- **8 duplicate rows in Maths**
- **21 duplicate rows in Portuguese**

They didn't significantly change the aggregate analysis, but they are important to keep in mind when doing student-level analysis.

### G3 = 0

A final grade of zero doesn't necessarily mean that a student simply scored zero on an exam.

It can also represent situations such as withdrawal or not taking the final assessment.

For this project, I classified these records as **At Risk**, but that's an analytical decision rather than proof that every student actually failed academically.

### Correlation ≠ causation

This was probably one of the biggest lessons from this project.

For example, students with internet access had higher grades on average.

That doesn't prove that internet access itself caused the higher grades.

The same applies to:

- Parental education
- Attendance
- Study time
- Home location

These are **relationships in the dataset**, not proof of cause and effect.

---

📁 [View the full Day 04 analysis](https://github.com/oyenugatoluwalase3-sudo/30-day-data-analytics-challenge/tree/main/Day04)

---

# 🛠️ My Main Tools

## SQL Server

I use SQL for:

- Data cleaning
- Data quality checks
- Data transformation
- Joins
- Aggregations
- Window functions
- Business analysis
- Creating datasets for Power BI

## Python

I use Python when the data needs a little more work before it gets to SQL or Power BI.

For example, in Day 03 I used Python to collect movie information from an external API, combine different datasets, and clean the critic scores.

## Power BI

I use Power BI to turn the analysis into dashboards that make the findings easier to understand.

The goal isn't simply to create charts.

**The goal is to make the important part of the analysis obvious.**

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
├── Day04/
│   ├── data/
│   │   ├── Maths.csv
│   │   └── Portuguese.csv
│   ├── sql/
│   │   └── Day04_School_Analytics.sql
│   ├── dashboard/
│   │   └── Day04_Dashboard.pbix
│   └── README.md
│
└── README.md
```

---

# 🔭 What's Next?

Day 04 is done.

**26 days to go.**

Four projects down, and I'm already learning that the most interesting part of data analysis isn't always getting the answer you expected.

Sometimes it's finding something you didn't expect and asking:

**"Okay... why is this happening?"**

More questions, more datasets, more SQL, more dashboards, and hopefully more findings that make me stop and look twice.

**Let's see what the data says next. 📊🚀**
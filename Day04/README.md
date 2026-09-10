# 30-Day Data Analytics Challenge

## Day 04 — Can a School Predict Which Student Might Be At Risk Before the Semester Ends?

**Tool Stack:** SQL Server · Power BI  
**Datasets:** `Maths.csv` (397 rows) · `Portuguese.csv` (651 rows)  
**Author:** Toluwalase  
**Challenge Theme:** Sales & Finance — looking at data through the lens of cost, intervention, and resource allocation.

---

## 📌 Project Overview

For Day 4 of my 30-Day Data Analytics Challenge, I decided to work with **student performance data**.

The main question I wanted to explore was:

> **Can a school use information available early in the semester to identify students who might be at risk of failing?**

I worked with **1,048 student records** from Mathematics and Portuguese classes and used **SQL Server for data cleaning and analysis** and **Power BI for visualization**.

What I found was interesting.

Some students who eventually finished with a final grade of zero had already shown signs of declining performance earlier in the semester.

This made me curious about whether schools could use simple academic data to identify students who may need additional support earlier.

---

## 📁 Project Files

| File | Description |
|---|---|
| `Maths.csv` | 397 student records for Mathematics |
| `Portuguese.csv` | 651 student records for Portuguese |
| `Day04_School_Analytics.sql` | SQL script covering the analysis |
| `Day04_Dashboard.pbix` | Power BI dashboard |

---

## 🗃️ Dataset

**Source:** UCI Machine Learning Repository — Student Performance Dataset by Paulo Cortez (2008). The dataset is also available through a Kaggle mirror.

The data covers students from two Portuguese secondary schools and contains information collected from school records and student questionnaires.

### Some of the columns I worked with

| Column | Meaning |
|---|---|
| `G1` | Term 1 grade |
| `G2` | Term 2 grade |
| `G3` | Final grade |
| `absences` | Number of school absences |
| `Medu` | Mother's education level |
| `Fedu` | Father's education level |
| `failures` | Number of previous class failures |
| `internet` | Whether the student has internet access at home |
| `studytime` | Weekly study-time category |
| `address` | Urban or rural home location |

I left out some columns such as `Dalc`, `Walc`, and `romantic` because they weren't directly related to the question I wanted to explore.

---

## 🔧 SQL Analysis Structure

I continued using the same general 9-phase structure I've been using throughout the challenge.

| Phase | What I worked on |
|---|---|
| 1 — Setup | Created the schema, staging tables, and loaded the CSV files |
| 2 — Data Dictionary | Documented the columns and their meanings |
| 3 — Quality Checks | Checked for nulls, duplicates, unusual ages, and G3 = 0 records |
| 4 — Combine & Clean | Combined both datasets and created additional fields |
| 5 — Foundational Analysis | Looked at subject averages and performance groups |
| 6 — Core Analysis | Explored attendance, parental education, internet access, and study time |
| 7 — Window Functions | Used ranking, grade trends, and cumulative analysis |
| 8 — Business Insights | Looked at at-risk students, urban/rural differences, and other patterns |
| 9 — Power BI Queries | Prepared queries for the dashboard visuals |

---

# 📊 What I Found

## 1. Maths and Portuguese showed different grade trends

One of the first things that caught my attention was the difference between the two subjects.

- About **40.3% of Maths students had lower final grades than their Term 1 grades**
- About **18.4% of Portuguese students declined**
- Around **9.8% of Maths students were classified as At Risk**
- Around **2.3% of Portuguese students were classified as At Risk**

The difference made me curious about what other factors might be influencing student performance.

I wouldn't say this proves that there is a "systemic problem" with Maths, because the data alone can't establish that. But it definitely gives me something worth investigating further.

---

## 2. Attendance wasn't as simple as I expected

Before analysing the data, I expected students with fewer absences to automatically have better grades.

The Maths data gave me a different result:

- Students with **0 absences** had an average final grade of **8.37**
- Students with **1–5 absences** had the highest average at **11.65**

Interestingly, Portuguese showed more of the pattern I expected, where higher absence levels were generally associated with lower grades.

This was a good reminder for me that **one variable doesn't always explain the whole story**.

Attendance might be important, but there could be other factors affecting the Maths results.

---

## 3. Parental education showed a noticeable difference

Another pattern I noticed was the relationship between parental education and student grades.

For Maths:

- Higher parental education group → **11.29 average**
- Lower parental education group → **8.94 average**

That's roughly a **2.35-point difference**.

This doesn't mean parental education *causes* higher grades. It simply shows an association in this dataset.

It also made me think about factors outside the classroom that may be connected to academic performance.

---

## 4. Internet access also stood out

Students without internet access at home had lower average grades:

- **Maths:** about **1.40 points lower**
- **Portuguese:** about **1.14 points lower**

There were also **68 Maths students without internet access at home**.

For me, this was one of the more interesting findings because internet access can affect how easily students access learning materials outside school.

It could be worth exploring whether providing better access to learning resources would help, but that would require another study to establish the actual impact.

---

## 5. More study time didn't always mean better results

I also looked at the relationship between weekly study time and grades.

The students studying around **5–10 hours per week** performed better on average than some of the students reporting **10+ hours**.

That surprised me at first.

It reminded me that spending more hours studying doesn't automatically mean the study time is more effective.

There could be other factors involved, such as study methods, motivation, previous academic performance, or the difficulty of the subject.

---

# 🚨 The At-Risk Students

One of the biggest things I noticed during the analysis was that **54 students finished with a final grade of zero**.

When I looked at their earlier grades, all of them showed a declining trend from Term 1.

That made me ask:

> **What if the school could identify these students earlier instead of waiting until the end of the semester?**

A simple system using things like:

- Term 1 performance
- Grade trends
- Previous failures
- Absence patterns
- Other available student information

could potentially help staff identify students who may need additional support.

This doesn't mean the system would perfectly predict who will fail. Rather, it could be used as an **early-warning tool** that helps schools decide where to look more closely.

---

# 💰 Looking at the Business Side

Although this is an education dataset, I wanted to keep the **business-thinking approach** that I'm using throughout this challenge.

The question becomes:

> **Is it cheaper and more effective to identify students who need help early, rather than waiting until the end of the semester?**

For example:

| Possible Intervention | Potential Business Consideration |
|---|---|
| Early teacher check-in | Relatively low cost |
| Targeted tutoring | Requires additional teacher time |
| Counselling/support | Staff and time required |
| Device/internet support | Higher upfront cost |
| Waiting until the end of the semester | Potentially higher remediation cost |

I haven't calculated the actual financial ROI because the dataset doesn't contain school costs, tuition, staffing costs, or intervention outcomes.

Instead, I'm using the data to identify **where an intervention might be worth investigating**.

---

# 📐 Power BI Dashboard

I used Power BI to turn the SQL analysis into an interactive dashboard.

### Dashboard Theme

**Style:** Bold Academic — Dark Navy + Gold

| Element | Value |
|---|---|
| Background | `#0D1B2A` |
| Primary Accent | `#F4C430` |
| At Risk | `#E84855` |
| Positive | `#3BB273` |
| Title Font | Playfair Display |
| Body Font | Montserrat Bold |

### Dashboard Pages

**Page 1 — Overview**

- KPI cards
- Performance distribution
- Grade progression
- Subject comparison

**Page 2 — Insights**

- Absence analysis
- Parental education
- Study time
- Internet access

**Page 3 — At-Risk Tracker**

- Student-level records
- Conditional formatting
- Grade trends
- Potential intervention flags

The dashboard connects to:

`Challenge_day04.vw_StudentDashboard`

---

# ⚠️ Things I Need to Keep in Mind

There are a few limitations with this analysis.

### 1. The cross-subject student matching is approximate

There isn't a shared student ID between the two datasets.

For the cross-subject analysis, I used a combination of demographic information such as gender, age, school, and parental education to create approximate matches.

So those results should be interpreted carefully.

### 2. There are duplicate records

I found:

- **8 duplicate rows in Maths**
- **21 duplicate rows in Portuguese**

These didn't significantly change the aggregate analysis, but they are important to keep in mind when doing student-level analysis.

### 3. G3 = 0 needs to be interpreted carefully

A final grade of zero does not necessarily mean that the student simply scored zero on an exam.

It can also represent situations such as withdrawal or not taking the final assessment.

For this project, I grouped these records as **At Risk**, but that is an analytical choice rather than proof that every student actually failed academically.

### 4. Correlation isn't causation

This is probably the biggest lesson from the project.

Seeing that students with internet access had higher grades doesn't prove that internet access itself caused the higher grades.

The same applies to:

- Parental education
- Attendance
- Study time
- Home location

These are **relationships in the dataset**, not proof of cause and effect.

---

# 🔗 Data Source

Cortez, P. & Silva, A. (2008). *Using Data Mining to Predict Secondary School Student Performance*. University of Minho, Portugal.

Kaggle mirror: [Student Performance Dataset](https://www.kaggle.com/datasets/whenamancodes/student-performance)

---

# 🚀 Part of My 30-Day Data Analytics Challenge

This is **Day 04** of my 30-Day Data Analytics Challenge.

The goal of the challenge is simple:

**30 days → 30 projects → lots of SQL + Power BI practice.**

I'm using different datasets and business questions to improve my ability to:

- Clean and explore data
- Write better SQL queries
- Find useful patterns
- Build Power BI dashboards
- Explain insights clearly
- Think about data from a business perspective

**Day 4 complete. On to Day 5! 📊🚀**

Focus areas: **Sales · Finance · Education · Operations**

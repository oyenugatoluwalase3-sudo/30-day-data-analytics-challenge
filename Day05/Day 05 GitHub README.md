# Day 05 — Do Fashion Shows Actually Make Designers Money?

**30-Day Data Analytics Challenge | SQL Server + Power BI**  
**Author: Toluwalase Adedokun**

---

## 👀 The Question

For Day 5 of my 30-Day Data Analytics Challenge, I wanted to explore a question that came to mind while looking at the fashion industry:

> **Do expensive fashion shows actually translate into better business performance?**

Fashion shows can cost millions of dollars to produce, so I wanted to see what the numbers looked like when I compared brands that participate in runway shows with brands that don't.

This wasn't about trying to prove that fashion shows are either "good" or "bad."

I mainly wanted to explore whether there was any noticeable relationship between runway participation, revenue growth, and brand performance.

---

## 📊 Datasets I Used

I worked with three main datasets:

| Dataset | Source | Rows | What I Used It For |
|---|---|---:|---|
| `Fashion_company_data_set.tsv` | Kaggle | 156 | Revenue data for 13 brands from 2012–2023 |
| `fashion_boutique_dataset.csv` | Kaggle | 2,176 | Product-level information such as prices, markdowns, returns and ratings |
| `fashion_show_benchmarks` | Manually added | 13 | Runway participation and industry benchmark information |

The company dataset gave me the main revenue story, while the boutique dataset gave me additional retail/product-level information to explore.

---

## 🛠️ Tools I Used

- **SQL Server** — importing, cleaning, transforming and analysing the data
- **Power BI** — building the dashboard and visualising the results

---

## 🧹 Some Data Cleaning Challenges

One of the things I noticed while working on this project was that the data wasn't immediately ready for analysis.

I had to deal with a few issues before I could start answering the actual business questions.

| Problem I Found | What I Did |
|---|---|
| Commas inside `company_regions` were causing import problems | Saved the file as TSV and used `FIELDTERMINATOR = '\t'` |
| Some accented characters such as `é` and `ñ` weren't displaying correctly | Used `CODEPAGE = '65001'` during import |
| `annual_revenue` contained carriage returns (`\r`) | Removed them using `REPLACE()` before converting the column |
| `return_reason` contained `\r` values | Replaced those values with `NULL` |
| Some missing values were stored as the text `'NULL'` | Used `NULLIF()` before casting |
| Nike's 2012 store count looked inconsistent with the other years | Investigated it and corrected the value after identifying a data-definition issue |
| YSL's country value used `" in "` instead of a comma | Cleaned the value before splitting the location |
| `total_revenue` stayed the same across multiple yearly rows | Treated it as `peak_reported_revenue` and used `annual_revenue` for yearly analysis |

These issues were actually one of the useful parts of the project for me because they reminded me that **data analysis doesn't start with making charts.**

A lot of the work happens before that.

---

## 🗂️ Data Structure

The basic flow of the project looked like this:

```text
companies_raw (156)          boutique_raw (2,176)
        │                            │
        ▼                            ▼
companies_clean              boutique_clean
        │                            │
        └──────────────┬─────────────┘
                       │
                       ▼
        fashion_show_benchmarks (13)
                       │
                       ▼
              fashion_master (156)
```

I created cleaned versions of the datasets first and then combined the relevant information into a master table for analysis.

---

## 📈 What I Found

After cleaning the data and running my SQL queries, a few results stood out to me.

### 1. Runway Luxury wasn't dramatically different from No-Show Athleisure

The Runway Luxury brands had an average YoY growth of **10.30%**, while No-Show Athleisure averaged **10.49%**.

That made me question the idea that simply participating in runway shows automatically means stronger growth.

---

### 2. Premium brands showed a different pattern

Runway Premium brands averaged around **2.45% YoY growth**, compared with **3.42%** for No-Show Premium brands in my dataset.

Again, this doesn't prove that runway shows caused lower growth.

It just showed me that the relationship wasn't as straightforward as I initially expected.

---

### 3. Prada had a large media value compared with show cost

Based on the benchmark data I used, Prada's runway show cost was estimated at **$3.5M**, while its Media Impact Value was around **$15M**.

That's roughly **4.3x the show cost in media value**.

This made me think about runway shows differently. The value isn't necessarily just about the clothes being sold. There can also be a marketing and brand-awareness component.

---

### 4. Lululemon grew without runway shows

Lululemon's 2023 revenue was about **710% higher than its 2012 baseline** in the dataset, despite being classified as a No-Show brand.

This was probably one of the more interesting comparisons for me because it showed that a company can experience significant growth without relying on traditional runway shows.

---

### 5. The COVID period made the comparison interesting

The data showed a particularly strong recovery for Runway Luxury brands in 2021, with average growth of around **32.58%**.

However, I don't want to interpret this as proof that runway shows caused the recovery.

There were many other things happening during this period, so I treated this as a pattern worth investigating rather than a causal conclusion.

---

### 6. Revenue per store was also interesting

When I calculated revenue per store, there were large differences between brands.

For example, Prada came out at roughly **$88M per store**, while Tommy Hilfiger was around **$27.6M per store** based on the data used in the project.

This made me want to look beyond total revenue and think about how efficiently different brands generate revenue across their store networks.

---

## ⚠️ An Important Note About the Analysis

One thing I wanted to be careful about with this project is **causation**.

The analysis can show patterns between runway participation and revenue performance, but it can't tell me that:

> "Fashion shows caused this brand's revenue to increase."

There are many other factors that could affect revenue, including:

- Brand positioning
- Pricing
- Number of stores
- Product strategy
- Marketing
- Customer demographics
- Business model
- Economic conditions

So classifications such as **"Show Paid Off"** or **"Grew Without Show"** are simply rule-based labels created in my SQL analysis.

They aren't meant to be causal conclusions.

---

## 💻 SQL Script Structure

I organised my SQL work into different stages so that the project wasn't just one huge block of queries.

| Phase | What I Did |
|---|---|
| 1 | Created the database structure and imported the data |
| 2 | Created a data dictionary |
| 3 | Checked for nulls, duplicates, unusual values and inconsistencies |
| 4 | Cleaned the company and boutique datasets |
| 5 | Built the `fashion_master` table |
| 6 | Ran basic exploratory analysis |
| 7 | Analysed the main business questions |
| 8 | Used window functions for more advanced analysis |
| 9 | Created queries for business insights |
| 10 | Prepared queries for the Power BI dashboard |

---

## 📁 Project Files

```text
Day05_FashionShowROI.sql
README.md
```

The SQL file contains the data preparation, cleaning, analysis and reporting queries used for this project.

---

## 💭 What I Learned

The biggest thing I took away from this project wasn't a simple answer to whether fashion shows "make money."

It was learning how to take a question that sounds simple, turn it into something I can actually measure, clean messy data, and then be careful about what the results really tell me.

I'm also getting more comfortable with SQL, especially with cleaning data and using window functions for comparisons across brands and years.

This is **Day 5 of 30** — and I'm looking forward to seeing what question I end up investigating next.

---
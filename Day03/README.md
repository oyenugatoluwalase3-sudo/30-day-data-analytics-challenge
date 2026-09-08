# Day 03 — Do Critics Actually Affect Movie Sales?

> **30-Day Data Analytics Challenge**
> **Tools:** Python · SQL Server · Power BI
> **Industry:** Entertainment

---

## 🎬 The Question

Hollywood spends a lot of money making movies people will want to watch.

But here's something I wanted to find out:

**Does getting good reviews from critics actually help a movie make more money?**

In other words, if critics love a movie, do audiences show up at the cinema?

To answer this, I looked at **74 romantic comedy movies released between 2007 and 2011**. I combined movie and financial information with critic scores from Rotten Tomatoes, then used Python, SQL Server, and Power BI to analyse the data.

And the result surprised me.

### **The answer is: Not really.**

The relationship between critic scores and US box office revenue was almost nonexistent:

**Correlation = 0.04**

A correlation of 0 would mean there is no relationship at all, so **0.04 is extremely close to zero.**

---

## 📊 The Dashboard

![Critics vs Cash Dashboard](dashboard/day03_critics_vs_cash.png)

The dashboard was built to answer a simple business question:

> **Do better reviews lead to more money at the box office?**

Rather than just looking at individual movies, I compared critic scores with revenue, grouped movies into review categories, and looked for patterns that could actually tell us something about movie performance.

---

## 🔎 What Did the Data Show?

### 1. Critics and box office revenue were barely connected

The correlation between Rotten Tomatoes scores and US box office revenue was **0.04**.

That's so close to zero that, for this dataset, **a higher critic score did not meaningfully predict higher box office revenue.**

---

### 2. Most of these movies weren't highly rated

Across the 74 movies, the average Rotten Tomatoes score was only **47.4%**.

That means the typical movie in this dataset was actually in the **"Rotten"** range.

Yet many of these movies still made money.

---

### 3. The average movie made about $63.9M in the US

The 74 movies generated an average US box office revenue of approximately:

**$63.9 million**

This gives us a useful baseline for comparing movies with different critic scores.

---

### 4. One of the biggest earners had a terrible critic score

**The Twilight Saga: New Moon** made approximately **$298M** in the US despite having only a **28% Rotten Tomatoes score**.

That's a pretty good example of why critic approval isn't everything.

Audiences clearly had reasons to watch the movie that weren't reflected in the critics' score.

---

### 5. A critically acclaimed movie can still flop

**I Love You Phillip Morris** had a **71% Rotten Tomatoes score**, putting it in the "Good" category.

But it made only around **$2M** at the US box office.

So again, a good review didn't guarantee commercial success.

---

### 6. The most interesting result

I grouped the movies according to their Rotten Tomatoes scores:

| Critic Score   | Average US Box Office |
| -------------- | --------------------: |
| Mixed (41–60%) |              **$71M** |
| Good (61–80%)  |              **$48M** |

Interestingly, movies with **"Mixed" reviews actually made more money on average than movies with "Good" reviews.**

That's not what we'd expect if critic scores were a major driver of ticket sales.

---

## 💡 So, What Does This Mean?

For this particular group of romantic comedies, **critical approval doesn't appear to be a strong predictor of box office success.**

A movie doesn't necessarily need great reviews to make money.

And a movie with great reviews isn't guaranteed to attract a large audience.

This suggests that other factors — such as **audience interest, popularity of the actors, franchise recognition, marketing, release timing, and word of mouth** — may have a much bigger influence on how many people actually buy tickets.

### The takeaway:

> **Critics may influence how a movie is perceived, but in this dataset, they didn't appear to be driving the money.**

---

## 🛠️ How I Built This Analysis

I didn't just put the data into Power BI and make a few charts.

I built a small data pipeline that took the information from its original sources and turned it into something I could analyse.

### The process

**1. Start with movie data**

I used a Kaggle dataset containing information about Hollywood movies, including their genre, studio, profitability, and financial performance.

↓

**2. Add critic information**

Some of the information I needed wasn't in the original dataset, so I used the OMDb API to collect additional movie information, including Rotten Tomatoes scores.

↓

**3. Clean and combine the data**

Using Python and Pandas, I combined the two datasets, cleaned the scores, handled missing values, and prepared the data for analysis.

↓

**4. Analyse the data with SQL**

I loaded the cleaned dataset into SQL Server and used SQL queries to investigate patterns such as critic score categories, average revenue, rankings, blockbusters, and flops.

↓

**5. Turn the results into a dashboard**

Finally, I connected Power BI to the SQL Server data and built an interactive dashboard that makes the findings easier to understand.

---

## 🧰 Tools I Used

| Tool           | What I Used It For                                       |
| -------------- | -------------------------------------------------------- |
| **Python**     | Collecting, combining, and cleaning the data             |
| **OMDb API**   | Getting additional movie and critic information          |
| **SQL Server** | Storing the data and performing the analysis             |
| **Power BI**   | Building the final dashboard and presenting the findings |

---

## 📁 What's Inside This Folder?

| File                                           | What It Contains                                       |
| ---------------------------------------------- | ------------------------------------------------------ |
| `data/Hollywood_s_Most_Profitable_Stories.csv` | The original movie dataset                             |
| `data/omdb_raw.csv`                            | Movie information collected from the OMDb API          |
| `data/movies_final_analysis.csv`               | The cleaned and combined dataset used for the analysis |
| `scripts/01_omdb_fetch.py`                     | Collects additional movie information                  |
| `scripts/02_merge_and_clean.py`                | Combines and cleans the datasets                       |
| `scripts/03_day03_analysis.sql`                | SQL database setup and analysis                        |
| `dashboard/day03_critics_vs_cash.png`          | Screenshot of the final Power BI dashboard             |

---

## 🧠 What I Practised

This project helped me practise more than just creating charts.

I worked through the full process of taking relatively messy data and turning it into a business insight:

- Collecting data from an external API
- Cleaning and combining different datasets
- Working with missing and inconsistent values
- Loading data into SQL Server
- Writing SQL queries for business analysis
- Using rankings and other SQL window functions
- Calculating correlations and comparing groups
- Building a Power BI dashboard
- Turning numbers into a simple business story

---

## ▶️ Want to Reproduce the Analysis?

If you'd like to run the project yourself:

1. Get a free OMDb API key at http://www.omdbapi.com/apikey.aspx
2. Add the key to `scripts/01_omdb_fetch.py`
3. Run the Python script to collect the movie information
4. Run `scripts/02_merge_and_clean.py` to create the final dataset
5. Open SQL Server Management Studio
6. Run `scripts/03_day03_analysis.sql`
7. Update the `BULK INSERT` file paths if necessary
8. Connect Power BI Desktop to the SQL Server database
9. Load the `Challenge_day03.movies_clean` table
10. Explore the results

---

## 👋 About the Project

**Toluwalase**
300-Level Computer Science Student, FUTA

This project is part of my **30-Day Data Analytics Challenge**, where I'm building projects around real-world questions and practising how to turn raw data into insights that people can actually understand and use.

**Day 03 of 30**

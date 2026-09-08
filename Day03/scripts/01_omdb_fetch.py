# ============================================================
# Day 03 — 30-Day Data Analytics Challenge
# Script 01: Fetch Movie Data from OMDb API
# Author: Toluwalase
# ============================================================

import requests
import pandas as pd
import time

API_KEY = "YOUR_KEY_HERE"
BASE_URL = "http://www.omdbapi.com/"

# ---- Load source CSV ----
df_source = pd.read_csv("Hollywood_s Most Profitable Stories.csv")
titles_and_years = df_source[["Film", "Year"]].dropna().drop_duplicates().values.tolist()

print(f"Fetching data for {len(titles_and_years)} movies...\n")

# ---- Corrections for known mismatches ----
TITLE_FIXES = {
    "(500) Days of Summer":                {"i": "tt1022603"},
    "Beginners":                           {"i": "tt1532503"},
    "I Love You Phillip Morris":           {"i": "tt1045772"},
    "Penelope":                            {"i": "tt0472160"},
    "WALL-E":                              {"i": "tt0910970"},
    "Waiting For Forever":                 {"i": "tt1296898"},
    "Youth in Revolt":                     {"i": "tt0403702"},
    "Gnomeo and Juliet":                   {"t": "Gnomeo & Juliet",                            "y": "2011"},
    "Marley and Me":                       {"t": "Marley & Me",                                "y": "2008"},
    "Twilight: Breaking Dawn":             {"t": "The Twilight Saga: Breaking Dawn - Part 1",  "y": "2011"},
    "Tyler Perry's Why Did I get Married": {"t": "Why Did I Get Married?",                     "y": "2007"},
}

def clean_money(value):
    if not value or value in ("N/A", "", "-"):
        return None
    value = value.replace("$", "").replace(",", "").strip()
    multiplier = 1
    if value.endswith("B"):
        multiplier = 1_000_000_000
        value = value[:-1]
    elif value.endswith("M"):
        multiplier = 1_000_000
        value = value[:-1]
    try:
        return int(float(value) * multiplier)
    except ValueError:
        return None

def get_rating(ratings_list, source_name):
    for r in ratings_list:
        if r["Source"] == source_name:
            return r["Value"]
    return None

results = []

for title, year in titles_and_years:
    try:
        if title in TITLE_FIXES:
            params = {**TITLE_FIXES[title], "type": "movie", "apikey": API_KEY}
        else:
            params = {"t": title, "y": str(int(year)), "type": "movie", "apikey": API_KEY}

        response = requests.get(BASE_URL, params=params, timeout=10)
        response.raise_for_status()
        data = response.json()

        if data.get("Response") == "False":
            print(f"  ⚠️  Not found: '{title}' — {data.get('Error')}")
            results.append({"title_searched": title, "year_searched": year})
            continue

        ratings = data.get("Ratings", [])
        omdb_title = data.get("Title", "")
        mismatch = "⚠️ CHECK" if title.lower() not in omdb_title.lower() else ""

        results.append({
            "title_searched":   title,
            "title_omdb":       omdb_title,
            "year":             data.get("Year"),
            "genre":            data.get("Genre"),
            "box_office":       clean_money(data.get("BoxOffice")),
            "box_office_raw":   data.get("BoxOffice"),
            "imdb_rating":      data.get("imdbRating"),
            "imdb_votes":       data.get("imdbVotes"),
            "rt_score":         get_rating(ratings, "Rotten Tomatoes"),
            "metacritic_score": get_rating(ratings, "Metacritic"),
            "rated":            data.get("Rated"),
            "runtime":          data.get("Runtime"),
        })

        print(f"  ✅ '{title}' → '{omdb_title}' ({data.get('Year')}) {mismatch}")

    except requests.exceptions.Timeout:
        print(f"  ❌ TIMEOUT: '{title}'")
        results.append({"title_searched": title, "year_searched": year})
    except requests.exceptions.ConnectionError:
        print(f"  ❌ CONNECTION ERROR: '{title}'")
        results.append({"title_searched": title, "year_searched": year})
    except requests.exceptions.HTTPError as e:
        print(f"  ❌ HTTP ERROR: '{title}' — {e}")
        results.append({"title_searched": title, "year_searched": year})
    except Exception as e:
        print(f"  ❌ UNEXPECTED ERROR: '{title}' — {e}")
        results.append({"title_searched": title, "year_searched": year})

    time.sleep(0.3)

df_omdb = pd.DataFrame(results)

print(f"\n{'='*50}")
print(f"Total rows:            {len(df_omdb)}")
if "box_office" in df_omdb.columns:
    print(f"Has box office data:   {df_omdb['box_office'].notna().sum()}")
    print(f"Missing box office:    {df_omdb['box_office'].isna().sum()}")
print(f"{'='*50}\n")
print(df_omdb.head(5).to_string())

df_omdb.to_csv("omdb_raw.csv", index=False)
print("\nSaved to omdb_raw.csv ✅")

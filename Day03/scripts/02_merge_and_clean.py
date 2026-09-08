# ============================================================
# Day 03 — 30-Day Data Analytics Challenge
# Script 02: Merge Datasets and Clean Scores
# Author: Toluwalase
# ============================================================

import pandas as pd

print("Loading datasets...")
df_source = pd.read_csv("Hollywood_s Most Profitable Stories.csv")
df_omdb   = pd.read_csv("omdb_raw.csv")

print(f"Hollywood CSV: {len(df_source)} rows")
print(f"OMDb CSV:      {len(df_omdb)} rows")

# ---- Merge ----
print("\nMerging...")
df_merged = pd.merge(
    df_source,
    df_omdb,
    left_on  = "Film",
    right_on = "title_searched",
    how      = "left"
)
print(f"Merged: {len(df_merged)} rows")

# ---- Clean the Scores & Numbers ----
print("\nCleaning string artifacts into pure numbers...")

# 1. Clean Rotten Tomatoes (e.g., "86%" -> 86.0)
df_merged['rt_score_omdb'] = (
    df_merged['rt_score']
    .str.replace('%', '', regex=False)
    .astype(float)
)

# 2. Clean Metacritic (e.g., "76/100" -> 76.0)
df_merged['metacritic_clean'] = (
    df_merged['metacritic_score']
    .str.split('/')
    .str[0]
    .astype(float)
)

# 3. Clean IMDb Votes (e.g., "613,237" -> 613237.0)
df_merged['imdb_votes_clean'] = (
    df_merged['imdb_votes']
    .str.replace(',', '', regex=False)
    .astype(float)
)

# 4. Ensure IMDB Rating is a float (e.g., "7.6" -> 7.6)
df_merged['imdb_rating'] = df_merged['imdb_rating'].astype(float)

# ---- Select Final Columns ----
final_columns = [
    'Film', 'Genre', 'Lead Studio', 'Year',
    'Worldwide Gross', 'Profitability',
    'box_office',
    'rt_score_omdb', 'metacritic_clean', 'imdb_rating',
    'imdb_votes_clean', 'rated', 'runtime'
]
df_final = df_merged[final_columns]

# ---- Fix line endings for SQL Server BULK INSERT ----
print("\nFixing line endings for SQL Server compatibility...")
df_final.to_csv("movies_final_analysis.csv", index=False, lineterminator="\n")

# Re-write with guaranteed Unix endings
with open("movies_final_analysis.csv", "r", encoding="utf-8") as f:
    content = f.read()
with open("movies_final_analysis.csv", "w", encoding="utf-8", newline="\n") as f:
    f.write(content)

print(f"\nMerge complete! Saved to movies_final_analysis.csv ✅")
print(f"Shape: {df_final.shape}")
print("\nPreview:")
print(df_final.head())

# IMDb Movie Database — SQL Case Study

## 📌 Project Overview

This project analyzes an IMDb movie database to provide data-driven insights for **RSVP Movies**, an Indian production company planning a global release.

The analysis covers **29 business questions** across four areas:
- Movies & Genres
- Ratings Analysis
- Names, Cast & Crew
- Advanced Analytics

## 🗂️ Dataset & Schema

The database uses a six-table IMDb schema covering movies released from **2017–2019**:

- `movie` — movie details, release information, country, languages, revenue and production company
- `genre` — movie-to-genre mapping
- `ratings` — average rating, total votes and median rating
- `names` — actor, actress and director information
- `director_mapping` — movie-to-director mapping
- `role_mapping` — movie-to-cast mapping

## 🛠️ Tools & SQL Skills

**Tools:** MySQL 8, MySQL Workbench, IMDb Dataset

**SQL Concepts Used:**
- SELECT, WHERE, GROUP BY, HAVING, ORDER BY
- Aggregate functions: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- INNER JOIN and LEFT JOIN
- Common Table Expressions (CTEs)
- Window functions: `DENSE_RANK`, `ROW_NUMBER`, `LAG`
- Running totals and moving averages
- `CASE` statements for rating classification
- NULL/data-quality analysis
- String cleaning and numeric conversion using `REPLACE` and `CAST`
- Date analysis using `DATEDIFF`

## 🔎 Analysis Highlights

### 1. Movies & Genres
Analyzed yearly and monthly release trends, genre distribution, genre rankings, single-genre movies and average movie duration.

### 2. Ratings Analysis
Explored rating distributions, top-rated movies, hit production houses, vote patterns and country-level comparisons.

### 3. Names, Cast & Crew
Ranked directors, actors and actresses based on movie performance, ratings and audience votes.

### 4. Advanced Analytics
Applied window functions for running totals, moving averages, movie rankings, multilingual hit analysis and director-level performance metrics.

## 📊 Key Findings

- **Drama** was the largest genre by production volume with **4,285 movie-genre records**.
- **3,289 movies** belonged to exactly one genre.
- **887 movies** from the USA or India were released in 2019.
- German movies received approximately **2.03M votes**, compared with **0.70M** for Italian movies.
- **Marvel Studios, Twentieth Century Fox and Warner Bros.** ranked highest by total audience votes.
- **Vijay Sethupathi** ranked first among Indian actors using the vote-weighted rating approach.
- **Taapsee Pannu** ranked first among the analyzed Hindi actresses.
- The analysis suggested a **100–110 minute** target runtime, with Drama as a leading genre and Thriller as a potential supporting genre.

## 💡 Business Recommendation

Based on the analysis, RSVP Movies should consider a **Drama-led international movie with a Thriller element**, target a **100–110 minute runtime**, select talent from the strongest rating-based shortlists, and explore partnerships with high-reach production houses.

## 📁 Project Files

- `IMDB+dataset+import.sql` — database/data import script
- `IMDB+question(1).sql` — SQL questions and solutions
- `IMDb+movies+Data+and+ERD+final.xlsx` — dataset and ERD reference
- `IMDb_SQL_Case_Study_v2.pptx` — detailed case study, queries, outputs and findings

## 👤 Author

**Dipanshu Rangari**

**Focus:** Data Analytics | SQL | Power BI | Python

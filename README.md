# Netflix SQL EDA

Exploratory Data Analysis on the Netflix Movies and TV Shows dataset using MySQL. The project answers 14 business questions using SQL queries — covering content type distribution, ratings, durations, and more.

**Dataset:** [Netflix Movies and TV Shows (Kaggle)](https://www.kaggle.com/datasets/shivamb/netflix-shows)
**Tool:** MySQL

---

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT
    type,
    COUNT(*) AS total_count
FROM netfix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

---

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT type, rating
FROM (
    SELECT type, rating, COUNT(*),
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netfix
    GROUP BY type, rating
) t
WHERE t.ranking = 1;
```

**Objective:** Identify the most frequently assigned rating for each content type.

---

### 3. List All Movies Released in a Specific Year (e.g. 2020)

```sql
SELECT *
FROM netfix
WHERE type = 'Movie' AND release_year = '2020';
```

**Objective:** Retrieve all movies released in a chosen year.

---

### 4. Identify the Longest Movie

```sql
SELECT *
FROM netfix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;
```

**Objective:** Find the movie with the longest runtime.

---

### 5. Find Content Added in the Last Five Years

```sql
SELECT title, STR_TO_DATE(date_added, '%M %d, %Y') AS date_added
FROM netfix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= (CURRENT_DATE - INTERVAL 5 YEAR)
ORDER BY STR_TO_DATE(date_added, '%M %d, %Y') DESC;
```

**Objective:** Analyze recent content additions to the platform.

---

### 6. Find All TV Shows/Movies by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM netfix
WHERE director LIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by a specific director.

---

### 7. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netfix
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
```

**Objective:** Identify long-running TV shows with more than 5 seasons.

---

### 8. Find Each Year and the Average Number of Content Releases by India — Top 5 Years

```sql
SELECT
    EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) AS year,
    COUNT(*) AS yearly_content,
    COUNT(*) / (SELECT COUNT(*) FROM netfix WHERE country = 'India') * 100 AS avg_content_per_year
FROM netfix
WHERE country = 'India'
GROUP BY EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y'))
ORDER BY avg_content_per_year DESC
LIMIT 5;
```

**Objective:** Calculate and rank average content releases by India across years.

---

### 9. List All Movies that are Documentaries

```sql
SELECT *
FROM netfix
WHERE listed_in LIKE '%Documentaries%';
```

**Objective:** Retrieve all documentary titles.

---

### 10. Find All Content Without a Director

```sql
SELECT *
FROM netfix
WHERE director IS NULL
   OR TRIM(director) = '';
```

**Objective:** Identify content entries missing director information.

---

### 11. Find the Number of Movies Actor 'Salman Khan' Appeared in the Last 15 Years

```sql
SELECT *
FROM netfix
WHERE casts LIKE '%Salman Khan%'
  AND release_year = EXTRACT(YEAR FROM CURRENT_DATE) - 15;
```

**Objective:** Track a specific actor's appearances within a recent time window.

---

### 12. Categorize Content as 'Good' or 'Bad' Based on Keywords in the Description

```sql
SELECT content_type, COUNT(*)
FROM (
    SELECT *,
        CASE
            WHEN description LIKE '%bad%' OR description LIKE '%violence%' THEN 'bad'
            ELSE 'good'
        END AS content_type
    FROM netfix
) t
GROUP BY content_type;
```

**Objective:** Classify content based on the presence of sensitive keywords and count each category.

---

### 13. Calculate Total Movies and TV Shows Added Each Year

```sql
SELECT
    EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) AS year,
    COUNT(show_id) AS total_added
FROM netfix
WHERE EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) IS NOT NULL
GROUP BY year
ORDER BY year DESC;
```

**Objective:** Track how content additions have trended over time.

---

### 14. Find Titles Released Before 2000 but Added After 2015 (Age Gap)

```sql
SELECT
    title,
    release_year,
    date_added,
    (EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d,%Y')) - release_year) AS year_gap
FROM netfix
WHERE EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d,%Y')) > 2015
  AND release_year < 2000
ORDER BY year_gap DESC;
```

**Objective:** Find older titles that were added to Netflix long after their original release, and measure the gap.

---

## Key Findings

- Movies make up a larger share of the catalog than TV shows.
- A small number of ratings (e.g. TV-MA, TV-14) dominate across both content types.
- Content additions grew sharply in the years leading up to 2020.

## Author

Siddhant — B.Tech, Biomedical Engineering, NIT Raipur

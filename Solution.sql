-- Netflix Data Analysis using SQL
-- Solutions of 14 business problems


-- Q1 Count the number of movies vs TV shows.

SELECT type,COUNT(*) AS total_count
 FROM netfix
GROUP BY type;
 
-- Q2  Find the most common rating for movies and TV shows


SELECT type, rating FROM (SELECT type, rating, COUNT(*), 
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS 'ranking'
FROM netfix
GROUP BY type, rating) t
WHERE t.ranking=1;

-- Q3 List all movies released in a specific year


SELECT *
FROM netfix
WHERE type ='Movie' AND release_year='2020';


-- Q4 Identify the longest movie

SELECT * FROM netfix
WHERE type='Movie' 
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1)AS UNSIGNED) DESC 
LIMIT 1;

-- Q5 Find the content added in the last five years

SELECT title, STR_TO_DATE(date_added, '%M %d, %Y')
FROM netfix
WHERE STR_TO_DATE(date_added, '%M %d, %Y')>= (CURRENT_DATE - INTERVAL 5 YEAR )
ORDER BY STR_TO_DATE(date_added, '%M %d, %Y') DESC;

-- Q6  Find all the TV shows/movies by director 'Rajiv Chilaka' !

SELECT * FROM netfix
WHERE director LIKE '%Rajiv Chilaka%';

-- Q7 List all the TV shows with more than 5 seasons.

SELECT * FROM netfix
WHERE type= "TV Show" AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)>5;

-- Q8 . Find each year and the average numbers of content release by India on netflix. 
--         return top 5 year with highest avg content release !

SELECT  EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')), COUNT(*) AS "yearly_content",
COUNT(*)/ (SELECT COUNT(*) FROM netfix WHERE country='India') *100 AS "avg_content_per_year"
FROM netfix
WHERE country='India'
GROUP BY EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) 
ORDER BY COUNT(*)/ (SELECT COUNT(*) FROM netfix WHERE country='India') *100 DESC LIMIT 5;


-- Q9 List all movies that are documentries


SELECT * FROM netfix
WHERE listed_in LIKE "%Documentaries%";

-- Q10 Find all the content without the director 

SELECT * FROM netfix
WHERE director IS NULL
OR TRIM(director)='';

-- Q11 Find the number of movies actor 'Salman Khan' appeared in last 15 years

SELECT * FROM netfix
WHERE casts LIKE "%Salman Khan%" AND release_year= EXTRACT(YEAR FROM CURRENT_DATE) - 15;

-- Q12 Categorize the content based on the presence of the keywords 'kill' and 'violence' 
-- in the description field. Label content containing these keywords as 'Bad' 
-- and all other content as 'Good'. Count how many items fall into each category.

SELECT content_type, COUNT(*)	FROM (SELECT * ,
CASE
WHEN  description LIKE "%bad%" OR description LIKE "%violence%" THEN 'bad'
ELSE 'good'
END content_type
FROM netfix) t
GROUP BY content_type;

-- Q13 Calculate the total number of Movies and TV Shows added to Netflix for each year, 
-- sorted chronologically.


SELECT EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')), COUNT(show_id) FROM netfix
WHERE EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y'))  IS NOT NULL
GROUP BY EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y'))
ORDER BY EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) DESC;

-- Q14 Find all titles released prior to 2000 that were added to Netflix after 2015, 
-- calculating the age gap in years.

SELECT title, 
release_year, 
date_added, 
(EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d,%Y'))-release_year) AS 'year_gap' FROM netfix
WHERE EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d,%Y'))>2015 AND 
release_year<2000
ORDER BY year_gap DESC;

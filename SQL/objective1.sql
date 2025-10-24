-- Objective 1

-- Most popular girl name
SELECT
	name AS most_popular_female_name
FROM names
WHERE gender = 'F'
GROUP BY name
ORDER BY SUM(births) DESC
LIMIT 1; -- Jessica

-- Most popular boy name
SELECT
	name AS most_popular_male_name
FROM names
WHERE gender = 'M'
GROUP BY name
ORDER BY SUM(births) DESC
LIMIT 1; -- Michael

-- Show Jessica's ranking over the years
SELECT
	*
FROM
	(SELECT
		name,
		year,
		ROW_NUMBER() OVER(PARTITION BY year ORDER BY SUM(births) DESC) AS ranking
	FROM names
	WHERE gender = 'F'
	GROUP BY year, name) AS subq
WHERE name = 'Jessica';

-- Show Michael's ranking over the years
SELECT
	*
FROM
	(SELECT
		name,
		year,
		ROW_NUMBER() OVER(PARTITION BY year ORDER BY SUM(births) DESC) AS ranking
	FROM names
	WHERE gender = 'M'
	GROUP BY year, name) AS subq
WHERE name = 'Michael';

-- Find names with biggest jumps in popularity from first to last year
WITH year_1980 AS
	(SELECT
		name,
		year,
		gender,
		ROW_NUMBER() OVER(PARTITION BY year ORDER BY SUM(births) DESC) AS ranking
	FROM names
	WHERE year = 1980
	GROUP BY year, gender, name),

year_2009 AS
	(SELECT
		name,
		year,
		gender,
		ROW_NUMBER() OVER(PARTITION BY year ORDER BY SUM(births) DESC) AS ranking
	FROM names
	WHERE year = 2009
	GROUP BY year, gender, name)

SELECT
	y1980.name,
	y1980.gender,
	y2009.ranking - y1980.ranking AS rank_diff
FROM year_1980 AS y1980
	INNER JOIN year_2009 AS y2009
		ON y1980.name = y2009.name AND y1980.gender = y2009.gender
ORDER BY rank_diff DESC

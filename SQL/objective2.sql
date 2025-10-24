-- Objective 2

-- 3 most popular girl names each year
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
WHERE ranking IN (1, 2, 3);

-- 3 most popular boy names each year
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
WHERE ranking IN (1, 2, 3);

-- 3 most popular girl names per decade
SELECT
	*
FROM
	(SELECT
		name,
		(year / 10) * 10 AS decade,
		ROW_NUMBER() OVER(PARTITION BY (year / 10) * 10 ORDER BY SUM(births) DESC) AS ranking
	FROM names
	WHERE gender = 'F'
	GROUP BY (year / 10) * 10, name) AS subq
WHERE ranking IN(1,2,3);

SELECT -- re-write to stop decade calc repetition
	*
FROM
	(SELECT
		name,
		decade,
		ROW_NUMBER() OVER(PARTITION BY decade ORDER BY SUM(births) DESC) AS ranking
	FROM
		(SELECT
			name,
			(year / 10) * 10 AS decade,
			births,
			gender
		FROM names) AS decade_subq
	WHERE gender = 'F'
	GROUP BY decade, name) AS subq
WHERE ranking IN(1,2,3);

-- 3 most popular boy names per decade
SELECT
	*
FROM
	(SELECT
		name,
		(year / 10) * 10 AS decade,
		ROW_NUMBER() OVER(PARTITION BY (year / 10) * 10 ORDER BY SUM(births) DESC) AS ranking
	FROM names
	WHERE gender = 'M'
	GROUP BY (year / 10) * 10, name) AS subq
WHERE ranking IN(1,2,3);

SELECT -- re-write to stop decade calc repetition
	*
FROM
	(SELECT
		name,
		decade,
		ROW_NUMBER() OVER(PARTITION BY decade ORDER BY SUM(births) DESC) AS ranking
	FROM
		(SELECT
			name,
			(year / 10) * 10 AS decade,
			births,
			gender
		FROM names) AS decade_subq
	WHERE gender = 'M'
	GROUP BY decade, name) AS subq
WHERE ranking IN(1,2,3);
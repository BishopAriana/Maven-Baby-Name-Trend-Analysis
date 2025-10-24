-- Objective 3

-- It says MI needs to be in Midwest in the region table so I added it in:
-- INSERT INTO regions VALUES ('AL', 'South')

-- After running my first query I say that New England and New_England are 2 regions
/*UPDATE regions
SET region = 'New_England'
WHERE region = 'New England';*/

-- Return the number of babies born in each of the six regions
SELECT
	r.region,
	SUM(births) AS total_births
FROM names AS n
	INNER JOIN regions AS r
		ON n.state = r.state
GROUP BY r.region;

-- 3 most popular girl names per region
SELECT
	*
FROM
	(SELECT
		r.region,
		n.name,
		ROW_NUMBER() OVER(PARTITION BY r.region ORDER BY SUM(births) DESC) AS ranking
	FROM names AS n
		INNER JOIN regions AS r
			ON n.state = r.state
	WHERE n.gender = 'F'
	GROUP BY r.region, n.name)
WHERE ranking IN(1,2,3);

-- 3 most popular boy names per region
SELECT
	*
FROM
	(SELECT
		r.region,
		n.name,
		ROW_NUMBER() OVER(PARTITION BY r.region ORDER BY SUM(births) DESC) AS ranking
	FROM names AS n
		INNER JOIN regions AS r
			ON n.state = r.state
	WHERE n.gender = 'M'
	GROUP BY r.region, n.name)
WHERE ranking IN(1,2,3);

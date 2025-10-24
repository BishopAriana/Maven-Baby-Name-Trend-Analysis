-- Objective 4

-- 10 most popular androgynous names
WITH female AS
	(SELECT
		name,
		SUM(births) AS total_births
	FROM names
	WHERE gender = 'F'
	GROUP BY name),

male AS
	(SELECT
		name,
		SUM(births) AS total_births
	FROM names
	WHERE gender = 'M'
	GROUP BY name)

SELECT
	f.name,
	(f.total_births + m.total_births) AS total_births
FROM female AS f
	INNER JOIN male AS m
		ON f.name = m.name
ORDER BY total_births DESC
LIMIT 10;

-- shortest name length
SELECT
	MIN(LENGTH(NAME))
FROM names; -- 2

-- longest name length
SELECT
	MAX(LENGTH(NAME))
FROM names; -- 15

-- Most popular short names
SELECT
	name,
	SUM(births) AS births
FROM names
WHERE LENGTH(name) = 2
GROUP BY name
ORDER BY SUM(births) DESC;

-- Most popular long names
SELECT
	name,
	SUM(births) AS births
FROM names
WHERE LENGTH(name) = 15
GROUP BY name
ORDER BY SUM(births) DESC;

-- Find the state with the highest percentage of babies named Chris
WITH st_births AS
	(SELECT
		state,
		CAST(SUM(births) AS FLOAT) AS total_state_births
	FROM names
	GROUP BY state),

ch_births AS
	(SELECT
		state,
		CAST(SUM(births) AS FLOAT) AS total_chris_births
	FROM names
	WHERE name = 'Chris'
	GROUP BY state)

SELECT
	st.state,
	(ch.total_chris_births / st.total_state_births) * 100 AS pct_babies_named_chris
FROM st_births AS st
	INNER JOIN ch_births AS ch
		ON st.state = ch.state
ORDER BY pct_babies_named_chris DESC;
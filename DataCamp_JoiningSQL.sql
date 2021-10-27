--Week 06 and 07 Data Camp - Joining Data in SQL

--Inner Join
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;

SELECT * 
FROM cities
  -- Inner join to countries
  INNER JOIN countries
    -- Match on the country codes
    ON cities.country_code = countries.code;


--Modify the SELECT statement to keep only the name of the city, the name of the country, and the name of the region the country resides in.
--Alias the name of the city AS city and the name of the country AS country.
-- Select name fields (with alias) and region 
SELECT cities.name AS city, countries.name AS country, region
FROM cities
  INNER JOIN countries
    ON cities.country_code = countries.code;

SELECT c1.name AS city, c2.name AS country
FROM cities AS c1
INNER JOIN countries AS c2
ON c1.country_code = c2.code;

--Join the tables countries (left) and economies (right) aliasing countries AS c and economies AS e.
--Specify the field to match the tables ON.
--From this join, SELECT:
--c.code, aliased as country_code.
--name, year, and inflation_rate, not aliased.
SELECT c.code AS country_code, name, year, inflation_rate
FROM countries AS c
  INNER JOIN economies as e
    ON c.code = e.code;

--Inner Join 3 tables
SELECT *
FROM left_table
  INNER JOIN right_table
    ON left_table.id = right_table.id
  INNER JOIN another_table
    ON left_table.id = another_table.id;

--Inner join countries (left) and populations (right) on the code and country_code fields respectively.
--Alias countries AS c and populations AS p.
--Select code, name, and region from countries and also select year and fertility_rate from populations (5 fields in total).
SELECT c.code, c.name, c.region, p.year, p.fertility_rate
  FROM countries as c
  INNER JOIN populations as p
    ON c.code = p.country_code;

--Add an additional INNER JOIN with economies to your previous query by joining on code.
--Include the unemployment_rate column that became available through joining with economies.
--Note that year appears in both populations and economies, so you have to explicitly use e.year instead of year as you did before.
-- Select fields
SELECT c.code, c.name, c.region, e.year, p.fertility_rate, e.unemployment_rate
  FROM countries AS c
  INNER JOIN populations AS p
    ON c.code = p.country_code
  INNER JOIN economies as e
    ON c.code = e.code;

--The trouble with doing your last join on c.code = e.code and not also including year is that e.g. the 2010 value for fertility_rate is also paired with the 2015 value for unemployment_rate.
-- Select fields
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
  -- From countries (alias as c)
  FROM countries AS c
  -- Join to populations (as p)
  INNER JOIN populations AS p
    -- Match on country code
    ON c.code = p.country_code
  -- Join to economies (as e)
  INNER JOIN economies AS e
    -- Match on country code and year
    ON c.code = e.code AND e.year = p.year;

--When joining tables with a common field name, use USING as a shortcut
SELECT *
FROM countries
  INNER JOIN economies
    USING(code);

--Inner join countries on the left and languages on the right with USING(code).
--Select the fields corresponding to: country name AS country, continent name, language name AS language, and whether or not the language is official.
-- Select fields
SELECT c.name AS country,
continent, l.name AS language, official
  -- From countries (alias as c)
  FROM countries AS c
  -- Join to languages (as l)
  INNER JOIN languages AS l
    -- Match using code
    USING (code);

--
--SELF JOINs and CASE
--perform a self-join to calculate the percentage increase in population from 2010 to 2015 for each country code
-- Select fields with aliases (SQL won't allow two fields w/same name)
SELECT p1.country_code, p1.size AS size2010, p2.size AS size2015
-- From populations (alias as p1)
FROM populations as p1
  -- Join to itself (alias as p2)
  INNER JOIN populations as p2
    -- Match on country code
    USING (country_code);
--Notice from the result that for each country_code you have four entries laying out all combinations of 2010 and 2015.
--Extend the ON in your query to include only those records where the p1.year (2010) matches with p2.year - 5 (2015 - 5 = 2010). 
--This will omit the three entries per country_code that you aren't interested in.
-- Select fields with aliases
SELECT p1.country_code,
       p1.size AS size2010,
       p2.size AS size2015
-- From populations (alias as p1)
FROM populations AS p1
  -- Join to itself (alias as p2)
  INNER JOIN populations AS p2
    -- Match on country code
    ON p1.country_code = p2.country_code
        -- and year (with calculation)
        AND p1.year = p2.year - 5;

--With two numeric fields A and B , the percentage growth from A to B  can be calculated as (B-A)/A*100.0
-- Select fields with aliases
SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       -- Calculate growth_perc
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
-- From populations (alias as p1)
FROM populations AS p1
  -- Join to itself (alias as p2)
  INNER JOIN populations AS p2
    -- Match on country code
    ON p1.country_code = p2.country_code
        -- and year (with calculation)
        AND p1.year = p2.year - 5;

--Using the countries table, create a new field AS geosize_group that groups the countries into three groups:
SELECT name, continent, code, surface_area,
    -- First case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- Second case
        WHEN surface_area > 350000 THEN 'medium'
        -- Else clause + end
        ELSE 'small' END
        -- Alias name
        AS geosize_group
FROM countries;

--Observe the use of (and the placement of) the INTO command to create this countries_plus table:
SELECT name, continent, code, surface_area,
    CASE WHEN surface_area > 2000000
            THEN 'large'
       WHEN surface_area > 350000
            THEN 'medium'
       ELSE 'small' END
       AS geosize_group
INTO countries_plus
FROM countries;

--Using the populations table focused only for the year 2015, create a new field aliased as popsize_group to organize population size into groups
--Select only the country code, population size, and this new popsize_group as fields.
SELECT country_code, size,
    -- First case
    CASE WHEN size > 50000000 THEN 'large'
        -- Second case
        WHEN size > 1000000 THEN 'medium'
        -- Else clause + end
        ELSE 'small' END
        -- Alias name (popsize_group)
        AS popsize_group
-- From table
FROM populations
-- Focus on 2015
WHERE year = 2015;

--Use INTO to save the result of the previous query as pop_plus. 
--Then, include another query below your first query to display all the records in pop_plus
SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' END
        AS popsize_group
-- Into table
INTO pop_plus
FROM populations
WHERE year = 2015; --semicolon to end first query
-- Select all columns of pop_plus
SELECT * 
FROM pop_plus;

--Keep the first query intact that creates pop_plus using INTO.
--Write a query to join countries_plus AS c on the left with pop_plus AS p on the right matching on the country code fields.
--Sort the data based on geosize_group, in ascending order so that large appears on top.
--Select the name, continent, geosize_group, and popsize_group fields.
SELECT country_code, size,
  CASE WHEN size > 50000000
            THEN 'large'
       WHEN size > 1000000
            THEN 'medium'
       ELSE 'small' END
       AS popsize_group
INTO pop_plus       
FROM populations
WHERE year = 2015;

SELECT name, continent, geosize_group, popsize_group
FROM countries_plus AS c
  INNER JOIN pop_plus AS p
    ON c.code = p.country_code
ORDER BY geosize_group;

-- CHAPTER 2 --
-- LEFT AND RIGHT JOINS --

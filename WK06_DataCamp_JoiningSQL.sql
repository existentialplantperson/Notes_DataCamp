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

-- CHAPTER 2 -----------------------------------------------------------------------
-- LEFT AND RIGHT JOINS / OUTER JOINS AND FULL JOINS --

--Left join keeps all data on left table and drops non-matching data from right table
--Right table does reverse, less common

SELECT c1.name AS city, code, c2.name AS country,
       region, city_proper_pop
FROM cities AS c1
  -- Join right table (with alias)
  LEFT JOIN countries AS c2
    -- Match on country code
    ON c1.country_code = c2.code
-- Order by descending country code
ORDER BY code DESC;
--output gives null values from left table

--Modify your code to calculate the average GDP per capita AS avg_gdp for each region in 2010.
-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries as c
  -- Left join with economies (alias as e)
  LEFT JOIN economies as e
    -- Match on code fields
    ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region;

--Arrange this data on average GDP per capita for each region in 2010 from highest to lowest average GDP per capita.
-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries AS c 
  -- Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- Match on code fields
    ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC;

--RIGHT JOIN
-- convert this code to use RIGHT JOINs instead of LEFT JOINs
/*
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM cities
  LEFT JOIN countries
    ON cities.country_code = countries.code
  LEFT JOIN languages
    ON countries.code = languages.code
ORDER BY city, language;
*/

SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM languages
  RIGHT JOIN countries
    ON countries.code = languages.code
  RIGHT JOIN cities
    ON cities.country_code = countries.code
ORDER BY city, language;

--FULL JOINS-----------------------------------------------------------------
--includes all data from both tables

-- The FULL JOIN query returned 17 rows, the OUTER JOIN returned 4 rows, and the INNER JOIN only returned 3 rows.

--make sure to compare the number of records the different types of joins return and try to verify whether the results make sense.

SELECT countries.name, code, languages.name AS language
-- From languages
FROM languages
  -- Join to countries
  FULL JOIN countries
    -- Match on code
    USING (code)
-- Where countries.name starts with V or is null
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
-- Order by ascending countries.name
ORDER BY countries.name;

--Complete a full join with countries on the left and languages on the right.
--Next, full join this result with currencies on the right.
--Use LIKE to choose the Melanesia and Micronesia regions (Hint: 'M%esia').
--Select the fields corresponding to the country name AS country, region, language name AS --language, and basic and fractional units of currency.
-- Select fields (with aliases)
SELECT c1.name AS country, region, l.name AS language,
       basic_unit, frac_unit
-- From countries (alias as c1)
FROM countries as c1
  -- Join with languages (alias as l)
  FULL JOIN languages as l
    -- Match on code
    USING (code)
  -- Join with currencies (alias as c2)
  FULL JOIN currencies AS c2
    -- Match on code
    USING (code)
-- Where region like Melanesia and Micronesia
WHERE region LIKE 'M%esia';


--CROSS JOIN-----------------------------------------------
--create all possible combinations of two tables
--table 1 (3 values), table 2 (3 values)
--cross join table has 9 values

--Create a CROSS JOIN with cities AS c on the left and languages AS l on the right.
--Make use of LIKE and Hyder% to choose Hyderabad in both countries.
--Select only the city name AS city and language name AS language.
-- Select fields
SELECT c.name AS city, l.name AS language
-- From cities (alias as c)
FROM cities AS c        
  -- Join to languages (alias as l)
  CROSS JOIN languages AS l
-- Where c.name like Hyderabad
WHERE c.name LIKE 'Hyder%';
--returns 1910 rows

-- Select fields
SELECT c.name as city, l.name as language
-- From cities (alias as c)
FROM cities as c      
  -- Join to languages (alias as l)
  INNER JOIN languages AS l
    -- Match on country code
    ON c.country_code = l.code
-- Where c.name like Hyderabad
WHERE c.name LIKE 'Hyder%';
--returns 25 rows

--In terms of life expectancy for 2010, determine the names of the lowest five countries and their regions.
-- Select fields
SELECT c.name AS country, region, life_expectancy AS life_exp
-- From countries (alias as c)
FROM countries as c
  -- Join to populations (alias as p)
  LEFT JOIN populations as p
    -- Match on country code
    ON c.code = p.country_code
-- Focus on 2010
WHERE year = 2010
-- Order by life_exp
ORDER BY life_exp
-- Limit to 5 records
LIMIT 5;
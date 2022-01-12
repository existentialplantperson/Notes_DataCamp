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

--------------------------------------------------------------------------

--SET THEORY CLAUSES
--UNION, removes duplicates
--Combine the two new tables into one table containing all of the fields in economies2010.
--Sort this resulting single table by country code and then by year, both in ascending order.
-- Select fields from 2010 table
SELECT *
  -- From 2010 table
  FROM economies2010
	-- Set theory clause
	UNION
-- Select fields from 2015 table
SELECT *
  -- From 2015 table
  FROM economies2015
-- Order by code and year
ORDER BY code, year;

--UNION can also be used to determine all occurrences of a field across multiple tables. Try out this exercise with no starter code.

--Determine all (non-duplicated) country codes in either the cities or the currencies table. The result should be a table with only one field called country_code.
-- Select field
SELECT country_code
  -- From cities
  FROM cities
	-- Set theory clause
	UNION
-- Select field
SELECT code
  -- From currencies
  FROM currencies
-- Order by country_code
ORDER BY country_code;

--UNION ALL, keeps duplicates
--Determine all combinations (include duplicates) of country code and year that exist in either the economies or the populations tables. Order by code then year.
-- Select fields
SELECT code, year
  -- From economies
  FROM economies
	-- Set theory clause
	UNION ALL
-- Select fields
SELECT country_code, year
  -- From populations
  FROM populations
-- Order by code, year
ORDER BY code, year;

--INTERSECT, only includes records in common to both tables
--UNION ALL will extract all records from two tables, while INTERSECT will only return records that both tables have in common.

--Use INTERSECT to determine the records in common for country code and year for the economies and populations tables.
--Note - INTERSECT returns 380 rows while the same query with UNION ALL returns 814 rows
-- Select fields
SELECT code, year
  -- From economies
  FROM economies
	-- Set theory clause
	INTERSECT
-- Select fields
SELECT country_code, year
  -- From populations
  FROM populations
-- Order by code and year
ORDER BY code, year;

--which countries also have a city with the same name as their country name?
-- Select fields
SELECT name
  -- From countries
  FROM countries
	-- Set theory clause
	INTERSECT
-- Select fields
SELECT name
  -- From cities
  FROM cities;

--EXCEPT, only the records in the left table and not in the right table are included
--Get the names of cities in cities which are not noted as capital cities in countries as a single field result.
-- Select field
SELECT name
  -- From cities
  FROM CITIES
	-- Set theory clause
	EXCEPT
-- Select field
SELECT capital
  -- From countries
  FROM countries
-- Order by result
ORDER BY name;

--complete the previous query in reverse
--Determine the names of capital cities that are not listed in the cities table.
-- Select field
SELECT capital
  -- From countries
  FROm countries
	-- Set theory clause
	EXCEPT
-- Select field
SELECT name
  -- From cities
  FROM cities
-- Order by ascending capital
ORDER BY capital;

--SEMI JOINS and ANTI JOINS
--similar to a WHERE clause, use right table to decide which records to keep in the left table
--SEMI JOIN includes records on L where condition met on R
--ANTI JOIN includes records on L where condition NOT met on R
--useful for filtering records on 1 table using a second table

--Begin by selecting all country codes in the Middle East as a single field result using SELECT, FROM, and WHERE.
-- Select code
SELECT code
  -- From countries
  FROM countries
-- Where region is Middle East
WHERE region = 'Middle East';
--Below the commented code, select only unique languages by name appearing in the languages table.
-- Select field
SELECT DISTINCT name
  -- From languages
  FROM languages
-- Order by name
ORDER BY name;
--Combine the previous two queries into one query by adding a WHERE IN statement to the SELECT DISTINCT query to determine the unique languages spoken in the Middle East.
-- Query from step 2
SELECT DISTINCT name
  FROM languages
-- Where in statement
WHERE code IN
  -- Query from step 1
  -- Subquery
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
-- Order by name
ORDER BY name;

--Sometimes problems solved with semi-joins can also be solved using an inner join.
SELECT DISTINCT name
FROM languages
WHERE code IN
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
ORDER BY name;
--same result as:
SELECT DISTINCT languages.name AS language
FROM languages
INNER JOIN countries
ON languages.code = countries.code
WHERE region = 'Middle East'
ORDER BY language;

--ANTI JOIN is particularly useful in identifying which records are causing an incorrect number of records to appear in join queries.

--Begin by determining the number of countries in countries that are listed in Oceania using SELECT, FROM, and WHERE.
-- Select statement
SELECT COUNT(name)
  -- From countries
  FROM countries
-- Where continent is Oceania
WHERE continent = 'Oceania';


--Note that not all countries in Oceania were listed in the resulting inner join with currencies. Use an anti-join to determine which countries were not included!
-- Select fields
SELECT name, code
  -- From Countries
  FROM countries
  -- Where continent is Oceania
  WHERE continent = 'Oceania'
  	-- And code not in
  	AND code NOT IN
  	-- Subquery
  	(SELECT code
  	 FROM currencies);

--Identify the country codes that are included in either economies or currencies but not in populations.
--Use that result to determine the names of cities in the countries that match the specification in the previous instruction.

--Identify the country codes that are included in either economies or currencies but not in populations.

-- Select the city name
SELECT name
  -- Alias the table where city name resides
  FROM cities AS c1
  -- Choose only records matching the result of multiple set theory clauses
  WHERE c1.country_code IN
(
    -- Select appropriate field from economies AS e
    SELECT e.code
    FROM economies AS e
    -- Get all additional (unique) values of the field from currencies AS c2  
    UNION
    SELECT c2.code
    FROM currencies AS c2
    -- Exclude those appearing in populations AS p
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);

--CHAPTER 4
--SUBQUERIES INSIDE WHERE AND SELECT CLAUSES---------

--You'll now try to figure out which countries had high average life expectancies (at the country level) in 2015.
--EX1 - Begin by calculating the average life expectancy across all countries for 2015.
-- Select average life_expectancy
SELECT AVG(	life_expectancy)
  -- From populations
  FROM populations
-- Where year is 2015
WHERE year = 2015;
--Select all fields from populations with records corresponding to larger than 1.15 times the average you calculated in the first task for 2015. In other words, change the 100 in the example above with a subquery.
-- Select fields
SELECT *
  -- From populations
  FROM populations
-- Where life_expectancy is greater than
WHERE life_expectancy >
  -- 1.15 * subquery
  1.15 * 
   (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015) 
   AND year = 2015;

--EX2 - Use your knowledge of subqueries in WHERE to get the urban area population for only capital cities.
--Make use of the capital field in the countries table in your subquery.
--Select the city name, country code, and urban area population fields.
SELECT name, country_code, urbanarea_pop
  -- From cities
  FROM cities
-- Where city name in the field of capital cities
WHERE name IN
  -- Subquery
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;

--The code given in the first query selects the top nine countries in terms of number of cities appearing in the cities table. Recall that this corresponds to the most populous cities in the world. Your task will be to convert the second query to get the same result as the provided code.
SELECT countries.name AS country, COUNT(*) AS cities_num
  FROM cities
    INNER JOIN countries
    ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;

--Convert the GROUP BY code to use a subquery
SELECT countries.name AS country,
  -- Subquery
  (SELECT COUNT(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;

--SUBQUERY INSIDE FROM CLAUSE
--Begin by determining for each country code how many languages are listed in the languages table
-- Select fields (with aliases)
SELECT code, COUNT(*) AS lang_num
  -- From languages
  FROM languages
-- Group by code
GROUP BY code;
--Include the previous query (aliased as subquery) as a subquery in the FROM clause of a new query.
-- Select fields
SELECT countries.local_name, subquery.lang_num
  -- From countries
  FROM countries,
  	-- Subquery (alias as subquery)
  	(SELECT code, COUNT(*) AS lang_num
  	 FROM languages
  	 GROUP BY code) AS subquery
  -- Where codes match
  WHERE subquery.code = countries.code
-- Order by descending number of languages
ORDER BY lang_num DESC;

--Advanced subquery
--In this exercise, for each of the six continents listed in 2015, you'll identify which country had the maximum inflation rate, and how high it was, using multiple subqueries. 

--Create an INNER JOIN with countries on the left and economies on the right with USING, without aliasing your tables or columns.

--Select the maximum inflation rate in 2015 AS max_inf grouped by continent using the previous step's query as a subquery in the FROM clause.
--Thus, in your subquery you should:
--Create an inner join with countries on the left and economies on the right with USING (without aliasing your tables or columns).
--Retrieve the country name, continent, and inflation rate for 2015.
--This will result in the six maximum inflation rates in 2015 for the six continents as one field table.
-- Select the maximum inflation rate as max_inf
SELECT MAX(inflation_rate) AS max_inf
  -- Subquery using FROM (alias as subquery)
  FROM (
      SELECT name, continent, inflation_rate
      FROM countries
      INNER JOIN economies
      USING (code)
      WHERE year = 2015) AS subquery
-- Group by continent
GROUP BY continent;
--Now it's time to append your second query to your first query using AND and IN to obtain the name of the country, its continent, and the maximum inflation rate for each continent in 2015.
-- Select fields
SELECT name, continent, inflation_rate
  -- From countries
  FROM countries
	-- Join to economies
	INNER JOIN economies
	-- Match on code
	ON countries.code = economies.code
  -- Where year is 2015
  WHERE year = 2015
    -- And inflation rate in subquery (alias as subquery)
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT name, continent, inflation_rate
             FROM countries
             INNER JOIN economies
             ON countries.code = economies.code
             WHERE year = 2015) AS subquery
      -- Group by continent
        GROUP BY continent);

--Subquery Challenge
--Use a subquery to get 2015 economic data for countries that do not have gov_form of 'Constitutional Monarchy' or 'Republic' in their gov_form.
-- Select fields
SELECT code, inflation_rate, unemployment_rate
  -- From economies
  FROM economies
  -- Where year is 2015 and code is not in
  WHERE year = 2015 AND code NOT IN
  	-- Subquery
  	(SELECT code
  	 FROM countries
  	 WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic%'))
-- Order by inflation rate
ORDER BY inflation_rate;


--Course Review
--In this exercise, you'll need to get the country names and other 2015 data in the economies table and the countries table for Central American countries with an official language.
-- Select fields
SELECT DISTINCT name, e.total_investment, e.imports
  -- From table (with alias)
  FROM countries AS c
    -- Join with table (with alias)
    LEFT JOIN economies AS e
      -- Match on code
      ON (c.code = e.code
      -- and code in Subquery
        AND c.code IN (
          SELECT l.code
          FROM languages AS l
          WHERE official = 'true'
        ) )
  -- Where region and year are correct
  WHERE region = 'Central America' AND year = 2015
-- Order by field
ORDER BY name;


--Let's ease up a bit and calculate the average fertility rate for each region in 2015.
-- Select fields
SELECT region, continent, AVG(fertility_rate) AS avg_fert_rate
  -- From left table
  FROM countries AS c
    -- Join to right table
    INNER JOIN populations AS p
      -- Match on join condition
      ON c.code = p.country_code
  -- Where specific records matching some condition
  WHERE year = 2015
-- Group appropriately
GROUP BY region, continent
-- Order appropriately
ORDER BY avg_fert_rate;


--You are now tasked with determining the top 10 capital cities in Europe and the Americas in terms of a calculated percentage using city_proper_pop and metroarea_pop in cities.
--Select the city name, country code, city proper population, and metro area population.
--Calculate the percentage of metro area population composed of city proper population for each city in cities, aliased as city_perc.
--Focus only on capital cities in Europe and the Americas in a subquery.
--Make sure to exclude records with missing data on metro area population.
--Order the result by city_perc descending.
--Then determine the top 10 capital cities in Europe and the Americas in terms of this city_perc percentage.
-- Select fields
SELECT name, country_code, city_proper_pop, metroarea_pop,  
      -- Calculate city_perc
      city_proper_pop / metroarea_pop * 100 AS city_perc
  -- From appropriate table
  FROM cities
  -- Where 
  WHERE name IN
    -- Subquery
    (SELECT capital
     FROM countries
     WHERE (continent = 'Europe'
        OR continent LIKE '%America%'))
       AND metroarea_pop IS NOT NULL
-- Order appropriately
ORDER BY city_perc DESC
-- Limit amount
LIMIT 10;

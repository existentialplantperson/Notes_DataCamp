--Week 06 - Data Camp Intro to SQL Notes

--SQL, which stands for Structured Query Language, is a language for interacting with data stored in something called a relational database.
--You can think of a relational database as a collection of tables. Each row, or record, of a table contains information about a single entity. 

--the following query selects the name column from the people table:

SELECT name
FROM people;

--select and from are keywords, they are not case sensitive
--semicolon tells SQL where the end of the query is

--select two columns
SELECT name, birthdate
FROM people;

--select all columns
SELECT *
FROM people;
--set a specific number of results
SELECT *
FROM people
LIMIT 10;

--Get all the unique countries represented in the films table.
SELECT DISTINCT country
FROM films;

-- This code gives the number of rows in the people table:
SELECT COUNT(*)
FROM people;

--count the number of non-missing values in a column
SELECT COUNT(birthdate)
FROM people;

--counts the number of distinct birth dates contained in the people table:
SELECT COUNT(DISTINCT birthdate)
FROM people;

-- WHERE keyword allows you to filter based on both text and numeric values
--comparison operators:
= equal
<> not equal
< less than
> greater than
<= less than or equal to
>= greater than or equal to

--eturns all films with the title 'Metropolis':
SELECT title
FROM films
WHERE title = 'Metropolis';

--Get all details for all French language films.
SELECT *
FROM films
WHERE language = 'French';

--Get the name and birth date of the person born on November 11th, 1974. 
--Remember to use ISO date format ('1974-11-11')
SELECT name, birthdate
FROM people
WHERE birthdate ='1974-11-11';

--Get the number of Hindi language films.
SELECT COUNT(*)
FROM films
WHERE language = 'Hindi';

--Get the title and release year for all 
--Spanish language films released before 2000.
SELECT title, release_year
FROM films
WHERE release_year < 2000
AND language = 'Spanish';

--Get all details for Spanish language films released after 2000, 
--but before 2010.
SELECT *
FROM films
WHERE language = 'Spanish'
AND release_year > 2000
AND release_year < 2010;

--returns all films released in either 1994 OR
2000:
SELECT title
FROM films
WHERE release_year = 1994
OR release_year = 2000;

--When combining AND and OR, be sure to enclose the 
--individual clauses in parentheses, like so:
SELECT title
FROM films
WHERE (release_year = 1994 OR release_year = 1995)
AND (certification = 'PG' OR certification = 'R');

--Get the title and release year for films released in the 90s.
--filter the records to only include French or Spanish language films.
--restrict the query to only return films that took in more than $2M gross.
SELECT title, release_year
FROM films
WHERE (release_year >= 1990 AND release_year < 2000)
AND (language = 'French' OR language = 'Spanish')
AND gross > 2000000


--BETWEEN keyword provides a useful shorthand for filtering 
--values within a specified range.
--Between is INCLUSIVE of beginning and ending values
SELECT title
FROM films
WHERE release_year
BETWEEN 1994 AND 2000;

--Get the title and release year of all films released between 1990 and 2000 (inclusive).
SELECT title, release_year
FROM films
WHERE release_year
BETWEEN 1990 AND 2000;

--Build on your previous query to select only films that have budgets over $100 million.
--restrict the query to only return Spanish language films.
SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
AND budget > 100000000
AND language = 'Spanish';

--Finally, modify to your previous query to include all Spanish language or French language films
SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
AND budget > 100000000
AND (language = 'Spanish' OR language = 'French');


--IN operator allows you to specify multiple values 
--in a WHERE clause, making it easier to specify multiple OR conditions! 

--Get the title and release year of all films released in 1990 OR 2000 that were longer than two hours.
SELECT title, release_year
FROM films
WHERE release_year 
IN (1990, 2000)
AND duration > 120;

--Get the title and language of all films which were in English, Spanish, or French.
SELECT title, language
FROM films
WHERE language 
IN ('English', 'Spanish', 'French');


--check for NULL values in birthdate column:
SELECT COUNT(*)
FROM people
WHERE birthdate IS NULL;

--select all NOT NULL in birthdate column
SELECT name
FROM people
WHERE birthdate IS NOT NULL;

--Get the names of people who are still alive, i.e. whose death date is missing.
SELECT name
FROM people
WHERE deathdate IS NULL;

--Get the number of films which don't have a language associated with them.
SELECT COUNT(*)
FROM films
WHERE language IS NULL;

--Get the names of all people whose names begin with 'B'. 
SELECT name
FROM people
WHERE name LIKE 'B%';

--Get the names of people whose names have 'r' as the second letter. 
SELECT name
FROM people
WHERE name LIKE '_r%';

--Get the names of people whose names DO NOT start with A.
SELECT name
FROM people
WHERE name NOT LIKE 'A%';


--Aggregate Functions

--Use the SUM() function to get the total duration of all films.
SELECT SUM(duration)
FROM films;

--Get the average duration of all films.
SELECT AVG(duration)
FROM films;

--Get the duration of the shortest film.
SELECT MIN(duration)
FROM films;

--Get the duration of the longest film.
SELECT MAX(duration)
FROM films;

--Use the SUM() function to get the total amount grossed by all films made in the year 2000 or later.
SELECT SUM(gross)
FROM films
WHERE  release_year >= 2000;

--Get the average amount grossed by all films whose titles start with the letter 'A'.
SELECT AVG(gross)
FROM films
WHERE title LIKE 'A%';

--Get the amount grossed by the worst performing film in 1994.
SELECT MIN(gross)
FROM films
WHERE release_year = 1994;

--Get the amount grossed by the best performing film between 2000 and 2012, inclusive.
SELECT MAX(gross)
FROM films
WHERE release_year BETWEEN 2000 and 2012;

--Arithmetic
--SQL assumes that if you divide an integer by an integer, you want to get an integer back.
SELECT (4 * 3); --returns 12
SELECT (4 / 3); --returns 1 because it only give the integer
SELECT (4.0 / 3.0) AS result; --returns 1.333 


--Aliasing - assigning a temporary name

--Get the title and net profit (the amount a film grossed, minus its budget) for all films. 
--Alias the net profit as net_profit.
SELECT title, gross - budget AS net_profit
FROM films;

--Get the title and duration in hours for all films. The duration is in minutes, so you'll need to divide by 60.0 to get the duration in hours. 
--Alias the duration in hours as duration_hours.
SELECT title, duration / 60.0 AS duration_hours
FROM films;

--Get the average duration in hours for all films, aliased as avg_duration_hours.
SELECT AVG(duration) / 60 AS avg_duration_hours
FROM films;

--Get the percentage of people who are no longer alive. 
--Alias the result as percentage_dead. Remember to use 100.0 and not 100!
SELECT COUNT(deathdate) * 100.0 / COUNT(*) AS percentage_dead
FROM people;

--Get the number of years between the newest film and oldest film. 
--Alias the result as difference.
SELECT MAX(release_year) - MIN(release_year)
AS difference
FROM films;

--Get the number of decades the films table covers. Alias the result as number_of_decades. 
--The top half of your fraction should be enclosed in parentheses.
SELECT (MAX(release_year) - MIN(release_year)) / 10.0
AS number_of_decades
FROM films;


--ORDER BY keyword is used to sort results in ascending or descending order according to the values of one or more columns.
--ORDER BY will sort in ascending order. 
--If you want to sort the results in descending order, you can use the DESC keyword.

--Get the names of people from the people table, sorted alphabetically.
SELECT name
FROM people
ORDER BY name;

--Get the birth date and name for every person, in order of when they were born.
SELECT name, birthdate
FROM people
ORDER BY birthdate;

--Get the title of films released in 2000 or 2012, in the order they were released.
SELECT title
FROM films
WHERE release_year IN (2000, 2012)
ORDER BY release_year;

--Get all details for all films except those released in 2015 and order them by duration.
SELECT *
FROM films
WHERE release_year <> 2015
ORDER BY duration;

--Get the title and gross earnings for movies which begin with the letter 'M' and order the results alphabetically.
SELECT title, gross
FROM films
WHERE title LIKE 'M%'
ORDER BY title;

--Sorting with DESC
--Get the title for every film, in reverse order.
SELECT title
FROM films
ORDER BY title DESC;


--Sorting multiple columns -It will sort by the first column specified, then sort by the next, then the next, and so on. 
--Get the birth date and name of people in the people table, in order of when they were born and alphabetically by name. 
SELECT birthdate, name
FROM people
ORDER BY birthdate, name;

--Get the release year, duration, and title of films ordered by their release year and duration.
SELECT release_year, duration, title
FROM films
ORDER BY release_year, duration;


--Groupby
--used to aggregate results, combined with aggregate function liek COUNT(), MAX()
--SQL will return an error if you try to SELECT a field that is not in your GROUP BY clause
--without using it to calculate some kind of value about the entire group.
--example: count the number of male and female employees in your company
SELECT sex, count(*)
FROM employees
GROUP BY sex;
returns:
sex count
male 15
female 19

--Get the release year and average duration of all films, grouped by release year.
SELECT release_year, AVG(duration)
FROM films
GROUP BY release_year;

--combine GROUPBY and ORDER BY 
--Get the release year, country, and highest budget spent making a film for each year, for each country. 
--Sort your results by release year and country.
SELECT release_year, country, MAX(budget)
FROM films
GROUP BY release_year, country
ORDER BY release_year, country; 

--Get the country, release year, and lowest amount grossed per release year per country. 
--Order your results by country and release year.
SELECT country, release_year, MIN(gross)
FROM films
GROUP BY release_year, country
ORDER BY country, release_year;

--aggregate function CAN NOT be used in WHERE clauses
--instead use HAVING

--In how many different years were more than 200 movies released?
SELECT release_year
FROM films
GROUP BY release_year
HAVING COUNT(title) > 200;

--Get the release year, budget and gross earnings for each film in the films table.
--Modify your query so that only records with a release_year after 1990 are included.
--Modify your query so that only years with an average budget of greater than $60 million are included.
--modify your query to order the results from highest average gross earnings to lowest.
SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
ORDER BY AVG(gross) DESC;

--Get the country, average budget, and average gross take of countries that have made more than 10 films. 
--Order the result by country name, and limit the number of results displayed to 5. 
--You should alias the averages as avg_budget and avg_gross respectively.
-- select country, average budget, and average gross
SELECT country, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
-- from the films table
FROM films
-- group by country 
GROUP BY country
-- where the country has more than 10 titles
HAVING COUNT(country) > 10
-- order by country
ORDER BY country
-- limit to only show 5 results
LIMIT 5;

--how to query multiple tables

--find the IMDB score for 'To Kill A Mockingbird'
SELECT title, imdb_score
FROM films
JOIN reviews
ON films.id = reviews.film_id
WHERE title = 'To Kill a Mockingbird';
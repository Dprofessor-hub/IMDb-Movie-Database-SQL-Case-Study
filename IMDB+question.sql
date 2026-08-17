USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select count(*) As row_counts from director_mapping;
select count(*) As row_counts from genre;
select count(*) As row_counts from movie;
select count(*) As row_counts from names;
select count(*) As row_counts from ratings;
select count(*) As row_counts from role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
    SUM(country IS NULL) AS country_nulls,
    SUM(worlwide_gross_income IS NULL) AS worldwide_gross_income_nulls,
    SUM(languages IS NULL) AS languages_nulls,
    SUM(production_company IS NULL) AS production_company_nulls
FROM movie;

# But this query don't show that which column has null value but tell that is this column allows null value in it or not ?
# eg :- id is primary key column so it is not allowing null values


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 1st part
select year, count(id) as number_of_movies from movie group by year;

-- 2nd part 
select month(date_published) as Month_num, count(id) as number_of_movies from movie 
group by Month_num order by Month_num;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- seperate way
select country,count(*) from movie where (country = "USA" or country = "India") and year = 2019  group by country;

-- combined way
select  count(id) as Number_of_movies from movie where (country like "India" or country like "USA")  and year = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?

-- Type your code below:
select distinct(genre) from genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


select genre, count(movie_id) as Total_movies_count from genre
group by genre
order by Total_movies_count desc limit 1;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with ddd as 
(select movie_id, count(genre) as genre_count from genre  group by movie_id) 
select count(genre_count) as movie_num from ddd where genre_count = 1;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select * from movie;

select genre.genre, round(avg(movie.duration),2) as avg_duration from genre join movie 
on movie.id = genre.movie_id
group by genre.genre
order by avg_duration desc;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_ranking as (
select genre, count(movie_id) as movie_count,
dense_rank() over(order by  count(movie_id) desc) as genre_rank
from genre 
group by genre)
select * from genre_ranking where genre = "thriller";


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


select min(avg_rating) as min_avg_rating , max(avg_rating) as max_avg_rating, 
min(total_votes) as min_total_votes, max(total_votes) as max_total_votes, 
min(median_rating) as min_median_rating, max(median_rating) as max_median_rating
from ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

with top_movie as 
(select movie.title as title , ratings.avg_rating ,
dense_rank() over(order by ratings.avg_rating desc) as movie_rank
from movie 
join ratings 
on movie.id = ratings.movie_id)

select * from top_movie where movie_rank<= 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating , count(movie_id) as movie_count
from  ratings
group by median_rating 
order by median_rating;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, count(m.id) as movie_count, dense_rank() over(order by count(m.id) desc) as prod_company_rank
from movie m join ratings r on m.id = r.movie_id where r.avg_rating > 8 and m.production_company is not null group by m.production_company;

with www as
(select m.production_company, count(m.id) as movie_count, dense_rank() over (order by count(m.id) desc ) as prod_company_rank
from movie m join ratings r on m.id = r.movie_id where r.avg_rating > 8 and m.production_company is not null group by m.production_company)

select * from www where prod_company_rank = 1;







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre , count(*) as movie_count from genre g left join ratings r on g.movie_id = r.movie_id
join movie m on r.movie_id = m.id
where m.country = "USA" and (m.date_published between "2017-03-01" and "2017-03-31") and  r.total_votes > 1000 
group by g.genre
order by movie_count desc;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select m.title, r.avg_rating, g.genre from movie m join genre g on m.id = g.movie_id join ratings r on m.id = r.movie_id
where r.avg_rating > 8 and m.title like "The%"
order by r.avg_rating desc;

select m.title, r.median_rating, g.genre from movie m join genre g on m.id = g.movie_id join ratings r on m.id = r.movie_id
where r.avg_rating > 8 and m.title like "The%"
order by r.median_rating desc;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(m.id) AS movie_count
FROM
    movie m
        JOIN
    ratings r ON m.id = r.movie_id
WHERE
    (m.date_published BETWEEN '2018-04-01' AND '2019-04-01')
        AND r.median_rating = 8;






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
    'German' AS country_type,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.country LIKE '%Germany%'

UNION ALL

SELECT
    'Italian' AS country_type,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.country LIKE '%Italy%';





-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

describe names;

SELECT 
    SUM(name IS NULL) AS name_nulls,
    SUM(height IS NULL) AS height_nulls,
    SUM(date_of_birth IS NULL) AS date_of_birth_null,
    SUM(known_for_movies IS NULL) AS know_for_movies_nulls
FROM
    names;
 




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:
+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
with top_directors as 
(select g.genre, count(distinct g.movie_id) as movie_count from genre g 
join ratings r on g.movie_id = r.movie_id 
where r.avg_rating > 8
group by g.genre
order by movie_count desc 
limit 3) 
select n.name, count(distinct dm.movie_id) as movie_count from top_directors tp join genre g on tp.genre = g.genre
join director_mapping dm on g.movie_id = dm.movie_id 
join names n on n.id = dm.name_id 
join ratings r on dm.movie_id =  r.movie_id
where r.avg_rating > 8
group by n.name
order by movie_count desc
limit 3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    n.name AS actor_name,
    COUNT(DISTINCT rm.movie_id) AS movie_count
FROM role_mapping rm
JOIN names n 
    ON n.id = rm.name_id
JOIN ratings r 
    ON rm.movie_id = r.movie_id
WHERE r.median_rating >= 8
  AND rm.category = 'actor'
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

with aa as(
select m.production_company, sum(r.total_votes) as vote_count, 
dense_rank() over(order by sum(r.total_votes) desc) as prod_comp_rank
from movie m 
join ratings r on m.id = r.movie_id
group by m.production_company
) 
select * from aa where prod_comp_rank <=3;







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_stats AS (
    SELECT n.name AS actor_name, 
		SUM(r.total_votes) AS total_votes, 
		COUNT(DISTINCT m.id) AS movie_count,
        SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actor_avg_rating
    FROM movie m
    JOIN role_mapping rm ON m.id = rm.movie_id
    JOIN names n ON rm.name_id = n.id
    JOIN ratings r ON r.movie_id = m.id
    WHERE m.country like '%India%' AND rm.category = 'actor'
    GROUP BY n.name
    HAVING COUNT(DISTINCT m.id) >= 5
)
SELECT
    actor_name, total_votes, movie_count, ROUND(actor_avg_rating, 2) AS actor_avg_rating,
    DENSE_RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM actor_stats ORDER BY actor_rank;




-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_stats AS (
    SELECT
        n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT m.id) AS movie_count,
        SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS actress_avg_rating
    FROM movie m
    JOIN role_mapping rm  ON m.id = rm.movie_id
    JOIN names n ON rm.name_id = n.id
    JOIN ratings r ON r.movie_id = m.id
    WHERE m.country like '%India%' AND rm.category = 'actress'AND m.languages like "%Hindi%"
    GROUP BY n.name
    HAVING COUNT(DISTINCT m.id) >= 3
)

SELECT
    actress_name, total_votes, movie_count, ROUND(actress_avg_rating, 2) AS actress_avg_rating,
    DENSE_RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM actress_stats ORDER BY actress_rank limit 5;






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT g.genre, r.avg_rating,
    CASE
		WHEN r.avg_rating > 8 THEN 'Superhit movies'
		WHEN r.avg_rating >= 7 THEN 'Hit movies'
		WHEN r.avg_rating >= 5 THEN 'One-time-watch movies'
		ELSE 'Flop movies'
	END AS movie_category
FROM ratings r
JOIN genre g ON r.movie_id = g.movie_id
WHERE g.genre = 'Thriller';






/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
with rr as (
select g.genre, avg(m.duration) as avg_duration
from movie m 
join genre g on m.id = g.movie_id
group by g.genre)

select genre, round(avg_duration,2) as avg_duration,
round(sum(avg_duration) over(order by genre rows between unbounded preceding and current row),2) as running_total_duration,
round(avg(avg_duration) over(order by genre rows between 2 preceding and current row),2) as moving_avg_duration
from rr
order by genre;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
with top_genre as(
select g.genre, count(distinct g.movie_id) as movie_count from genre g 
group by g.genre
order by movie_count desc
limit 3
),
ranked_movie as (
select g.genre, m.year , m.title as movie_name, m.worlwide_gross_income,
dense_rank() over(partition by g.genre, m.year order by m.worlwide_gross_income desc) as movie_rank
from genre g 
join movie m on m.id = g.movie_id
join top_genre tg on g.genre = tg.genre
where m.worlwide_gross_income is not null )

select genre, year, movie_name,worlwide_gross_income, movie_rank
from ranked_movie
where movie_rank <= 5
order by genre,year,movie_rank;

-- Q26. Which are the five highest-grossing movies of each year
-- that belong to the top three genres?
-- (The top 3 genres would have the most number of movies.)

WITH top_genre AS (
    SELECT g.genre, COUNT(DISTINCT g.movie_id) AS movie_count FROM genre g
    GROUP BY g.genre ORDER BY movie_count DESC LIMIT 3 ),

ranked_movie AS (
    SELECT g.genre, m.year, m.title AS movie_name, m.worlwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY g.genre, m.year ORDER BY CAST( REPLACE( REPLACE(m.worlwide_gross_income, '$', ''), ',','') AS UNSIGNED) DESC) AS movie_rank
    FROM genre g
    JOIN movie m ON m.id = g.movie_id
    JOIN top_genre tg ON g.genre = tg.genre
    WHERE m.worlwide_gross_income IS NOT NULL
)
SELECT genre, year, movie_name, worlwide_gross_income, movie_rank
FROM ranked_movie
WHERE movie_rank <= 5
ORDER BY genre, year, movie_rank;




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, count(distinct m.id) movie_count,
dense_rank() over(order by count(distinct m.id) desc) as prod_comp_rank
from movie m 
join ratings r on m.id = r.movie_id
where r.median_rating >= 8 and POSITION(',' IN m.languages)>0 and m.production_company is not null
group by m.production_company
order by movie_count desc
limit 2;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with top_actress as(
select n.name as actress_name, sum(r.total_votes) as total_votes, count(distinct r.movie_id) as movie_count, sum(r.total_votes * r.avg_rating) / sum(r.total_votes) as actress_avg_rating
from ratings r join role_mapping rm on r.movie_id = rm.movie_id 
join names n on n.id = rm.name_id
join genre g on g.movie_id = rm.movie_id
where r.avg_rating > 8 and g.genre = "Drama" and rm.category = "actress"
group by n.name)

select actress_name	, total_votes, movie_count, round(actress_avg_rating,2) as actress_avg_rating,
dense_rank() over(order by movie_count desc, total_votes desc) as actress_rank
from top_actress
where movie_count is not null
order by actress_rank
limit 3;





/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH director_movies AS (
    SELECT
        dm.name_id AS director_id, n.name AS director_name, m.id AS movie_id, m.date_published, m.duration, r.avg_rating, r.total_votes,
        LAG(m.date_published) OVER (PARTITION BY dm.name_id ORDER BY m.date_published) AS previous_movie_date
    FROM movie m
    JOIN director_mapping dm ON m.id = dm.movie_id
    JOIN names n ON n.id = dm.name_id
    JOIN ratings r ON r.movie_id = m.id),

director_stats AS (
    SELECT director_id, director_name, 
    COUNT(DISTINCT movie_id) AS number_of_movies,
        AVG( DATEDIFF(date_published, previous_movie_date) ) AS avg_inter_movie_days,
        AVG(avg_rating) AS avg_rating, 
        SUM(total_votes) AS total_votes, MIN(avg_rating) AS min_rating, MAX(avg_rating) AS max_rating, SUM(duration) AS total_duration
    FROM director_movies GROUP BY director_id, director_name )
    
SELECT
    director_id, director_name, number_of_movies, 
    ROUND(avg_inter_movie_days, 0) AS avg_inter_movie_days,
    ROUND(avg_rating, 2) AS avg_rating,
    total_votes, min_rating, max_rating, total_duration
FROM director_stats
ORDER BY number_of_movies DESC LIMIT 9;




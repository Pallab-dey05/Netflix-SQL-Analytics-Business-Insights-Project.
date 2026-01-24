-- Netflix Clone Project 

drop table if exists netflix;
create table netflix
(
	show_id	varchar(10),
	type varchar(20),
	title varchar(150),
	director varchar(250),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(20),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(300)
);

select * from netflix;

select
	count(*) as total_content
from netflix;


-- 14 Business Problems


-- Q1. Count the number of Movies vs TV Shows.

select
	type,
	count(type) as total_content
from netflix
group by type;


-- Q2. Find the most common rating for movies and TV Shows.

select	
	rating, type, count(rating) as numbers
from netflix
where type = 'Movie' or type = 'TV Show'
group by rating, type                                 -- Top 5 common rating for Movies or TV Show
order by numbers desc
limit 5;


-- Q3. List all movies released in a specific year (e.g., 2020).

select *
from netflix
	where type = 'Movie'
	and 
	release_year = 2020;


-- Q4. Find the 5 top countries with the most content on Netflix.

select 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by new_country
order by total_content desc
limit 5;


-- Q5. Identify the longest movie.

select 
	title, type, duration
from netflix
where
	type = 'Movie'
	and 
	duration = (select max(duration) from netflix);                 -- converting the duration from string to integer


-- Q6. Find the content added in the last 5 years.

select *
from netflix
where
	to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';


-- Q7. Find all the movies/TV Shows by a specific director. (e.g., 'Rajiv Chilaka').

select 
	*
from netflix
where director = 'Rajiv Chilaka'; -- used when only he has directed the movie.

-- better way 

select
	*
from netflix
where director ilike '%Rajiv Chilaka%';    -- use this for better results. (not case sensitive)



-- Q8. List all the TV Shows with more than 5 seasons.

select 
	*
from netflix
where 
	type ilike '%TV Show%'
	and 
	split_part(duration, ' ', 1):: numeric > 5;   --- most commonly used function.


-- Q9. Count the number of content items in each genre.

select 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by genre
order by total_count desc;

-- Q10. List all the movies that are documentaries.

select 
	* 
from netflix
where
	listed_in ilike '%documentaries%' 
	and 
	type ilike '%Movie%';


-- Q11. Find all the content without a director.

select 
	*
from netflix
where director is null;


-- Q12. Find in how many movies a specific actor (e.g., Salman Khan) appeared in last 10 years.

select 
	*
from netflix
where 
	casts ilike '%Salman Khan%'
	and 
	type ilike '%Movie%'
	and 
	release_year > extract(year from current_date):: numeric- 10;


-- Q13. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	count(show_id) as appearance
from netflix
where 
	country ilike '%India%'
	and 
	type ilike '%Movie%'
group by actors
order by appearance desc
limit 10;


-- Q14. Categorize the content based on the presence of the keywords "Kill" and "Violence" in the description field. Label the content containing these keywords as "Bad" and all other content as "Good". Count how many items fall into each category.


with new_table
as
(
select 
	*,
	case 
	when
		description ilike '%Kill%'
		or
		description ilike '%Violence%' then 'Bad Content'
		else 'Good Content'
	end category
from netflix
)
select 
	category,
	count(*) as total_content
from new_table
group by 1;




select *
from countries
limit 10;

select *
from population_years
limit 10;

-- How many entries in the countries table are from Africa?
select count(*)
from countries
where continent = 'Africa';

-- What was the total population of the continent of Oceania in 2005?
with oceania_countries as (
  select *
  from countries
  where continent = 'Oceania'
  )
select continent, round(sum(population), 2) as 'Total Population'
from oceania_countries
join population_years
  on oceania_countries.id = population_years.country_id
where year = 2005;

-- What is the average population of countries in South America in 2003?
with sa_countries as (
  select *
  from countries
  where continent = 'South America'
  )
select continent, round(avg(population), 2) as 'Average Population'
from sa_countries
join population_years
  on sa_countries.id = population_years.country_id
where year = 2003;

-- What country had the smallest population in 2007?
select name, min(population)
from population_years
join countries
  on population_years.country_id = countries.id
where year = 2007;

-- What is the average population of Poland during the time period covered by this dataset?
select name, round(avg(population), 2) as 'Average Population'
from population_years
join countries
  on countries.id = population_years.country_id
where name = 'Poland';

-- How many countries have the word “The” in their name?
select count(*)
from countries
where name like '% The%';

-- What was the total population of each continent in 2010?
select continent, round(sum(population), 2) as 'Total Population'
from population_years
join countries
  on population_years.country_id = countries.id
where year = 2010
group by 1
order by 2 desc;
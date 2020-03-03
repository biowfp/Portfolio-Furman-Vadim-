/*Which airline appear most frequently as the carrier with 
the lowest fare (ie. carrier_low)? How about the airline 
with the largest market share (ie. carrier_lg)?*/
SELECT count (*), carrier_low
FROM airfare_data
GROUP by 2
ORDER by 1 DESC;

SELECT count (*), carrier_lg
FROM airfare_data
GROUP by 2
ORDER by 1 DESC;

/*How many instances are there where the carrier with the 
largest market share is not the carrier with the lowest fare? 
What is the average difference in fare?*/
SELECT count(*)
FROM airfare_data
WHERE carrier_lg != carrier_low;

SELECT round(avg(fare_lg - fare_low), 2)
FROM airfare_data;

/* What is the percent change in average fare from 2007 
to 2017 by flight? */
/*thats (agv2017 fare - avg2007 fare) / avg2007 fare
group city1 and city2*/
WITH old_data as
(
SELECT Year, round(avg(fare), 2) as avg_fare, city1, city2
FROM airfare_data
where Year = 2007
GROUP by city1, city2
ORDER by Year
),
new_data as
(
SELECT Year, round(avg(fare), 2) as avg_fare, city1, city2
FROM airfare_data
where Year = 2017
GROUP by city1, city2
ORDER by Year
),
aggregate_fares as
(
SELECT old_data.Year as 'year_first', old_data.avg_fare as 'fare_first', new_data.Year as 'year_second', new_data.avg_fare as 'fare_second', old_data.city1, old_data.city2 
FROM old_data
JOIN new_data
	on old_data.city1 = new_data.city1 and old_data.city2 = new_data.city2
GROUP by old_data.city1, old_data.city2
)
SELECT year_first, year_second, round((fare_second - fare_first) / fare_first, 2) as 'fare_change', city1, city2
FROM aggregate_fares;

/* How about from 1997 to 2017? */
WITH old_data as
(
SELECT Year, round(avg(fare), 2) as avg_fare, city1, city2
FROM airfare_data
where Year = 1997
GROUP by city1, city2
ORDER by Year
),
new_data as
(
SELECT Year, round(avg(fare), 2) as avg_fare, city1, city2
FROM airfare_data
where Year = 2017
GROUP by city1, city2
ORDER by Year
),
aggregate_fares as
(
SELECT old_data.Year as 'year_first', old_data.avg_fare as 'fare_first', new_data.Year as 'year_second', new_data.avg_fare as 'fare_second', old_data.city1, old_data.city2 
FROM old_data
JOIN new_data
	on old_data.city1 = new_data.city1 and old_data.city2 = new_data.city2
GROUP by old_data.city1, old_data.city2
)
SELECT year_first, year_second, round((fare_second - fare_first) / fare_first, 2) as 'fare_change', city1, city2
FROM aggregate_fares;

/* How would you describe the overall trend in airfares 
from 1997 to 2017, as compared 2007 to 2017? */
WITH old_data as
(
SELECT Year, round(avg(fare), 2) as avg_fare
FROM airfare_data
where Year = 1997
GROUP by Year
),
new_data as
(
SELECT Year, round(avg(fare), 2) as avg_fare
FROM airfare_data
where Year = 2017
GROUP by Year
),
aggregate_fares as
(
SELECT Year, avg_fare
from old_data
UNION
SELECT Year, avg_fare
FROM new_data
)
SELECT round((max(avg_fare) - min(avg_fare)) / min(avg_fare), 2) as 'fare_change'
FROM aggregate_fares;

WITH old_data as
(
SELECT Year, round(avg(fare), 2) as avg_fare
FROM airfare_data
where Year = 2007
GROUP by Year
),
new_data as
(
SELECT Year, round(avg(fare), 2) as avg_fare
FROM airfare_data
where Year = 2017
GROUP by Year
),
aggregate_fares as
(
SELECT Year, avg_fare
from old_data
UNION
SELECT Year, avg_fare
FROM new_data
)
SELECT round((max(avg_fare) - min(avg_fare)) / min(avg_fare), 2) as 'fare_change'
FROM aggregate_fares;

/* Considering only the flights that have data available 
on all 4 quarters of the year, which quarter has the highest 
overall average fare? lowest? */
WITH q1 as 
(
SELECT *
FROM airfare_data
WHERE quarter = 1
GROUP by city1, city2
),
q2 as 
(
SELECT *
FROM airfare_data
WHERE quarter = 2
GROUP by city1, city2
),
q3 as 
(
SELECT *
FROM airfare_data
WHERE quarter = 3
GROUP by city1, city2
),
q4 as 
(
SELECT *
FROM airfare_data
WHERE quarter = 4
GROUP by city1, city2
),
rejoined_table as 
(
SELECT *
FROM q1
JOIN q2 on q2.city1=q1.city1 AND q2.city2=q1.city2
JOIN q3 on q3.city1=q1.city1 AND q3.city2=q1.city2
JOIN q4 on q4.city1=q1.city1 AND q4.city2=q1.city2
)
SELECT Year,
round(avg(fare), 2) as 'q1_fare', 
round(avg("fare:1"), 2) as 'q2_fare', 
round(avg("fare:2"), 2) as 'q3_fare', 
round(avg("fare:3"), 2) as 'q4_fare'
FROM rejoined_table
/*GROUP by Year*/;
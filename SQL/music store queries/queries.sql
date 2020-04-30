/*How many customers did each employee support, 
what is the average revenue for each sale, 
and what is their total sale?*/
SELECT e.FirstName as Employee, 
	count(c.CustomerId) as 'Number of Customers',
	round(avg(i.Total), 2) as 'Average Sale',
	round(sum(i.Total), 2) as 'Total Sales'
FROM employees as e
	JOIN customers as c on e.EmployeeId = c.SupportRepId
	JOIN invoices as i on i.CustomerId = c.CustomerId
GROUP by e.EmployeeId
ORDER by 2 DESC;

/*Is the number of times a track appears in any playlist 
a good indicator of sales? (Yes)*/
WITH revenue_per_number_of_playlists as 
(
SELECT count(pt.PlaylistId) as "Number of Playlists", 
	sum(i.Total) as "Total Revenue"
FROM playlist_track as pt
	JOIN invoice_items as ii on pt.TrackId = ii.TrackId
	JOIN invoices as i on ii.InvoiceId = i.InvoiceId
GROUP by pt.TrackId
ORDER by 2 DESC
)
SELECT "Number of Playlists", 
	round(avg("Total Revenue"),2 ) as "Average Revenue"
FROM revenue_per_number_of_playlists as rpp
GROUP by 1
ORDER by 2 DESC;

/*Do longer or shorter length albums tend to generate 
more revenue? (Longer) */
WITH albums_stats as 
(
SELECT a.Title, 
	sum(t.Milliseconds) / 60000 as 'Length, min',
	sum(i.Total) as 'Total Revenue'
FROM albums as a
	JOIN tracks as t on a.AlbumId = t.AlbumId
	JOIN invoice_items as ii on t.TrackId = ii.TrackId
	JOIN invoices as i on i.InvoiceId = ii.InvoiceId
GROUP by 1
ORDER by 3 DESC
)
SELECT "Length, min", 
	round(avg("Total Revenue"), 2) as "Average Revenue"
FROM albums_stats
GROUP by 1
ORDER by 2 DESC;

/*Which tracks appeared in the most playlists? 
How many playlist did they appear in?*/
SELECT t.Name, count(pt.PlaylistId) as 'In Total Playlists'
FROM playlist_track as pt
	JOIN tracks as t on pt.TrackId = t.TrackId
GROUP by 1
ORDER by 2 DESC;

/*Which track generated the most revenue? which album? 
which genre?*/
SELECT t.Name, sum(i.Total) as 'Total Revenue'
FROM invoice_items as ii
	JOIN invoices as i on ii.InvoiceId = i.InvoiceId
	JOIN tracks as t on ii.TrackId = t.TrackId
GROUP by 1
ORDER by 2 DESC
LIMIT 1;

SELECT a.Title, sum(i.Total) as 'Total Revenue'
FROM invoice_items as ii
	JOIN invoices as i on ii.InvoiceId = i.InvoiceId
	JOIN tracks as t on ii.TrackId = t.TrackId
	JOIN albums as a on t.AlbumId = a.AlbumId
GROUP by 1
ORDER by 2 DESC
LIMIT 1;

SELECT g.Name, round(sum(i.Total), 2) as 'Total Revenue'
FROM invoice_items as ii
	JOIN invoices as i on ii.InvoiceId = i.InvoiceId
	JOIN tracks as t on ii.TrackId = t.TrackId
	JOIN genres as g on t.GenreId = g.GenreId
GROUP by 1
ORDER by 2 DESC
LIMIT 1;

/*Which countries have the highest sales revenue?*/ 
SELECT i.BillingCountry as Country, 
	sum(i.Total) as 'Total Revenue'
FROM invoices as i
GROUP by 1
ORDER by 2 DESC;

/*How much revenue is generated each year*/
SELECT CAST(strftime('%Y', i.InvoiceDate) as INT) as Year, 
	sum(i.Total) as "Total Revenue"
FROM invoices as i
GROUP by 1
ORDER by 1 DESC;
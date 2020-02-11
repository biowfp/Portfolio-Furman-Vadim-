/* Нужно вывести на экран тех посетителей, кто впервые 
зарегистрировался в продукте (users.csv) после вебинара,
и для каждого из них посчитать сумму его пополнений в 
системе (transactions.csv). */
SELECT webinar.email, sum(transactions.price)
FROM users
JOIN webinar on webinar.email = users.email
JOIN transactions on users.user_id = transactions.user_id
WHERE date_registration > '2016-04-01'
GROUP by 1;

SELECT
FROM users
JOIN reviews on reviews.users_id=users.user_id
WHERE sum(reviews.status)=0 /*WHERE sum(reviews.status)>5*/
GROUP by users.user_id;

SELECT *
FROM doctors
WHERE speciality = 'дерм_толог' and experience >= 20;
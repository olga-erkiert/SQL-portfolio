/*DVD Rental Database (link: https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/) */


/* QUERY 1
Prepare list of customers and newsletter message about promotion for the next customer's rental
when customer rented more then 30 films he gets 30% discount
when customer rented between 20-29 films he gets 20% discount
when customer rented between 15-19 films he gets 10% discount
*/

SELECT customer.customer_id, first_name, last_name, email, COUNT(inventory_id) AS total_rental, 
	CASE
		WHEN (COUNT(inventory_id) >= 30) THEN '30% discount! You have received maximum discount! Congratulations!'
		WHEN (COUNT(inventory_id) = 29) THEN CONCAT('20% discount! You need ', 30-COUNT(inventory_id), ' more rental to get 30% discount in the next promotion!')
		WHEN (COUNT(inventory_id) BETWEEN 20 AND 28) THEN CONCAT('20% discount! You need ', 30-COUNT(inventory_id), ' more rentals to get 30% discount in the next promotion!')
		WHEN (COUNT(inventory_id) = 19) THEN CONCAT('10% discount! You need ', 20-COUNT(inventory_id), ' more rental to get 20% discount in the next promotion!')
		WHEN (COUNT(inventory_id) BETWEEN 15 AND 18) THEN CONCAT('10% discount! You need ', 20-COUNT(inventory_id), ' more rentals to get 20% discount in the next promotion!')
		ELSE 'Sorry this time you haven''t receive any discount. You need to have more then 15 rentals. Keep going!'
	END AS newsletter_message
FROM customer
LEFT OUTER JOIN rental
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id
ORDER BY COUNT(inventory_id) DESC;


/* QUERY 2
Prepare a list of all customers who have ever rented a movie more than once.
*/

WITH customers_rentals AS (
	SELECT f.film_id film, f.title title, c.customer_id customer, 
		CONCAT(c.first_name, ' ', c.last_name) customer_name
	FROM rental AS r
	LEFT JOIN inventory AS i
	ON r.inventory_id = i.inventory_id
	LEFT JOIN film AS f
	ON f.film_id = i.film_id
	LEFT JOIN customer c
	ON r.customer_id = c.customer_id
)
SELECT title, customer_name, COUNT (*) AS rental_count 
FROM customers_rentals
GROUP BY title, customer_name
HAVING COUNT(*) > 1
ORDER BY rental_count DESC;


/* QUERY 3
Show to customer a list of Action and Sci-Fi movies with length between 90 and 120 minutes in German language. 
*/

SELECT f.title, f.description, f.length, c.name "film category" 
FROM film f
LEFT JOIN language l
ON f.language_id = f.language_id
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
WHERE 
	length BETWEEN 90 AND 120 
	AND c.name IN ('Action', 'Sci-Fi') 
	AND l.name = 'German'
ORDER BY length;

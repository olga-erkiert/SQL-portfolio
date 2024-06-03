/*DVD Rental Database (link: https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/) */


/*Prepare list of customers and newsletter message about promotion for the next customer's rental
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
-- What is every client's most recent purchase date?

WITH customer_rank AS (
	SELECT 
		customer_id, 
		purchase_date, 
		total_purchase_amount,
		ROW_NUMBER ()
			OVER (PARTITION BY customer_id ORDER BY purchase_date DESC) AS most_recent_purchase
	FROM customer_data
)
SELECT * 
FROM customer_rank
WHERE most_recent_purchase =1;
-- 5 - Ранг и процентное соотношение клиентов по количеству бронирований
WITH t_bookings_exists AS (
	SELECT
		c.id,
		booking_id,
		CASE WHEN booking_id IS NOT NULL THEN 1 ELSE 0 END AS bookings_exists
	FROM clients c
	LEFT JOIN bookings b ON c.id = b.renter_id
	ORDER BY bookings_exists
),
t_bookings_count AS (
	SELECT
		id AS renter_id,
		SUM(bookings_exists) AS bookings_count
	FROM t_bookings_exists
	GROUP BY renter_id
	ORDER BY bookings_count
),
t_bookings_count_rank AS (
	SELECT 
		renter_id, bookings_count,
		DENSE_RANK() OVER (ORDER BY bookings_count DESC) AS renter_rank
	FROM t_bookings_count
),
t_bookings_rank_count AS (
	SELECT 
		renter_rank, bookings_count,
		COUNT(*) AS renters_count
	FROM t_bookings_count_rank
	GROUP BY renter_rank, bookings_count
	ORDER BY renter_rank
)
SELECT 
	renter_rank, bookings_count, renters_count,
	ROUND(100.0 * renters_count / SUM(renters_count) OVER (), 1) AS renters_percent
FROM t_bookings_rank_count
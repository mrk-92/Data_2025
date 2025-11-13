-- 4 - Минимум и максимум заселений за 30 дней на протяжении года
WITH t_bookings_count AS (
	SELECT
		DATE_TRUNC('day', check_in_date) AS bookings_date,
		COUNT(check_in_date) AS bookings_count
	FROM bookings
	GROUP BY bookings_date
	ORDER BY bookings_date
),
t_bookings_sum_30 AS (
	SELECT
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM bookings_date) ORDER BY bookings_date) AS booking_rank,
		EXTRACT(YEAR FROM bookings_date) AS bookings_year,
		bookings_date,
		SUM(bookings_count) OVER (PARTITION BY EXTRACT(YEAR FROM bookings_date) ORDER BY bookings_date
		ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS bookings_sum_30
	FROM t_bookings_count
)
SELECT 
	bookings_year, 
	MIN(bookings_sum_30) AS min_check_in,
	MAX(bookings_sum_30) AS max_check_in
FROM t_bookings_sum_30
WHERE booking_rank > 29
GROUP BY bookings_year
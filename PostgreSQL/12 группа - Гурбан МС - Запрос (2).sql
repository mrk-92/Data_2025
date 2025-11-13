-- 2 - Количество дней в году, в которые номера были заняты
WITH t_bookings_date AS (
	SELECT 
		b.room_number, 
		GENERATE_SERIES(check_in_date, check_out_date, INTERVAL '1 day')::date AS bookings_date
	FROM bookings b
	ORDER BY room_number
)
SELECT 
	room_number, 
	-- DATE_TRUNC('month', bookings_date) AS booking_month, 
	DATE_TRUNC('year', bookings_date) AS booking_year, 
	COUNT(*) AS stay_days
FROM t_bookings_date
WHERE EXTRACT(YEAR FROM bookings_date) < 2024
GROUP BY room_number, booking_year
ORDER BY stay_days --DESC
-- 3 - Процентное соотношение по прибыли от каждого номера
WITH t_bookings_date AS (
	SELECT 
		b.room_number, 
		GENERATE_SERIES(check_in_date, check_out_date, INTERVAL '1 day')::date AS bookings_date
	FROM bookings b
	ORDER BY room_number
),
t_bookings_count AS (
	SELECT 
		room_number, 
		DATE_TRUNC('year', bookings_date) AS bookings_date_2, 
		-- DATE_TRUNC('month', bookings_date) AS bookings_date_2, 
		COUNT(*) AS stay_days
	FROM t_bookings_date
	WHERE EXTRACT(YEAR FROM bookings_date) < 2024
	GROUP BY room_number, bookings_date_2
	ORDER BY room_number, bookings_date_2
),
t_bookings_profit AS (
	SELECT 
		tbc.room_number, tbc.bookings_date_2, tbc.stay_days, 
		ro.price_per_night, 
		tbc.stay_days * ro.price_per_night AS profit,
		ro.type_name
	FROM t_bookings_count tbc
	JOIN rooms ro ON tbc.room_number = ro.room_number
	ORDER BY tbc.room_number, tbc.bookings_date_2
)
SELECT *,
	ROUND(100.0 * profit / SUM(profit) OVER (PARTITION BY DATE_TRUNC('year', bookings_date_2)), 1) AS profit_percent
	-- ROUND(100.0 * profit / SUM(profit) OVER (PARTITION BY DATE_TRUNC('month', bookings_date_2)), 1) AS profit_percent
FROM t_bookings_profit
ORDER BY profit_percent DESC
-- 1 - Количество дней между бронированием и заселением
WITH t_bookings_pre_order AS (
	SELECT 
		b.booking_id, 
		payment_date, 
		check_in_date,
		check_in_date - payment_date AS pre_order
	FROM bookings b
	JOIN payments p ON b.booking_id = p.booking_id
	ORDER BY check_in_date
)
SELECT 
	MIN(pre_order) AS min_pre_order,
	MAX(pre_order) AS max_pre_order,
	AVG(pre_order) AS avg_pre_order
FROM t_bookings_pre_order
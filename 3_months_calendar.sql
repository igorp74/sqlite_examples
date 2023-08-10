CREATE VIEW vv_monthly_calendar as
WITH 
	RECURSIVE calendar(date_generator) AS (
	SELECT date('now','start of month','-1 month')

	UNION ALL
	
	SELECT date(date_generator, '+1 day')
	FROM calendar
	WHERE date_generator < (SELECT date('now', 'start of month','+2 month','-1 day'))
),
year_calendar as (
	SELECT
		  date_generator
		, CAST(strftime('%Y',date_generator) as int) as Year
		, CAST(strftime('%m',date_generator) as int) as Month
		, CAST(strftime('%W',date_generator) as int) as Week
		, CASE strftime("%w",date_generator)
			WHEN '1' THEN 'Mon'
			WHEN '2' THEN 'Tue'
			WHEN '3' THEN 'Wed'
			WHEN '4' THEN 'Thu'
			WHEN '5' THEN 'Fri'
			WHEN '6' THEN 'Sat'
			WHEN '0' THEN 'Sun'
			ELSE NULL
		  END as Weekday		
		, CAST(strftime('%d',date_generator) as int) as Day
	FROM calendar
),
grid as (
	SELECT  Year,Month,Week, 
	   MAX(CASE WHEN "Weekday" == 'Mon' THEN Day END) as 'Mon',
	   MAX(CASE WHEN "Weekday" == 'Tue' THEN Day END) as 'Tue',
	   MAX(CASE WHEN "Weekday" == 'Wed' THEN Day END) as 'Wed',
	   MAX(CASE WHEN "Weekday" == 'Thu' THEN Day END) as 'Thu',
	   MAX(CASE WHEN "Weekday" == 'Fri' THEN Day END) as 'Fri',
	   MAX(CASE WHEN "Weekday" == 'Sat' THEN Day END) as 'Sat',
	   MAX(CASE WHEN "Weekday" == 'Sun' THEN Day END) as 'Sun'		   
	FROM year_calendar
	GROUP BY Month, Week
)
select * from grid

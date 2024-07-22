USE [Healthify]
GO

SELECT [expert_id]
      ,[team_lead_id]
      ,[user_id]
      ,[India_vs_NRI]
      ,[medicalconditionflag]
      ,[funnel]
      ,[event_type]
      ,[current_status]
      ,[handled_time]
      ,[slot_start_time]
      ,[booked_flag]
      ,[payment_time]
      ,[target_class]
      ,[Payment]
  FROM [dbo].[sales_call_dataset] as sales_data

GO

select count(*) from [dbo].[sales_call_dataset] as sales_data
SELECT DISTINCT(india_vs_nri) FROM [dbo].[sales_call_dataset];
SELECT DISTINCT(medicalconditionflag) FROM [dbo].[sales_call_dataset];
SELECT DISTINCT(funnel) FROM [dbo].[sales_call_dataset];
SELECT DISTINCT(event_type) FROM [dbo].[sales_call_dataset];
SELECT DISTINCT(current_status) FROM [dbo].[sales_call_dataset];
SELECT DISTINCT(booked_flag) FROM [dbo].[sales_call_dataset];
SELECT DISTINCT(target_class) FROM [dbo].[sales_call_dataset];
SELECT DISTINCT(payment) FROM [dbo].[sales_call_dataset];


--1. What are the key factors influencing successful bookings, and how do they vary between Indian and NRI users?
select india_vs_nri, 
	(count(*) * 100.0)/(select count(*) from [dbo].[sales_call_dataset]) as Percentage
from [dbo].[sales_call_dataset]
where booked_flag = 'Booked'
group by india_vs_nri
----- where 87% were Indians, 12% we NRI

--2. Is there a correlation between the presence of medical conditions and booking success?
select medicalconditionflag,
	(count(*) * 100.0)/(select count(*) from [dbo].[sales_call_dataset]) as Percentage
from [dbo].[sales_call_dataset]
where booked_flag = 'Booked'
group by medicalconditionflag;
-- we got 61% of YES and 38% of NO

--3. Can we identify patterns in the funnel stages that lead to higher conversion rates?
select funnel,
	(count(*) * 100.0)/(select count(*) from [dbo].[sales_call_dataset]) as Percentage
from [dbo].[sales_call_dataset]
where booked_flag = 'Booked'
group by funnel;
--56.6%:FT, 43%:Bot


--4. Are there specific times or slots that result in higher booking success?


SELECT
    DATEPART(MONTH, handled_time) AS handled_month,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset]) AS month_percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    booked_flag = 'Booked'
GROUP BY
    DATEPART(MONTH, handled_time)
ORDER BY
    month_percentage DESC;
-- for jan its 55% and  fpr Dec its 43%

-- which DOW  results in higher booking
SELECT
    DATEPART(WEEKDAY, handled_time) AS handled_weekday,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset]) AS weekday_percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    booked_flag = 'Booked'
GROUP BY
    DATEPART(WEEKDAY, handled_time)
ORDER BY
    weekday_percentage DESC;
-- maximum is Monday - 16% and minium is sunday - 8%

SELECT
    datepart(DAY, handled_time) AS handled_day,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset]) AS day_percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    booked_flag = 'Booked'
GROUP BY
     datepart(DAY, handled_time)
ORDER BY
    day_percentage DESC;
-- 28th day we have 4% of bookings



SELECT
    datepart(hour, handled_time) AS handled_hour,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset]) AS day_percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    booked_flag = 'Booked'
GROUP BY
     datepart(hour, handled_time)
ORDER BY
    day_percentage DESC;
-- 17th hour - 8 %


--5. What role does the expertise of the assigned expert play in successful bookings?
select 
	target_class,
	COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset]) AS percentage
from [dbo].[sales_call_dataset]
where booked_flag = 'Booked'
group by target_class
order by 2 desc
-- Most booked by C: 36% then A: 28%



-- PAYMENT/ conversion success
--conversion rate
SELECT
    ROUND((COUNT(CASE WHEN payment = 1 THEN 1 END) * 100.0) / COUNT(*),0) AS conversion_rate
from [dbo].[sales_call_dataset]

-- 5%

--1. NRI V/S INDIANS
SELECT
    india_vs_nri,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset] WHERE payment = 1), 2) AS Percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    payment = 1
GROUP BY
    india_vs_nri;
-- 82% indians, 17.5% NRI


--2. MEDICAL HISTORY
SELECT medicalconditionflag,
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset]
	   WHERE payment = 1), 2) AS Percentage
FROM [dbo].[sales_call_dataset]
WHERE payment = 1
GROUP BY medicalconditionflag;
-- 52.65%:No, 47.35%: Yes


SELECT funnel,
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset] WHERE payment = 1), 2) AS Percentage
FROM [dbo].[sales_call_dataset]
WHERE payment = 1
GROUP BY funnel;
--58% BOT, 41% FT(Free Trial)

--4. DURATION AND CONVERSION
SELECT
    datepart(MONTH, handled_time) AS handled_month,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset] WHERE payment = 1), 2) 
	AS month_percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    payment = 1
GROUP BY
     datepart(MONTH, handled_time)
ORDER BY
    month_percentage DESC;
-- maximum in january: 43% and december 43%


SELECT
    datepart(weekday , handled_time) AS handled_weekday,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset] WHERE payment = 1), 2) AS weekday_percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    payment = 1
GROUP BY
    datepart(weekday , handled_time)
ORDER BY
    weekday_percentage DESC;
--Tuesday maximum:13%, Wednesday-saturday: 13%

SELECT
    datepart(DAY, handled_time) AS handled_day,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset] WHERE payment = 1), 2) AS day_percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    payment = 1
GROUP BY
    datepart(DAY, handled_time)
ORDER BY
    day_percentage DESC;
-- 4th,7th day of the month : 5% ,  5th, 1st day i.e. first week of the month

SELECT
    datepart(HOUR , handled_time) AS handled_hour,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM [dbo].[sales_call_dataset] WHERE payment = 1), 2) AS hour_percentage
FROM
    [dbo].[sales_call_dataset]
WHERE
    payment = 1
GROUP BY
     datepart(HOUR , handled_time)
ORDER BY
    hour_percentage DESC;
-- 10 A.M. : 7%, 11 AM: 8%, 12 PM,14: 6% i.e. morning: 10-12 or 14-18 evening


--4. Target class
SELECT target_class,
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM  [dbo].[sales_call_dataset] WHERE payment = 1), 2) AS Percentage
FROM  [dbo].[sales_call_dataset]
WHERE payment = 1
GROUP BY target_class
ORDER BY 2 DESC;
-- A: 39%, C: 28%
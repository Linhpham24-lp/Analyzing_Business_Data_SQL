--Revenue Quartile
WITH user_revenues AS (
  -- Select the user IDs and their revenues
  SELECT
    user_id,
    SUM(meal_price*order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Calculate the first, second, and third quartile
  ROUND(
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue ASC):: NUMERIC,
  2) AS revenue_p25,
  ROUND(
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue ASC):: NUMERIC,
  2) AS revenue_p50,
  ROUND(
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue ASC):: NUMERIC,
  2) AS revenue_p75,
  -- Calculate the average
  ROUND(avg(revenue) :: NUMERIC, 2) AS avg_revenue
FROM user_revenues;



--Interquartile range

SELECT
    -- Select user_id and calculate revenue by user 
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id
  
  
  
  -- Create a CTE named user_revenues
WITH user_revenues AS (
  SELECT
    -- Select user_id and calculate revenue by user 
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Calculate the first and third revenue quartiles
  ROUND(
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue ASC):: NUMERIC,
  2) AS revenue_p25,
  ROUND(
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue ASC):: NUMERIC,
  2) AS revenue_p75
FROM user_revenues;


WITH user_revenues AS (
  SELECT
    -- Select user_id and calculate revenue by user 
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id),

  quartiles AS (
  SELECT
    -- Calculate the first and third revenue quartiles
    ROUND(
      PERCENTILE_CONT(0.25) WITHIN GROUP
      (ORDER BY revenue ASC) :: NUMERIC,
    2) AS revenue_p25,
    ROUND(
      PERCENTILE_CONT(0.75) WITHIN GROUP
      (ORDER BY revenue ASC) :: NUMERIC,
    2) AS revenue_p75
  FROM user_revenues)

SELECT
  -- Count the number of users in the IQR
  COUNT(DISTINCT user_id) AS users
FROM user_revenues
CROSS JOIN quartiles
-- Only keep users with revenues in the IQR range
WHERE revenue :: NUMERIC >= revenue_p25
  AND revenue :: NUMERIC <= revenue_p75;

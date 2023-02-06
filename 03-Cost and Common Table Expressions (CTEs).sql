--Total Cost
SELECT SUM(meal_cost*stocked_quantity)
FROM meals m JOIN stock s 
ON m.meal_id=s.meal_id

--Top meals by cost
SELECT
  -- Calculate cost per meal ID
  meals.meal_id,
  SUM(stocked_quantity*meal_cost) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id
ORDER BY cost DESC
-- Only the top 5 meal IDs by purchase cost
LIMIT 5;

--Using CTEs:  how much Delivr spent per month on average during its early months (before September 2018)
--A query to calculate cost per month, wrapped in a CTE,
SELECT
  -- Calculate cost
  DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
  SUM(stocked_quantity*meal_cost) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY delivr_month
ORDER BY delivr_month ASC;

-- Declare a CTE named monthly_cost
WITH monthly_cost AS (
  SELECT
    DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
    SUM(meal_cost * stocked_quantity) AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  GROUP BY delivr_month)

SELECT
  -- Calculate the average monthly cost before September
  avg(cost)
FROM monthly_cost
WHERE delivr_month <'2018-09-01'


    

--Profit per eatery

WITH revenue AS (
  -- Calculate revenue per eatery
  SELECT eatery,
          SUM(order_quantity*meal_price) AS revenue
    FROM meals
    JOIN orders ON meals.meal_id = orders.meal_id
   GROUP BY eatery),

  cost AS (
  -- Calculate cost per eatery
  SELECT eatery,
         SUM(stocked_quantity*meal_cost) AS cost
    FROM meals
    JOIN stock ON meals.meal_id = stock.meal_id
   GROUP BY eatery)

   -- Calculate profit per eatery
   SELECT revenue.eatery,
          revenue - cost as profit
     FROM revenue
     JOIN cost ON revenue.eatery = cost.eatery
    ORDER BY profit DESC
    
    
    
--Profit per month

-- Set up the revenue CTE
WITH revenue AS ( 
	SELECT
		DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
		SUM(order_quantity*meal_price) AS revenue
	FROM meals
	JOIN orders ON meals.meal_id = orders.meal_id
	GROUP BY delivr_month),
-- Set up the cost CTE
  cost AS (
 	SELECT
		DATE_TRUNC('month', stocking_date) :: DATE AS delivr_month,
		SUM(stocked_quantity*meal_cost) AS cost
	FROM meals
    JOIN stock ON meals.meal_id = stock.meal_id
	GROUP BY delivr_month)
-- Calculate profit by joining the CTEs
SELECT
	revenue.delivr_month,
	revenue-cost as profit
FROM revenue
JOIN cost ON revenue.delivr_month = cost.delivr_month
ORDER BY revenue.delivr_month ASC;

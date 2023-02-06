--Revenue per customer

-- Calculate revenue
SELECT SUM(meal_price * order_quantity) AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
-- Keep only the records of customer ID 15
WHERE user_id = 15;

--Revenue per week

SELECT DATE_TRUNC('week', order_date) :: DATE AS delivr_week,
       -- Calculate revenue
       SUM(meal_price*order_quantity) AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
-- Keep only the records in June 2018
WHERE DATE_TRUNC('month',order_date) :: DATE = '2018-06-01'
GROUP BY delivr_week
ORDER BY delivr_week ASC;




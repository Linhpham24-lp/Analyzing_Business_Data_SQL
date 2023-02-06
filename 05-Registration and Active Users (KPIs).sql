SELECT
  -- Get the earliest (minimum) order date by user ID
 user_id,
 min(order_date)::DATE AS reg_date
FROM orders
GROUP BY 1
-- Order by user ID
ORDER BY user_id ASC;


--Registrations by month

-- Wrap the query you wrote in a CTE named reg_dates
WITH reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id)

SELECT
  -- Count the unique user IDs by registration month
  DATE_TRUNC('month',reg_date) ::DATE AS delivr_month,
  COUNT(DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY delivr_month
ORDER BY delivr_month ASC; 

--Monthly active users (MAU)

SELECT
  -- Truncate the order date to the nearest month
  DATE_TRUNC('month',order_date) :: DATE AS delivr_month,
  -- Count the unique user IDs
  COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY delivr_month
-- Order by month
ORDER BY delivr_month ASC;


-- 4-1-1
SELECT*FROM purchase_log;

SELECT
  dt
, COUNT(*) AS purchase_count
, SUM(purchase_amount) AS total_amount
, AVG(purchase_amount) AS avg_amount
FROM purchase_log
GROUP BY dt
ORDER BY dt
;

-- 4-1-2
SELECT
   dt
 , SUM(purchase_amount) AS total_amount
 , AVG(SUM(purchase_amount))
   OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
   AS seven_day_avg
-- より厳密に
 , CASE
     WHEN
       7 = COUNT(*)
       OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
     THEN
       AVG(SUM(purchase_amount))
       OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
   END
   AS seven_day_avg_strict
FROM purchase_log
GROUP BY dt
ORDER BY dt
;

-- 4-1-3
SELECT
  dt
, substring(dt, 1, 7) AS year_month
, SUM(purchase_amount) AS total_amount
, SUM(SUM(purchase_amount))
  OVER(PARTITION BY substring(dt, 1, 7) ORDER BY dt ROWS UNBOUNDED PRECEDING)
AS agg_amount
FROM purchase_log
GROUP BY dt
ORDER BY dt
;
-- 4-1-4
WITH
daily_purchase AS (
    SELECT
      dt
    , substring(dt, 1, 4) AS year
    , substring(dt, 6, 2) AS month
    , substring(dt, 9, 2) AS date
    , SUM(purchase_amount) AS purchase_amount
    FROM purchase_log
    GROUP BY dt    
)
SELECT*
FROM daily_purchase
ORDER BY dt
;

WITH
daily_purchase AS (
    SELECT
      dt
    , substring(dt, 1, 4) AS year
    , substring(dt, 6, 2) AS month
    , substring(dt, 9, 2) AS date
    , SUM(purchase_amount) AS purchase_amount
    FROM purchase_log
    GROUP BY dt   
)
SELECT
  dt
, concat(year, '-', month) AS year_month
, purchase_amount
, SUM(purchase_amount)
  OVER(PARTITION BY year ORDER BY dt ROWS UNBOUNDED PRECEDING)
  AS  agg_amount
FROM daily_purchase
ORDER BY dt
;

WITH
daily_purchase AS (
    SELECT
      dt
    , substring(dt, 1, 4) AS year
    , substring(dt, 6, 2) AS month
    , substring(dt, 9, 2) AS date
    , SUM(purchase_amount) AS purchase_amount
    FROM purchase_log
    GROUP BY dt   
)
SELECT
  month
, SUM(CASE year WHEN '2014' THEN purchase_amount END) AS amount_2014
, SUM(CASE year WHEN '2015' THEN purchase_amount END) AS amount_2015
, 100.0
  * SUM(CASE year WHEN '2015' THEN purchase_amount END)
  / SUM(CASE year WHEN '2014' THEN purchase_amount END)
  AS rate
FROM daily_purchase
GROUP BY month
ORDER BY month
;

-- 4-1-5

WITH
daily_purchase AS (
    SELECT
      dt
    , substring(dt, 1, 4) AS year
    , substring(dt, 6, 2) AS month
    , substring(dt, 9, 2) AS date
    , SUM(purchase_amount) AS purchase_amount
    FROM purchase_log
    GROUP BY dt   
)
, monthly_amount AS (
    SELECT
      year
    , month
    , SUM(purchase_amount) AS amount
    FROM daily_purchase
    GROUP BY year, month
)
, cals_index AS (
    SELECT
      year
    , month
    , amount
    , SUM(CASE WHEN year = '2015' THEN amount END)
      OVER(ORDER BY year, month ROWS UNBOUNDED PRECEDING)
      AS agg_amount
    , SUM(amount)
      OVER(ORDER BY year, month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)
      AS year_avg_amount
    FROM monthly_amount
    ORDER BY year, month
)
SELECT
  concat(year, '-', month) AS year_month
, amount
, agg_amount
, year_avg_amount
FROM cals_index
WHERE year = '2015'
ORDER BY year_month
;

-- 4-1-6

\i SQL_Recipe_sample-code_20170325/Chapter4/4-1-6-data.sql
SELECT*FROM purchase_log;

WITH
daily_purchase AS (
    SELECT
      dt
    , order_id
    , substring(dt, 1, 4) AS year
    , substring(dt, 6, 2) AS month
    , substring(dt, 9, 2) AS date
    , SUM(purchase_amount) AS purchase_amount
    FROM purchase_log
    GROUP BY dt, order_id
)
, monthly_purchase AS (
    SELECT
      year
    , month
    , SUM(order_id) AS orders
    , AVG(purchase_amount) AS avg_amount
    , SUM(purchase_amount) AS monthly
    FROM daily_purchase
    GROUP BY year, month
)
SELECT
  concat(year, '-', month) AS year_month
, orders
, avg_amount
, monthly
, SUM(monthly)
    OVER(PARTITION BY year ORDER BY month ROWS UNBOUNDED PRECEDING)
  AS agg_amount
, LAG(monthly, 12)
    OVER(ORDER BY year, month) 
  AS last_year
, 100.0
  * monthly
  / LAG(monthly, 12)
      OVER(ORDER BY year, month)
  AS rate
FROM monthly_purchase
ORDER BY year_month
;

-- 4-2-1
SELECT*FROM purchase_detail_log;

WITH
sub_category_amount AS (
    SELECT
      category AS category
    , sub_category AS sub_category
    , SUM(price) AS amount
    FROM purchase_detail_log
    GROUP BY
      category, sub_category
)
, category_amount AS (
    SELECT
      category
    , 'all' AS sub_category
    , SUM(price) AS amount
    FROM purchase_detail_log
    GROUP BY category
)
, total_amount AS (
    SELECT
      'all' AS category
    , 'all' AS sub_category
    , SUM(price) AS amount
    FROM purchase_detail_log
)
          SELECT category, sub_category, amount FROM sub_category_amount
UNION ALL SELECT category, sub_category, amount FROM category_amount
UNION ALL SELECT category, sub_category, amount FROM total_amount
;

-- ROLLUPを用いたver.
SELECT
  COALESCE(category, 'all') AS category
, COALESCE(sub_category, 'all') AS sub_category
, SUM(price) AS amount
FROM purchase_detail_log
GROUP BY
  ROLLUP(category, sub_category)
;

-- 4-2-2
SELECT * FROM purchase_detail_log;

WITH
monthly_sales AS (
  SELECT
    category
  , SUM(price) AS amount
  FROM purchase_detail_log
  WHERE
   dt BETWEEN '2015-12-01' AND '2015-12-31'
  GROUP BY category
)
, sales_composition_ratio AS (
  SELECT
    category
  , amount
  , 100.0 * amount / SUM(amount) OVER() AS composition_ratio
  , 100.0 * SUM(amount) OVER(ORDER BY amount DESC) / 
  SUM(amount) OVER() cumulative_ratio
  FROM monthly_sales
)
SELECT
  *
  , CASE
      WHEN cumulative_ratio BETWEEN 0 AND 70 THEN 'A'
      WHEN cumulative_ratio BETWEEN 70 AND 90 THEN 'B'
      WHEN cumulative_ratio BETWEEN 90 AND 100 THEN 'C'
    END AS abc_rank
  FROM sales_composition_ratio
  ORDER BY amount DESC
;

-- 4-2-3
WITH
daily_category_amount AS (
  SELECT
    dt
  , category
  , substring(dt, 1, 4) AS year
  , substring(dt, 6, 2) AS month
  , substring(dt, 9, 2) AS date
  , SUM(price) AS amount
  FROM purchase_detail_log
  GROUP BY dt, category
)
, monthly_category_amount AS (
  SELECT
    concat(year, '-', month) AS year_month
  , category
  , SUM(amount) AS amount
  FROM daily_category_amount
  GROUP BY year, month, category
)
SELECT
  year_month
, category
, amount
, FIRST_VALUE(amount)
    OVER(PARTITION BY category ORDER BY year_month, category ROWS UNBOUNDED PRECEDING)
  AS base_amount
, 100.0 * amount / 
  FIRST_VALUE(amount)
    OVER(PARTITION BY category ORDER BY year_month, category ROWS UNBOUNDED PRECEDING)
  AS rate
FROM monthly_category_amount
ORDER BY year_month, category
;

WITH
stats AS (
  SELECT
    MAX(price) AS max_price
  , MIN(price) AS min_price
  , MAX(price) - MIN(price) AS range_price
  , 10 AS bucket_num
  FROM purchase_detail_log
)
SELECT *
FROM stats
;

WITH
stats AS (
  SELECT
    MAX(price) + 1 AS max_price
  , MIN(price) AS min_price
  , MAX(price) + 1 - MIN(price) AS range_price
  , 10 AS bucket_num
  FROM purchase_detail_log
)
, purchase_log_with_buckets AS (
SELECT
  price
, min_price
, price - min_price AS diff
, 1.0 * range_price / bucket_num AS bucket_range
-- , FLOOR(
--   1.0 * (price - min_price)
--   / (1.0 *range_price / bucket_num)
--   )  + 1 AS buckt
-- 組み込み関数
, width_bucket(price, min_price, max_price, bucket_num) AS bucket 
FROM purchase_detail_log, stats)
SELECT * 
FROM purchase_log_with_buckets
ORDER BY price
;

WITH
stats AS (
  SELECT
    MAX(price) + 1 AS max_price
  , MIN(price) AS min_price
  , MAX(price) + 1 - MIN(price) AS range_price
  , 10 AS bucket_num
  FROM purchase_detail_log
)
, purchase_log_with_buckets AS (
SELECT
  price
, min_price
, price - min_price AS diff
, 1.0 * range_price / bucket_num AS bucket_range
-- , FLOOR(
--   1.0 * (price - min_price)
--   / (1.0 *range_price / bucket_num)
--   )  + 1 AS buckt
-- 組み込み関数
, width_bucket(price, min_price, max_price, bucket_num) AS bucket 
FROM purchase_detail_log, stats)
SELECT
  bucket
, min_price + bucket_range * (bucket - 1) AS lower_limit
, min_price + bucket_range * bucket AS upper_limit
, COUNT(price) AS num_purchase
, SUM(price) AS total_amount
FROM purchase_log_with_buckets
GROUP BY bucket, min_price, bucket_range
ORDER BY bucket
;
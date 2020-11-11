-- 3-1-2
-- substring(string from pattern)
SELECT*FROM access_log;

SELECT
stamp,
substring(referrer from 'https?://([^/]*)') AS referrer_host
FROM access_log;

SELECT
stamp,
substring(url from '//[^/]+([^?#]+)') AS path,
substring(url from 'id=([^&]*)') AS id
FROM access_log;

-- 3-1-3
-- split_part(string text, delimiter text, field int)
SELECT
stamp,
url,
split_part(substring(url from '//[^/]+([^?#]+)'), '/', 2) AS path1,
split_part(substring(url from '//[^/]+([^?#]+)'), '/', 3) AS path2
FROM access_log;

-- 3-1-4
SELECT
CURRENT_DATE AS dt,
CURRENT_TIMESTAMP as stamp,
LOCALTIMESTAMP as localstamp;

SELECT
CAST('2016-01-30' AS date) AS dt,
CAST('2016-01-30 12:00:00' AS timestamp) AS stamp;

SELECT
stamp,
EXTRACT(YEAR FROM stamp) AS year,
EXTRACT(HOUR FROM stamp) AS hour
FROM
(SELECT CAST('2016-01-30 12:00:00' AS timestamp) AS stamp) AS t;

SELECT
stamp,
substring(stamp, 1, 4) AS year,
substring(stamp, 6, 2) AS month
-- substrでもok
-- substr(stamp, 1, 4) AS year
FROM
(SELECT CAST('2016-01-30 12:00:00' AS text) AS stamp) AS t;

-- 3-1-5
-- COARESCE(columnname, NULLの場合に置き換えたい値) 
SELECT
purchase_id,
amount,
coupon,
amount - coupon AS discount_amount1,
amount - COALESCE(coupon, 0) AS discount_amount2
FROM
purchase_log_with_coupon;

-- 3-2-1
SELECT
user_id,
CONCAT(pref_name, city_name) AS pref_city
-- 演算子||でもok
-- pref_name || city_name AS pref_city
FROM
mst_user_location;

-- 3-2-2
SELECT
year,
q1,
q2,
CASE
WHEN q1 < q2 THEN '+'
WHEN q1 = q2 THEN ' '
ELSE '-'
END AS judge_q1_q2,
q2 - q1 AS diff,
SIGN(q2 -q1) AS sign
FROM
quarterly_sales
ORDER BY
year;

SELECT
year,
greatest(q1, q2, q3, q4) AS greatest_sales,
least(q1, q2, q3, q4) AS least_sales
FROM
quarterly_sales
ORDER BY
year;

SELECT
year, 
(q1 + q2 + q3 + q4) / 4 AS average
FROM
quarterly_sales
ORDER BY
year;

SELECT
year, 
(COALESCE(q1, 0) + COALESCE(q2, 0)+ COALESCE(q3, 0) + COALESCE(q4, 0)) / 
(SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0)) + SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0)))
AS average
FROM
quarterly_sales
ORDER BY
year;

-- 3-2-3
SELECT*FROM advertising_stats;

SELECT
dt,
ad_id,
CAST(clicks AS double precision) / impressions AS ctr,
100.0 * clicks / impressions AS ctr_as_percent
FROM
advertising_stats
WHERE
dt = '2017-04-01'
ORDER BY
dt, ad_id;

SELECT
dt,
ad_id,
-- CESEの場合
-- CASE
-- WHEN impressions > 0 THEN 100.0 * clicks / impressions
-- END AS ctr_as_percent_by_case
-- NULLIFの場合
100.0 * clicks / NULLIF(impressions, 0) AS ctr_as_percent
FROM
advertising_stats
ORDER BY
dt, ad_id;

-- 3-2-4
SELECT*FROM location_1d;
SELECT*FROM location_2d;

SELECT
abs(x1 - x2) AS abs,
sqrt(power(x1 -x2, 2)) AS rms
FROM
location_1d;

SELECT
sqrt(power(x1 -x2, 2) + power(y1 -y2, 2)) AS dist,
point(x1, y1) <-> point(x2, y2) AS dist_by_point
FROM
location_2d;

-- 3-2-5
SELECT*FROM mst_users_with_birthday;

SELECT
user_id,

register_stamp::timestamp AS register_stamp,
register_stamp::timestamp + '1 hour'::interval AS after_1_hour,

register_stamp::date AS register_date,
(register_stamp::date - '1 month'::interval)::date AS before_1_month
FROM
mst_users_with_birthday;

SELECT
user_id,
CURRENT_DATE AS today,
register_stamp::date AS register_date,
CURRENT_DATE - register_stamp::date AS diff_days
FROM
mst_users_with_birthday;

SELECT
user_id,
CURRENT_DATE AS today,
register_stamp::date AS register_date,
birth_date::date AS birth_date,
EXTRACT(YEAR FROM age(birth_date::date)) AS current_age,
EXTRACT(YEAR FROM age(register_stamp::date, birth_date::date)) AS register_age
FROM
mst_users_with_birthday;

SELECT
user_id,
substring(register_stamp, 1, 10) AS register_date,
floor(
     (CAST(replace(substring(register_stamp, 1, 10), '-', '') AS integer)
      - CAST(replace(birth_date, '-', '') AS integer)
     ) /10000
) AS register_age
FROM
mst_users_with_birthday;

-- 3−2−6
SELECT
CAST('127.0.0.1' AS inet) < CAST('127.0.0.2' AS inet) AS lt,
CAST('127.0.0.1' AS inet) > CAST('127.0.0.2' AS inet) AS gt
;

SELECT
CAST('127.0.0.1' AS inet) << CAST('127.0.0.0/8' AS inet) AS is_contained
;

SELECT
ip,
CAST(split_part(ip, '.', 1) AS integer) AS ip_1,
CAST(split_part(ip, '.', 2) AS integer) AS ip_2,
CAST(split_part(ip, '.', 3) AS integer) AS ip_3,
CAST(split_part(ip, '.', 4) AS integer) AS ip_4
FROM
(SELECT CAST('192.168.0.1' AS text) AS ip) AS t
;

SELECT
ip,
CAST(split_part(ip, '.', 1) AS integer) * 2^24
 + CAST(split_part(ip, '.', 2) AS integer) * 2^16
 + CAST(split_part(ip, '.', 3) AS integer) * 2^8
 + CAST(split_part(ip, '.', 4) AS integer) * 2^0
AS ip_interger
FROM
(SELECT CAST('192.168.0.1' AS text) AS ip) AS t
;

SELECT
ip,
lpad(split_part(ip, '.', 1), 3, '0')
 || lpad(split_part(ip, '.', 2), 3, '0')
 || lpad(split_part(ip, '.', 3), 3, '0')
 || lpad(split_part(ip, '.', 4), 3, '0')
AS ip_padding
FROM
(SELECT CAST('192.168.0.1' AS text) AS ip) AS t
;

-- 3-3-1
SELECT*FROM review;

SELECT
COUNT(*) AS total_count,
COUNT(DISTINCT user_id) AS user_count,
COUNT(DISTINCT product_id) AS product_count,
SUM(score) AS sum,
AVG(score) AS avg,
MAX(score) AS max
FROM
review
-- GROUP BY句を使用したクエリでは、SELECT句に指定できるカラムはGROUP BY句に指定したカラムか集約関数だけ。
GROUP BY
user_id
;

SELECT
user_id,
product_id,
score,
AVG(score) OVER() AS avg_score,
AVG(score) OVER(PARTITION BY user_id) AS user_avg_score,
score - AVG(score) OVER(PARTITION BY user_id) AS user_avg_score_diff
FROM
review
;

-- 3-3-2
SELECT*FROM popular_products;

SELECT
  product_id
, score
, ROW_NUMBER() OVER(ORDER BY score DESC) AS row
, RANK() OVER(ORDER BY score DESC) AS rank
, DENSE_RANK() OVER(ORDER BY score DESC) AS dense_rank
, LAG(product_id) OVER(ORDER BY score DESC) AS lag1
, LAG(product_id, 2) OVER(ORDER BY score DESC) AS lag2
, LEAD(product_id) OVER(ORDER BY score DESC) AS lead1
, LEAD(product_id, 2) OVER(ORDER BY score DESC) AS lead2
FROM
popular_products
ORDER BY
row
;

SELECT
  product_id
, score
, ROW_NUMBER() OVER(ORDER BY score DESC) AS row
, SUM(score)
    OVER(ORDER BY score DESC
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
  AS cum_score
, AVG(score)
    OVER(ORDER BY score DESC
         ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
  AS local_avg
, FIRST_VALUE(product_id)
    OVER(ORDER BY score DESC
         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
  AS first_value       
FROM
popular_products
ORDER BY
row
;

SELECT
  product_id
, ROW_NUMBER() OVER(ORDER BY score DESC) AS row
, array_agg(product_id)
    OVER(ORDER BY score DESC
         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
  AS whole_agg
, array_agg(product_id)
    OVER(ORDER BY score DESC
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
  AS cum_agg
FROM
popular_products
WHERE
category = 'action'
ORDER BY
row
;

SELECT
  category
, product_id
, score
, ROW_NUMBER() OVER(PARTITION BY category ORDER BY score DESC)
  AS row
, RANK() OVER(PARTITION BY category ORDER BY score DESC)
  AS rank
FROM
popular_products
ORDER BY
category, row
;

SELECT *
FROM
(
    SELECT
      category
    , product_id
    , score
    , ROW_NUMBER() OVER(PARTITION BY category ORDER BY score DESC)
    AS row
    , RANK() OVER(PARTITION BY category ORDER BY score DESC)
    AS rank
    FROM
    popular_products
) AS popular_products_with_rank
WHERE rank <=2
ORDER BY
category, rank
;

SELECT DISTINCT
  category
  , FIRST_VALUE(product_id)
    OVER(PARTITION BY category ORDER BY score DESC
         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
    AS product_id
FROM
popular_products
;

-- 3-3-3
SELECT*FROM daily_kpi;

SELECT
  dt
, MAX(CASE WHEN indicator = 'impressions' THEN val END) AS impressions
, MAX(CASE WHEN indicator = 'sessions' THEN val END) AS sessions
, MAX(CASE WHEN indicator = 'users' THEN val END) AS users
FROM
daily_kpi
GROUP BY dt
ORDER BY dt
;

SELECT*FROM purchase_detail_log;

SELECT
  purchase_id
, string_agg(product_id, ',') AS product_ids
, SUM(price) AS amount
FROM purchase_detail_log
GROUP BY purchase_id
ORDER BY purchase_id
;

-- 3-3-4
SELECT*FROM quarterly_sales;

SELECT
  q.year
, CASE
  WHEN p.idx = 1 THEN 'q1'
  WHEN p.idx = 2 THEN 'q2'
  WHEN p.idx = 3 THEN 'q3'
  WHEN p.idx = 4 THEN 'q4'
  END AS quarter
, CASE
  WHEN p.idx = 1 THEN q.q1
  WHEN p.idx = 2 THEN q.q2
  WHEN p.idx = 3 THEN q.q3
  WHEN p.idx = 4 THEN q.q4
  END AS sales
FROM quarterly_sales AS q
 CROSS JOIN
 (        
           SELECT 1 AS idx
 UNION ALL SELECT 2 AS idx
 UNION ALL SELECT 3 AS idx
 UNION ALL SELECT 4 AS idx
 ) AS p
 ;

SELECT*FROM purchase_detail_log;

SELECT 
unnest(ARRAY['A001', 'A002', 'A003'])
AS product_id;

SELECT
  purchase_id
, product_ids
FROM
  purchase_detail_log AS p
 CROSS JOIN unnest(string_to_array(product_id, ',')) AS product_ids
 ;

SELECT*
FROM(
            SELECT 1 AS idx
  UNION ALL SELECT 2 AS idx
  UNION ALL SELECT 3 AS idx
) AS povot
;

SELECT
  split_part('A001, A002, A003', ',', 1) AS part_1
, split_part('A001, A002, A003', ',', 2) AS part_2
, split_part('A001, A002, A003', ',', 3) AS part_3
;

-- 3-4-1
SELECT
'app1' 
AS
  app_name, user_id, name, email
FROM
  app1_mst_users
UNION ALL
SELECT
'app2' 
AS
  app_name, user_id, name, NULL
FROM
  app2_mst_users;

-- 3-4-2
SELECT
  m.category_id
, m.name
, s.sales
, r.product_id
AS sale_product
FROM
  mst_categories AS m
JOIN
  category_sales AS s
  ON m.category_id = s.category_id
JOIN
  product_sale_ranking AS r
  ON m.category_id = r.category_id
; 

SELECT
  m.category_id
, m.name
, s.sales
, r.product_id
AS sale_product
FROM
  mst_categories AS m
LEFT JOIN
  category_sales AS s
  ON m.category_id = s.category_id
LEFT JOIN
  product_sale_ranking AS r
  ON m.category_id = r.category_id
  AND r.rank = 1
; 

SELECT
  m.category_id
, m.name
, (SELECT s.sales
   FROM category_sales AS s
   WHERE m.category_id = s.category_id
  ) AS sales
, (SELECT r.product_id
   FROM product_sale_ranking AS r
   WHERE m.category_id = r.category_id
   ORDER BY sales DESC
   LIMIT 1
  ) AS top_sale_product
FROM mst_categories AS m
;   

-- 3-4-3
SELECT
  m.user_id
, m.card_number
, COUNT(p.user_id) AS purchase_count
, CASE WHEN m.card_number IS NOT NULL THEN 1 ELSE 0 END AS has_card
, SIGN(COUNT(p.user_id)) AS has_purchased
FROM
  mst_users_with_card_number AS m
 LEFT JOIN
   purchase_log AS p
   ON m.user_id = p.user_id
GROUP BY m.user_id, m.card_number
;

-- 3-4-4
WITH
product_sale_ranking AS (
  SELECT
    category_name
  , product_id
  , sales
  , ROW_NUMBER() OVER(PARTITION BY category_name ORDER BY sales DESC) AS rank
  FROM
    product_sales
)
SELECT*
FROM product_sale_ranking
;

WITH
product_sale_ranking AS (
  SELECT
    category_name
  , product_id
  , sales
  , ROW_NUMBER() OVER(PARTITION BY category_name ORDER BY sales DESC) AS rank
  FROM
    product_sales
)
, mst_rank AS (
  SELECT DISTINCT rank
  FROM product_sale_ranking
)
SELECT*
FROM mst_rank
;

WITH
product_sale_ranking AS (
  SELECT
    category_name
  , product_id
  , sales
  , ROW_NUMBER() OVER(PARTITION BY category_name ORDER BY sales DESC) AS rank
  FROM
    product_sales
)
, mst_rank AS (
  SELECT DISTINCT rank
  FROM product_sale_ranking
)
SELECT
  m.rank
, r1.product_id AS dvd
, r1.sales AS dvd_sales
, r2.product_id AS cd
, r2.sales AS cd_sales
, r3.product_id AS book
, r3.sales AS book_sales
FROM
  mst_rank AS m
 LEFT JOIN
  product_sale_ranking AS r1
  ON m.rank = r1.rank
  AND r1.category_name = 'dvd'
 LEFT JOIN
  product_sale_ranking AS r2
  ON m.rank = r2.rank
  AND r2.category_name = 'cd'
 LEFT JOIN
  product_sale_ranking AS r3
  ON m.rank = r3.rank
  AND r3.category_name = 'book'
ORDER BY m.rank
;

-- 3-4-5
WITH
mst_devices AS (
            SELECT 1 AS device_id, 'PC' AS device_name
  UNION ALL SELECT 2 AS device_id, 'SP' AS device_name
  UNION ALL SELECT 3 AS device_id, 'アプリ' AS device_name
)
SELECT*
FROM mst_devices
;

WITH
mst_devices AS (
            SELECT 1 AS device_id, 'PC' AS device_name
  UNION ALL SELECT 2 AS device_id, 'SP' AS device_name
  UNION ALL SELECT 3 AS device_id, 'アプリ' AS device_name
)
SELECT
  u.user_id
, d.device_name
FROM
  mst_users AS u
 LEFT JOIN
   mst_devices AS d
   ON u.register_device = d.device_id
;

WITH
mst_devices(device_id, device_name) AS (
  VALUES
    (1, 'PC')
  , (2, 'SP')
  , (3, 'アプリ')
)
SELECT*
FROM mst_devices
;

WITH
series AS (
  -- １から五までの連番を生成
  SELECT generate_series(1, 5) AS idx
)
SELECT*
FROM series
;
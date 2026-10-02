#. Проверяю, что данные загрузились (первые 5 строк)
SELECT * FROM audience LIMIT 5;

#1.  Расчет MAU
SELECT COUNT(DISTINCT user_id) AS MAU
FROM audience;

#2  Расчет DAU 
SELECT AVG(DAU) AS avg_dau
FROM (
    SELECT date, COUNT(DISTINCT user_id) AS DAU 
    FROM audience 
    GROUP BY date
) AS daily_users;

#3. 
WITH nov_2023 AS (
  
    SELECT user_id, MIN(date) AS first_date
    FROM audience
    GROUP BY user_id
    HAVING MIN(date) = '2023-11-01'
),
returned_next_day AS (

    SELECT DISTINCT a.user_id
    FROM audience a
    JOIN nov_2023 n ON a.user_id = n.user_id
    WHERE a.date = '2023-11-02'
)

SELECT 
    (SELECT COUNT(*) FROM returned_next_day) * 100.0 / (SELECT COUNT(*) FROM nov_2023) AS retention_d1_pct,
    (SELECT COUNT(*) FROM returned_next_day) AS returned_count,
    (SELECT COUNT(*) FROM nov_2023) AS total_cohort_count;
    
#5.
SELECT 
    COUNT(DISTINCT CASE WHEN view_adverts > 0 THEN user_id END) * 100.0 / COUNT(DISTINCT user_id) AS conversion_pct
FROM audience;

#6.
SELECT SUM(view_adverts) / COUNT(DISTINCT user_id) AS avg_views_per_user
FROM audience;

#7.
SELECT 
    (1200 - 500) * 100.0 / 2000 AS nps;
    
#8.
SELECT 
    experiment_num,
    experiment_group,
    SUM(revenue) / COUNT(DISTINCT user_id) AS arpu
FROM ab_test
GROUP BY experiment_num, experiment_group;


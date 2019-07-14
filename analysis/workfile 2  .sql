---Revenue per platfrom------
SELECT
    signup_platform,
    is_paid_channel,
    SUM(net_revenue)
FROM
    subscriptions
WHERE
    subscription_date BETWEEN '2016-10-01' AND '2017-03-31'
GROUP BY
    1,2;
-------------subscription_count distribtuion per platform
SELECT
    signup_platform,
    subscription_count,
    COUNT(*)
FROM
    subscriptions
WHERE
    subscription_date BETWEEN '2016-10-01' AND '2017-03-31'
AND is_paid_channel IS true
GROUP BY
    1,2;
--------------spendings per month per platfrom
SELECT
    platform,
    EXTRACT(MONTH FROM report_date) AS MonthOfDate ,
    SUM(spendings)
FROM
    spendings
WHERE
    is_paid_channel IS true
AND report_date BETWEEN '2016-10-01' AND '2017-03-31'
AND platform IN('ios',
                'android')
GROUP BY
    1,2;
-----------------subscription per region
SELECT
    signup_platform,
    sub_region,
    SUM(net_revenue)
FROM
    subscriptions a
LEFT JOIN
    countries b
ON
    a.signup_country_code=b.country_code
WHERE
    is_paid_channel IS true
AND subscription_date BETWEEN '2016-10-01' AND '2017-03-31'
AND signup_platform IN('ios',
                       'android')
GROUP BY
    1,2;
------------subscription count per platfrom
SELECT
    signup_platform,
    CASE
        WHEN subscription_count < 10
        THEN CAST(subscription_count AS VARCHAR)
        WHEN subscription_count BETWEEN 10 AND 15
        THEN '10-15'
        WHEN subscription_count BETWEEN 16 AND 20
        THEN '16-20'
        WHEN subscription_count BETWEEN 21 AND 30
        THEN '21-30'
        WHEN subscription_count BETWEEN 31 AND 40
        THEN '31-40'
        WHEN subscription_count >= 40
        THEN '40+'
    END AS subscription_count,
    COUNT(*)
FROM
    subscriptions
WHERE
    is_paid_channel IS true
AND subscription_date BETWEEN '2016-10-01' AND '2017-03-31'
AND signup_platform IN('ios',
                       'android')
GROUP BY
    1,2;
------------------paying user count per platfrom
SELECT DISTINCT
    signup_platform,
    CASE
        WHEN net_revenue>0
        THEN '1'
        ELSE '0'
    END AS is_pay,
    COUNT(*)
FROM
    subscriptions
WHERE
    signup_platform IN('ios',
                       'android')
AND subscription_date BETWEEN '2016-10-01' AND '2017-03-31'
GROUP BY
    1,2;
--------------Revnue distribtion per platfrom
SELECT DISTINCT
    signup_platform,
    PERCENTILE_DISC ( 0.1 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_1,
    PERCENTILE_DISC ( 0.2 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_2,
    PERCENTILE_DISC ( 0.3 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_3,
    PERCENTILE_DISC ( 0.4 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_4,
    PERCENTILE_DISC ( 0.5 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_5,
    PERCENTILE_DISC ( 0.6 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_6,
    PERCENTILE_DISC ( 0.7 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_7,
    PERCENTILE_DISC ( 0.8 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_8,
    PERCENTILE_DISC ( 0.9 ) WITHIN GROUP ( ORDER BY net_revenue ) AS p_9,
    AVG(net_revenue)
FROM
    subscriptions
WHERE
    net_revenue>0
AND is_paid_channel IS true
AND subscription_date BETWEEN '2016-10-01' AND '2017-03-31'
GROUP BY
    1;
--------num. of acquisitions per platfrom
SELECT
    signup_platform,
    COUNT(*)
FROM
    subscriptions
WHERE
    subscription_date BETWEEN '2016-10-01' AND '2017-03-31'
GROUP BY
    1
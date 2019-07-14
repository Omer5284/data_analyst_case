---1. How much did we spent per channel in December?--
SELECT
    marketing_channel_id,
    SUM(spendings)
FROM
    dwh.spendings
WHERE
    is_paid_channel IS true
AND report_date BETWEEN '2016-10-01' AND '2017-01-31'
AND EXTRACT(MONTH FROM report_date)=12.0
GROUP BY
    1;
---------2. What is the average cost of acquisition for a subscription per country?
SELECT
    b.country_name,
    spendings/users AS avg_cost_of_acquisition_per_subscription
FROM
    (
        SELECT
            signup_country_code,
            COUNT(*) AS users
        FROM
            dwh.subscriptions
        WHERE
            is_paid_channel IS true
        AND subscription_date BETWEEN '2016-10-01' AND '2017-01-31'
        GROUP BY
            1) a
LEFT JOIN
    dwh.countries b
ON
    a.signup_country_code=b.country_code
LEFT JOIN
    (
        SELECT
            country_code,
            SUM(spendings) AS spendings
        FROM
            dwh.spendings
        WHERE
            is_paid_channel IS true
        AND report_date BETWEEN '2016-10-01' AND '2017-01-31'
        GROUP BY
            1)c
ON
    a.signup_country_code=c.country_code;
---------3. What is our average revenue and spending per day of the week (Monday, Tuesday...)?
SELECT
    CASE
        WHEN a.dow=0.0
        THEN 'Sun'
        WHEN a.dow=1.0
        THEN 'Mon'
        WHEN a.dow= 2.0
        THEN 'Tue'
        WHEN a.dow=3.0
        THEN 'Wed'
        WHEN a.dow=4.0
        THEN 'Thu'
        WHEN a.dow=5.0
        THEN 'fry'
        WHEN a.dow=6.0
        THEN 'Sta'
    END as dow,
    avg_spendings,
    avg_net_revenue
FROM
    (
        SELECT
            extract(dow FROM report_date) AS dow,
            AVG(spendings)                AS avg_spendings
        FROM
            dwh.spendings
        WHERE
            is_paid_channel IS true
        AND report_date BETWEEN '2016-10-01' AND '2017-01-31'
        GROUP BY
            1)a
LEFT JOIN
    (
        SELECT
            extract(dow FROM subscription_date) AS dow,
            AVG(net_revenue)                    AS avg_net_revenue
        FROM
            dwh.subscriptions
        WHERE
            is_paid_channel IS true
        AND subscription_date BETWEEN '2016-10-01' AND '2017-01-31'
        GROUP BY
            1)b
ON
    a.dow=b.dow
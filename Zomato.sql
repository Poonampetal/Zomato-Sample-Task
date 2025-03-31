-- a) Calculate: total_transactions, unique_users and total_transaction_amount for every date and hour combination.

SELECT 
    DATE(timestamp) AS transaction_date,
    DATEPART(HOUR, timestamp) AS transaction_hour,
    COUNT(transaction_id) AS total_transactions,
    COUNT(DISTINCT user_id) AS unique_users,
    SUM(transaction_amount) AS total_transaction_amount
FROM
    transactions
GROUP BY transaction_date , transaction_hour
ORDER BY transaction_date , transaction_hour;


-- b) Calculate hour with highest transaction_amount for every date

SELECT transaction_date, transaction_hour, total_transaction_amount
FROM ( SELECT
        DATE(timestamp) AS transaction_date,
        EXTRACT(HOUR FROM timestamp) AS transaction_hour,
        SUM(transaction_amount) AS total_transaction_amount,
        RANK() OVER (PARTITION BY DATE(timestamp) ORDER BY SUM(transaction_amount) DESC) AS rnk
    FROM transactions
    GROUP BY transaction_date, transaction_hour) ranked
WHERE rnk = 1;

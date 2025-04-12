Create database Debt_Collection
USE debt_collection ;
select *
from debtors;

SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS missing_names,
    SUM(CASE WHEN total_debt IS NULL THEN 1 ELSE 0 END) AS missing_total_debt,
    SUM(CASE WHEN total_paid IS NULL THEN 1 ELSE 0 END) AS missing_total_paid,
    SUM(CASE WHEN phone IS NULL THEN 1 ELSE 0 END) AS missing_phones
FROM debtors;

SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS missing_names
FROM collectors;

SELECT 
    SUM(CASE WHEN debtor_id IS NULL THEN 1 ELSE 0 END) AS missing_debtor_ids,
    SUM(CASE WHEN amount_paid IS NULL THEN 1 ELSE 0 END) AS missing_amount_paid,
    SUM(CASE WHEN payment_date IS NULL THEN 1 ELSE 0 END) AS missing_payment_dates
FROM payments;

SELECT 
    SUM(CASE WHEN debtor_id IS NULL THEN 1 ELSE 0 END) AS missing_debtor_ids,
    SUM(CASE WHEN collector_id IS NULL THEN 1 ELSE 0 END) AS missing_collector_ids,
    SUM(CASE WHEN attempt_date IS NULL THEN 1 ELSE 0 END) AS missing_attempt_dates,
    SUM(CASE WHEN outcome IS NULL THEN 1 ELSE 0 END) AS missing_outcomes
FROM collection_attempts;

/* checking duplicates */

SELECT name, phone, COUNT(*) 
FROM debtors 
GROUP BY name, phone 
HAVING COUNT(*) > 1;

Select debtor_id, amount_paid, payment_date, count(*)
from payments
group by payment_date, debtor_id, amount_paid
Having count(*) > 1;

select name, count(*)
from collectors
group by name
having count(*) >1;

select debtor_id, collector_id, attempt_date, outcome, count(*)
from collection_attempts
group by debtor_id, collector_id, attempt_date, outcome
having count(*) > 1;

DESC debtors;
ALTER TABLE debtors 
MODIFY COLUMN total_debt DECIMAL(10,2);  -- Correct debt values to decimal

ALTER TABLE debtors 
MODIFY COLUMN phone VARCHAR(15);  -- Ensure phone numbers are properly formatted

ALTER TABLE debtors 
MODIFY COLUMN city VARCHAR(50);  -- Optimize storage for city names

DESC collectors;

DESC payments;

ALTER TABLE payments
modify column payment_date date; -- Modify it to date type

alter table payments
modify column amount_paid decimal(10,2); -- Change it to decimal

DESC collection_attempts;

alter table collection_attempts
modify column attempt_date date; -- Changes type to date

-- Validating foriegn key relationship
SELECT p.debtor_id 
FROM payments p 
LEFT JOIN debtors d ON p.debtor_id = d.debtor_id 
WHERE d.debtor_id IS NULL;

SELECT c.debtor_id 
FROM collection_attempts c
LEFT JOIN debtors d ON c.debtor_id = d.debtor_id 
WHERE d.debtor_id IS NULL;

SELECT c.debtor_id 
FROM collection_attempts c
LEFT JOIN debtors d ON c.debtor_id = d.debtor_id 
WHERE d.debtor_id IS NULL;

SELECT c.collector_id 
FROM collection_attempts c
LEFT JOIN collectors col ON c.collector_id = col.collector_id 
WHERE col.collector_id IS NULL;

-- Verfiying negative and invalid values
SELECT * FROM debtors 
WHERE total_debt < 0 OR total_paid < 0;

SELECT * FROM payments 
WHERE amount_paid < 0;

-- Overview of Data

SELECT 
    (SELECT COUNT(*) FROM debtors) AS total_debtors,
    (SELECT COUNT(*) FROM payments) AS total_payments,
    (SELECT COUNT(*) FROM collection_attempts) AS total_collection_attempts;
    
SELECT 
    AVG(total_debt) AS avg_debt,
    min(total_debt) AS min_debt,
    max(total_debt) AS max_debt
FROM debtors;

SELECT 
    MIN(amount_paid) AS min_payment,
    MAX(amount_paid) AS max_payment
FROM payments;

-- Debt Distribution Analysis

SELECT 
    CASE 
        WHEN total_debt < 5000 THEN 'Low'
        WHEN total_debt BETWEEN 5000 AND 20000 THEN 'Medium'
        ELSE 'High'
    END AS debt_category,
    COUNT(*) AS num_debtors
FROM debtors
GROUP BY debt_category;

SELECT 
    COUNT(CASE WHEN total_paid >= total_debt THEN 1 END) AS fully_paid_debtors,
    COUNT(CASE WHEN total_paid < total_debt THEN 1 END) AS pending_debtors
FROM debtors;

SELECT 
    (COUNT(DISTINCT debtor_id) / (SELECT COUNT(*) FROM debtors)) * 100 AS percentage_with_payments
FROM payments;

SELECT COUNT(*) AS zero_payment_debtors 
FROM debtors 
WHERE debtor_id NOT IN (SELECT DISTINCT debtor_id FROM payments);

-- Collector Performance

SELECT 
    col.collector_id, 
    col.name, 
    SUM(p.amount_paid) AS total_recovered
FROM payments p
JOIN collection_attempts ca ON p.debtor_id = ca.debtor_id
JOIN collectors col ON ca.collector_id = col.collector_id
GROUP BY col.collector_id, col.name
ORDER BY total_recovered DESC;

SELECT collector_id, COUNT(*) AS total_attempts
FROM collection_attempts
GROUP BY collector_id
ORDER BY total_attempts DESC;

SELECT collector_id, 
       COUNT(*) AS total_attempts, 
       SUM(CASE WHEN outcome = 'Failed' THEN 1 ELSE 0 END) AS failed_attempts, 
       (SUM(CASE WHEN outcome = 'Failed' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS failure_rate
FROM collection_attempts
GROUP BY collector_id
ORDER BY failure_rate DESC;

SELECT 
    debtor_id, 
    COUNT(debtor_id) AS collection_attempts,
    max(amount_paid) AS amount_recovered 
FROM  payments
GROUP BY debtor_id
ORDER BY amount_recovered DESC 
LIMIT 5;

SELECT 
    CASE 
        WHEN amount_paid BETWEEN 0 AND 5000 THEN '0 - 5000'
        WHEN amount_paid BETWEEN 5001 AND 15000 THEN '5001 - 15000'
        ELSE '15001 and Above'
    END AS payment_range,
    COUNT(DISTINCT debtor_id) AS unique_debtors
FROM payments
GROUP BY payment_range;

SELECT 
    CASE 
        WHEN amount_paid BETWEEN 0 AND 5000 THEN '0-5K'
        WHEN amount_paid BETWEEN 5001 AND 10000 THEN '5K-10K'
        WHEN amount_paid BETWEEN 10001 AND 20000 THEN '10K-20K'
        WHEN amount_paid > 20000 THEN '20K+'
    END AS payment_range,
    COUNT(*) AS count_payments,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments)), 2) AS percentage
FROM payments
GROUP BY payment_range
ORDER BY percentage DESC;








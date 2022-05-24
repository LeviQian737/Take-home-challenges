CREATE TABLE march (
	user_id int,
	date varchar,
	transaction_amount int
)

CREATE TABLE april (
	user_id int,
	date varchar,
	transaction_amount int
)
'''
question 1
Write a query that returns the total amount of money spent by each user. That is, the sum
of the column transaction_amount for each user over both tables.
'''

-- my solution
SELECT user_id, SUM(transaction_amount) as total_amount
FROM
	(SELECT *
	FROM march
	UNION ALL
	SELECT *
	FROM april) tmp
GROUP BY user_id
ORDER BY user_id

-- sample solution
SELECT user_id,
SUM(transaction_amount) as total_amount
FROM
(
SELECT * FROM march
UNION ALL
SELECT * FROM april
) tmp
GROUP BY user_id
ORDER BY user_id
LIMIT 5;


'''
question 2
Write a query that returns day by day the cumulative sum of money spent by each user.
That is, each day a user had a transcation, we should have how much money she has
spent in total until that day. Obviously, the last day cumulative sum should match the
numbers from the previous bullet point.
'''
-- my solution
-- !!!!REMEBER that we need to first group the transactions of same day from same customer into 1 transaction
SELECT user_id,date,
	SUM(total_amount) OVER(partition by user_id order by date) as total_amount
FROM
	(SELECT user_id, date, SUM(transaction_amount) as total_amount
	 FROM march
	 GROUP BY user_id, date
	 UNION ALL
	 SELECT user_id, date, SUM(transaction_amount) as total_amount
	 FROM april
	 GROUP BY user_id, date
	) tmp

-- sample solution
SELECT user_id,date,
	SUM(amount) over(PARTITION BY user_id ORDER BY date) as total_amount
FROM
	(
	SELECT user_id, date, SUM(transaction_amount) as amount
	FROM march
	GROUP BY user_id, date
	UNION ALL
	SELECT user_id, date, SUM(transaction_amount) as amount
	FROM april
	GROUP BY user_id, date
	) tmp
ORDER BY user_id, date
LIMIT 5;
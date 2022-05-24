CREATE TABLE data (
	user_id int,
	date varchar
)
'''
Write a query that 
returns for each user on which day they became a power user. That is, for each user, on which
day they bought the 10th item.
'''
-- my solution
SELECT user_id, date
FROM
	(SELECT *,
		COUNT(date) OVER(partition by user_id order by date) as purchase_times
	FROM data) tmp
WHERE purchase_times = 10

-- sample solution
SELECT user_id, date
FROM
	(SELECT *, ROW_NUMBER() over(PARTITION BY user_id ORDER BY date) row_num FROM
	data ) tmp
WHERE row_num = 10
LIMIT 5;
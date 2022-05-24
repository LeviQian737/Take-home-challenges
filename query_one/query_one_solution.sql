CREATE TABLE data 
(User_id char(10), 
 Page varchar, 
 Unix_timestamp int
 );
 
SELECT *
FROM data
LIMIT 5

'''
For each user_id, find the difference between the last action and the second last action. Action
here is defined as visiting a page. If the user has just one action, you can either remove her from
the final results or keep that user_id and have NULL as time difference between the two actions.
'''
-- step 1: create subquery to select those do have second last action
SELECT user_id, COUNT(unix_timestamp) as action_times
FROM data
GROUP BY user_id
HAVING COUNT(unix_timestamp)>1

-- step 2: create a view to store the query for ranking 
CREATE OR REPLACE VIEW user_time_rank AS
SELECT user_id, unix_timestamp, 
	RANK() OVER(Partition by user_id 
				 Order by unix_timestamp DESC)
From data
where user_id IN (
	SELECT user_id
	FROM data
	GROUP BY user_id
	HAVING COUNT(unix_timestamp)>1	
)

-- step 3: calculate time difference
SELECT user_id, (MAX(unix_timestamp)-MIN(unix_timestamp)) as diff
FROM user_time_rank
GROUP BY user_id
ORDER BY user_id

-- Sample solution
SELECT user_id,
	unix_timestamp - previous_time AS Delta_SecondLast0ne_LastOne
FROM
	(SELECT user_id,
		unix_timestamp,
		LAG(unix_timestamp, 1) OVER (PARTITION BY user_id ORDER BY unix_timestamp) AS previous_time,
		ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY unix_timestamp DESC) AS order_desc
	 FROM data
	) tmp
WHERE order_desc = 1
ORDER BY user_id;

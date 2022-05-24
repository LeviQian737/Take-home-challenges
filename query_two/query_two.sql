-- BEGIN CREATE TABLES
CREATE TABLE web (
	user_id int,
	page varchar(10)
)

CREATE TABLE mobile (
	user_id int,
	page varchar(20)
)

SELECT * 
FROM web

SELECT *
FROM mobile
-- END CREATE TABLES
''' 
Write a query that returns the percentage of users who only visited mobile, only web and both.
That is, the percentage of users who are only in the mobile table, only in the web table and in
both tables. The sum of the percentages should return 1.
'''

SELECT 
	100*SUM(
		CASE 
		WHEN mobile_user_id IS NULL THEN 1
		ELSE 0
		END)
		/COUNT(*) as WEB_ONLY,
	100*SUM(
		CASE 
		WHEN web_user_id IS NULL THEN 1
		ELSE 0
		END)
		/COUNT(*) as MOBILE_ONLY,
	100*SUM(
		CASE
		WHEN web_user_id IS NOT NULL AND mobile_user_id IS NOT NULL THEN 1
		ELSE 0
		END)
		/COUNT(*) as BOTH
FROM
	(SELECT distinct m.user_id mobile_user_id, w.user_id web_user_id
	FROM mobile m
	FULL JOIN web w
	ON m.user_id = w.user_id) as tmp


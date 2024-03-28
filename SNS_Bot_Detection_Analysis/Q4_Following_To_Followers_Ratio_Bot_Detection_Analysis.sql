/*
Below is the fourth in five queries that extract various aspects of user 
behavior that mimicks typical bot-like behavior on SNS services like instagram. 
Specifically, the query below outputs each user's total followers, the site
average total followers, users' difference from site average, each user's total
following, site average total following, the difference from site average, 
following-to-followers ratio, comparison against the site average, and based on
the criteria of the case statement below, the probabiliy that a given users is 
a bot: "high", "moderate", or "uncertain".

The reasoning behind this query was that bots typically follow an inordinate
amount of users, yet have a very small following. 
*/



SELECT user_id, 
SUM(number_followers) AS total_followers, 
ROUND(AVG(SUM(number_followers)) OVER(), 2) AS site_AVG_total_followers,
SUM(number_followers) - ROUND(AVG(SUM(number_followers)) OVER(), 2) AS total_followers_diff_from_AVG,
SUM(number_following) AS total_following, -- the sum function is used because the union add the two subquerries togeth in rows, so e.g. you have user_id: 1, total_followers: 5, total_following: 0
ROUND(AVG(SUM(number_following)) OVER(), 2) AS site_AVG_total_following,
-- and then you'll have user_id: 1 again, but with number_of_followers: 0 and number_following: 4. these need to be combined/added and a GROUP BY or COUNT() won't do that, it has to be summed.
SUM(number_following) - ROUND(AVG(SUM(number_following)) OVER(), 2) AS total_following_diff_from_AVG,
ROUND((SUM(number_following))/(SUM(number_followers)), 2) AS following_followers_ratio, 
ROUND(AVG((SUM(number_following))/(SUM(number_followers))) OVER(), 2) AS site_AVG_following_followers_ratio,
ROUND((SUM(number_following))/(SUM(number_followers)) - AVG((SUM(number_following))/(SUM(number_followers))) OVER(), 2) AS 'following_followers_ratio_diff_from_AVG',
CASE 
WHEN ROUND((SUM(number_following))/(SUM(number_followers)), 2) > 5 THEN 'high' -- As mentioned above, the cutoffs would be more consistent with real-world number if they were around 100 and 25 for 'high' and 'moderate', but due to the limitations of the data, 5 and 2.5 were used to simply demonstrate the query.
WHEN ROUND((SUM(number_following))/(SUM(number_followers)), 2) > 2.5 THEN 'moderate'
ELSE 'uncertain'
END AS 'prob_user_is_robot'
FROM (
    -- Query for followers
    SELECT followee_id AS user_id, COUNT(follower_id) AS number_followers, 0 AS number_following -- 0 is placed here because this query is only retrieving the number of followers (can't do both in one query)
    FROM follows
    GROUP BY followee_id
    UNION
    -- Query for following
    SELECT follower_id AS user_id, 0 AS number_followers, COUNT(followee_id) AS number_following -- 0 is used because this query is only retrieving the number following (can't do both in one query)
    FROM follows
    GROUP BY follower_id
) AS subquery
GROUP BY user_id
ORDER BY prob_user_is_robot;



-- Below is a sample of the ouput from the top 10 rows:
/* 
*** Please note again that this is from simulated data, and this query in particular
shows more repeated data than the others.*** 
*/

# user_id, total_followers, site_AVG_total_followers, total_followers_diff_from_AVG, total_following, site_AVG_total_following, total_following_diff_from_AVG, following_followers_ratio, site_AVG_following_followers_ratio, following_followers_ratio_diff_from_AVG, prob_user_is_robot
'100', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'99', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'98', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'97', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'96', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'95', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'94', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'93', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'92', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'
'91', 		'17', 			'48.59', 					'-31.59', 					'99', 				'48.59', 				'50.41', 						'5.82', 					'1.72', 							'4.10', 								'high'



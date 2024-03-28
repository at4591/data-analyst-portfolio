-- AGGREGATED RESULTS --

-- BELOW ARE THE FOUR SEPARATE QUERIES REDEFINED AS TEMPORARY TABLES:
-- *** At the bottom is the final analysis with a thorough description ***

CREATE TEMPORARY TABLE Q1_num_likes_per_user AS
SELECT u.id AS user_id, u.username AS username, 
COUNT(l.photo_id) AS user_total_likes, 
ROUND(AVG(COUNT(l.photo_id)) OVER(), 2) AS site_AVG_total_likes_count,
COUNT(l.photo_id) - ROUND(AVG(COUNT(l.photo_id)) OVER(), 2) AS total_likes_diff_from_AVG,
CASE
WHEN COUNT(l.photo_id) >= 2.5 * ROUND(AVG(COUNT(l.photo_id)) OVER(), 2) THEN 'high' -- The current cutoffs of 2.5x and 1x are set in place for demonstration only due to the limitations of the dataset, however more realistic classifications of ‘high’ and ‘moderate’ probability that given users are actually bot accounts (in light of available real-world social media data) would be around 200x and 100x.
WHEN COUNT(l.photo_id) >= 1 * ROUND(AVG(COUNT(l.photo_id)) OVER(), 2) THEN 'moderate'
ELSE 'uncertain'
END AS prob_user_is_robot
FROM users u
LEFT JOIN likes l ON u.id = l.user_id
GROUP BY u.id, u.username
ORDER BY prob_user_is_robot
;

CREATE TEMPORARY TABLE Q2_like_time_post_time AS
SELECT u.id AS user_id, u.username AS username, AVG(timestampdiff(SECOND, p.created_at, l.created_at)) AS user_average_time_to_like_sec, 
ROUND(AVG(AVG(timestampdiff(SECOND, p.created_at, l.created_at))) OVER(), 2) AS site_AVG_time_to_like_sec, -- the reason the average of user average times is being calculated is because it gives 
-- each user equal weight in the calculation by reducing each user to have one data point for their response times to photos, and this is preferable over the above calculation where each 
-- individual response time was included into the calculation, giving users who like more photos more statistical weight. we're just trying to see if individual users are exhibiting behaviors deemed (robotic - ie. too fast)
ROUND(AVG(timestampdiff(SECOND, p.created_at, l.created_at)) - AVG(AVG(timestampdiff(SECOND, p.created_at, l.created_at))) OVER(), 2) AS time_to_like_diff_from_AVG_sec,
CASE 
WHEN AVG(timestampdiff(SECOND, p.created_at, l.created_at)) < 60 THEN 'high'
WHEN AVG(timestampdiff(SECOND, p.created_at, l.created_at)) < 300 THEN 'moderate'
ELSE 'uncertain'
END AS prob_user_is_robot
FROM users u
JOIN likes l ON u.id = l.user_id
JOIN photos p ON l.photo_id = p.id
GROUP BY u.id, u.username
ORDER BY AVG(timestampdiff(SECOND, p.created_at, l.created_at))
;

CREATE TEMPORARY TABLE Q3_num_posts_vs_avg AS
SELECT
    u.id AS user_id,
    u.username AS username,
    p.num_photos,
    AVG(p.num_photos) OVER() AS site_AVG_num_photos,
    p.num_photos - AVG(p.num_photos) OVER() AS num_photos_diff_from_AVG,
    l.num_likes_sent,
    AVG(l.num_likes_sent) OVER() AS site_AVG_likes_sent,
    l.num_likes_sent - AVG(l.num_likes_sent) OVER() AS likes_sent_diff_from_AVG,
    IFNULL(l.num_likes_sent / p.num_photos, 'NA') AS likes_photos_ratio,
    (AVG(l.num_likes_sent) OVER() * 1.0) / AVG(p.num_photos) OVER() AS site_AVG_likes_photos_ratio,
    (l.num_likes_sent / p.num_photos) - ((AVG(l.num_likes_sent) OVER() * 1.0) / AVG(p.num_photos) OVER()) AS likes_photos_ratio_diff_from_AVG,
    CASE 
        WHEN (l.num_likes_sent / p.num_photos) >= 2.5 * ((AVG(l.num_likes_sent) OVER() * 1.0) / AVG(p.num_photos) OVER()) THEN 'high' -- These cutoffs are again solely to work with the current dataset - a more realistic cutoff would be 100x and 10x for detecting ‘high’ and ‘moderate’ probabilities that certain users are robots.
        WHEN (l.num_likes_sent / p.num_photos) >= 2 * ((AVG(l.num_likes_sent) OVER() * 1.0) / AVG(p.num_photos) OVER()) THEN 'moderate'
        ELSE 'uncertain'
    END AS prob_user_is_robot
FROM -- Below the tables are join with subqueries, which ouput the necessary information in small parts. This greatly minimizes error, while also allowing the code to be more modular and easy to read. this is a valuable technique that I recently learned and will be using more often in the future.
    users u
LEFT JOIN (
    SELECT user_id, COUNT(*) AS num_photos
    FROM photos
    GROUP BY user_id
) p ON u.id = p.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS num_likes_sent
    FROM likes
    GROUP BY user_id
) l ON u.id = l.user_id
ORDER BY
    prob_user_is_robot
    ;
    
    
CREATE TEMPORARY TABLE Q4_following_to_followers AS
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
END AS prob_user_is_robot
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






-- BELOW IS THE AGGREGATE OF THE ABOVE FOUR QUERIES:

CREATE TEMPORARY TABLE aggregated_results AS
SELECT user_id,
       SUM(CASE WHEN prob_user_is_robot = 'high' THEN 1 ELSE 0 END) AS high_count,
       SUM(CASE WHEN prob_user_is_robot = 'moderate' THEN 1 ELSE 0 END) AS moderate_count
FROM (
    SELECT user_id, prob_user_is_robot FROM Q1_num_likes_per_user
    UNION ALL
    SELECT user_id, prob_user_is_robot FROM Q2_like_time_post_time
    UNION ALL
    SELECT user_id, prob_user_is_robot FROM Q3_num_posts_vs_avg
    UNION ALL
    SELECT user_id, prob_user_is_robot FROM Q4_following_to_followers
) AS subquery
GROUP BY user_id;



-- FINAL ANALYSIS:

/*
Below is the final in five queries that extract various aspects of user 
behavior that mimicks typical bot-like behavior on SNS services like instagram. 
Specifically, the query below evaluates how many times each user is determined
to be at "high", "moderate", and "uncertain". Further, based on the CASE 
statements below, ouputs the final analysis of a given user being at "high", 
"moderate", or "uncertain" probability for being a bot.

In order to produce this final analysis, I had to develop four temporary tables
for each of my previous queries, create a sum via the "aggregated_results" table
above for how many times "high", "moderate", or "uncertain" was ascribed to each 
user, then finally produce the final probabilities. Based on the criteria, no user 
was evaluated as "high" probability for being a bot as the criteria was a bit
conservative/strict, however, even "moderate" would be cause for concern if this 
were a real SNS service. 
*/

SELECT user_id,
       CASE
           WHEN high_count >= 3 THEN 'high'
           WHEN high_count >= 1 THEN 'moderate'
           WHEN moderate_count >= 3 THEN 'moderate'
           ELSE 'uncertain'
       END AS final_analysis
FROM aggregated_results
ORDER BY final_analysis
;



-- Below is the total ouput from the final anlysis:

# user_id, final_analysis
'14', 'moderate'
'76', 'moderate'
'54', 'moderate'
'57', 'moderate'
'21', 'moderate'
'75', 'moderate'
'5',  'moderate'
'24', 'moderate'
'41', 'moderate'
'66', 'moderate'
'71', 'moderate'
'36', 'moderate'
'91', 'moderate'
'37', 'moderate'
'4',  'moderate'
'87', 'moderate'
'99', 'moderate'
'97', 'moderate'
'84', 'moderate'
'40', 'moderate'
'22', 'moderate'
'39', 'moderate'
'96', 'moderate'
'69', 'moderate'
'95', 'moderate'
'85', 'moderate'
'93', 'moderate'
'94', 'moderate'
'31', 'moderate'
'70', 'moderate'
'20', 'moderate'
'61', 'moderate'
'73', 'moderate'
'92', 'moderate'
'100', 'moderate'
'98', 'moderate'
'50', 'uncertain'
'48', 'uncertain'
'9',  'uncertain'
'23', 'uncertain'
'3',  'uncertain'
'47', 'uncertain'
'74', 'uncertain'
'64', 'uncertain'
'81', 'uncertain'
'90', 'uncertain'
'29', 'uncertain'
'67', 'uncertain'
'43', 'uncertain'
'68', 'uncertain'
'19', 'uncertain'
'32', 'uncertain'
'89', 'uncertain'
'38', 'uncertain'
'63', 'uncertain'
'77', 'uncertain'
'12', 'uncertain'
'30', 'uncertain'
'65', 'uncertain'
'7',  'uncertain'
'79', 'uncertain'
'72', 'uncertain'
'86', 'uncertain'
'45', 'uncertain'
'27', 'uncertain'
'1',  'uncertain'
'28', 'uncertain'
'80', 'uncertain'
'53', 'uncertain'
'26', 'uncertain'
'51', 'uncertain'
'78', 'uncertain'
'42', 'uncertain'
'88', 'uncertain'
'55', 'uncertain'
'59', 'uncertain'
'13', 'uncertain'
'49', 'uncertain'
'15', 'uncertain'
'11', 'uncertain'
'17', 'uncertain'
'18', 'uncertain'
'83', 'uncertain'
'34', 'uncertain'
'56', 'uncertain'
'10', 'uncertain'
'35', 'uncertain'
'58', 'uncertain'
'82', 'uncertain'
'2',  'uncertain'
'60', 'uncertain'
'44', 'uncertain'
'8',  'uncertain'
'25', 'uncertain'
'46', 'uncertain'
'6',  'uncertain'
'16', 'uncertain'
'62', 'uncertain'
'33', 'uncertain'
'52', 'uncertain'







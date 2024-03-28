/*
Below is the third in five queries that extract various aspects of user 
behavior that mimicks typical bot-like behavior on SNS services like instagram. 
Specifically, the query below outputs the number of photos each user has posted,
compares that to the site average, the number of likes sent by each user, 
compares that against the site average, the likes-to-photos ratio for each user,
compares that against the site average, and finally based on the case statement
criteria below, determines if the probability of a particular user being a bot
is "high", "moderate", or "uncertain". 

The thinking behind this query was that bots typically post very few photos, but 
send a lot of likes to gain followers and build connections. As such, comparing 
their likes-to-photos to the site average offers good context into determining
if a user is a bot or not. 
*/




SELECT
    u.id,
    u.username,
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



-- Below is a sample of the ouput from the top 10 rows:


# id, username, 		num_photos, 	site_AVG_num_photos, num_photos_diff_from_AVG, num_likes_sent, site_AVG_likes_sent, likes_sent_diff_from_AVG, likes_photos_ratio, site_AVG_likes_photos_ratio, likes_photos_ratio_diff_from_AVG, prob_user_is_robot
'73', 'Jaylan.Lakin', 	'1', 			'3.4730', 			'-2.4730', 					'86', 			'114.0519', 		'-28.0519', 			'86.0000', 				'32.839591132', 			'53.160408868', 				'high'
'31', 'Aiyana_Hoeger', 	'1', 			'3.4730', 			'-2.4730', 					'88', 			'114.0519', 		'-26.0519', 			'88.0000', 				'32.839591132', 			'55.160408868', 				'high'
'37', 'Yazmin_Mills95', '1', 			'3.4730', 			'-2.4730', 					'84', 			'114.0519', 		'-30.0519', 			'84.0000', 				'32.839591132', 			'51.160408868', 				'high'
'40', 'Rafael.Hickle2', '1', 			'3.4730', 			'-2.4730', 					'85', 			'114.0519', 		'-29.0519', 			'85.0000', 				'32.839591132', 			'52.160408868', 				'high'
'22', 'Kenneth64', 		'1', 			'3.4730', 			'-2.4730', 					'91', 			'114.0519', 		'-23.0519', 			'91.0000', 				'32.839591132', 			'58.160408868', 				'high'
'39', 'Kelsi26', 		'1', 			'3.4730', 			'-2.4730', 					'89', 			'114.0519', 		'-25.0519', 			'89.0000', 				'32.839591132', 			'56.160408868', 				'high'
'69', 'Karley_Bosco', 	'1', 			'3.4730', 			'-2.4730', 					'97', 			'114.0519', 		'-17.0519', 			'97.0000', 				'32.839591132', 			'64.160408868', 				'high'
'61', 'Jayson65', 		'1', 			'3.4730', 			'-2.4730', 					'83', 			'114.0519', 		'-31.0519', 			'83.0000', 				'32.839591132', 			'50.160408868', 				'high'
'70', 'Erick5', 		'1', 			'3.4730', 			'-2.4730', 					'88', 			'114.0519', 		'-26.0519', 			'88.0000', 				'32.839591132', 			'55.160408868', 				'high'
'20', 'Delpha.Kihn', 	'1', 			'3.4730', 			'-2.4730', 					'87', 			'114.0519', 		'-27.0519', 			'87.0000', 				'32.839591132', 			'54.160408868', 				'high'

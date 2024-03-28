/* 
Below is the first in five queries that extract various aspects of user 
behavior that mimicks typical bot-like behavior on SNS services like instagram. 
Specifically, the query below is the simplest of the five, as it simply outputs 
the total likes sent by each user, compares it against the site average, and 
based on the CASE statements below, determines if a user's probability for being 
a robot is "high", "moderate", or "uncertain". A "high" would be given if a user's
likes sent count was considerably over the site average. Ultimately, this query's 
purpose is to give additional context to users' behaviors from a more broad, 
high-level perspective. 

The ouput for this query can be found in the readme section for this project
*/

-- average number of likes per user (throughout time using the site/app):
SELECT u.id, u.username, 
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


-- Below is a sample of the ouput from the first 10 rows:
/* 
*** Please note again that this is from simulated data, and this query in particular
shows more repeated data than the others.*** 
*/


# id, username  			user_total_likes, site_AVG_total_likes_count, total_likes_diff_from_AVG, prob_user_is_robot
'14', 'Jaclyn81', 			'257', 				'87.82', 					'169.18', 				'high'
'76', 'Janelle.Nikolaus81', '257', 				'87.82', 					'169.18', 				'high'
'54', 'Duane60', 			'257', 				'87.82', 					'169.18', 				'high'
'57', 'Julien_Schmidt', 	'257', 				'87.82', 					'169.18', 				'high'
'21', 'Rocio33', 			'257', 				'87.82', 					'169.18', 				'high'
'75', 'Leslie67', 			'257', 				'87.82', 					'169.18', 				'high'
'5', 'Aniya_Hackett', 		'257', 				'87.82', 					'169.18', 				'high'
'24', 'Maxwell.Halvorson', 	'257', 				'87.82', 					'169.18', 				'high'
'41', 'Mckenna17', 			'257', 				'87.82', 					'169.18', 				'high'
'66', 'Mike.Auer39', 		'257', 				'87.82', 					'169.18', 				'high'

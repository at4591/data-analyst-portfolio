/*
Below is the second in five queries that extract various aspects of user 
behavior that mimicks typical bot-like behavior on SNS services like instagram. 
Specifically, the query below outputs how long it takes each user to like photos
after they have been posted, compare it to the average, and then determine the
probability that a given user is a robot - again with "high", "moderate", and
"uncertain". The goal here was to average each user's time-to-like behavior to
see how many seconds after photos are posted they send a like across all of the
photos they have liked. This was important as one istance of a fast like is clearly 
not evidence that a given user is a bot, but if their average is highly aberrant, 
then that is considerably more substantial evidence. 
*/



SELECT u.id, u.username, AVG(timestampdiff(SECOND, p.created_at, l.created_at)) AS user_average_time_to_like_sec, 
ROUND(AVG(AVG(timestampdiff(SECOND, p.created_at, l.created_at))) OVER(), 2) AS site_AVG_time_to_like_sec, -- the reason the average of user average times is being calculated is because it gives 
-- each user equal weight in the calculation by reducing each user to have one data point for their response times to photos, and this is preferable over the above calculation where each 
-- individual response time was included into the calculation, giving users who like more photos more statistical weight. we're just trying to see if individual users are exhibiting behaviors deemed (robotic - ie. too fast)
ROUND(AVG(timestampdiff(SECOND, p.created_at, l.created_at)) - AVG(AVG(timestampdiff(SECOND, p.created_at, l.created_at))) OVER(), 2) AS time_to_like_diff_from_AVG_sec,
CASE 
WHEN AVG(timestampdiff(SECOND, p.created_at, l.created_at)) < 60 THEN 'high'
WHEN AVG(timestampdiff(SECOND, p.created_at, l.created_at)) < 300 THEN 'moderate'
ELSE 'uncertain'
END AS 'prob_user_is_robot'
FROM users u
JOIN likes l ON u.id = l.user_id
JOIN photos p ON l.photo_id = p.id
GROUP BY u.id, u.username
ORDER BY AVG(timestampdiff(SECOND, p.created_at, l.created_at))
;


-- Below is a sample of the ouput from the first 10 rows:

# id, username,             user_average_time_to_like_sec, site_AVG_time_to_like_sec, time_to_like_diff_from_AVG_sec, prob_user_is_robot
'87', 'Rick29',              '43.0000',                     '628.97',                   '-585.97',                      'high'
'85', 'Milford_Gleichner42', '43.0000',                     '628.97',                   '-585.97',                      'high'
'84', 'Alysa22',             '43.0000',                     '628.97',                   '-585.97',                      'high'
'5', 'Aniya_Hackett',        '43.0000',                     '628.97',                   '-585.97',                      'high'
'4', 'Arely_Bogan63',        '43.0000',                     '628.97',                   '-585.97',                      'high'
'93', 'Willie_Leuschke',     '223.0000',                    '628.97',                   '-405.97',                      'moderate'
'3', 'Harley_Lind18',        '223.0000',                    '628.97',                   '-405.97',                      'moderate'
'2', 'Andre_Purdy85',        '223.0000',                    '628.97',                   '-405.97',                      'moderate'
'92', 'Frederik_Rice',       '223.0000',                    '628.97',                   '-405.97',                      'moderate'
'91', 'Bethany20',           '223.0000',                    '628.97',                   '-405.97',                      'moderate'

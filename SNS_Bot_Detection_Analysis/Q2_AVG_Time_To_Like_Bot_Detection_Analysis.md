Below is the second in five queries that extract various aspects of user 
behaviors that mimick typical bot-like behaviors on SNS services like instagram. 
Specifically, the query below outputs how long it takes each user to like photos
after they have been posted, compare it to the average, and then determine the
probability that a given user is a robot - again with "high", "moderate", and
"uncertain". The goal here was to average each user's time-to-like behavior to
see how many seconds after photos are posted they send a like across all of the
photos they have liked. This was important as one istance of a fast like is clearly 
not evidence that a given user is a bot, but if their average is highly aberrant, 
then that is considerably more substantial evidence. 



```sql
SELECT u.id, u.username, AVG(timestampdiff(SECOND, p.created_at, l.created_at)) AS user_average_time_to_like_sec, 
ROUND(AVG(AVG(timestampdiff(SECOND, p.created_at, l.created_at))) OVER(), 2) AS site_AVG_time_to_like_sec, -- the reason the average of user average times is being calculated is because it gives 
-- each user equal weight in the calculation by reducing each user to have one data point for their response times to photos, and this is preferable to including each individual response time was included into the calculation, giving users who like more photos more statistical weight for the site average. 
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
```

[Link to Tableau visualization](https://public.tableau.com/app/profile/aryan.tehrani/viz/Q1_robot_num_likes/Q2?publish=yes)


Below is the output of the above query:

| id  | username              | user_average_time_to_like_sec | site_AVG_time_to_like_sec | time_to_like_diff_from_AVG_sec | prob_user_is_robot |
|-----|-----------------------|-------------------------------|---------------------------|--------------------------------|--------------------|
| 87  | Rick29                | 43                            | 628.97                    | -585.97                        | high               |
| 85  | Milford_Gleichner42   | 43                            | 628.97                    | -585.97                        | high               |
| 84  | Alysa22               | 43                            | 628.97                    | -585.97                        | high               |
| 5   | Aniya_Hackett         | 43                            | 628.97                    | -585.97                        | high               |
| 4   | Arely_Bogan63         | 43                            | 628.97                    | -585.97                        | high               |
| 93  | Willie_Leuschke       | 223                           | 628.97                    | -405.97                        | moderate           |
| 3   | Harley_Lind18         | 223                           | 628.97                    | -405.97                        | moderate           |
| 2   | Andre_Purdy85         | 223                           | 628.97                    | -405.97                        | moderate           |
| 92  | Frederik_Rice         | 223                           | 628.97                    | -405.97                        | moderate           |
| 91  | Bethany20             | 223                           | 628.97                    | -405.97                        | moderate           |
| 82  | Aracely.Johnston98    | 703                           | 628.97                    | 74.03                          | uncertain          |
| 15  | Billy52               | 703                           | 628.97                    | 74.03                          | uncertain          |
| 78  | Colten.Harris76       | 703                           | 628.97                    | 74.03                          | uncertain          |
| 94  | Damon35               | 703                           | 628.97                    | 74.03                          | uncertain          |
| 28  | Dario77               | 703                           | 628.97                    | 74.03                          | uncertain          |
| 27  | Darwin29              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 20  | Delpha.Kihn           | 703                           | 628.97                    | 74.03                          | uncertain          |
| 12  | Dereck65              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 54  | Duane60               | 703                           | 628.97                    | 74.03                          | uncertain          |
| 63  | Elenor88              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 67  | Emilio_Bernier52      | 703                           | 628.97                    | 74.03                          | uncertain          |
| 70  | Erick5                | 703                           | 628.97                    | 74.03                          | uncertain          |
| 16  | Annalise.McKenzie16   | 703                           | 628.97                    | 74.03                          | uncertain          |
| 50  | Gerard79              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 48  | Granville_Kutch       | 703                           | 628.97                    | 74.03                          | uncertain          |
| 9   | Gus93                 | 703                           | 628.97                    | 74.03                          | uncertain          |
| 19  | Hailee26              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 13  | Alexandro35           | 703                           | 628.97                    | 74.03                          | uncertain          |
| 47  | Harrison.Beatty50     | 703                           | 628.97                    | 74.03                          | uncertain          |
| 98  | Imani_Nicolas17       | 703                           | 628.97                    | 74.03                          | uncertain          |
| 32  | Irwin.Larson          | 703                           | 628.97                    | 74.03                          | uncertain          |
| 14  | Jaclyn81              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 76  | Janelle.Nikolaus81    | 703                           | 628.97                    | 74.03                          | uncertain          |
| 43  | Janet.Armstrong       | 703                           | 628.97                    | 74.03                          | uncertain          |
| 100 | Javonte83             | 703                           | 628.97                    | 74.03                          | uncertain          |
| 73  | Jaylan.Lakin          | 703                           | 628.97                    | 74.03                          | uncertain          |
| 61  | Jayson65              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 38  | Jordyn.Jacobson2      | 703                           | 628.97                    | 74.03                          | uncertain          |
| 26  | Josianne.Friesen      | 703                           | 628.97                    | 74.03                          | uncertain          |
| 57  | Julien_Schmidt        | 703                           | 628.97                    | 74.03                          | uncertain          |
| 11  | Justina.Gaylord27     | 703                           | 628.97                    | 74.03                          | uncertain          |
| 30  | Kaley9                | 703                           | 628.97                    | 74.03                          | uncertain          |
| 69  | Karley_Bosco          | 703                           | 628.97                    | 74.03                          | uncertain          |
| 79  | Katarina.Dibbert      | 703                           | 628.97                    | 74.03                          | uncertain          |
| 72  | Kathryn80             | 703                           | 628.97                    | 74.03                          | uncertain          |
| 96  | Keenan.Schamberger60  | 703                           | 628.97                    | 74.03                          | uncertain          |
| 39  | Kelsi26               | 703                           | 628.97                    | 74.03                          | uncertain          |
| 22  | Kenneth64             | 703                           | 628.97                    | 74.03                          | uncertain          |
| 35  | Lennie_Hartmann40     | 703                           | 628.97                    | 74.03                          | uncertain          |
| 75  | Leslie67              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 46  | Malinda_Streich       | 703                           | 628.97                    | 74.03                          | uncertain          |
| 24  | Maxwell.Halvorson     | 703                           | 628.97                    | 74.03                          | uncertain          |
| 42  | Maya.Farrell          | 703                           | 628.97                    | 74.03                          | uncertain          |
| 41  | Mckenna17             | 703                           | 628.97                    | 74.03                          | uncertain          |
| 55  | Meggie_Doyle          | 703                           | 628.97                    | 74.03                          | uncertain          |
| 66  | Mike.Auer39           | 703                           | 628.97                    | 74.03                          | uncertain          |
| 99  | Alek_Watsica          | 703                           | 628.97                    | 74.03                          | uncertain          |
| 71  | Nia_Haag              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 95  | Nicole71              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 17  | Norbert_Carroll35     | 703                           | 628.97                    | 74.03                          | uncertain          |
| 18  | Odessa2               | 703                           | 628.97                    | 74.03                          | uncertain          |
| 36  | Ollie_Ledner37        | 703                           | 628.97                    | 74.03                          | uncertain          |
| 56  | Peter.Stehr0          | 703                           | 628.97                    | 74.03                          | uncertain          |
| 10  | Presley_McClure       | 703                           | 628.97                    | 74.03                          | uncertain          |
| 40  | Rafael.Hickle2        | 703                           | 628.97                    | 74.03                          | uncertain          |
| 62  | Ressie_Stanton46      | 703                           | 628.97                    | 74.03                          | uncertain          |
| 31  | Aiyana_Hoeger         | 703                           | 628.97                    | 74.03                          | uncertain          |
| 21  | Rocio33               | 703                           | 628.97                    | 74.03                          | uncertain          |
| 60  | Sam52                 | 703                           | 628.97                    | 74.03                          | uncertain          |
| 44  | Seth46                | 703                           | 628.97                    | 74.03                          | uncertain          |
| 8   | Tabitha_Schamberger11 | 703                           | 628.97                    | 74.03                          | uncertain          |
| 97  | Tomas.Beatty93        | 703                           | 628.97                    | 74.03                          | uncertain          |
| 6   | Travon.Waters         | 703                           | 628.97                    | 74.03                          | uncertain          |
| 65  | Adelle96              | 703                           | 628.97                    | 74.03                          | uncertain          |
| 37  | Yazmin_Mills95        | 703                           | 628.97                    | 74.03                          | uncertain          |
| 33  | Yvette.Gottlieb91     | 703                           | 628.97                    | 74.03                          | uncertain          |
| 52  | Zack_Kemmer93         | 703                           | 628.97                    | 74.03                          | uncertain          |
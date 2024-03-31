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




```sql
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
```

[Link to Tableau visualization](https://public.tableau.com/app/profile/aryan.tehrani/viz/Q1_robot_num_likes/Q3?publish=yes)


-- Below is the output of the above query:

| id  | username              | num_photos | site_AVG_num_photos | num_photos_diff_from_AVG | num_likes_sent | site_AVG_likes_sent | likes_sent_diff_from_AVG | likes_photos_ratio | site_AVG_likes_photos_ratio | likes_photos_ratio_diff_from_AVG | prob_user_is_robot |
|-----|-----------------------|------------|---------------------|--------------------------|----------------|---------------------|--------------------------|--------------------|-----------------------------|----------------------------------|--------------------|
| 73  | Jaylan.Lakin          | 1          | 3.473               | -2.473                   | 86             | 114.0519            | -28.0519                 | 86                 | 32.8395911                  | 53.1604089                       | high               |
| 31  | Aiyana_Hoeger         | 1          | 3.473               | -2.473                   | 88             | 114.0519            | -26.0519                 | 88                 | 32.8395911                  | 55.1604089                       | high               |
| 37  | Yazmin_Mills95        | 1          | 3.473               | -2.473                   | 84             | 114.0519            | -30.0519                 | 84                 | 32.8395911                  | 51.1604089                       | high               |
| 40  | Rafael.Hickle2        | 1          | 3.473               | -2.473                   | 85             | 114.0519            | -29.0519                 | 85                 | 32.8395911                  | 52.1604089                       | high               |
| 22  | Kenneth64             | 1          | 3.473               | -2.473                   | 91             | 114.0519            | -23.0519                 | 91                 | 32.8395911                  | 58.1604089                       | high               |
| 39  | Kelsi26               | 1          | 3.473               | -2.473                   | 89             | 114.0519            | -25.0519                 | 89                 | 32.8395911                  | 56.1604089                       | high               |
| 69  | Karley_Bosco          | 1          | 3.473               | -2.473                   | 97             | 114.0519            | -17.0519                 | 97                 | 32.8395911                  | 64.1604089                       | high               |
| 61  | Jayson65              | 1          | 3.473               | -2.473                   | 83             | 114.0519            | -31.0519                 | 83                 | 32.8395911                  | 50.1604089                       | high               |
| 70  | Erick5                | 1          | 3.473               | -2.473                   | 88             | 114.0519            | -26.0519                 | 88                 | 32.8395911                  | 55.1604089                       | high               |
| 20  | Delpha.Kihn           | 1          | 3.473               | -2.473                   | 87             | 114.0519            | -27.0519                 | 87                 | 32.8395911                  | 54.1604089                       | high               |
| 94  | Damon35               | 1          | 3.473               | -2.473                   | 84             | 114.0519            | -30.0519                 | 84                 | 32.8395911                  | 51.1604089                       | high               |
| 56  | Peter.Stehr0          | 1          | 3.473               | -2.473                   | 81             | 114.0519            | -33.0519                 | 81                 | 32.8395911                  | 48.1604089                       | moderate           |
| 18  | Odessa2               | 1          | 3.473               | -2.473                   | 82             | 114.0519            | -32.0519                 | 82                 | 32.8395911                  | 49.1604089                       | moderate           |
| 55  | Meggie_Doyle          | 1          | 3.473               | -2.473                   | 78             | 114.0519            | -36.0519                 | 78                 | 32.8395911                  | 45.1604089                       | moderate           |
| 79  | Katarina.Dibbert      | 1          | 3.473               | -2.473                   | 75             | 114.0519            | -39.0519                 | 75                 | 32.8395911                  | 42.1604089                       | moderate           |
| 98  | Imani_Nicolas17       | 1          | 3.473               | -2.473                   | 74             | 114.0519            | -40.0519                 | 74                 | 32.8395911                  | 41.1604089                       | moderate           |
| 48  | Granville_Kutch       | 1          | 3.473               | -2.473                   | 75             | 114.0519            | -39.0519                 | 75                 | 32.8395911                  | 42.1604089                       | moderate           |
| 27  | Darwin29              | 1          | 3.473               | -2.473                   | 79             | 114.0519            | -35.0519                 | 79                 | 32.8395911                  | 46.1604089                       | moderate           |
| 80  | Darby_Herzog          | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 28  | Dario77               | 4          | 3.473               | 0.527                    | 77             | 114.0519            | -37.0519                 | 19.25              | 32.8395911                  | -13.589591                       | uncertain          |
| 78  | Colten.Harris76       | 5          | 3.473               | 1.527                    | 83             | 114.0519            | -31.0519                 | 16.6               | 32.8395911                  | -16.239591                       | uncertain          |
| 45  | David.Osinski47       | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 86  | Delfina_VonRueden68   | 9          | 3.473               | 5.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 88  | Clint27               | 11         | 3.473               | 7.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 12  | Dereck65              | 4          | 3.473               | 0.527                    | 77             | 114.0519            | -37.0519                 | 19.25              | 32.8395911                  | -13.589591                       | uncertain          |
| 77  | Donald.Fritsch        | 6          | 3.473               | 2.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 54  | Duane60               | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 63  | Elenor88              | 4          | 3.473               | 0.527                    | 83             | 114.0519            | -31.0519                 | 20.75              | 32.8395911                  | -12.089591                       | uncertain          |
| 67  | Emilio_Bernier52      | 3          | 3.473               | -0.473                   | 86             | 114.0519            | -28.0519                 | 28.6667            | 32.8395911                  | -4.1728911                       | uncertain          |
| 59  | Cesar93               | 10         | 3.473               | 6.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 90  | Esmeralda.Mraz57      | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 81  | Esther.Zulauf61       | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 23  | Eveline95             | 12         | 3.473               | 8.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 64  | Florence99            | 5          | 3.473               | 1.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 68  | Franco_Keebler64      | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 92  | Frederik_Rice         | 3          | 3.473               | -0.473                   | 91             | 114.0519            | -23.0519                 | 30.3333            | 32.8395911                  | -2.5062911                       | uncertain          |
| 50  | Gerard79              | 3          | 3.473               | -0.473                   | 81             | 114.0519            | -33.0519                 | 27                 | 32.8395911                  | -5.8395911                       | uncertain          |
| 15  | Billy52               | 4          | 3.473               | 0.527                    | 84             | 114.0519            | -30.0519                 | 21                 | 32.8395911                  | -11.839591                       | uncertain          |
| 9   | Gus93                 | 4          | 3.473               | 0.527                    | 85             | 114.0519            | -29.0519                 | 21.25              | 32.8395911                  | -11.589591                       | uncertain          |
| 19  | Hailee26              | 2          | 3.473               | -1.473                   | 90             | 114.0519            | -24.0519                 | 45                 | 32.8395911                  | 12.1604089                       | uncertain          |
| 3   | Harley_Lind18         | 4          | 3.473               | 0.527                    | 79             | 114.0519            | -35.0519                 | 19.75              | 32.8395911                  | -13.089591                       | uncertain          |
| 47  | Harrison.Beatty50     | 5          | 3.473               | 1.527                    | 76             | 114.0519            | -38.0519                 | 15.2               | 32.8395911                  | -17.639591                       | uncertain          |
| 74  | Hulda.Macejkovic      | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 91  | Bethany20             | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 32  | Irwin.Larson          | 4          | 3.473               | 0.527                    | 91             | 114.0519            | -23.0519                 | 22.75              | 32.8395911                  | -10.089591                       | uncertain          |
| 14  | Jaclyn81              | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 29  | Jaime53               | 8          | 3.473               | 4.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 76  | Janelle.Nikolaus81    | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 43  | Janet.Armstrong       | 5          | 3.473               | 1.527                    | 86             | 114.0519            | -28.0519                 | 17.2               | 32.8395911                  | -15.639591                       | uncertain          |
| 100 | Javonte83             | 2          | 3.473               | -1.473                   | 82             | 114.0519            | -32.0519                 | 41                 | 32.8395911                  | 8.16040887                       | uncertain          |
| 65  | Adelle96              | 5          | 3.473               | 1.527                    | 96             | 114.0519            | -18.0519                 | 19.2               | 32.8395911                  | -13.639591                       | uncertain          |
| 83  | Bartholome.Bernhard   | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 89  | Jessyca_West          | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 38  | Jordyn.Jacobson2      | 2          | 3.473               | -1.473                   | 85             | 114.0519            | -29.0519                 | 42.5               | 32.8395911                  | 9.66040887                       | uncertain          |
| 26  | Josianne.Friesen      | 5          | 3.473               | 1.527                    | 94             | 114.0519            | -20.0519                 | 18.8               | 32.8395911                  | -14.039591                       | uncertain          |
| 57  | Julien_Schmidt        | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 11  | Justina.Gaylord27     | 5          | 3.473               | 1.527                    | 89             | 114.0519            | -25.0519                 | 17.8               | 32.8395911                  | -15.039591                       | uncertain          |
| 30  | Kaley9                | 2          | 3.473               | -1.473                   | 81             | 114.0519            | -33.0519                 | 40.5               | 32.8395911                  | 7.66040887                       | uncertain          |
| 58  | Aurelie71             | 8          | 3.473               | 4.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 7   | Kasandra_Homenick     | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 4   | Arely_Bogan63         | 3          | 3.473               | -0.473                   | 93             | 114.0519            | -21.0519                 | 31                 | 32.8395911                  | -1.8395911                       | uncertain          |
| 72  | Kathryn80             | 5          | 3.473               | 1.527                    | 85             | 114.0519            | -29.0519                 | 17                 | 32.8395911                  | -15.839591                       | uncertain          |
| 96  | Keenan.Schamberger60  | 3          | 3.473               | -0.473                   | 98             | 114.0519            | -16.0519                 | 32.6667            | 32.8395911                  | -0.1728911                       | uncertain          |
| 82  | Aracely.Johnston98    | 2          | 3.473               | -1.473                   | 84             | 114.0519            | -30.0519                 | 42                 | 32.8395911                  | 9.16040887                       | uncertain          |
| 16  | Annalise.McKenzie16   | 4          | 3.473               | 0.527                    | 103            | 114.0519            | -11.0519                 | 25.75              | 32.8395911                  | -7.0895911                       | uncertain          |
| 1   | Kenton_Kirlin         | 5          | 3.473               | 1.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 35  | Lennie_Hartmann40     | 2          | 3.473               | -1.473                   | 92             | 114.0519            | -22.0519                 | 46                 | 32.8395911                  | 13.1604089                       | uncertain          |
| 75  | Leslie67              | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 53  | Linnea59              | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 46  | Malinda_Streich       | 4          | 3.473               | 0.527                    | 88             | 114.0519            | -26.0519                 | 22                 | 32.8395911                  | -10.839591                       | uncertain          |
| 51  | Mariano_Koch3         | 5          | 3.473               | 1.527                    | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 24  | Maxwell.Halvorson     | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 42  | Maya.Farrell          | 3          | 3.473               | -0.473                   | 87             | 114.0519            | -27.0519                 | 29                 | 32.8395911                  | -3.8395911                       | uncertain          |
| 41  | Mckenna17             | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 5   | Aniya_Hackett         | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 66  | Mike.Auer39           | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 85  | Milford_Gleichner42   | 2          | 3.473               | -1.473                   | 87             | 114.0519            | -27.0519                 | 43.5               | 32.8395911                  | 10.6604089                       | uncertain          |
| 49  | Morgan.Kassulke       | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 71  | Nia_Haag              | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 95  | Nicole71              | 2          | 3.473               | -1.473                   | 86             | 114.0519            | -28.0519                 | 43                 | 32.8395911                  | 10.1604089                       | uncertain          |
| 17  | Norbert_Carroll35     | 3          | 3.473               | -0.473                   | 78             | 114.0519            | -36.0519                 | 26                 | 32.8395911                  | -6.8395911                       | uncertain          |
| 2   | Andre_Purdy85         | 4          | 3.473               | 0.527                    | 94             | 114.0519            | -20.0519                 | 23.5               | 32.8395911                  | -9.3395911                       | uncertain          |
| 36  | Ollie_Ledner37        | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 34  | Pearl7                | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 84  | Alysa22               | 2          | 3.473               | -1.473                   | 75             | 114.0519            | -39.0519                 | 37.5               | 32.8395911                  | 4.66040887                       | uncertain          |
| 10  | Presley_McClure       | 3          | 3.473               | -0.473                   | 87             | 114.0519            | -27.0519                 | 29                 | 32.8395911                  | -3.8395911                       | uncertain          |
| 13  | Alexandro35           | 5          | 3.473               | 1.527                    | 93             | 114.0519            | -21.0519                 | 18.6               | 32.8395911                  | -14.239591                       | uncertain          |
| 62  | Ressie_Stanton46      | 2          | 3.473               | -1.473                   | 88             | 114.0519            | -26.0519                 | 44                 | 32.8395911                  | 11.1604089                       | uncertain          |
| 87  | Rick29                | 4          | 3.473               | 0.527                    | 92             | 114.0519            | -22.0519                 | 23                 | 32.8395911                  | -9.8395911                       | uncertain          |
| 21  | Rocio33               | NULL       | 3.473               | NULL                     | 257            | 114.0519            | 142.9481                 | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 60  | Sam52                 | 2          | 3.473               | -1.473                   | 86             | 114.0519            | -28.0519                 | 43                 | 32.8395911                  | 10.1604089                       | uncertain          |
| 44  | Seth46                | 4          | 3.473               | 0.527                    | 86             | 114.0519            | -28.0519                 | 21.5               | 32.8395911                  | -11.339591                       | uncertain          |
| 8   | Tabitha_Schamberger11 | 4          | 3.473               | 0.527                    | 79             | 114.0519            | -35.0519                 | 19.75              | 32.8395911                  | -13.089591                       | uncertain          |
| 25  | Tierra.Trantow        | NULL       | 3.473               | NULL                     | NULL           | 114.0519            | NULL                     | NA                 | 32.8395911                  | NULL                             | uncertain          |
| 97  | Tomas.Beatty93        | 2          | 3.473               | -1.473                   | 69             | 114.0519            | -45.0519                 | 34.5               | 32.8395911                  | 1.66040887                       | uncertain          |
| 6   | Travon.Waters         | 5          | 3.473               | 1.527                    | 82             | 114.0519            | -32.0519                 | 16.4               | 32.8395911                  | -16.439591                       | uncertain          |
| 93  | Willie_Leuschke       | 2          | 3.473               | -1.473                   | 91             | 114.0519            | -23.0519                 | 45.5               | 32.8395911                  | 12.6604089                       | uncertain          |
| 99  | Alek_Watsica          | 3          | 3.473               | -0.473                   | 74             | 114.0519            | -40.0519                 | 24.6667            | 32.8395911                  | -8.1728911                       | uncertain          |
| 33  | Yvette.Gottlieb91     | 5          | 3.473               | 1.527                    | 77             | 114.0519            | -37.0519                 | 15.4               | 32.8395911                  | -17.439591                       | uncertain          |
| 52  | Zack_Kemmer93         | 5          | 3.473               | 1.527                    | 85             | 114.0519            | -29.0519                 | 17                 | 32.8395911                  | -15.839591                       | uncertain          |


Below is the first in five queries that extract various aspects of user 
behaviors that mimick typical bot-like behaviors on SNS services like instagram. 
Specifically, the query below is the simplest of the five, as it simply outputs 
the total likes sent by each user, compares it against the site average, and 
based on the CASE statements below, determines if a user's probability for being 
a robot is "high", "moderate", or "uncertain". A "high" would be given if a user's
total likes sent was considerably over the site average. Ultimately, this query's 
purpose is to give additional context to users' behaviors from a more broad, 
high-level perspective. 

```sql
-- number of likes per user (throughout time using the site/app):
SELECT u.id, u.username, 
COUNT(l.photo_id) AS user_total_likes, 
ROUND(AVG(COUNT(l.photo_id)) OVER(), 2) AS site_AVG_total_likes_count,
COUNT(l.photo_id) - ROUND(AVG(COUNT(l.photo_id)) OVER(), 2) AS total_likes_diff_from_AVG,
CASE
WHEN COUNT(l.photo_id) >= 2.5 * ROUND(AVG(COUNT(l.photo_id)) OVER(), 2) THEN 'high' -- The current cutoffs of 2.5x and 1x are set in place for demonstration only due to the limitations of the dataset, however more realistic classifications of ‘high’ and ‘moderate’ probability that given users are bot accounts (in light of available real-world social media data) would be around 200x and 100x.
WHEN COUNT(l.photo_id) >= 1 * ROUND(AVG(COUNT(l.photo_id)) OVER(), 2) THEN 'moderate'
ELSE 'uncertain'
END AS prob_user_is_robot
FROM users u
LEFT JOIN likes l ON u.id = l.user_id
GROUP BY u.id, u.username
ORDER BY prob_user_is_robot
;
```

[Link to Tableau visualization](https://public.tableau.com/app/profile/aryan.tehrani/viz/Q1_robot_num_likes/Q1?publish=yes)


-- Below is the output of the above query:

*** Please note again that this is from simulated data, and this query in particular
shows more repeated data than the others. *** 


| id  | username              | user_total_likes | site_AVG_total_likes_count | total_likes_diff_from_AVG | prob_user_is_robot |
|-----|-----------------------|------------------|----------------------------|---------------------------|--------------------|
| 14  | Jaclyn81              | 257              | 87.82                      | 169.18                    | high               |
| 76  | Janelle.Nikolaus81    | 257              | 87.82                      | 169.18                    | high               |
| 54  | Duane60               | 257              | 87.82                      | 169.18                    | high               |
| 57  | Julien_Schmidt        | 257              | 87.82                      | 169.18                    | high               |
| 21  | Rocio33               | 257              | 87.82                      | 169.18                    | high               |
| 75  | Leslie67              | 257              | 87.82                      | 169.18                    | high               |
| 5   | Aniya_Hackett         | 257              | 87.82                      | 169.18                    | high               |
| 24  | Maxwell.Halvorson     | 257              | 87.82                      | 169.18                    | high               |
| 41  | Mckenna17             | 257              | 87.82                      | 169.18                    | high               |
| 66  | Mike.Auer39           | 257              | 87.82                      | 169.18                    | high               |
| 71  | Nia_Haag              | 257              | 87.82                      | 169.18                    | high               |
| 36  | Ollie_Ledner37        | 257              | 87.82                      | 169.18                    | high               |
| 91  | Bethany20             | 257              | 87.82                      | 169.18                    | high               |
| 62  | Ressie_Stanton46      | 88               | 87.82                      | 0.18                      | moderate           |
| 4   | Arely_Bogan63         | 93               | 87.82                      | 5.18                      | moderate           |
| 87  | Rick29                | 92               | 87.82                      | 4.18                      | moderate           |
| 16  | Annalise.McKenzie16   | 103              | 87.82                      | 15.18                     | moderate           |
| 46  | Malinda_Streich       | 88               | 87.82                      | 0.18                      | moderate           |
| 2   | Andre_Purdy85         | 94               | 87.82                      | 6.18                      | moderate           |
| 35  | Lennie_Hartmann40     | 92               | 87.82                      | 4.18                      | moderate           |
| 22  | Kenneth64             | 91               | 87.82                      | 3.18                      | moderate           |
| 39  | Kelsi26               | 89               | 87.82                      | 1.18                      | moderate           |
| 96  | Keenan.Schamberger60  | 98               | 87.82                      | 10.18                     | moderate           |
| 69  | Karley_Bosco          | 97               | 87.82                      | 9.18                      | moderate           |
| 11  | Justina.Gaylord27     | 89               | 87.82                      | 1.18                      | moderate           |
| 13  | Alexandro35           | 93               | 87.82                      | 5.18                      | moderate           |
| 93  | Willie_Leuschke       | 91               | 87.82                      | 3.18                      | moderate           |
| 26  | Josianne.Friesen      | 94               | 87.82                      | 6.18                      | moderate           |
| 31  | Aiyana_Hoeger         | 88               | 87.82                      | 0.18                      | moderate           |
| 70  | Erick5                | 88               | 87.82                      | 0.18                      | moderate           |
| 65  | Adelle96              | 96               | 87.82                      | 8.18                      | moderate           |
| 32  | Irwin.Larson          | 91               | 87.82                      | 3.18                      | moderate           |
| 19  | Hailee26              | 90               | 87.82                      | 2.18                      | moderate           |
| 92  | Frederik_Rice         | 91               | 87.82                      | 3.18                      | moderate           |
| 68  | Franco_Keebler64      | 0                | 87.82                      | -87.82                    | uncertain          |
| 64  | Florence99            | 0                | 87.82                      | -87.82                    | uncertain          |
| 50  | Gerard79              | 81               | 87.82                      | -6.82                     | uncertain          |
| 48  | Granville_Kutch       | 75               | 87.82                      | -12.82                    | uncertain          |
| 9   | Gus93                 | 85               | 87.82                      | -2.82                     | uncertain          |
| 23  | Eveline95             | 0                | 87.82                      | -87.82                    | uncertain          |
| 3   | Harley_Lind18         | 79               | 87.82                      | -8.82                     | uncertain          |
| 47  | Harrison.Beatty50     | 76               | 87.82                      | -11.82                    | uncertain          |
| 74  | Hulda.Macejkovic      | 0                | 87.82                      | -87.82                    | uncertain          |
| 98  | Imani_Nicolas17       | 74               | 87.82                      | -13.82                    | uncertain          |
| 81  | Esther.Zulauf61       | 0                | 87.82                      | -87.82                    | uncertain          |
| 90  | Esmeralda.Mraz57      | 0                | 87.82                      | -87.82                    | uncertain          |
| 29  | Jaime53               | 0                | 87.82                      | -87.82                    | uncertain          |
| 67  | Emilio_Bernier52      | 86               | 87.82                      | -1.82                     | uncertain          |
| 43  | Janet.Armstrong       | 86               | 87.82                      | -1.82                     | uncertain          |
| 100 | Javonte83             | 82               | 87.82                      | -5.82                     | uncertain          |
| 73  | Jaylan.Lakin          | 86               | 87.82                      | -1.82                     | uncertain          |
| 61  | Jayson65              | 83               | 87.82                      | -4.82                     | uncertain          |
| 89  | Jessyca_West          | 0                | 87.82                      | -87.82                    | uncertain          |
| 38  | Jordyn.Jacobson2      | 85               | 87.82                      | -2.82                     | uncertain          |
| 63  | Elenor88              | 83               | 87.82                      | -4.82                     | uncertain          |
| 77  | Donald.Fritsch        | 0                | 87.82                      | -87.82                    | uncertain          |
| 12  | Dereck65              | 77               | 87.82                      | -10.82                    | uncertain          |
| 30  | Kaley9                | 81               | 87.82                      | -6.82                     | uncertain          |
| 20  | Delpha.Kihn           | 87               | 87.82                      | -0.82                     | uncertain          |
| 7   | Kasandra_Homenick     | 0                | 87.82                      | -87.82                    | uncertain          |
| 79  | Katarina.Dibbert      | 75               | 87.82                      | -12.82                    | uncertain          |
| 72  | Kathryn80             | 85               | 87.82                      | -2.82                     | uncertain          |
| 86  | Delfina_VonRueden68   | 0                | 87.82                      | -87.82                    | uncertain          |
| 45  | David.Osinski47       | 0                | 87.82                      | -87.82                    | uncertain          |
| 27  | Darwin29              | 79               | 87.82                      | -8.82                     | uncertain          |
| 1   | Kenton_Kirlin         | 0                | 87.82                      | -87.82                    | uncertain          |
| 28  | Dario77               | 77               | 87.82                      | -10.82                    | uncertain          |
| 80  | Darby_Herzog          | 0                | 87.82                      | -87.82                    | uncertain          |
| 53  | Linnea59              | 0                | 87.82                      | -87.82                    | uncertain          |
| 94  | Damon35               | 84               | 87.82                      | -3.82                     | uncertain          |
| 51  | Mariano_Koch3         | 0                | 87.82                      | -87.82                    | uncertain          |
| 78  | Colten.Harris76       | 83               | 87.82                      | -4.82                     | uncertain          |
| 42  | Maya.Farrell          | 87               | 87.82                      | -0.82                     | uncertain          |
| 88  | Clint27               | 0                | 87.82                      | -87.82                    | uncertain          |
| 55  | Meggie_Doyle          | 78               | 87.82                      | -9.82                     | uncertain          |
| 59  | Cesar93               | 0                | 87.82                      | -87.82                    | uncertain          |
| 85  | Milford_Gleichner42   | 87               | 87.82                      | -0.82                     | uncertain          |
| 49  | Morgan.Kassulke       | 0                | 87.82                      | -87.82                    | uncertain          |
| 15  | Billy52               | 84               | 87.82                      | -3.82                     | uncertain          |
| 95  | Nicole71              | 86               | 87.82                      | -1.82                     | uncertain          |
| 17  | Norbert_Carroll35     | 78               | 87.82                      | -9.82                     | uncertain          |
| 18  | Odessa2               | 82               | 87.82                      | -5.82                     | uncertain          |
| 83  | Bartholome.Bernhard   | 0                | 87.82                      | -87.82                    | uncertain          |
| 34  | Pearl7                | 0                | 87.82                      | -87.82                    | uncertain          |
| 56  | Peter.Stehr0          | 81               | 87.82                      | -6.82                     | uncertain          |
| 10  | Presley_McClure       | 87               | 87.82                      | -0.82                     | uncertain          |
| 40  | Rafael.Hickle2        | 85               | 87.82                      | -2.82                     | uncertain          |
| 58  | Aurelie71             | 0                | 87.82                      | -87.82                    | uncertain          |
| 82  | Aracely.Johnston98    | 84               | 87.82                      | -3.82                     | uncertain          |
| 84  | Alysa22               | 75               | 87.82                      | -12.82                    | uncertain          |
| 60  | Sam52                 | 86               | 87.82                      | -1.82                     | uncertain          |
| 44  | Seth46                | 86               | 87.82                      | -1.82                     | uncertain          |
| 8   | Tabitha_Schamberger11 | 79               | 87.82                      | -8.82                     | uncertain          |
| 25  | Tierra.Trantow        | 0                | 87.82                      | -87.82                    | uncertain          |
| 97  | Tomas.Beatty93        | 69               | 87.82                      | -18.82                    | uncertain          |
| 6   | Travon.Waters         | 82               | 87.82                      | -5.82                     | uncertain          |
| 99  | Alek_Watsica          | 74               | 87.82                      | -13.82                    | uncertain          |
| 37  | Yazmin_Mills95        | 84               | 87.82                      | -3.82                     | uncertain          |
| 33  | Yvette.Gottlieb91     | 77               | 87.82                      | -10.82                    | uncertain          |
| 52  | Zack_Kemmer93         | 85               | 87.82                      | -2.82                     | uncertain          |

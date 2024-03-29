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


[Link to Tableau visualization](https://public.tableau.com/app/profile/aryan.tehrani/viz/Q1_robot_num_likes/Q3?publish=yes)


-- Below is the output of the above query:

+-----+-----------------------+------------+---------------------+--------------------------+----------------+---------------------+--------------------------+--------------------+-----------------------------+----------------------------------+--------------------+
| id  | username              | num_photos | site_AVG_num_photos | num_photos_diff_from_AVG | num_likes_sent | site_AVG_likes_sent | likes_sent_diff_from_AVG | likes_photos_ratio | site_AVG_likes_photos_ratio | likes_photos_ratio_diff_from_AVG | prob_user_is_robot |
+-----+-----------------------+------------+---------------------+--------------------------+----------------+---------------------+--------------------------+--------------------+-----------------------------+----------------------------------+--------------------+
|  73 | Jaylan.Lakin          |          1 |              3.4730 |                  -2.4730 |             86 |            114.0519 |                 -28.0519 | 86.0000            |                32.839591132 |                     53.160408868 | high               |
|  31 | Aiyana_Hoeger         |          1 |              3.4730 |                  -2.4730 |             88 |            114.0519 |                 -26.0519 | 88.0000            |                32.839591132 |                     55.160408868 | high               |
|  37 | Yazmin_Mills95        |          1 |              3.4730 |                  -2.4730 |             84 |            114.0519 |                 -30.0519 | 84.0000            |                32.839591132 |                     51.160408868 | high               |
|  40 | Rafael.Hickle2        |          1 |              3.4730 |                  -2.4730 |             85 |            114.0519 |                 -29.0519 | 85.0000            |                32.839591132 |                     52.160408868 | high               |
|  22 | Kenneth64             |          1 |              3.4730 |                  -2.4730 |             91 |            114.0519 |                 -23.0519 | 91.0000            |                32.839591132 |                     58.160408868 | high               |
|  39 | Kelsi26               |          1 |              3.4730 |                  -2.4730 |             89 |            114.0519 |                 -25.0519 | 89.0000            |                32.839591132 |                     56.160408868 | high               |
|  69 | Karley_Bosco          |          1 |              3.4730 |                  -2.4730 |             97 |            114.0519 |                 -17.0519 | 97.0000            |                32.839591132 |                     64.160408868 | high               |
|  61 | Jayson65              |          1 |              3.4730 |                  -2.4730 |             83 |            114.0519 |                 -31.0519 | 83.0000            |                32.839591132 |                     50.160408868 | high               |
|  70 | Erick5                |          1 |              3.4730 |                  -2.4730 |             88 |            114.0519 |                 -26.0519 | 88.0000            |                32.839591132 |                     55.160408868 | high               |
|  20 | Delpha.Kihn           |          1 |              3.4730 |                  -2.4730 |             87 |            114.0519 |                 -27.0519 | 87.0000            |                32.839591132 |                     54.160408868 | high               |
|  94 | Damon35               |          1 |              3.4730 |                  -2.4730 |             84 |            114.0519 |                 -30.0519 | 84.0000            |                32.839591132 |                     51.160408868 | high               |
|  56 | Peter.Stehr0          |          1 |              3.4730 |                  -2.4730 |             81 |            114.0519 |                 -33.0519 | 81.0000            |                32.839591132 |                     48.160408868 | moderate           |
|  18 | Odessa2               |          1 |              3.4730 |                  -2.4730 |             82 |            114.0519 |                 -32.0519 | 82.0000            |                32.839591132 |                     49.160408868 | moderate           |
|  55 | Meggie_Doyle          |          1 |              3.4730 |                  -2.4730 |             78 |            114.0519 |                 -36.0519 | 78.0000            |                32.839591132 |                     45.160408868 | moderate           |
|  79 | Katarina.Dibbert      |          1 |              3.4730 |                  -2.4730 |             75 |            114.0519 |                 -39.0519 | 75.0000            |                32.839591132 |                     42.160408868 | moderate           |
|  98 | Imani_Nicolas17       |          1 |              3.4730 |                  -2.4730 |             74 |            114.0519 |                 -40.0519 | 74.0000            |                32.839591132 |                     41.160408868 | moderate           |
|  48 | Granville_Kutch       |          1 |              3.4730 |                  -2.4730 |             75 |            114.0519 |                 -39.0519 | 75.0000            |                32.839591132 |                     42.160408868 | moderate           |
|  27 | Darwin29              |          1 |              3.4730 |                  -2.4730 |             79 |            114.0519 |                 -35.0519 | 79.0000            |                32.839591132 |                     46.160408868 | moderate           |
|  80 | Darby_Herzog          |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  28 | Dario77               |          4 |              3.4730 |                   0.5270 |             77 |            114.0519 |                 -37.0519 | 19.2500            |                32.839591132 |                    -13.589591132 | uncertain          |
|  78 | Colten.Harris76       |          5 |              3.4730 |                   1.5270 |             83 |            114.0519 |                 -31.0519 | 16.6000            |                32.839591132 |                    -16.239591132 | uncertain          |
|  45 | David.Osinski47       |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  86 | Delfina_VonRueden68   |          9 |              3.4730 |                   5.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  88 | Clint27               |         11 |              3.4730 |                   7.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  12 | Dereck65              |          4 |              3.4730 |                   0.5270 |             77 |            114.0519 |                 -37.0519 | 19.2500            |                32.839591132 |                    -13.589591132 | uncertain          |
|  77 | Donald.Fritsch        |          6 |              3.4730 |                   2.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  54 | Duane60               |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  63 | Elenor88              |          4 |              3.4730 |                   0.5270 |             83 |            114.0519 |                 -31.0519 | 20.7500            |                32.839591132 |                    -12.089591132 | uncertain          |
|  67 | Emilio_Bernier52      |          3 |              3.4730 |                  -0.4730 |             86 |            114.0519 |                 -28.0519 | 28.6667            |                32.839591132 |                     -4.172891132 | uncertain          |
|  59 | Cesar93               |         10 |              3.4730 |                   6.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  90 | Esmeralda.Mraz57      |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  81 | Esther.Zulauf61       |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  23 | Eveline95             |         12 |              3.4730 |                   8.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  64 | Florence99            |          5 |              3.4730 |                   1.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  68 | Franco_Keebler64      |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  92 | Frederik_Rice         |          3 |              3.4730 |                  -0.4730 |             91 |            114.0519 |                 -23.0519 | 30.3333            |                32.839591132 |                     -2.506291132 | uncertain          |
|  50 | Gerard79              |          3 |              3.4730 |                  -0.4730 |             81 |            114.0519 |                 -33.0519 | 27.0000            |                32.839591132 |                     -5.839591132 | uncertain          |
|  15 | Billy52               |          4 |              3.4730 |                   0.5270 |             84 |            114.0519 |                 -30.0519 | 21.0000            |                32.839591132 |                    -11.839591132 | uncertain          |
|   9 | Gus93                 |          4 |              3.4730 |                   0.5270 |             85 |            114.0519 |                 -29.0519 | 21.2500            |                32.839591132 |                    -11.589591132 | uncertain          |
|  19 | Hailee26              |          2 |              3.4730 |                  -1.4730 |             90 |            114.0519 |                 -24.0519 | 45.0000            |                32.839591132 |                     12.160408868 | uncertain          |
|   3 | Harley_Lind18         |          4 |              3.4730 |                   0.5270 |             79 |            114.0519 |                 -35.0519 | 19.7500            |                32.839591132 |                    -13.089591132 | uncertain          |
|  47 | Harrison.Beatty50     |          5 |              3.4730 |                   1.5270 |             76 |            114.0519 |                 -38.0519 | 15.2000            |                32.839591132 |                    -17.639591132 | uncertain          |
|  74 | Hulda.Macejkovic      |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  91 | Bethany20             |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  32 | Irwin.Larson          |          4 |              3.4730 |                   0.5270 |             91 |            114.0519 |                 -23.0519 | 22.7500            |                32.839591132 |                    -10.089591132 | uncertain          |
|  14 | Jaclyn81              |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  29 | Jaime53               |          8 |              3.4730 |                   4.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  76 | Janelle.Nikolaus81    |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  43 | Janet.Armstrong       |          5 |              3.4730 |                   1.5270 |             86 |            114.0519 |                 -28.0519 | 17.2000            |                32.839591132 |                    -15.639591132 | uncertain          |
| 100 | Javonte83             |          2 |              3.4730 |                  -1.4730 |             82 |            114.0519 |                 -32.0519 | 41.0000            |                32.839591132 |                      8.160408868 | uncertain          |
|  65 | Adelle96              |          5 |              3.4730 |                   1.5270 |             96 |            114.0519 |                 -18.0519 | 19.2000            |                32.839591132 |                    -13.639591132 | uncertain          |
|  83 | Bartholome.Bernhard   |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  89 | Jessyca_West          |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  38 | Jordyn.Jacobson2      |          2 |              3.4730 |                  -1.4730 |             85 |            114.0519 |                 -29.0519 | 42.5000            |                32.839591132 |                      9.660408868 | uncertain          |
|  26 | Josianne.Friesen      |          5 |              3.4730 |                   1.5270 |             94 |            114.0519 |                 -20.0519 | 18.8000            |                32.839591132 |                    -14.039591132 | uncertain          |
|  57 | Julien_Schmidt        |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  11 | Justina.Gaylord27     |          5 |              3.4730 |                   1.5270 |             89 |            114.0519 |                 -25.0519 | 17.8000            |                32.839591132 |                    -15.039591132 | uncertain          |
|  30 | Kaley9                |          2 |              3.4730 |                  -1.4730 |             81 |            114.0519 |                 -33.0519 | 40.5000            |                32.839591132 |                      7.660408868 | uncertain          |
|  58 | Aurelie71             |          8 |              3.4730 |                   4.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|   7 | Kasandra_Homenick     |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|   4 | Arely_Bogan63         |          3 |              3.4730 |                  -0.4730 |             93 |            114.0519 |                 -21.0519 | 31.0000            |                32.839591132 |                     -1.839591132 | uncertain          |
|  72 | Kathryn80             |          5 |              3.4730 |                   1.5270 |             85 |            114.0519 |                 -29.0519 | 17.0000            |                32.839591132 |                    -15.839591132 | uncertain          |
|  96 | Keenan.Schamberger60  |          3 |              3.4730 |                  -0.4730 |             98 |            114.0519 |                 -16.0519 | 32.6667            |                32.839591132 |                     -0.172891132 | uncertain          |
|  82 | Aracely.Johnston98    |          2 |              3.4730 |                  -1.4730 |             84 |            114.0519 |                 -30.0519 | 42.0000            |                32.839591132 |                      9.160408868 | uncertain          |
|  16 | Annalise.McKenzie16   |          4 |              3.4730 |                   0.5270 |            103 |            114.0519 |                 -11.0519 | 25.7500            |                32.839591132 |                     -7.089591132 | uncertain          |
|   1 | Kenton_Kirlin         |          5 |              3.4730 |                   1.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  35 | Lennie_Hartmann40     |          2 |              3.4730 |                  -1.4730 |             92 |            114.0519 |                 -22.0519 | 46.0000            |                32.839591132 |                     13.160408868 | uncertain          |
|  75 | Leslie67              |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  53 | Linnea59              |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  46 | Malinda_Streich       |          4 |              3.4730 |                   0.5270 |             88 |            114.0519 |                 -26.0519 | 22.0000            |                32.839591132 |                    -10.839591132 | uncertain          |
|  51 | Mariano_Koch3         |          5 |              3.4730 |                   1.5270 |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  24 | Maxwell.Halvorson     |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  42 | Maya.Farrell          |          3 |              3.4730 |                  -0.4730 |             87 |            114.0519 |                 -27.0519 | 29.0000            |                32.839591132 |                     -3.839591132 | uncertain          |
|  41 | Mckenna17             |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|   5 | Aniya_Hackett         |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  66 | Mike.Auer39           |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  85 | Milford_Gleichner42   |          2 |              3.4730 |                  -1.4730 |             87 |            114.0519 |                 -27.0519 | 43.5000            |                32.839591132 |                     10.660408868 | uncertain          |
|  49 | Morgan.Kassulke       |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  71 | Nia_Haag              |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  95 | Nicole71              |          2 |              3.4730 |                  -1.4730 |             86 |            114.0519 |                 -28.0519 | 43.0000            |                32.839591132 |                     10.160408868 | uncertain          |
|  17 | Norbert_Carroll35     |          3 |              3.4730 |                  -0.4730 |             78 |            114.0519 |                 -36.0519 | 26.0000            |                32.839591132 |                     -6.839591132 | uncertain          |
|   2 | Andre_Purdy85         |          4 |              3.4730 |                   0.5270 |             94 |            114.0519 |                 -20.0519 | 23.5000            |                32.839591132 |                     -9.339591132 | uncertain          |
|  36 | Ollie_Ledner37        |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  34 | Pearl7                |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  84 | Alysa22               |          2 |              3.4730 |                  -1.4730 |             75 |            114.0519 |                 -39.0519 | 37.5000            |                32.839591132 |                      4.660408868 | uncertain          |
|  10 | Presley_McClure       |          3 |              3.4730 |                  -0.4730 |             87 |            114.0519 |                 -27.0519 | 29.0000            |                32.839591132 |                     -3.839591132 | uncertain          |
|  13 | Alexandro35           |          5 |              3.4730 |                   1.5270 |             93 |            114.0519 |                 -21.0519 | 18.6000            |                32.839591132 |                    -14.239591132 | uncertain          |
|  62 | Ressie_Stanton46      |          2 |              3.4730 |                  -1.4730 |             88 |            114.0519 |                 -26.0519 | 44.0000            |                32.839591132 |                     11.160408868 | uncertain          |
|  87 | Rick29                |          4 |              3.4730 |                   0.5270 |             92 |            114.0519 |                 -22.0519 | 23.0000            |                32.839591132 |                     -9.839591132 | uncertain          |
|  21 | Rocio33               |       NULL |              3.4730 |                     NULL |            257 |            114.0519 |                 142.9481 | NA                 |                32.839591132 |                             NULL | uncertain          |
|  60 | Sam52                 |          2 |              3.4730 |                  -1.4730 |             86 |            114.0519 |                 -28.0519 | 43.0000            |                32.839591132 |                     10.160408868 | uncertain          |
|  44 | Seth46                |          4 |              3.4730 |                   0.5270 |             86 |            114.0519 |                 -28.0519 | 21.5000            |                32.839591132 |                    -11.339591132 | uncertain          |
|   8 | Tabitha_Schamberger11 |          4 |              3.4730 |                   0.5270 |             79 |            114.0519 |                 -35.0519 | 19.7500            |                32.839591132 |                    -13.089591132 | uncertain          |
|  25 | Tierra.Trantow        |       NULL |              3.4730 |                     NULL |           NULL |            114.0519 |                     NULL | NA                 |                32.839591132 |                             NULL | uncertain          |
|  97 | Tomas.Beatty93        |          2 |              3.4730 |                  -1.4730 |             69 |            114.0519 |                 -45.0519 | 34.5000            |                32.839591132 |                      1.660408868 | uncertain          |
|   6 | Travon.Waters         |          5 |              3.4730 |                   1.5270 |             82 |            114.0519 |                 -32.0519 | 16.4000            |                32.839591132 |                    -16.439591132 | uncertain          |
|  93 | Willie_Leuschke       |          2 |              3.4730 |                  -1.4730 |             91 |            114.0519 |                 -23.0519 | 45.5000            |                32.839591132 |                     12.660408868 | uncertain          |
|  99 | Alek_Watsica          |          3 |              3.4730 |                  -0.4730 |             74 |            114.0519 |                 -40.0519 | 24.6667            |                32.839591132 |                     -8.172891132 | uncertain          |
|  33 | Yvette.Gottlieb91     |          5 |              3.4730 |                   1.5270 |             77 |            114.0519 |                 -37.0519 | 15.4000            |                32.839591132 |                    -17.439591132 | uncertain          |
|  52 | Zack_Kemmer93         |          5 |              3.4730 |                   1.5270 |             85 |            114.0519 |                 -29.0519 | 17.0000            |                32.839591132 |                    -15.839591132 | uncertain          |
+-----+-----------------------+------------+---------------------+--------------------------+----------------+---------------------+--------------------------+--------------------+-----------------------------+----------------------------------+--------------------+


# SNS_Bot_Detection_Analysis


The current project contains five queries, the last one being an aggregate of the previous four, to determine if users in a simulated dataset mimicking SNS services 
like instagram are potentially bots. The impetus for creating this project was to
contend with an issue that is rife in virtually all online platforms and has 
deleterious consequences in regards to politics, general news, mental health, scams, authenticity of content feedback, etc. 

Having a background as a researcher/Lab Manager at UC Berkeley's Relationsihps and 
Social Cognition Laboratory, I knew prior to the onset of this project that a 
holistic, multivariet analysis of the data would be the best method for producing accurate measures of user behavior. As such, I developed queries that evaluate user behavior across time, and then contextualize that with the average user behavior on the
site. 

Here, I want to provide a brief explanation for each query, but also note that above 
each query in the separate files in this repository, there is further overview of the queries along with more specific explanations next to certain parts of the code to illuminate some technical decisions.

Query 1: Total likes  
- sums the total likes sent by each user
- compares the total likes sent by each user against the site average
- determines the probability a given user is a bot based on how much their likes sent is greater than the site average

Of course this query by itself is not powerful enough to determine which accounts are inauthentic, but it would be remiss to not include such relevant information. 


Query 2: Average time to like photos  
- measures the average time a user likes a photo after it has been posted to the site
- compares each user's average time to like a photo against the site average
- determines the probability a given user is a bot based on how fast they like photos on average

<!-- One key characteristic of SNS bots is speed, and as such, the query here measures the average time a user likes a photo after it has been posted to the site. The idea is that if a user is consistently liking photos within seconds after they have been posted, this is likely not a real user. Moreover, I believe it was particularly important to calculate an average with this query, as it is reasonable for authentic users to be using the service, by chance see a post right after it was uploaded, and like the photo within seconds - this can indeed happen on occasion. However, if a given user is demonstrating this short timeframe between the photo being uploaded and liking the photo over many interactions using the service, it becomes more and more improbable that such an account is authentic. -->
Query 3: Likes to photos ratio  
- measures each user's ratio of likes sent to their photos posted
- compares each user's ratio to the site average ratio
- determines the probability a given user is a bot based on how large their ratio is - i.e. large number of likes sent with few photos posted

<!-- Another key characteristic of SNS bots, especially on instagram, is their number of likes sent in comparison to their number of photos posted. To gain followers and interactions with real users, bots send an inordinate amount of likes, yet their own profiles rarely have many photos, and even if they do, do not have a human subject, or are advertisements of some kind. Likewise, this query outputs users' likes sent to photos posted ratio, compares that against the average, and finally based on that ratio, determines their probability of being a bot. This query is similar to the first query, in that it extracts the number of likes sent, however, because there are many avid users on sites like instagram, who like photos at a rate far beyond average, this query assesses if a given user's number of photos is commensurate with their number of likes sent. In comparison to a avid user, a bot will have a much more disproportionate ratio. -->
Query 4: following to followers ratio  
- measures each user's ratio of accounts following to their followers
- compares each user's ratio to the site average ratio
- determines the probability a given user is a bot based on how large their ratio is
<!-- This query evaluates another common occurrence with SNS bots, which is that they typically gain very few followers relative to how many accounts they follow. Of course, there are authentic users who have many followers, and also use their own bots to follow many other accounts and then unfollow them after they've gained the mutual follow, or simply unfollow if a mutual follow was unreciprocated, but this query's goal is actually to detect bots from inauthentic accounts. As such, this fourth query this query outputs each user's follows to followers ratio, and if the ratio is past a threshold that is considered aberrant, a probability of them being a bot is ascribed. -->

Query 5: final analysis  
- four temporary tables (temporary tables are typically used to store intermediate results during a session to perform more complicated queries; in my case, it's necessary because I'm evaluating results from four separate queries) are created from the above four queries
- sums the number of times each user has received a probability of "high", "moderate", and "uncertain" in a separate temporary table
- based on how many times a user has been ascribed a particular probability, a final probability is produced as a simple list of user id and a probability of "high", "moderate", and "uncertain"
- this final analysis doesn't evaluate based on any new criteria, but rather, integrates all of the prior four queries for a holistic analysis
<!-- The final query utilizes temporary tables from each previous query, and then sums the number of times each user has received a probability of "high", "moderate", and "uncertain" for being a bot to ascribe a final probability. A simple output of user id and probability the user is a bot is produced, which can be very easily visualized in Tableu or other software. Further, this query summarizes the behavior within the site to give stakeholders an overview of how many users are authentic. Of course, this information is important on many different levels, as mentioned in the introduction, however it is ultimately important for the survival of the company, since a SNS service that is overrun with bots will witness its financial evaluation diminish, which will limit its investments and growth. -->





# National_Data_Analyst_Salaries_Comparison

<!--find out the data of the salaries -->
Introduction

Welcome to my National Data Analyst Salaries Comparison project! The dataset used for this analysis was sourced from [kaggle.com](https://www.kaggle.com/datasets/andrewmvd/data-analyst-jobs) and represents salaries posted on Glassdoor around 2020, amidst the pandemic.

To prepare the dataset for visualization in Tableau, extensive data preprocessing was required. This involved utilizing Excel and Python Pandas functions to parse and modify various information, such as converting salary ranges into minimum and maximum values. Each column presented its own challenges, necessitating careful planning and research.

Additionally, to provide more context around the salaries and their locations, I integrated the salary data with another dataset from [zumper.com](https://www.zumper.com/blog/rental-price-data/), offering valuable insights into the national rental market.

Throughout this project, I aimed to explore trends and disparities in data analyst salaries across different regions, leveraging both quantitative analysis and data visualization techniques.

Geo-spatial visualization of data analyst salaries:  
- Displays red, orange, and green spheres across various US cities to indicate low, medium, and high salary ranges, respectively
- Sizes of the spheres also indicate salary, with larger spheres representing higher salaries
- Hovering the mouse over a city will display a pop-up window with information that includes city, state, and the average data analyst salary in that area, as well as the average 1 and 2 bedroom rent along with its national ranking, if available.
- On the right side of the screen, toggles for state and city are available if the user wishes to view only select locations

[Link to Tableau visualization](https://public.tableau.com/app/profile/aryan.tehrani/viz/LabelPractice/SalarybyCity?publish=yes)


Salary Minus Rent Visualization:  
- A chart that displays select cities along with their rent ranking, average one and two bedroom rent costs, average data analyst salary for the city, and their savings after a year of paying for a one and two bedroom home
- The results are color-coded red, orange, and green to indicate low, medium, and high savings after rent, respectively

[Link to Tableau visualization](https://public.tableau.com/app/profile/aryan.tehrani/viz/LabelPractice/SalaryVsRent33Cities?publish=yes)


Most Popular Job Sectors Visualization:  
- Displays red, orange, and green bars next to job sectors along the y-axis to indicate level of employee satisfaction out of five possible points (this is on the left side of the x-axis labeled Avg.Rating)
- On the right side of the x-axis labeled "Avg.Salary Estimate", the bar sizes, not colors, indicate expected salary

[Link to Tableau visualization](https://public.tableau.com/app/profile/aryan.tehrani/viz/LabelPractice/MostPopularJobSectors?publish=yes)


Salary by State Visualization:  
- Orders states by average income and displays bars in red, orange, and green to indicate low, medium, and high average salaries, respectively

[Link to Tableau visualization](https://public.tableau.com/app/profile/aryan.tehrani/viz/LabelPractice/BestVariablesforPredictingHighSalary3?publish=yes)






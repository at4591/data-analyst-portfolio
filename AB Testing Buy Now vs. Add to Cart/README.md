# A/B Testing: 'Buy Now' vs. 'Add to Cart'

### **Introduction**

Welcome to my A/B testing project concerning the efficacy of a "Buy Now" button on consumer spending for a hypothetical e-commerce site! This data was generated in Python and the probability of the results were determined before hand. 

More specifically, the purpose of the study was to employ advanced statistical measures, such as a t-test and z-test to determine if adding a "Buy Now" button will generate higher consumer spending as opposed to the more traditional purchasing procedure of selecting items via an "Add to Cart" button (i.e. no "Buy Now" button present). I hypothesized that the introduction of a "Buy Now" button would not increase sales, as it would not encourage users to browse through multiple items, but rather purchase a single item and feel closure or satiation right then and there. 

Below, I would like to outline the study and then share the results and code at the bottom.

### **Study Outline**

**Question**  
Does the addition of a call-to-action (CTA) button, such as a "Buy Now" button, generate more sales?

**Hypothesis**  
If a “Buy Now” button is added to site (not removing the "Add to Cart" button), significantly less products will be purchased, generating less sales, than if there were only an “Add to cart” button.

**Methodology**  
There are two groups (control and experimental) that are randomly selected where the control group sees the site as is with no “Buy Now” button, just the “Add to cart” button. The experimental group still has the “Add to cart” button, but also a “Buy Now” button that utilizes the users stored payment information and address for an expedited checkout process. The purchase of an item is represented by the variable "clicked" in the code. Further, in the code's design, each user is given five sessions where based on their group, they have a certain probability of making a purchase (0.10 for "Buy Now" and 0.15 for "Add to Cart"). Other experimental minutiae are left out as this is more of a simple showcase of my A/B Test design and can't easily be reflected in the code (such as time of year, new vs recurring users, etc.). 

**Metrics**  
The main metric of interest is purchases - ultimately, did the user purchase a given item. The purchase is represented by the "clicked" variable, which doesn't merely represent a click of the button, but the final purchase. Moreover, number of items viewed, number of items purchased, and total dollars spent per user are obtained. 

**Study limitations**  
This study is only taking data on an item bases and not obtaining secondary metrics from users, such as demographics, time per session, number of items viewed, etc. Obtaining this information would have complicated the study, and my goal was to obtain a strict baseline for the effect of a "Buy Now" button on user spending between two randomly selected groups. However, the results of this study are a nice launching pad towards pursuing the above mentioned variables in a future study. 

**Results**  
The full results are brief and can be viewed below, but chiefly, as designed the "Add to Cart" group (control group) exhibited significantly more purchases per session and higher spending overall. The "Add to Cart" group demonstrated a mean of 0.81 purchases at $16.21 spent per session in comparison to the "Buy Now" group's 0.55 purchases and $11.09 spent per session. These results support the hypothesis that the introduction of a "Buy Now" button would result in less consumer purchases and spending per session.  


### **Below are the outputted results of the study**:

|                   | Items Purchased |           |         | Total Spend   |           |         |
|-------------------|-----------------|-----------|---------|---------------|-----------|---------|
| Button Type       | Mean            | Std       | Count   | Mean          | Std       | Count   |
|-------------------|-----------------|-----------|---------|---------------|-----------|---------|
| Add to Cart       | 0.810379        | 0.929403  | 2505    | 16.207585     | 18.588061 | 2505    |
| Buy Now           | 0.554709        | 0.774566  | 2495    | 11.094188     | 15.491323 | 2495    |


T-test for items purchased: t-statistic = -10.564232002937189, p-value = 8.154455032164342e-26  
T-test for total spend: t-statistic = -10.564232002937189, p-value = 8.154455032164342e-26  
The difference in the number of items purchased is statistically significant.  
The difference in total spend is statistically significant.  
Z-test for items purchased: z-score = -19.423176766112732, p-value = 0.0, pooled proportion = 0.6828  


### **Code used to simulate study**:

```python
import random
import pandas as pd
import numpy as np
from scipy.stats import ttest_ind, norm

buy_now_click_rate = 0.10  # 10% click rate for "Buy Now"
add_to_cart_click_rate = 0.15  # 15% click rate for "Add to Cart"

# All items are set to $20.00
avg_spend_per_item = 20

# Number of users
n_users = 1000

# Simulate user sessions
data = []
sessions_per_user = 5  # Each user has 5 sessions
for user_id in range(1, n_users + 1):
    for session_id in range(1, sessions_per_user + 1):
        button_type = random.choice(['Buy Now', 'Add to Cart'])
        session_items = 0
        session_spend = 0
        items_viewed = random.randint(1, 10)  # Each session has 1-10 items viewed
        for _ in range(items_viewed):
            click_rate = buy_now_click_rate if button_type == 'Buy Now' else add_to_cart_click_rate
            clicked = 1 if random.random() < click_rate else 0
            session_items += clicked
            session_spend += clicked * avg_spend_per_item
        data.append((user_id, session_id, button_type, session_items, session_spend))

# Convert to DataFrame
df = pd.DataFrame(data, columns=['user_id', 'session_id', 'button_type', 'items_purchased', 'total_spend'])

# Display a sample of the generated data
print(df.head())

# Calculate overall metrics
metrics = df.groupby('button_type').agg({
    'items_purchased': ['mean', 'std', 'count'],
    'total_spend': ['mean', 'std', 'count']
})

print(metrics)

# Perform t-tests for items purchased
buy_now_items = df[df['button_type'] == 'Buy Now']['items_purchased']
add_to_cart_items = df[df['button_type'] == 'Add to Cart']['items_purchased']
t_stat_items, p_val_items = ttest_ind(buy_now_items, add_to_cart_items)

# Perform t-tests for total spend
buy_now_spend = df[df['button_type'] == 'Buy Now']['total_spend']
add_to_cart_spend = df[df['button_type'] == 'Add to Cart']['total_spend']
t_stat_spend, p_val_spend = ttest_ind(buy_now_spend, add_to_cart_spend)

# Print the results
print(f"T-test for items purchased: t-statistic = {t_stat_items}, p-value = {p_val_items}")
print(f"T-test for total spend: t-statistic = {t_stat_spend}, p-value = {p_val_spend}")

# Determine statistical significance
alpha = 0.05
if p_val_items < alpha:
    items_significant = "The difference in the number of items purchased is statistically significant."
else:
    items_significant = "The difference in the number of items purchased is not statistically significant."

if p_val_spend < alpha:
    spend_significant = "The difference in total spend is statistically significant."
else:
    spend_significant = "The difference in total spend is not statistically significant."

print(items_significant)
print(spend_significant)

# Additional Statistics: Z-Test
def z_test(clicks_A, total_A, clicks_B, total_B):
    p_A = clicks_A / total_A
    p_B = clicks_B / total_B
    p_pool = (clicks_A + clicks_B) / (total_A + total_B)
    se = (p_pool * (1 - p_pool) * (1 / total_A + 1 / total_B)) ** 0.5
    z = (p_A - p_B) / se
    return z, p_pool

clicks_buy_now = df[df['button_type'] == 'Buy Now']['items_purchased'].sum()
clicks_add_to_cart = df[df['button_type'] == 'Add to Cart']['items_purchased'].sum()
total_buy_now = df[df['button_type'] == 'Buy Now']['items_purchased'].count()
total_add_to_cart = df[df['button_type'] == 'Add to Cart']['items_purchased'].count()

z_score_items, p_pool_items = z_test(clicks_buy_now, total_buy_now, clicks_add_to_cart, total_add_to_cart)
p_value_items_z = 2 * (1 - norm.cdf(abs(z_score_items)))  # Two-tailed test

print(f"Z-test for items purchased: z-score = {z_score_items}, p-value = {p_value_items_z}, pooled proportion = {p_pool_items}")

if p_value_items_z < alpha:
    z_test_significant = "The difference in the number of items purchased is statistically significant (Z-test)."
else:
    z_test_significant = "The difference in the number of items purchased is not statistically significant (Z-test)."

print(z_test_significant)

# Exporting to Excel
with pd.ExcelWriter('AB_test_results.xlsx') as writer:
    df.to_excel(writer, sheet_name='Raw Data', index=False)
    metrics.to_excel(writer, sheet_name='Metrics')
    summary_data = {
        'Test': ['T-test Items', 'T-test Spend', 'Z-test Items'],
        'T-statistic': [t_stat_items, t_stat_spend, z_score_items],
        'P-value': [p_val_items, p_val_spend, p_value_items_z],
        'Conclusion': [items_significant, spend_significant, z_test_significant]
    }
    summary_df = pd.DataFrame(summary_data)
    summary_df.to_excel(writer, sheet_name='Summary', index=False)

print("Results have been exported to 'AB_test_results.xlsx'")

```
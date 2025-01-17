# 🍕 Case Study #2 Pizza Runner

<img src="https://github.com/sweety21-coder/8WeekSQLChallenge/blob/main/IMG/Pizza%20Runner.png?raw=true" width=50% height=50%>

## 📚 Table of Contents
- 🛠️ [Problem Statement]
- 🅰➖🅱 [Entity Relationship Diagram]
- 📋 [Case Study Questions]
- 🔑 Solution
  - [Data Cleaning and Transformation](https://github.com/sweety21-coder/8WeekSQLChallenge/blob/main/Case%20Study%20%232%20Pizza%20Runner/Data%20cleaning.sql)
  - [A. Pizza Metrics](https://github.com/sweety21-coder/8WeekSQLChallenge/tree/main/Case%20Study%20%232%20Pizza%20Runner/1.%20Pizza%20Metrics)
  - [B. Runner and Customer Experience](https://github.com/sweety21-coder/8WeekSQLChallenge/tree/main/Case%20Study%20%232%20Pizza%20Runner/2.%20Runner%20and%20Customer%20Experience)
  - [D.Pricing and Ratings](https://github.com/sweety21-coder/8WeekSQLChallenge/tree/main/Case%20Study%20%232%20Pizza%20Runner/4.%20Pricing%20and%20Ratings)
 
***

## 🛠️ Problem Statement
Danny is expanding his new Pizza Empire and at the same time, he wants to Uberize it, so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers. 

## 🅰➖🅱 Entity Relationship Diagram

![image](https://github.com/sweety21-coder/8WeekSQLChallenge/blob/main/IMG/E-R%20Diagram%20Pizza%20Runner.png?raw=true)

## 📋 Case Study Questions

### A. Pizza Metrics

View my solution [here](https://github.com/sweety21-coder/8WeekSQLChallenge/tree/main/Case%20Study%20%232%20Pizza%20Runner/1.%20Pizza%20Metrics).

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

### B. Runner and Customer Experience

View my solution [here](https://github.com/sweety21-coder/8WeekSQLChallenge/tree/main/Case%20Study%20%232%20Pizza%20Runner/2.%20Runner%20and%20Customer%20Experience).

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?


### D. Pricing and Ratings
View my solution [here](https://github.com/sweety21-coder/8WeekSQLChallenge/tree/main/Case%20Study%20%232%20Pizza%20Runner/4.%20Pricing%20and%20Ratings).

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

### E. Bonus Questions
View my solution [here](https://github.com/sweety21-coder/8WeekSQLChallenge/tree/main/Case%20Study%20%232%20Pizza%20Runner/4.%20Pricing%20and%20Ratings).

If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

***


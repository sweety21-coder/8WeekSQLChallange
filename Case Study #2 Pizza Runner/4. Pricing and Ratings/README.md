# [8WeeksSQLChallange](https://github.com/sweety21-coder/8WeekSQLChallange)
# 🍕 Case Study #2 - Pizza Metrics
<p align="center">
<img src= "https://github.com/sweety21-coder/8WeekSQLChallange/blob/main/IMG/Pizza%20Runner.png?raw=true" width=50%,height=50%>

 ## 📋 Case Study's Questions

  1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has 
  Pizza Runner made so far if there are no delivery fees?

 2.What if there was an additional $1 charge for any pizza extras?
  Add cheese is $1 extra.

 3.The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner,
  how would you design an additional table for this new dataset - generate a schema for this new table and insert 
  Your own data for ratings for each successful customer order between 1 to 5.

 4.Using your newly generated table - can you join all of the information together to form a table which has the following information
  for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
--Time between order and pickup
--Delivery duration
--Average speed
--Total number of pizzas

5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
   how much money does Pizza Runner have left over after these deliveries?

### E. Bonus Questions
                
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to 
demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

## 🔑 Solutions
###**Q1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has 
         Pizza Runner made so far if there are no delivery fees?
```Query
select
sum(CASE WHEN c.pizza_id= 1 THEN 12 ELSE 10 END) as Money_earned
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0;
```
**Result**
|MoneyEarned|
|-----------|
| 138       |

**Money Earned by Pizza Runner is 138$**
 

  
  
  
  
  
  
  
  


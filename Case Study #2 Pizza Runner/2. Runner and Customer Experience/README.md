# [8WeeksSQLChallange](https://github.com/sweety21-coder/8WeekSQLChallange)
# 🍕 Case Study #2 - Pizza Metrics
<p align="center">
<img src= "https://github.com/sweety21-coder/8WeekSQLChallange/blob/main/IMG/Pizza%20Runner.png?raw=true" width=50%,height=50%>
  
 ## 📋 Case Study's Questions
  
-- 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
-- 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- 3.Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- 4.What was the average distance travelled for each customer?
-- 5.What was the difference between the longest and shortest delivery times for all orders?
-- 6.What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- 7.What is the successful delivery percentage for each runner?

## 🚀 Solutions

### **Q1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)**
```Query
with CTE
as
(
select runner_id,
CASE
     WHEN registration_date between '2021-01-01' and '2021-01-07' THEN 'week 1'
     WHEN registration_date between '2021-01-08' and '2021-01-14' THEN 'week 2'
     ELSE 'week 3'
     END as [week]
from runners
group by runner_id,registration_date
)
select [week],count(runner_id) as Runner_sign_up
from CTE
group by [week];
```
**Result:** 
  
| Week   | Runner_sign_up |
|--------|----------------|
| Week 1 | 2              |
| Week 2 | 1              |
| Week 3 | 1              |  

 ### **Q2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**
```Query
with CTE
as
(
select c.order_id,runner_id,DATEDIFF(MINUTE,order_time,pickup_time)as time_taken
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0
group by c.order_id,runner_id,order_time,pickup_time
)
select runner_id ,AVG(time_taken)as average_mins_taken_to_arrive_HQ
from CTE
group by runner_id;
```
**Result:**
| runner_id | average_mins_taken_to_arrive_HQ |
|-----------|---------------------------------|
| 1         |    14                           |
| 2         |    20                           |
| 3         |    10                           |

 ### **Q3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**
 ```Query
with prepare_time
as
( 
select c.order_id,COUNT(c.order_id)as Pizza_count,
DATEDIFF(MINUTE,order_time,pickup_time)as Pizza_preparation_time
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance<> 0
group by c.order_id,order_time,pickup_time
)
select pizza_count,AVG(Pizza_preparation_time)as avg_time_to_preapre
from prepare_time
group by Pizza_count;
```
**Result:**

| pizzas_order_count | avg_time_to _prepare|
|--------------------|---------------------|
| 1                  | 12                  |
| 2                  | 18                  |
| 3                  | 30                  |

### **Q4. What was the average distance travelled for each runner?**
```Query
select distinct customer_id,round(AVG(distance),2)as Average_distance
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0
group by customer_id
order by customer_id;
```
**Result:**

| Customer_id | Average_distance  |
|-----------|---------------------|
| 101       | 20                  |
| 102       | 16.73               |
| 103       | 23.4                |
| 104       | 10                  |
| 105       | 25                  |
 
### **Q5. What was the difference between the longest and shortest delivery times for all orders?**
```Query
with time_taken
as
(
select c.order_id,runner_id,DATEDIFF(MINUTE,order_time,pickup_time)as delivery_time
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0
group by c.order_id,runner_id,order_time,pickup_time
)
select (MAX(delivery_time)-MIN(delivery_time))as diff_longest_shortest_delivery_time
from time_taken;
```
**Result**
|diff_longest_shortest_delivery_time|
|-----------------------------------|
| 20                                |

### **Q6. What was the average speed for each runner for each delivery and do you notice any trend for these values?**




  

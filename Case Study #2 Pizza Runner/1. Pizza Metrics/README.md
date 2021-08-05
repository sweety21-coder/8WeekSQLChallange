# [8WeeksSQLChallange](https://github.com/sweety21-coder/8WeekSQLChallange)
# 🍕 Case Study #2 - Pizza Metrics
<p align="center">
<img src= "https://github.com/sweety21-coder/8WeekSQLChallange/blob/main/IMG/Pizza%20Runner.png?raw=true" width=50%,height=50%>
  
 ## 📋 Case Study's Questions
  
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

## 🔑 Solutions
### **Q1. How many pizzas were ordered?**
```Query
select COUNT(order_id)as no_of_Pizza_ordered
from #updated_customer_orders;
```
 **Result:**
  
|no_of_Pizza_ordered|
|-------------------|
|     14            | 
  
total **14 pizzas** were ordered

### **Q2. How many unique customer orders were made?**
 ```Query 
SELECT COUNT(DISTINCT(order_id))as unique_orders
from #updated_customer_orders;
```
**Result:**
|unique_orders|
|-------------|
|10           |
 
**10 UNIQUE customer orders** 

### **Q3.How many successful orders were delivered by each runner?**

```Query
SELECT runner_id,COUNT(order_id) AS successful_orders
FROM #updated_runner_orders
WHERE distance <> 0
group by runner_id
order by runner_id;
```
**Result:**
| runner_id | successful_orders |
|-----------|-------------------|
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |

### **Q4. How many of each type of pizza was delivered?**
```Query
select pizza_name,COUNT(c.pizza_id)as no_of_pizza_delivered
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
join pizza_names pn
on c.pizza_id= pn.pizza_id
where distance<> 0
group by pizza_name;
```
**Result:**
| pizza_name | no_of_pizza_delivered |
|------------|-----------------------|
| Meatlovers | 9                     |
| Vegetarian | 3                     |

 **9 ```Meatlovers```** pizzas were ordered.
 **3 ```Vegetarian```** pizzas were ordered.

### **Q5. How many Vegetarian and Meatlovers were ordered by each customer?**
```Query
select c.customer_id,pizza_name,COUNT(order_id)as no_of_pizza_ordered
from #updated_customer_orders c
join pizza_names p
on c.pizza_id=p.pizza_id
group by customer_id,pizza_name
order by customer_id;
```
--other way 
```QUERY
select customer_id,
SUM(CASE WHEN pizza_id= 1 THEN 1 ELSE 0 END)as meatlover,
SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END)as Vegetarian
from #updated_customer_orders 
group by customer_id; 
```
**Result:**
| customer_id | meat_lovers | vegetarian |
|-------------|-------------|------------|
| 101         | 2           | 1          |
| 103         | 3           | 1          |
| 104         | 3           | 0          |
| 105         | 0           | 1          |
| 102         | 2           | 1          |

- **Customer 101:** **2 meatlovers** and **1 vegetarian**.
- **Customer 102:** **2 meatlovers** and **1 vegetarian**.
- **Customer 103:** **3 meatlovers** and **1 vegetarian**.
- **Customer 104:** **3 meatlovers**.
- **Customer 105:** **1 vegetarian**.

### **Q6. What was the maximum number of pizzas delivered in a single order?**
```Query  
with CTE
as
(
  select c.order_id,count(pizza_id)as count_of_pizza
  from #updated_customer_orders c
  join #updated_runner_orders r
  on c.order_id = r.order_id 
  where distance <> 0
  group by c.order_id
)
select MAX(count_of_pizza)as max_pizza_in_single_order
from CTE; 
```
**Result:**
| max_Pizza_in_single_order|
|--------------------------|
|        3                 |  

maximum number of pizzas delivered in a single order is **3**
  
### **Q7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
```Query
select c.customer_id ,
       sum(CASE
               WHEN exclusions IS not null or extras is not null then 1
               ELSE 0
               END)as change,
       sum(CASE
               WHEN exclusions IS null or extras IS null then 1
               ELSE 0
               END)as no_change
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0
group by c.customer_id
order by c.customer_id;
```
**Result:**
| customer_id | changes | no_change |
|-------------|---------|-----------|
| 101         | 2       | 0         |
| 102         | 3       | 0         |
| 103         | 3       | 0         |
| 104         | 3       | 0         |
| 105         | 1       | 0         | 

### **Q8. How many pizzas were delivered that had both exclusions and extras?**
```Query

select c.order_id,
SUM(CASE WHEN exclusions is not null and extras is not null THEN 1
    ELSE 0 END)as pizza_with_exclusion_and_extras
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0
and exclusions <> ''
and extras <> ''
group by c.order_id;
```
**Result:**
|Order_id| pizza_with_exclusion_and_extras| 
|--------|--------------------------------|
| 10     |        1                       |
  
only 1 pizza order that had both exlcusions and extras


  
  
  
  
  
 

  

  


--Pizza Metrics

-- 1. How many pizzas were ordered?
-- 2. How many unique customer orders were made?
-- 3. How many successful orders were delivered by each runner?
-- 4. How many of each type of pizza was delivered?
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
-- 6. What was the maximum number of pizzas delivered in a single order?
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- 8. How many pizzas were delivered that had both exclusions and extras?
-- 9. What was the total volume of pizzas ordered for each hour of the day?
-- 10. What was the volume of orders for each day of the week?


-- 1.How many pizzas were ordered?
select COUNT(order_id)as no_of_Pizza_ordered
from #updated_customer_orders;


-- 2.How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id))as unique_orders
from #updated_customer_orders;

-- 3.How many successful orders were delivered by each runner?
select COUNT(*)as successful_orders
from #updated_runner_orders
where distance <> 0;


-- 4.How many of each type of pizza was delivered?
select pizza_id,COUNT(c.pizza_id)as no_of_pizza_delivered
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance<> 0
group by pizza_id;

-- 5.How many Vegetarian and Meatlovers were ordered by each customer?
select c.customer_id,pizza_name,COUNT(order_id)as no_of_pizza_ordered
from #updated_customer_orders c
join pizza_names p
on c.pizza_id=p.pizza_id
group by customer_id,pizza_name
order by customer_id;

--other way 

select customer_id,
SUM(CASE WHEN pizza_id= 1 THEN 1 ELSE 0 END)as meatlover,
SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END)as Vegetarian
from #updated_customer_orders 
group by customer_id;

-- 6.What was the maximum number of pizzas delivered in a single order?
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

--7.For each customer, how many delivered pizzas had at least 1 change
-- and how many had no changes?

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

-- 8.How many pizzas were delivered that had both exclusions and extras?

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


-- 9.What was the total volume of pizzas ordered for each hour of the day?

select DATEPART(HOUR,[order_time])as hour_of_the_day, COUNT(order_id)as pizza_ordered
 from #updated_customer_orders
 group by DATEPART(HOUR,[order_time])
 order by hour_of_the_day;
 
 -- 10.What was the volume of orders for each day of the week?

select DATENAME(WEEKDAY,order_time)as day_of_week,COUNT(order_id)as pizza_ordered
from #updated_customer_orders
group by DATENAME(WEEKDAY,order_time)
order by day_of_week;
--B. Runner and Customer Experience

-- 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
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

-- 2.What was the average time in minutes it took for 
--each runner to arrive at the Pizza Runner HQ to pickup the order?
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

-- 3.Is there any relationship between the number of pizzas 
  -- and how long the order takes to prepare?
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

-- 4.What was the average distance travelled for each customer?

select distinct customer_id,AVG(distance)as Average_distance
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0
group by customer_id
order by customer_id;

-- 5.What was the difference between the longest and shortest delivery times for all orders?
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

-- 6.What was the average speed for each runner for each delivery and 
--do you notice any trend for these values?

select c.order_id, runner_id,count(c.order_id)as pizza_count,(distance*1000)as distance_meter,
(duration*60)as time_sec,round((distance*1000)/(duration*60),2)as avg_speed
from #updated_customer_orders c
 join #updated_runner_orders r
 on c.order_id=r.order_id
 where distance <> 0
 group by runner_id,duration,distance,c.order_id
 order by avg_speed desc;
 
 --Finding:
--Orders shown in decreasing order of average speed:
--While the fastest order only carried 1 pizza and the slowest order carried 3 pizzas, 
--there is no clear trend that more pizzas slow down the delivery speed of an order.


-- 7.What is the successful delivery percentage for each runner?

With CTE 
as
(
select runner_id,count(order_id)as total_delivery,
SUM(CASE
    WHEN distance <> 0 THEN 1 
    ELSE distance
    END) as successful_delivery,
SUM(CASE
    WHEN cancellation like '%cancel%' THEN 1
    ELSE cancellation
    END) as failed_delivery
from #updated_runner_orders 
 group by runner_id
)
select runner_id,(SUM(successful_delivery)/SUM(total_delivery)*100)as delivery_percent
from CTE
group by runner_id;

--D. Pricing and Ratings
                              
-- 1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has 
--Pizza Runner made so far if there are no delivery fees?

-- 2.What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra.

-- 3.The Pizza Runner team now wants to add an additional ratings system that allows customers
-- to rate their runner, how would you design an additional table for 
--this new dataset - generate a schema for this new table and insert 
--your own data for ratings for each successful customer order between 1 to 5.

-- 4.Using your newly generated table - can you join all of the information together
-- to form a table which has the following information for successful deliveries?
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




-- 1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has 
--Pizza Runner made so far if there are no delivery fees?
select
sum(CASE WHEN c.pizza_id= 1 THEN 12 ELSE 10 END) as Money_earned
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0;


-- 2.What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra.
select
SUM(CASE WHEN pizza_id= 1 THEN 12 ELSE 10 END)+
SUM(CASE WHEN extras is not null or extras <> '' THEN 1 ELSE 0 END) as Total_earned
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0;


-- 3.The Pizza Runner team now wants to add an additional ratings system that allows customers
-- to rate their runner, how would you design an additional table for 
--this new dataset - generate a schema for this new table and insert 
--your own data for ratings for each successful customer order between 1 to 5.


use pizza_runner;
create table Ratings(
Customer_id Integer,
Order_id Integer,
Runner_id integer,
Rating integer)
Insert into Ratings values
(101,1,1,5),
(101,2,1,5),
(102,3,1,4),
(103,4,2,4),
(104,5,3,3),
(105,7,2,5),
(102,8,2,4),
(104,10,1,4);

select * from Ratings;

-- 4.Using your newly generated table - can you join all of the information together
-- to form a table which has the following information for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
--Time between order and pickup
--Delivery duration
--Average speed

select c.customer_id,c.order_id,ro.runner_id,Rating,order_time,
pickup_time ,DATEDIFF(MINUTE,order_time,pickup_time)as time_between_order_and_pickup,duration,
ROUND(avg((convert(float,distance) / convert(float,duration))*60),2) AS average_speed,COUNT(*)as Pizza_count
from #updated_customer_orders c
join #updated_runner_orders ro
on c.order_id=ro.order_id
join Ratings r
on c.order_id= r.Order_id
where distance <> 0
group by c.customer_id,c.order_id,ro.runner_id,Rating,order_time,
pickup_time,duration
order by order_id;

-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras 
--and each runner is paid $0.30 per kilometre traveled - 
--how much money does Pizza Runner have left over after these deliveries?

with cte
as
(
select runner_id,
SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END)-
SUM(CASE WHEN distance <> 0 THEN (distance * 0.30) ELSE 0 END)as Money_earned
from #updated_customer_orders c
join #updated_runner_orders r
on c.order_id=r.order_id
where distance <> 0
group by runner_id
)
select SUM(money_earned)as profit
from cte;

                          --E. Bonus Questions
                           
--If Danny wants to expand his range of pizzas - 
--how would this impact the existing data design? Write an INSERT statement to 
--demonstrate what would happen if a new Supreme pizza with all the toppings
-- was added to the Pizza Runner menu?

Insert into pizza_names values
(3,'Supreme_pizza');

insert pizza_recipes values
(3,'1,2,3,4,5,6,7,8,9,10,11,12');

select * from pizza_names
select * from pizza_recipes;






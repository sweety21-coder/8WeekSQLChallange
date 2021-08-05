--data cleaning and transformation

--TABLE: customer_orders

--Clean up exclusions and extras from customer_orders 

--Cleaning customer_orders
--- 1. Identify records with null or 'null' values
--- 2.updating null or 'null' values to ''
--- 3.blanks '' are not null because it indicates the 
--customer asked for no extras or exclusions.
--4.Blanks indicate that the customer requested no extras/exclusions 
--for the pizza, whereas null values would be ambiguous on this.

use pizza_runner;

SELECT order_id, customer_id, pizza_id,
CASE 
      WHEN exclusions IS NULL OR exclusions LIKE 'null' THEN ''
      ELSE exclusions 
    END AS exclusions,
    CASE 
      WHEN extras IS NULL OR extras LIKE 'null' THEN ''
      ELSE extras 
    END AS extras,
    order_time
INTO #updated_customer_orders
FROM customer_orders;

select * from #updated_customer_orders;

--TABLE: runner_orders
select * from runner_orders;

--Check data type
exec sp_help runner_orders;

--pickup_time - remove nulls and replace with ' '
--distance - remove km and nulls
--duration - remove minutes and nulls
--cancellation - remove NULL and null and replace with ' ' 


SELECT order_id,runner_id,
CASE 
    WHEN pickup_time is null or pickup_time like 'null' THEN ''
    ELSE pickup_time
    END AS pickup_time,
CASE
    WHEN distance is null or distance like 'null' THEN ''
    WHEN distance like '%km' THEN REPLACE(distance,'km','')
    ELSE distance
    END AS distance,
CASE
   WHEN duration is null or duration like 'null' THEN ' '
   WHEN duration like '%minutes' THEN REPLACE(duration,'minutes','')
   WHEN duration like '%mins' THEN REPLACE(duration,'mins',' ')
   WHEN duration like '%minute' THEN REPLACE(duration,'minute','')
   ELSE duration
   END AS duration,
CASE
    WHEN cancellation is null or cancellation like 'null' THEN ''
    ELSE cancellation
    END AS cancellation

INTO #updated_runner_orders
FROM runner_orders;

--change the required data type of runner_orders

ALTER TABLE #updated_runner_orders
ALTER COLUMN pickup_time DATETIME

ALTER TABLE #updated_runner_orders
ALTER COLUMN distance FLOAT

ALTER TABLE #updated_runner_orders
ALTER COLUMN duration INT;

--check the data type

exec sp_help pizza_names;

--change data type names in all 3 pizza tables

Alter TABLE pizza_names
ALTER COLUMN pizza_name varchar(50);

Alter TABLE pizza_recipes
ALTER COLUMN toppings varchar(50);

Alter TABLE pizza_toppings
ALTER COLUMN topping_name varchar(50);















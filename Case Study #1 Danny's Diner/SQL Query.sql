
--1. What is the total amount each customer spent at the restaurant?
 
 select s.customer_id,sum(m.price)as total_amount_spent
 from sales s
 join menu m on
 s.product_id= m.product_id
 group by customer_id;
 
 --2.How many days has each customer visited the restaurant?
select customer_id,COUNT(distinct order_date)as num_of_visit
from sales
group by customer_id;

--3. What was the first item from the menu purchased by each customer?

with first_item
as
(
    select customer_id,product_name,
    Dense_Rank() over (partition by customer_id order by order_date) as first_occurence
    from sales
    join menu
    on sales.product_id= menu.product_id
    
 )
 select distinct customer_id,product_name
 from first_item
 where first_occurence= 1;
 
--4. What is the most purchased item on the menu and
-- how many times was it purchased by all customers?

SELECT top(1)m.product_name, COUNT(1) as purchased_count
FROM sales s
JOIN menu m
ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY COUNT(1) DESC;


--5. Which item was the most popular for each customer?

WITH CTE
AS
(
SELECT customer_id, product_id, COUNT(product_id) AS count_of_product,
RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(product_id) DESC) AS ranking
FROM sales
GROUP BY customer_id, product_id
)
SELECT customer_id, product_name, count_of_product
FROM CTE c
	JOIN menu m
		ON c.product_id=m.product_id
WHERE ranking=1;


--6. Which item was purchased first by the customer after they became a member?

with CTE
as
(
   select s.customer_id,s.order_date,m.product_name,
   RANK()over(PARTITION by s.customer_id order by order_date) as ranking
   from sales s
   join menu m
   on s.product_id=m.product_id
   join members me
   on s.customer_id=me.customer_id
   where s.order_date>= me.join_date
 )
 select customer_id,product_name
 from CTE
 where ranking=1;
 
 
 --7. Which item was purchased just before the customer became a member?
with CTE
as
(
  select s.customer_id,s.order_date,m.product_name,
  RANK()over(partition by s.customer_id order by order_date desc )as ranking
  from sales s
  join menu m
  on s.product_id=m.product_id
  join members me 
  on s.customer_id=me.customer_id
  where order_date<join_date
 )
 select customer_id,product_name
 from CTE
 where ranking=1;
 
 --8. What is the total items and amount spent for each member before they became a member?

select s.customer_id,count(m.product_id)as total_item,sum(m.price)as amount_spent
from sales s
join menu m
on s.product_id=m.product_id
join members me
on s.customer_id=me.customer_id
where order_date<join_date
group by s.customer_id;
 
 --9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
 --how many points would each customer have?
 
 select customer_id,
 sum(price*(case when product_name='sushi' then 20 else 10 end)) as total_points
 from sales 
 join menu m
 on sales.product_id=m.product_id
  group by customer_id;
  
  SELECT s.customer_id, SUM(price*(CASE WHEN m.product_name='sushi' THEN 20 ELSE 10 END)) AS total_points
FROM sales s
	JOIN menu m
		ON s.product_id=m.product_id
GROUP BY s.customer_id


 --10. In the first week after a customer joins the program (including their join date)
 --they earn 2x points on all items, not just sushi -
 --how many points do customer A and B have at the end of January?
 
select s.customer_id,
SUM(price*(case when order_date<join_date and product_name <> 'sushi'then 10
when order_date< join_date and product_name='sushi'then 20
when order_date>= join_date then 20 else 10 end))as total_points
from sales s
join menu
on s.product_id=menu.product_id
join members m 
on s.customer_id=m.customer_id
where order_date<= '2021-01-31'
group by s.customer_id;


--11. Bonus Questions

--Join All The Things
--The following questions are related creating basic data tables that Danny and
--his team can use to quickly derive insights without needing to join 
--the underlying tables using SQL.

--Recreate the following table output using the available data:

                    
--customer_id	 order_date	 product_name   price member ranking
--   A	     2021-01-01	    curry	     15	   N	  null
--   A	     2021-01-01	    sushi	     10	   N	  null
--   A	     2021-01-07	    curry	     15	   Y	   1
--   A	     2021-01-10	    ramen	     12	   Y	   2
--   A	     2021-01-11	    ramen	     12	   Y	   3
--   A	     2021-01-11	    ramen	     12	   Y	   3
--   B	     2021-01-01	    curry	     15	   N	  null
--   B	     2021-01-02	    curry	     15    N	  null
--   B	     2021-01-04	    sushi	     10	   N	  null
--   B	     2021-01-11	    sushi	     10	   Y	   1
--   B	     2021-01-16	    ramen	     12	   Y	   2
--   B	     2021-02-01	    ramen	     12	   Y	   3
--   C	     2021-01-01	    ramen	     12	   N	 null
--   C	     2021-01-01	    ramen	     12	   N	 null
--   C	     2021-01-07	    ramen	     12	   N	 null
   
   
 select s.customer_id,order_date,product_name,price,
 CASE WHEN order_date>=join_date THEN 'Y'
      WHEN order_date < join_date THEN 'N' 
      ELSE 'N' END as members
 from sales s
 join menu m
 on s.product_id=m.product_id
 left join members me
 on s.customer_id=me.customer_id
 order by customer_id,order_date;
 
 --12. Rank All The Things
 
--Danny also requires further information about the ranking of customer products, 
--but he purposely does not need the ranking for non-member purchases so he expects 
--null ranking values for the records when customers are not yet part of the loyalty program.

 with Ranks as
 (
   select s.customer_id,order_date,product_name,price,
   CASE WHEN order_date>=join_date THEN 'Y'
      WHEN order_date < join_date THEN 'N' 
      ELSE 'N' END as members
 from sales s
 join menu m
 on s.product_id=m.product_id
 left join members me
 on s.customer_id=me.customer_id
 )
 select *,
 CASE WHEN members ='Y' THEN RANK()over(partition by customer_id,members order by order_date)
 ELSE null END as Ranking
 from Ranks
 order by customer_id,order_date;
 









 
 
  
 
 



 
 
 










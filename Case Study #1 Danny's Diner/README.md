#[8WeeksSQLChallange](https://github.com/sweety21-coder/8WeekSQLChallange)

# 🍜 Case Study #1 - Danny's Diner 
<p align="center">
<img src= "https://github.com/sweety21-coder/8WeekSQLChallange/blob/main/IMG/Danny's%20Diner.png?raw=true" width=50% height=50%>
	
 ## 📕 Table Of Contents
* 🛠️ [Problem Statement](#problem-statement)
* 📁 [Dataset](#dataset)
* 📋 [Case Study Questions](#case-study-questions)
* 🔑 [Solutions](#solutions)
 
 ## 🛠️ Problem Statement 

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.
 <br /> 

---
## 📂 Dataset
Danny has shared 3 key datasets for this case study:
 
 * ### **```sales```**
 
The sales table captures all ```customer_id``` level purchases with an corresponding ```order_date``` and ```product_id``` information for when and what menu items were ordered.
 
|customer_id|order_date|product_id|
|-----------|----------|----------|
|A          |2021-01-01|1         |
|A          |2021-01-01|2         |
|A          |2021-01-07|2         |
|A          |2021-01-10|3         |
|A          |2021-01-11|3         |
|A          |2021-01-11|3         |
|B          |2021-01-01|2         |
|B          |2021-01-02|2         |
|B          |2021-01-04|1         |
|B          |2021-01-11|1         |
|B          |2021-01-16|3         |
|B          |2021-02-01|3         |
|C          |2021-01-01|3         |
|C          |2021-01-01|3         |
|C          |2021-01-07|3         |
 <br /> 

* ### **```menu```**
The menu table maps the ```product_id``` to the actual ```product_name``` and ```price``` of each menu item.

|product_id |product_name|price     |
|-----------|------------|----------|
|1          |sushi       |10        |
|2          |curry       |15        |
|3          |ramen       |12        |
 <br /> 

* ### **```members```**
The final members table captures the ```join_date``` when a ```customer_id``` joined the beta version of the Danny’s Diner loyalty program.
 
|customer_id|join_date |
|-----------|----------|
|A          |1/7/2021  |
|B          |1/9/2021  |

 <br /> 
 
 ## 📋 Case Study Questions
<p align="center">
 
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
 <br /> 
 
 ## 🔑 Solutions
### **Q1. What is the total amount each customer spent at the restaurant?**
```Query
 
 select s.customer_id,sum(m.price)as total_amount_spent
 from sales s
 join menu m on
 s.product_id= m.product_id
 group by customer_id;
 ```
 
 **Result:**
| customer_id  | total_amount_spent |
| -------------|--------------------|
| A            | 76                 |
| B            | 74                 |
| C            | 36                 |

> * **Customer A** spent **$76**
> * **Customer B** spent **$74**
> * **Customer C** spent **$36**
---
### **Q2. How many days has each customer visited the restaurant?**
 
 ```Query
 
select customer_id,COUNT(distinct order_date)as num_of_visit
from sales
group by customer_id;
```

 **Result:**
|customer_id|Num_of_visit|
|-----------|------------|
|A          |4           |
|B          |6           |
|C          |2           |

> * **Customer A** has visited **4 days**
> * **Customer B** has visited **6 days**
> * **Customer C** has visited **2 days**

### **Q3. What was the first item from the menu purchased by each customer?**

```Query
 with first_item
as
(
    select customer_id,product_name,
    Rank() over (partition by customer_id order by order_date) as first_occurence
    from sales
    join menu
    on sales.product_id= menu.product_id
    
 )
 select distinct customer_id,product_name
 from first_item
 where first_occurence= 1;
 ```
 **Result:**
| customer_id | product_name | 
| ----------- | ------------ | 
| A           | sushi        |
| B           | curry        |
| C           | ramen        |
 > First item purchased by:
> * **Customer A** is **sushi**
> * **Customer B** is **curry**
> * **Customer C** is **ramen**

### **Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

```Query
SELECT top(1)m.product_name, COUNT(1) as purchased_count
FROM sales s
JOIN menu m
ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY COUNT(1) DESC;
```
 **Result:**
|product_name|Purchased_count|
|------------|---------------|
|ramen       |8              |
 
Most purchased item was **ramen**, which was ordered **8 times**

 ### **Q5. Which item was the most popular for each customer?**
 ```Query
 
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
 ```
 **Result:**
| customer_id | product_name | Count_of_product|
| ----------- | ------------ | --------------- | 
| A           | ramen        | 3               | 
| B           | ramen        | 2               | 
| B           | curry        | 2               | 
| B           | sushi        | 2               | 
| C           | ramen        | 3               | 
 
> Most popular item for:
> * **Customer A** was **Ramen** 
> * **Customer B** ordered **all three menu items equally**
> * **Customer C** was **ramen**

### **Q6. Which item was purchased first by the customer after they became a member?**
 
```Query

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
```
**Result:**
| customer_id | product_name | 
| ----------- | ------------ | 
| A           | curry        | 
| B           | sushi        | 

> First product ordered after becoming a member:
> * **Customer A** is **curry** 
> * **Customer B** is **sushi**
> 
> (*Customer C is not included in the list cos C didn't join the membership program*)

	
### **Q7. Which item was purchased just before the customer became a member?**
```Query
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
 ```
**Result:**
| customer_id | product_name |
| ----------- | ------------ |
| A           | sushi        | 
| A           | curry        |
| B           | sushi        |

> Last item purchased before becoming a member:
> * **Customer A** has ordered **Sushi/Curry**
> * **Customer B** was **sushi**

### **Q8. What is the total items and amount spent for each member before they became a member?**
```Query
with CTE
as
(
  select s.customer_id,s.product_id as product,sum(price) as amount_spent
  from sales s
  join menu m
  on s.product_id=m.product_id
  join members me
  on s.customer_id=me.customer_id
  where order_date<join_date
  group by s.customer_id,s.product_id
 )
 select customer_id,COUNT(cte.product) as total_items ,sum(cte.amount_spent)as total_spent
 from CTE
 group by customer_id;
```
**Result:**
| customer_id | total_items |total_spent   |
| ----------- |-------------|--------------|
| A           |2            |   25         |
| B           |3            |   40         |

> * **Customer A** spent **$25** on **2 items** before becoming member
> * **Customer B** spent **$40** on **3 items** before becoming member
	
			     

### **Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**
```Query
 select customer_id,sum(price*(case when product_name='sushi' then 20 else 10 end)) as total_points
 from sales 
 join menu m
 on sales.product_id=m.product_id
  group by customer_id;
```
**Result:**
| customer_id | total_points |
| ----------- | ------------ |
| A           | 860          |
| B           | 940          |
| C           | 360          |

 * **Customer A** has **860 pts**
* **Customer  B** has **940 pts**
* **Customer C** has **360  pts**

			     
### **Q10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**
```Query
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
```
**Result:**
| customer_id | total_points |
| ----------- | ------------ |
| A           | 1370         |
| B           |	940	     |
<br />		       
		       
## Bonus Questions
	
### **Q11. Join All The Things. The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.**

**Recreate the following table output using the available data:**


| customer_id | order_date       | product_name | price | member |
| ----------- | -----------------| ------------ | ----- | ------ |
| A           | 2021-01-01       | sushi        | 10    | N      |
| A           | 2021-01-01       | curry        | 15    | N      |
| A           | 2021-01-07       | curry        | 15    | Y      |
| A           | 2021-01-10       | ramen        | 12    | Y      |
| A           | 2021-01-11       | ramen        | 12    | Y      |
| A           | 2021-01-11       | ramen        | 12    | Y      |
| B           | 2021-01-01       | curry        | 15    | N      |
| B           | 2021-01-02       | curry        | 15    | N      |
| B           | 2021-01-04       | sushi        | 10    | N      |
| B           | 2021-01-11       | sushi        | 10    | Y      |
| B           | 2021-01-16       | ramen        | 12    | Y      |
| B           | 2021-02-01       | ramen        | 12    | Y      |
| C           | 2021-01-01       | ramen        | 12    | N      |
| C           | 2021-01-01       | ramen        | 12    | N      |
| C           | 2021-01-07       | ramen        | 12    | N      |
	
```Query
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
```

### **Q12. Rank All The Things. Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.**

**Recreate the following table output using the available data:**

| customer_id | order_date       | product_name | price | member | ranking |
| ----------- | ---------------- | ------------ | ----- | ------ | ------- |
| A           | 2021-01-01       | sushi        | 10    | N      |         |
| A           | 2021-01-01       | curry        | 15    | N      |         |
| A           | 2021-01-07       | curry        | 15    | Y      | 1       |
| A           | 2021-01-10       | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11       | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11       | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01       | curry        | 15    | N      |         |
| B           | 2021-01-02       | curry        | 15    | N      |         |
| B           | 2021-01-04       | sushi        | 10    | N      |         |
| B           | 2021-01-11       | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16       | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01       | ramen        | 12    | Y      | 3       |
| C           | 2021-01-01       | ramen        | 12    | N      |         |
| C           | 2021-01-01       | ramen        | 12    | N      |         |
| C           | 2021-01-07       | ramen        | 12    | N      |         |

```Query
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
 ```
<br />
				 
		      



 
 
 
 
 

create database pizzahut;
use pizzahut;

#Basic:

#Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_orders
FROM orders;
    
#Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;

#Identify the highest-priced pizza.
select pizza_types.name, pizzas.price from pizza_types join pizzas using (pizza_type_id) order by pizzas.price desc limit 1;

#Identify the most common pizza size ordered.
select pizzas.size,count(order_details.order_details_id) as order_count
from pizzas 
join order_details using(pizza_id)
group by pizzas.size
order by order_count
limit 1; 


#List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,
sum(order_details.quantity) as qty
from pizza_types
join pizzas using (pizza_type_id)
join order_details using(pizza_id)
# on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by qty desc
limit 5;


#Intermediate:
#Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category,
sum(order_details.quantity) as qty
from pizza_types
join pizzas using (pizza_type_id)
join order_details using (pizza_id)
#on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by qty desc;


#Determine the distribution of orders by hour of the day.
select hour(order_time) as hour,count(order_id) as order_count
from orders
group by hour(order_time);


#Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name)
from pizza_types
group by category	;


#Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(qty),0) as avg_per_hr from 

(select orders.order_date,sum(order_details.quantity) as qty
from orders
join order_details using(order_id)
group by orders.order_date) as order_qty ;

#Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types
join pizzas using (pizza_type_id)
join order_details using (pizza_id)
group by pizza_types.name
order by revenue desc
limit 3;


#Advanced:
#Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category, 
round(sum(order_details.quantity*pizzas.price) / (SELECT ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id)*100,2) as revenue
from pizza_types 
join pizzas using (pizza_type_id)
join order_details using (pizza_id)
group by pizza_types.category 
order by revenue desc;


#Analyze the cumulative revenue generated over time.
select order_date, 
sum(revenue) over (order by order_date) as cum_rev from  
(select orders.order_date, 
round(sum(order_details.quantity*pizzas.price),2) as revenue
from pizzas 
join order_details using (pizza_id)
join orders using (order_id)
group by orders.order_date) as sales;


#Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name,revenue from 
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
round(sum((order_details.quantity) * pizzas.price),2) as revenue
from pizza_types 
join pizzas using(pizza_type_id)
join order_details using (pizza_id)
group by pizza_types.category, pizza_types.name) as a) as b
where rn <= 3;




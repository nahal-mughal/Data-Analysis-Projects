-- 1.Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id)
FROM
    orders;


-- 2.Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(pizzas.price * order_details.quantity),
            2)
FROM
    pizzas
        INNER JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id;


-- 3.Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- 4.Identify the most common pizza size ordered.

SELECT 
    pizzas.size, SUM(order_details.quantity) AS total_qt
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY total_qt DESC
LIMIT 1;


-- 5.List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS sum_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY sum_quantity DESC
LIMIT 5;


-- Join the necessary tables to find the total quantity of 
-- each pizza category ordered.

SELECT 
    pizza_types.category AS catgry,
    SUM(order_details.quantity) AS quant
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY catgry
ORDER BY quant DESC;


-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hrs, COUNT(order_id)
FROM
    orders
GROUP BY hrs;


-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- Group the orders by date and calculate the 
-- average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quant), 0) AS average_orders
FROM
    (SELECT 
        orders.order_date AS dat,
            SUM(order_details.quantity) AS quant
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY dat) AS totl_quant;
    
    
-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name AS pname,
    ROUND(SUM(pizzas.price * order_details.quantity),
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pname
ORDER BY revenue DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category AS ptypes,
    ROUND(SUM(pizzas.price * order_details.quantity) / (SELECT 
                    SUM(pizzas.price * order_details.quantity)
                FROM
                    pizzas
                        JOIN
                    order_details ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS revenue_percentage
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY ptypes;


-- Analyze the cumulative revenue generated over time.

select dat, 
sum(rev) over(order by dat) as cumultative_rev
from
(select orders.order_date as dat, 
round(sum(pizzas.price * order_details. quantity),2) as rev
from orders 
join order_details
on orders.order_id = order_details.order_id
join pizzas
on order_details.pizza_id = pizzas.pizza_id
group by dat) as revenue;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name, category, revenue
from
(
select name, category, revenue,
rank() over(partition by category order by revenue desc) as ranks
from
(
select pizza_types.name, pizza_types.category,
round(sum(pizzas.price * order_details. quantity),2) as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name, pizza_types.category
) 
as alpha)
as beta
where ranks<=3;





















create database pizzaDB;

use pizzaDB;

create table pizzatype(
	pizza_type_id varchar(50) primary key not null,
    pizza_name varchar(50),
    pizza_category varchar(50),
    pizza_ingredients varchar(200)
);

create table pizzatb(
	pizza_id varchar(50) primary key not null,
    pizza_size char,
    pizza_price float,
    pizza_type_id varchar(50),
    foreign key (pizza_type_id) references pizzatype(pizza_type_id)
);

create table orders(
	order_id int primary key not null,
    order_date date,
    order_time time
);

create table order_details(
	order_details_id int primary key not null,
    quantity int,
    order_id int,
    pizza_id varchar(50),
    foreign key (order_id) references orders(order_id),
    foreign key (pizza_id) references pizzatb(pizza_id)
);

-- Q1 Retrieve the total number of orders placed.
select count(order_id) from orders;


-- Q2 Calculate the total revenue generated from pizza sales.
select 
	round(sum(od.quantity * pt.pizza_price), 2) as 'TotalRevenue'
from order_details od
join pizzatb pt on od.pizza_id = pt.pizza_id;


-- Q3 Identify the highest-priced pizza.
select
	ptb.pizza_id, ptb.pizza_type_id, ptb.pizza_size, ptb.pizza_price, pt.pizza_name
from pizzatype pt
join pizzatb ptb on pt.pizza_type_id = ptb.pizza_type_id
order by ptb.pizza_price desc
limit 1;	


-- Q4 Identify the most common pizza size ordered.
select 
	pt.pizza_size, count(od.order_details_id) as 'OrderCount'
from order_details od
join pizzatb pt on od.pizza_id = pt.pizza_id
group by pt.pizza_size
order by OrderCount desc;


-- Q5 List the top 5 most ordered pizza types along with their quantities.
select
	pt.pizza_name, sum(od.quantity) as 'OrderQuantity'
from order_details od
join pizzatb ptb on od.pizza_id = ptb.pizza_id
join pizzatype pt on ptb.pizza_type_id = pt.pizza_type_id
group by pt.pizza_name
order by OrderQuantity desc
limit 5;


-- Q6 Find the total quantity of each pizza category ordered.
select
	pt.pizza_category, sum(od.quantity) as 'TotalQuantity'
from pizzatype pt
join pizzatb ptb on pt.pizza_type_id = ptb.pizza_type_id
join order_details od on ptb.pizza_id = od.pizza_id
group by pt.pizza_category
order by TotalQuantity desc; 


-- Q7 Determine the distribution of orders by hour of the day.
select
	hour(order_time) as 'Hour',
    count(order_id) as 'Orders'
from orders
group by Hour
order by Orders desc;


-- Q8 Find the category-wise distribution of pizzatb.
select pizza_category, count(pizza_type_id) as 'Count'
from pizzatype
group by pizza_category;

-- Q9 Group the orders by date and calculate the average number of pizzatb ordered per day.
select avg(OrderQuantity) as 'Average pizza ordered per day'
from
	(select
		ord.order_date, sum(od.quantity) as 'OrderQuantity'
	from orders ord
	join order_details od on ord.order_id = od.order_id
	group by ord.order_date) as pizza_ordered_per_day;
    

-- Q10 Determine the top 3 most ordered pizza types based on revenue.
select
	pt.pizza_name, sum(ptb.pizza_price * od.quantity) as 'Revenue'
from order_details od
join pizzatb ptb on od.pizza_id = ptb.pizza_id
join pizzatype pt on ptb.pizza_type_id = pt.pizza_type_id
group by pt.pizza_name
order by Revenue desc
limit 3;


-- Q11 Calculate the percentage contribution of each pizza category to total revenue.
select 
	pt.pizza_category,
    concat(round((sum(od.quantity * ptb.pizza_price) / 
													(select 
														round(sum(od.quantity * ptb.pizza_price), 2) as 'TotalRevenue'
													from order_details od
													join pizzatb ptb on od.pizza_id = ptb.pizza_id)) *100, 2), '%') as 'Percentage Contribution'
from order_details od
join pizzatb ptb on od.pizza_id = ptb.pizza_id
join pizzatype pt on ptb.pizza_type_id = pt.pizza_type_id
group by pt.pizza_category;



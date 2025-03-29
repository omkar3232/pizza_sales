![PIZZA SALES ANALYSIS](https://github.com/omkar3232/pizza_sales/blob/main/download.png)
## Upload these csv files via Table import data wizard in mysql.

# if facing issue importing data for orders and order_details, create table schema below and import data.
+ create table orders(
+ order_id int not null,
+ order_date date not null,
+ order_time time not null,
+ primary key(order_id) );
 
+ create table orders_details(
+ order_details_id int not null,
+ order__id int not null,
+ pizza_id text not null,
+ primary key(order_details);

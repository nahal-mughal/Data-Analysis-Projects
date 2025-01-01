create database papajohns;

create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
)
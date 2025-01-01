-- --------------------------------Data Wrangling-----------------------------------


Create database WalmartSales;

CREATE TABLE salesdata (
    invoice_id VARCHAR(30) NOT NULL,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(10 , 2 ) NOT NULL,
    s_date DATE NOT NULL,
    s_time TIME NOT NULL,
    payment_method VARCHAR(30) not null,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_percentage FLOAT(11 , 9 ) NOT NULL,
    gross_income DECIMAL(10 , 2 ) NOT NULL,
    rating FLOAT(2 , 1 ) NOT NULL
);

select * from salesdata;

-- ----------------------Feature Engineering-----------------------------------------------

-- time of day

alter table salesdata
add column time_of_day varchar(10) not null;

update salesdata
set time_of_day=(
Case
	when s_time between '03:00:00' and '12:00:00' then 'Morning'
    when s_time between '12:01:00' and '17:00:00' then 'Afternoon'
    else 'Evening'
end
);

-- name of month

alter table salesdata
add column month_name varchar(15) not null;

update salesdata
set month_name= monthname(s_date);

-- name of day

alter table salesdata
add column day_name varchar(10) not null;

update salesdata
set day_name=dayname(s_date);

select * from salesdata;


-- --------------------------------Business Questions To Answer----------------------------

										-- Generic --
                                        
-- How many unique cities does the data have?

select distinct city from salesdata;

-- In which city is each branch?

select distinct branch, city from salesdata;


										-- product --
                                        
                                        
-- How many unique product lines does the data have?

select distinct product_line from salesdata;

-- What is the most common payment method?

select count(quantity) as qt, payment_method 
from salesdata
group by payment_method order by qt desc;

-- What is the most selling product line?

select product_line, count(gross_income) as gross
from salesdata
group by product_line order by gross desc;

-- What is the total revenue by month?

select month_name, sum(total)  as revenue 
from salesdata
group by month_name order by sum(total) desc;

-- What month had the largest COGS?

select month_name, sum(cogs) high_cogs
from salesdata
group by month_name order by high_cogs desc;

-- What product line had the largest revenue?

select product_line, sum(total) as revenue 
from salesdata
group by product_line order by revenue desc;

-- What is the city with the largest revenue?

select city, sum(total) as revenue
from salesdata
group by city order by revenue desc;

-- What product line had the largest VAT?

select product_line, sum(VAT) as totlVAT
from salesdata
group by product_line order by totlVAT desc;

-- Fetch each product line and add a column to those product line showing 
-- "Good", "Bad". Good if its greater than average sales
 
 select * from salesdata;
 
select product_line,
(Case
	when avg(quantity) > 6 then 'Good'
    else 'Bad'
end) as ranks
from salesdata group by product_line;

-- Which branch sold more products than average product sold?

select branch, sum(quantity) as sum_qt
from salesdata group by branch
Having sum_qt>(select avg(quantity) from salesdata);

-- What is the most common product line by gender?

select gender, count(gender) as cnt, product_line
from salesdata
group by gender, product_line
order by cnt desc;

-- What is the average rating of each product line

select product_line, round(avg(rating),2) 
from salesdata
group by product_line;


										-- Sales --
                                        
-- Number of sales made in each time of the day per weekday

select time_of_day, count(*) 
from salesdata
where day_name='sunday'
group by time_of_day;

-- Which of the customer types brings the most revenue?

select customer_type, sum(total) as revenue 
from salesdata
group by customer_type;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, round(sum(VAT),2) as LVAT
from salesdata group by city
order by LVAT desc;

-- Which customer type pays the most in VAT?

select customer_type, round(sum(VAT),2) as LVAT
from salesdata
group by customer_type;


										-- Customer --
                                        
-- How many unique customer types does the data have?

select distinct customer_type from salesdata;

-- How many unique payment methods does the data have?

select distinct payment_method from salesdata;

-- What is the most common customer type?

select customer_type, count(*) 
from salesdata  group by customer_type;

-- Which customer type buys the most?

select customer_type, sum(total) as revenue 
from salesdata group by customer_type;

-- What is the gender of most of the customers?

select gender, count(*)
from salesdata group by gender order by count(*) desc;

-- What is the gender distribution per branch?

select gender, count(*) as per_branch
from salesdata
where branch= 'A'
group by gender order by per_branch desc;

-- Which time of the day do customers give most ratings?

select time_of_day, round(avg(rating),1) as most_rating 
from salesdata group by time_of_day
order by most_rating  desc;

-- Which time of the day do customers give most ratings per branch?

select time_of_day, round(avg(rating),2) as most_rating 
from salesdata 
where branch='B'
group by time_of_day
order by most_rating  desc;

-- Which day of the week has the best avg ratings?

select day_name, round(avg(rating),1)  as avg_rat
from salesdata
group by day_name
order by avg_rat desc;

-- Which day of the week has the best average ratings per branch?

select day_name, round(avg(rating),1)  as avg_rat
from salesdata
where branch='C'
group by day_name
order by avg_rat desc;


									-- END --























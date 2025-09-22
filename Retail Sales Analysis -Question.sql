-- SQL Retail Sales Analysis - P1
CREATE schema sql_project_p2;
use sql_project_p2;
select * from retail_sales;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity INT,
                price_per_unit FLOAT,	
                cogs FLOAT,
                total_sale FLOAT
            );


SELECT * FROM retail_sales	
LIMIT 10;

SELECT 
    COUNT(*) 
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;



SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
       SELECT * FROM retail_sales 
       where sale_date = "05-11-2022";
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
	   SELECT * FROM retail_sales
	   WHERE category = 'clothing'
       AND quantiy > 10
	   AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
   
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
      select category,
      ROUND(SUM(total_sale))as total_sales
      from retail_sales
      group by category;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
	select AVG(age) as average_age
    from retail_sales
    where category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * FROM retail_sales
where total_sale > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender, category, COUNT(ï»¿transactions_id) as total_transaction
FROM retail_sales
GROUP BY gender, category; 
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- . Average sale for each month
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale * price_per_unit), 2) AS avg_monthly_sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;


-- . Best selling month in each year (by total sale)
SELECT 
    year,
    month,
    total_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total_sale * price_per_unit) AS total_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY SUM(total_sale * price_per_unit) DESC) AS rank_in_year
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) ranked_sales
WHERE rank_in_year = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,
	SUM(quantiy * price_per_unit) as total_sale
	from retail_sales
    GROUP BY customer_id 
    order by total_sale DESC
    LIMIT 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
count(distinct customer_id) as unique_customers
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
  CASE
    WHEN HOUR(sale_time) < 12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS shift,
  COUNT(DISTINCT ï»¿transactions_id) AS total_transactions
FROM retail_sales
GROUP BY shift;






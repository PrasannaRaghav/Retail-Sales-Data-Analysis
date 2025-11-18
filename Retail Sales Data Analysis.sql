create database sql_project_p2;

--TABLE CREATION

DROP TABLE IF EXISTS retail;
CREATE TABLE retail(
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(15),
age	INT,
category VARCHAR(15),
quantiy	INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT

);

SELECT * FROM RETAIL
LIMIT 10;

SELECT COUNT(*) FROM RETAIL;

--CHECK FOR NULL VALUES

SELECT * FROM retail
WHERE transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

--DELETE NULL VALUES

DELETE FROM retail
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


--Total sales
SELECT COUNT(*) as total_sale FROM retail

--uniuque customers

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail


 -- retrieve all columns for sales on '2022-11-05

SELECT *
FROM retail
WHERE sale_date = '2022-11-05';


--retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4


--calculate the total sales for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail
GROUP BY 1

--average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail
WHERE category = 'Beauty'


--find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail
WHERE total_sale > 1000


--find the total number of transactions made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail
GROUP 
    BY 
    category,
    gender
ORDER BY 1


-- In the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail
GROUP BY 1, 2
) as t1
WHERE rank = 1
    


--the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category



--To create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

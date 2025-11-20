               -- ================================================
                             -- Create database --
               -- ================================================
CREATE DATABASE pizza_db;

  -- import csv file into table ">> right click on database >>task>> import csv >>"  
  -- file imported succesfully

               -- ==============================================
                     -- Table overview --
               -- ==============================================

SELECT *
FROM dbo.pizza_sales;


                 -- ========================================================
                         -- Key Questions and their answers are below :-
                 -- ========================================================

-- Q1 Which pizzas generate the highest total revenue , also followings (4)?

SELECT TOP 5
    pizza_name,
    ROUND(SUM(total_price),1) AS revenue_IN_$
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY sum(total_price) DESC;
                            -- if you want bottom 5 then simply REPLACE "DESC" with "ASC"

--============================================================================================
-- Q2 What are the top 5 most ordered pizzas by quantity (best sellers pizzas)?

SELECT TOP 5
    pizza_name,
    SUM(quantity) AS total_qty_sale
FROM dbo.pizza_sales
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC;
                             -- if you want to worst sellers then replace "DESC" with "ASC"

--============================================================================================
-- Q3 Which pizza size contributes the most to total sales?

SELECT 
    pizza_size,
    ROUND(SUM(total_price),1) AS revenue_in_$
FROM dbo.pizza_sales
GROUP BY pizza_size
ORDER BY SUM(total_price) DESC;

--============================================================================================    
-- Q4 Revenue trend by date (daily sales trend)?

SELECT
    tt.order_date,
    tt.daily_sales_$,
    ROUND(daily_sales_$ - trends,1) AS daily_sales_trnds_$
FROM(
    SELECT
        order_date,
        ROUND(SUM(total_price),1) AS daily_sales_$,
        LAG(ROUND(SUM(total_price),1)) OVER(ORDER BY order_date ASC) AS trends
    FROM dbo.pizza_sales
    GROUP BY order_date
) tt
    ORDER BY order_date ASC
;
--============================================================================================
-- Q5 What is the hourly order pattern (peak hours) TOP(5)?

SELECT TOP 5
    DATEPART(hour,order_time) as hour_frame,
    SUM(quantity) AS total_orders
FROM dbo.pizza_sales
GROUP BY DATEPART(hour,order_time)
ORDER BY SUM(quantity) DESC
;
--============================================================================================
-- Q6 Which pizza category brings the most revenue?

SELECT
    pizza_category,
    ROUND(SUM(total_price),1) AS revenue_$
FROM dbo.pizza_sales
GROUP BY pizza_category
ORDER BY ROUND(SUM(total_price),1) DESC;

--============================================================================================
-- Q7 What is the average order value (AOV)?

SELECT
    ROUND(AVG(tt.avg_order),2) AS avg_order_value_$
FROM(
    SELECT
        order_id,
        ROUND(SUM(total_price),2) AS avg_order
    FROM dbo.pizza_sales
    GROUP BY order_id 
    )tt;

--============================================================================================
-- Q8 Find the most commonly used ingredient combinations?

SELECT
    pizza_ingredients,
    COUNT(*) AS pizza_ingredients
FROM dbo.pizza_sales
GROUP BY pizza_ingredients
ORDER BY COUNT(pizza_ingredients) DESC;

--============================================================================================
-- Q9 Which pizzas have the highest price (premium items)?

SELECT TOP 3
    pizza_name,
    ROUND(MAX(unit_price),2) AS unit_price
FROM dbo.pizza_sales
GROUP BY pizza_name 
ORDER BY unit_price DESC;

--============================================================================================
-- Q10 Average pizza per order ?
SELECT
    CAST(AVG(tt.quantity_ordered) AS FLOAT) AS avg_pizza_per_order
FROM(
    SELECT
        order_id,
        SUM(quantity) AS quantity_ordered
    FROM dbo.pizza_sales
    GROUP BY order_id
    )tt;

--============================================================================================
-- Q11 Which weekday max number of customers placed orders ?

SELECT
    DATENAME(DW,order_date) weekday_,
    COUNT(DISTINCT order_id) as ppl_placed_order
FROM dbo.pizza_sales
GROUP BY DATENAME(DW,order_date)
;
--============================================================================================
-- Q12 Which month max number of customers placed orders ?

SELECT
    DATENAME(MONTH,order_date) month_name,
    COUNT(DISTINCT order_id) as ppl_placed_order
FROM dbo.pizza_sales
GROUP BY DATENAME(MONTH,order_date)
ORDER BY COUNT(DISTINCT order_id) DESC
;

--============================================================================================
-- Q13 Which category sales contributed max % ?

SELECT
    tt.pizza_category,
    ROUND(tt.sale_$,2) AS sale,
    ROUND(sale_$*100/total_sale_$ ,1) as percent_contri

    FROM(
        SELECT
            pizza_category,
            SUM(total_price) as sale_$,
            (SELECT 
                SUM(total_price) 
                FROM dbo.pizza_sales) AS total_sale_$
        FROM dbo.pizza_sales
        GROUP BY pizza_category)tt
        ORDER BY percent_contri DESC;

--============================================================================================
-- Q14 Which pizza_size sales contributed max % ?

SELECT
    tt.pizza_size,
    ROUND(tt.sale_$,2) AS sale,
    ROUND(sale_$*100/total_sale_$ ,1) as percent_contri

    FROM(
        SELECT
            pizza_size,
            SUM(total_price) as sale_$,
            (SELECT 
                SUM(total_price) 
                FROM dbo.pizza_sales) AS total_sale_$
        FROM dbo.pizza_sales
        GROUP BY pizza_size)tt
        ORDER BY percent_contri DESC; 
         

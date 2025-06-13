--- Creating Database

CREATE DATABASE Ecommerce_Analysis;

--- Using the Database

USE Ecommerce_Analysis;

--- Creating Tables

SELECT * FROM Orders_table;
SELECT * FROM Products_table;
SELECT * FROM Customers_table;
SELECT * FROM Sellers_table;
SELECT * FROM Customers_review_table;
SELECT * FROM Order_items_table;
SELECT * FROM Payments_table;


--- Analysing the tables

SELECT COUNT(order_id) AS Total_Orders FROM Order_items_table;
SELECT DISTINCT order_status FROM Orders_table;
SELECT DISTINCT product_category_name FROM Products_table;
SELECT DISTINCT payment_type FROM Payments_table;


--- How much total money has the platform made so far, and how has it changed over time?

SELECT DATEPART(YEAR,O.order_purchase_timestamp) AS Year,
DATEPART(QUARTER,O.order_purchase_timestamp) AS Quarter,
ROUND(SUM(OI.price + OI.freight_value),2) AS Revenue
FROM Orders_table O
JOIN Order_items_table OI
ON O.order_id = OI.order_id
GROUP BY DATEPART(YEAR,O.order_purchase_timestamp),DATEPART(QUARTER,O.order_purchase_timestamp)
ORDER BY Year, Quarter;

--- Which product categories are the most popular, and how do their sales numbers compare?

SELECT TOP 10 P.product_category_name, 
COUNT(OI.order_id) AS Total_Orders, 
ROUND(SUM(OI.price),2) AS Total_Price
FROM Products_table P
JOIN Order_items_table OI
ON P.product_id = OI.product_id
GROUP BY P.product_category_name
ORDER BY Total_Orders DESC;

--- What is the average amount spent per order, and how does it change depending on the product category or payment method?

SELECT PR.product_category_name, P.payment_type,
COUNT(P.order_id) AS Total_orders,
ROUND(SUM(P.payment_value)/COUNT(DISTINCT P.order_id),2) AS AOV
FROM Payments_table P
JOIN Order_items_table OI
ON P.order_id = OI.order_id
JOIN Products_table PR
ON PR.product_id = OI.product_id
GROUP BY P.payment_type,PR.product_category_name
ORDER BY PR.product_category_name DESC;

--- How many active sellers are there on the platform, and does this number go up or down over time?

SELECT DATEPART(YEAR,O.order_purchase_timestamp) AS YEAR,
DATEPART(QUARTER,O.order_purchase_timestamp) AS Quarter,
COUNT(OI.seller_id) AS Active_Sellers
FROM Order_items_table OI
JOIN Orders_table O
ON OI.order_id = O.order_id
GROUP BY DATEPART(YEAR,O.order_purchase_timestamp), DATEPART(QUARTER,O.order_purchase_timestamp)
ORDER BY Year,Quarter;

--- Which products sell the most, and how have their sales changed over time?

SELECT P.product_id,P.product_category_name,
COUNT(OI.order_id) AS Total_orders,ROUND(SUM(OI.price),2) AS Price,
DATEPART(YEAR,O.order_purchase_timestamp) Year
FROM Products_table P
JOIN Order_items_table OI
ON P.product_id = OI.product_id
JOIN Orders_table O
ON OI.order_id = O.order_id
GROUP BY P.product_id,P.product_category_name,DATEPART(YEAR,O.order_purchase_timestamp)
ORDER BY Year,Total_orders DESC;

---Do customer reviews and ratings help products sell more or perform better on the platform? 

SELECT P.product_category_name,COUNT(OI.order_id) AS Total_Count,
AVG(C.review_score) AS Avg_Rating, 
ROUND(SUM(OI.price+OI.freight_value),2) AS Revenue
FROM Customers_review_table C
JOIN Order_items_table OI
ON C.order_id = OI.order_id
JOIN Products_table P
ON OI.product_id = P.product_id
GROUP BY P.product_category_name
ORDER BY Avg_Rating DESC, Total_Count DESC;

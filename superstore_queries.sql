CREATE DATABASE superstore;

USE superstore;

CREATE TABLE orders (
  Row_ID INT,
  Order_ID VARCHAR(20),
  Order_Date DATE,
  Ship_Date DATE,
  Ship_Mode VARCHAR(50),
  Customer_ID VARCHAR(20),
  Customer_Name VARCHAR(100),
  Segment VARCHAR(50),
  Country VARCHAR(50),
  City VARCHAR(100),
  State VARCHAR(50),
  Postal_Code VARCHAR(20),
  Region VARCHAR(50),
  Product_ID VARCHAR(20),
  Category VARCHAR(50),
  Sub_Category VARCHAR(50),
  Product_Name VARCHAR(255),
  Sales DECIMAL(10,4),
  Quantity INT,
  Discount DECIMAL(5,2),
  Profit DECIMAL(10,4)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data analysis.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- Total sales, profit and quantity
SELECT 
  SUM(Sales) AS Total_Sales,
  SUM(Profit) AS Total_Profit,
  SUM(Quantity) AS Total_Quantity
FROM orders;

-- Count of orders
SELECT COUNT(DISTINCT Order_ID) AS Total_Orders FROM orders;

-- Sales by category and subcategory
SELECT 
  Category, Sub_Category,
  SUM(Sales) AS Total_Sales,
  SUM(Profit) AS Total_Profit
FROM orders
GROUP BY Category, Sub_Category
ORDER BY Total_Sales DESC;

-- Monthly sales trend
SELECT 
  DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
  SUM(Sales) AS Monthly_Sales
FROM orders
GROUP BY Month
ORDER BY Month;

-- Top 5 customers by sales
SELECT 
  Customer_Name,
  ROUND(SUM(Sales), 2) AS Total_Sales
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 5;

-- Products with high sales but low profit
SELECT 
  Product_Name,
  SUM(Sales) AS Total_Sales,
  SUM(Profit) AS Total_Profit
FROM orders
GROUP BY Product_Name
HAVING SUM(Sales) > 1000 AND SUM(Profit) < 0
ORDER BY Total_Sales DESC;

-- Shipping effect on profit
SELECT 
  Ship_Mode,
  COUNT(*) AS Total_Orders,
  ROUND(SUM(Profit), 2) AS Total_Profit
FROM orders
GROUP BY Ship_Mode;


-- City level profit
SELECT 
  City, State,
  SUM(Sales) AS Total_Sales,
  SUM(Profit) AS Total_Profit
FROM orders
GROUP BY City, State
ORDER BY Total_Profit ASC
LIMIT 10;

-- Top 10 products by quantity sold
SELECT 
  Product_Name,
  SUM(Quantity) AS Total_Units_Sold
FROM orders
GROUP BY Product_Name
ORDER BY Total_Units_Sold DESC
LIMIT 10;

-- Orders with high discount and loss
SELECT 
  Order_ID, Product_Name, Discount, Profit
FROM orders
WHERE Discount > 0.3 AND Profit < 0
ORDER BY Discount DESC;



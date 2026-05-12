--Table Creation
CREATE table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR (100),
name VARCHAR (100) NOT NULL,
mrp NUMERIC (8,2),
discountpercent NUMERIC (5,2),
availablequantity INT,
discountsellingprice NUMERIC (8,2),
weightingms INT,
outofstock BOOLEAN,
quantity INT
);

--Data Exploration

-- Count of Rows
SELECT COUNT(*) FROM zepto;

--Sample Data
SELECT * FROM zepto

--Performed data quality checks to identify missing/null values.
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

--Different products categories.
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--Products in stock vs out of stock.
SELECT outofstock,COUNT(*)
FROM zepto
GROUP BY outofstock;

--Identified duplicate product entries for catalog consistency validation.
SELECT name,COUNT(*) 
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY count(*) DESC;

--Data Cleaning

--Products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--Convert paise into rupees.
UPDATE zepto
SET mrp = mrp/100.0,
discountsellingprice = discountsellingprice/100.0;

SELECT mrp,discountsellingprice
FROM zepto;

--Q1. Find the top 10 best value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Q2. What are the products with high MRP but Out of Stock.
SELECT DISTINCT name,mrp
FROM zepto
WHERE outofstock = 'True'
AND mrp > 300
ORDER BY mrp DESC;

--Q3. Estimated category-wise revenue contribution using available inventory and selling price.
SELECT category,SUM(discountsellingprice*availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all products where MRP is greater than 500 and discount is less than 10%.
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
WHERE MRP > 500
AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

--Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, ROUND(AVG(discountpercent),2) AS average_discount_percentage
FROM zepto
GROUP BY category
ORDER BY average_discount_percentage DESC
LIMIT 5;

Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightingms, discountsellingprice,ROUND(discountsellingprice/weightingms,2) AS price_per_gms
FROM zepto
WHERE weightingms > 100
ORDER BY price_per_gms ASC;

Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;	 

Q8. What is the Total Inventory Weight Per Category.
SELECT category, SUM(weightingms * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
	 
	 









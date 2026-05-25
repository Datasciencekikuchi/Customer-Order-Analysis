#In this SQL, I'm querying a database with multiple tables in it to quantify statistics about customer and order data. 

#1. How many orders were placed in January? 
SELECT COUNT(orderid)
FROM BIT_DB.JanSales
WHERE length(orderid) = 6 
AND orderid <> 'Order ID';

#2. How many of those orders were for an iPhone? 
SELECT COUNT(orderid)
FROM BIT_DB.JanSales
WHERE Product='iPhone'
AND length(orderid) = 6 
AND orderid <> 'Order ID';

#3. Select the customer account numbers for all the orders that were placed in February. 
SELECT distinct acctnum
FROM BIT_DB.customers cust

INNER JOIN BIT_DB.FebSales Feb
ON cust.order_id=FEB.orderid
WHERE length(orderid) = 6 
AND orderid <> 'Order ID';

#4. Which product was the cheapest one sold in January, and what was the price? 
  
SELECT distinct Product, price
FROM BIT_DB.JanSales
WHERE  price in (SELECT min(price) FROM BIT_DB.JanSales);
  
#OR 
  
SELECT distinct product, price FROM BIT_DB.JanSales 
ORDER BY price ASC LIMIT 1;

#5. What is the total revenue for each product sold in January?
SELECT sum(quantity)*price as revenue
,product
FROM BIT_DB.JanSales
GROUP BY product;

#6. Which products were sold in February at 548 Lincoln St, Seattle, WA 98101, how many of each were sold, and what was the total revenue?
select 
sum(Quantity), 
product, 
sum(quantity)*price as revenue
FROM BIT_DB.FebSales 
WHERE location = '548 Lincoln St, Seattle, WA 98101'
GROUP BY product;

#7. How many customers ordered more than 2 products at a time, and what was the average amount spent for those customers? 
select 
count(distinct cust.acctnum), 
avg(quantity*price)
FROM BIT_DB.FebSales Feb
LEFT JOIN BIT_DB.customers cust
ON FEB.orderid=cust.order_id
WHERE Feb.Quantity>2
AND length(orderid) = 6 
AND orderid <> 'Order ID';

#8. Calculates the total quantity sold for each headphone product in February, filtering for valid order IDs and grouping results by product name.
SELECT SUM(Quantity), Product
FROM BIT_DB.FebSales
WHERE Product LIKE '%Headphones%'
AND length(orderid) = 6
AND orderid <> 'Order ID'
GROUP BY Product;

#9.Computes the average revenue per order in February by joining sales and customer data, using quantity × price for each transaction and excluding invalid order records.
SELECT avg(quantity*price)
FROM BIT_DB.FebSales Feb
LEFT JOIN BIT_DB.customers cust
ON FEB.orderid=cust.order_id
WHERE length(orderid) = 6
AND orderid <> 'Order ID';

#10.Identifies April orders from Georgia where the average item price exceeds $1,000, filtering by valid order IDs and grouping results at the order level.
SELECT orderID, location
FROM BIT_DB.AprSales
WHERE orderdate LIKE '04/1%'
AND location LIKE '%GA%'
AND length(orderid) = 6
AND orderid <> 'Order ID'
GROUP BY orderID
HAVING AVG(price) > 1000;

#11.Retrieves the location and order ID for a specific May order pattern, ensuring only valid six-character order IDs are included.
SELECT location,
orderID
FROM MaySales
WHERE orderID LIKE '1943_5'
AND length(orderid) = 6
AND orderid <> 'Order ID';

#12. Determines the highest-revenue product in January by aggregating total sales (quantity × price) per product and returning the top result.
SELECT product,
sum(quantity*price) as revenue
FROM BIT_DB.JanSales
GROUP BY product
ORDER BY revenue desc
LIMIT 1;

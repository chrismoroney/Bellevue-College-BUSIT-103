--*  BUSIT 103	 Assignment   #3		DUE DATE :  Consult course calendar

/****** Chris Moroney ******/
							
/*  You are to develop SQL statements for each task listed. You should type your SQL statements under each task. You should always create an alias for any derived fields. Add a sort that makes sense for each query. */

USE AdventureWorksLT2012;


--1. List the customer id and the name for each customer using two columns. The customer id will be in the first column. Create a concatenation for the second column that combines the title, first name, and last name for each customer. 
-- For example, the name for customer ID 29485 will display in one column as Ms. Catherine Abel. Don't forget to include a space between each part of the name. Assign CustomerName as the alias for the derived column. Order the results in alphabetical order by last name then by first name.


SELECT CustomerID, Title + ' ' + FirstName + ' ' + LastName AS CustomerName
FROM [SalesLT].[Customer]
ORDER BY LastName, FirstName



--2. Using the CAST function, list the customer ID and the name for each customer in one column. Create a concatenation of the customer id, title, first name and last name for each customer. 
-- For example, the record for customer id 29485 will display in one column as 29485 Ms. Catherine Abel 
-- Assign CustomerInfo as the alias for the derived column. 
-- Order the results in alphabetical order by last name then by first name.
-- HINT: Look at the data type of the fields to which you are concatenating the customer id and cast customer id to match.



SELECT CAST(CustomerID AS nvarchar) + ' ' + Title + ' ' + FirstName + ' ' + LastName AS CustomerInfo
FROM [SalesLT].[Customer]
ORDER BY LastName, FirstName





--3. Using the CAST function, rewrite the SELECT statement created in #2 to add the descriptive text  "Customer ID" and "is". The record for customer id 29485 will display in one column as Customer ID 29485 is Ms. Catherine Abel
-- Use the same alias and sort order as #2.



SELECT 'Customer ID' + ' ' + CAST(CustomerID AS nvarchar) + ' ' + 'is' + ' ' + Title + ' ' + FirstName + ' ' + LastName AS CustomerInfo
FROM [SalesLT].[Customer]
ORDER BY LastName, FirstName



--4. Using the CAST function and the ProductCategory table, create a list of the product category and the category name in one column. Product category 1 will display in one column as Product Category 1: Bikes 
-- Give the derived column a meaningful alias (column name) and sort order.



SELECT 'Product Category' + ' ' + CAST(ProductCategoryID AS nvarchar) + ': ' + Name AS ProductCategoryInfo
FROM [SalesLT].[ProductCategory]
ORDER BY ProductCategoryID ASC


	
--5. For a and b below, use the SalesLT.SalesOrderDetail table to list all product sales. Show SalesOrderID, TotalCost and LineTotal for each sale. 
-- Compute TotalCost as UnitPrice * (1-UnitPriceDiscount) * OrderQty. Display money values to exactly 2 decimal places.
-- TotalCost and LineTotal should show the same amount. LineTotal is included to double check your calculation; the two amounts should match. Be sure to add a meaningful sort to the statement. 
--a.	CAST is the ANSI standard. Write the statement using CAST.



SELECT SalesOrderID, CAST((UnitPrice * (1-UnitPriceDiscount) * OrderQty) AS decimal(9, 2)) AS TotalCost, CAST(LineTotal AS decimal(9, 2)) AS LineTotal
FROM [SalesLT].[SalesOrderDetail]
ORDER BY SalesOrderID ASC


--b.	Write the statement again using CONVERT instead of CAST. CONVERT is also commonly used.



SELECT SalesOrderID, CONVERT(decimal(9, 2), (UnitPrice * (1-UnitPriceDiscount) * OrderQty)) AS TotalCost, CONVERT(decimal(9, 2), LineTotal) AS LineTotal
FROM [SalesLT].[SalesOrderDetail]
ORDER BY SalesOrderID ASC

--6. For a. and b. below, AdventureWorks predicts a 6% increase in production costs for all their products. They wish to see how the increase will affect their profit margins. To help them understand the impact of this increase in production costs (StandardCost), you will create a list of all products showing ProductID, Name, ListPrice, FutureCost (use StandardCost * 1.06 to compute FutureCost), and Profit (use ListPrice minus the calculation for FutureCost to find Profit). 
-- All money values are to show exactly 2 decimal places. Order the results descending by Profit. 
-- FYI:  Read online about the "Logical Query Processing Phases".  It will explain why you cannot use an alias created in the SELECT clause in a calculation but can use it in the ORDER BY clause.

-- a. First write the requested statement using CAST. CAST is the ANSI standard. There will be five fields (columns). There will be one row for each product in the Product table. 



SELECT ProductID, Name, ListPrice, CAST(StandardCost * 1.06 AS decimal(9, 2)) AS FutureCost, CAST(ListPrice - CAST(StandardCost * 1.06 AS decimal(9, 2)) AS decimal(9 ,2)) AS Profit
FROM [SalesLT].[Product]
ORDER BY Profit DESC


--b.	Next write the statement from 6a again using CONVERT. There will be five fields (columns). There will be one row for each product in the Product table. 


SELECT ProductID, Name, ListPrice, CONVERT(decimal(9, 2), StandardCost * 1.06) AS FutureCost, CONVERT(decimal(9, 2), ListPrice - CONVERT(decimal(9, 2), StandardCost * 1.06)) AS Profit
FROM [SalesLT].[Product]
ORDER BY Profit DESC



--7. For a. and b. below, list all sales orders showing PurchaseOrderNumber, SalesOrderID, CustomerID, OrderDate, DueDate, and ShipDate. Format the datetime fields so that no time is displayed. Be sure to give each derived column an alias and add a meaningful sort to each statement. 

--a. CAST is the ANSI standard. Write the statement using CAST. 



SELECT PurchaseOrderNumber, SalesOrderID, CustomerID, CAST(OrderDate AS DATE) AS OrderDate, CAST(DueDate AS DATE) AS DueDate, CAST(ShipDate AS DATE) AS ShipDate
FROM [SalesLT].[SalesOrderHeader]
ORDER BY SalesOrderID ASC


--b. Write the statement again using CONVERT.



SELECT PurchaseOrderNumber, SalesOrderID, CustomerID, CONVERT(DATE, OrderDate) AS OrderDate, CONVERT(Date, DueDate) AS DueDate, CONVERT(DATE, ShipDate) AS ShipDate
FROM [SalesLT].[SalesOrderHeader]
ORDER BY SalesOrderID ASC


--c. Write a statement using either 7a or 7b add a field that calculates the difference between the due date and the ship date. Name the field ShipDays and show the result as a positive number. Be sure Datetime fields still show only the date.
-- The DateDiff function is not an ANSI standard; don't use it in this statement.




SELECT PurchaseOrderNumber, SalesOrderID, CustomerID, CONVERT(DATE, OrderDate) AS OrderDate, CONVERT(Date, DueDate) AS DueDate, CONVERT(DATE, ShipDate) AS ShipDate, CONVERT(int, DueDate - ShipDate) AS ShipDays
FROM [SalesLT].[SalesOrderHeader]
ORDER BY SalesOrderID ASC



--d. Rewrite the statement from 7c to use the DateDiff function to find the difference between the OrderDate and the ShipDate. Again, show only the date in datetime fields.




SELECT PurchaseOrderNumber, SalesOrderID, CustomerID, CONVERT(DATE, OrderDate) AS OrderDate, CONVERT(Date, DueDate) AS DueDate, CONVERT(DATE, ShipDate) AS ShipDate, DATEDIFF(day, OrderDate, ShipDate) AS ShipDays
FROM [SalesLT].[SalesOrderHeader]
ORDER BY SalesOrderID ASC


 
--8.	EXPLORE: Research the following on the Web for an answer: Find a date function that will return a datetime value that contains the date and time from the computer on which the instance of SQL Server is running (this means it shows the date and time of the PC on which the function is executed). The time zone offset is not included. Write the statement so it will execute. Format the result to show only the date portion of the field and give it the alias of MyPCDate.



SELECT CURRENT_TIMESTAMP AS MyPCDate





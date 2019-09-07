/**** Chris Moroney ****/

--*  BUSIT 103           Assignment   #4              DUE DATE:  Consult course calendar
							
/* You are to develop SQL statements for each task listed. You should type your SQL statements under each task. You should test each SQL statement using the database shown in the USE statement. The SQL statement should execute against that database without errors. */

--Do not remove the USE statement

USE AdventureWorksLT2012;

--1.  Use the SalesLT.Address table to list addresses in the United States. Select the address1, city, state/province, country/region and postal code. Sort by state/province and city.


SELECT AddressLine1, City, StateProvince, CountryRegion, PostalCode
FROM [SalesLT].[Address]
WHERE CountryRegion = 'United States'
ORDER BY StateProvince, City



--2. Use the SalesLT.Address table to list addresses in the US states of Idaho or Montana. 
-- Select the address1, city, state/province, country/region and postal code. Sort by state/province and city.


SELECT AddressLine1, City, StateProvince, CountryRegion, PostalCode
FROM [SalesLT].[Address]
WHERE StateProvince = 'Idaho' OR StateProvince = 'Montana'
ORDER BY StateProvince, City


--3. Use the SalesLT.Address table to list addresses in the cities of Victoria or Vancouver. 
-- Select the address1, city, state/province, country/region and postal code.
-- Order the list by city.


SELECT AddressLine1, City, StateProvince, CountryRegion, PostalCode
FROM [SalesLT].[Address]
WHERE City = 'Victoria' OR City = 'Vancouver'
ORDER BY City

--4. Use the SalesLT.Address table to list addresses in the cities of Victoria or Vancouver in the Canadian province of British Columbia. Select the address1, city, state/province, country/region and postal code. Order the list by city.


SELECT AddressLine1, City, StateProvince, CountryRegion, PostalCode
FROM [SalesLT].[Address]
WHERE City = 'Victoria' OR City = 'Vancouver' AND StateProvince = 'British Columbia'
ORDER BY City



--5. List the company name and phone for those customers whose phone number contains the following sequence: 34.
-- Order the list by phone number in ascending order. "Contains" means that the sequence exists within the phone number.


SELECT CompanyName, Phone
FROM [SalesLT].[Customer]
WHERE Phone LIKE '%34%'
ORDER BY Phone ASC



--6. List the name, product number, size, standard cost, and list price in alphabetical order by name for Products whose standard cost is $1500 or more. Show all money values at exactly two decimal places. Be sure to give each derived column an alias.


SELECT Name, ProductNumber, Size, CAST(StandardCost AS decimal(9, 2)) AS StandardCost, CAST(ListPrice AS decimal(9,2)) AS ListPrice
FROM [SalesLT].[Product]
WHERE StandardCost >=1500
ORDER BY Name ASC



--7. List the name, product number, size, standard cost, and list price in alphabetical order by name for Products whose list price is $100 or less and standard cost is $40 or more.


SELECT Name, ProductNumber, Size, StandardCost, ListPrice
FROM [SalesLT].[Product]
WHERE ListPrice <= 100 AND StandardCost >= 40
ORDER BY Name ASC



--8. List the name, standard cost, list price, and size for products whose size is one of the following:  XS, S, M, L, XL. Show all money values at exactly two decimal places. Be sure to give each derived column an alias. Order the list by name in alphabetical order.


SELECT Name, CAST(StandardCost AS decimal(9,2)) AS StandardCost, CAST(ListPrice AS decimal(9,2)) AS ListPrice, Size
FROM [SalesLT].[Product]
WHERE SIZE = 'XS' OR SIZE = 'S' OR SIZE = 'M' OR SIZE = 'L' OR SIZE = 'XL'
ORDER BY Name ASC



--9. List the name, product number, and sell end date for all products in the Product table that are not currently sold. Sort by the sell end date from most recent to oldest date. Show only the date (no time) in the sell end date field. Be sure to give each derived column an alias.


SELECT Name, ProductNumber, CAST(SellEndDate AS DATE) AS SellEndDate
FROM [SalesLT].[Product]
WHERE SellEndDate IS NOT NULL
ORDER BY SellEndDate ASC



--10. List the name, product number, standard cost, list price, and weight for products whose standard cost is less than $50, list price is greater than $100, and weight is greater than 1,000. Round money values to exactly 2 decimal places and give each derived column a meaningful alias. Sort by weight.


SELECT Name, ProductNumber, CAST(StandardCost AS decimal (9, 2)) AS StandardCost, CAST(ListPrice AS decimal(9, 2)) AS ListPrice, Weight
FROM [SalesLT].[Product]
WHERE StandardCost < 50 AND ListPrice > 100  AND Weight > 1000
ORDER BY Weight ASC


--11. In a and b below, explore the data to better understand how to locate products. 

--a. List the name, product number, and product category ID for all products in the Product table that include 'bike' in the name. Sort by the name. 
-- Something to consider: How many of these products are actually bikes? → 0 are bikes


SELECT Name, ProductNumber, ProductCategoryID
FROM [SalesLT].[Product]
WHERE Name LIKE '%Bike%'
ORDER BY Name ASC


--b. List the name and product category id, and parent id for all categories in the product category table that include 'bike' in the name. Sort by the parent product category id. 
-- Something to consider: How many of these product categories are actually bikes?  → 4
-- What is the ProductCategoryID for Bikes? → For standard Bikes, it is 1. The other bikes derive from this Parent Category.
	

SELECT Name, ProductCategoryID, ParentProductCategoryID
FROM [SalesLT].[ProductCategory]
WHERE Name LIKE '%Bike%'
ORDER BY ParentProductCategoryID ASC



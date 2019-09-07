--*  BUSIT 103           Assignment   #1              DUE DATE:  Consult course calendar

/*****	You are to develop SQL statements for each task listed. You should type your SQL statements under each task. 
The fields' names are written as if a person is asking you for the report. You will need to look at the data and understand that list price is in the ListPrice field, for example. 
Add comments to describe your reasoning when you are in doubt about something. To find the tables that contain the fields that are requested, 
consider creating a Database Diagram that includes only the tables from the SalesLT schema and referring to it. *****/

/*** Chris Moroney ***/


/***** Do not remove the USE statement. *****/

USE AdventureWorksLT2012;


--1. Write a SQL statement that pulls all of the records from the AdventureWorksLT Products table. 

SELECT * 
FROM [SalesLT].[Product]


--2. Write a SQL statement that pulls all of the records from the AdventureWorksLT Products table
-- but show only the ProductID, Name, ProductNumber, and ListPrice.

SELECT ProductID, Name, ProductNumber, ListPrice 
FROM [SalesLT].[Product]

--3. Write a SQL statement that pulls all of the records from the AdventureWorksLT Products table, 
-- but show only the ProductID, Name, ProductNumber, and ListPrice, 
-- and sort by Name in ascending order.

SELECT ProductID, Name, ProductNumber, ListPrice 
FROM [SalesLT].[Product]
ORDER BY Name ASC



--4. Write a SQL statement that pulls all of the records from the AdventureWorksLT Products table, 
-- but show only the ProductID, Name, ProductNumber, and ListPrice, 
-- and sort by ListPrice in descending order. 

SELECT ProductID, Name, ProductNumber, ListPrice 
FROM [SalesLT].[Product]
ORDER BY Name ASC



--5a.	Write a SQL statement that pulls all of the records from the AdventureWorksLT ProductCategory table.

SELECT * 
FROM [SalesLT].[ProductCategory]

--5b.   Explain how records 1-4 in the table differ from the other records, and explain their purpose:
--  Include your explanation below inside the multi-line comment symbols /* and */

/***************************
Records 1-4 are categories where other products would fit inside of.
For instances, Mountain Bikes, Road Bikes, and Touring Bikes are all forms of Bikes, which is product category number 1. 
Records 1-4 are known as parents and they can be used to help sort certain products from one another.
***************************/


--6a.	Write a SQL statement that pulls all of the records from the AdventureWorksLT SalesOrderHeader table.

SELECT * FROM [SalesLT].[SalesOrderHeader]

--6b.	Write a SQL statement that pulls all of the records from the AdventureWorksLT SalesOrderDetail table.

SELECT * FROM [SalesLT].[SalesOrderDetail]

--6c.	Explain how you would add records to the AdventureWorksLT database for the following scenario:
-- An existing customer places an order for 3 distinct existing products, 
-- (i.e. not a quantity of 3 of one single product).
-- In your explanation, indicate which tables would require new records, and the number of records.

/***************************
The tables that would require new records would be the SalesOrderDetail and SalesOrderHeader. 
Because the customer is already EXISTING, there is no need to create a new record for the buyer, which means Customer and CustomerAddress do not need any new records. 
We do not need to worry about Address, Product, ProductCategory, ProductDescription, ProductModel, or ProductModelProductDescription because purchasing a product from a store wouldn’t require a new entry or a product or location. 
Since the customer is buying three new products that are all distinct, we need 3 new records in the SalesOrderDetail in order to keep track of what was bought and give it a label from the products. 
We then take these three sales give them a SINGLE ID (because the sale happened with only one customer), and put only one additional record in the Header table. 
Since the Header mainly keeps track of purchase and deliveries to CUSTOMERS instead of keeping track of PRODUCTS, we only add one record. Altogether, we are adding one record to the SalesOrderHeader, and three to the SalesOrderDetail. 
***************************/

--*  BUSIT 103                    assignment   #6                      DUE DATE :  Consult course calendar 

--You are to develop SQL statements for each task listed. You should type your SQL statements under 
--each task. You are required to use inner joins to solve each problem. Even if you know another method 
--that will produce the result, this module is practice in inner joins.


--NOTE: We are now using a different database. 
USE AdventureWorks2012;

/*  Reminder: You are required to use the INNER JOIN syntax to solve each problem. INNER JOIN is ANSI syntax. 
	It is generally considered more readable, especially when joining many tables. Even if you have prior 
	experience with joins, you will still use the INNER JOIN syntax and refrain from using any OUTER or 
	FULL joins for SQL Assignments 6 and 7. */



--1.a.	List any products that have product reviews.  Show product name, product ID, and comments. 
--		Sort alphabetically on the product name. Don’t over complicate this. A correctly written 
--		inner join will return only those products that have product reviews; i.e., matching values in 
--		the linking field. Hint:  Use the Production.Product and Production.ProductReview tables.

SELECT Name, [Production].[Product].ProductID, [Production].[ProductReview].Comments
FROM [Production].[Product] INNER JOIN [Production].[ProductReview] ON [Production].[Product].ProductID = [Production].[ProductReview].ProductID
ORDER BY Name ASC;

--1.b.	Copy/paste 1.a. to 1.b. then modify 1.b. to show only records in which the word 'heavy' is 
--		found in the Comments field. Show product ID, product name, and comments. Sort on ProductID. 

SELECT Name, [Production].[Product].ProductID, [Production].[ProductReview].Comments
FROM [Production].[Product] INNER JOIN [Production].[ProductReview] ON [Production].[Product].ProductID = [Production].[ProductReview].ProductID 
WHERE [Production].[ProductReview].Comments LIKE '%heavy%' 
ORDER BY Name ASC;


--2.a.	List product models with products. Show the product model ID, model name, product ID,
--		product name, standard cost, and class. Round all money values to exactly two decimal places. 
--		Be sure to give any derived fields an alias. order by standard cost from highest to lowest.
--		Hint: You know you need to use the Product table. Now look for a related table that contains  
--		the information about the product model and inner join it to Product on the linking field.  


SELECT [Production].[ProductModel].ProductModelID, [Production].[ProductModel].Name, [Production].[Product].ProductID, [Production].[Product].Name, CAST([Production].[Product].StandardCost AS decimal(9, 2)) AS RoundedStandardCost, [Production].[Product].Class  
FROM [Production].[ProductModel] INNER JOIN [Production].[Product] ON [Production].[ProductModel].Name = [Production].[Product].Name
ORDER BY RoundedStandardCost DESC;


--2.b.	Copy/paste 2.a. to 2.b. then modify 2.b. to list only products with a value in the  
--		class field. Do this using NULL appropriately in the where clause. Hint: Remember
--		that nothing is ever equal (on not equal) to NULL; it either is or it isn't NULL.
	

SELECT [Production].[ProductModel].ProductModelID, [Production].[ProductModel].Name, [Production].[Product].ProductID, [Production].[Product].Name, CAST([Production].[Product].StandardCost AS decimal(9, 2)) AS RoundedStandardCost, [Production].[Product].Class  
FROM [Production].[ProductModel] INNER JOIN [Production].[Product] ON [Production].[ProductModel].Name = [Production].[Product].Name
WHERE [Production].[Product].Class IS NOT NULL
ORDER BY RoundedStandardCost DESC;



--2.c.	Copy/paste 2.b. to 2.c. then modify 2.c. to list only products that contain a value in 
--		the class field and contain 'fork' or 'front' in the product model name. Be sure that NULL 
--		does not appear in the Class field by using parentheses appropriately.


SELECT [Production].[ProductModel].ProductModelID, [Production].[ProductModel].Name, [Production].[Product].ProductID, [Production].[Product].Name, CAST([Production].[Product].StandardCost AS decimal(9, 2)) AS RoundedStandardCost, [Production].[Product].Class  
FROM [Production].[ProductModel] INNER JOIN [Production].[Product] ON [Production].[ProductModel].Name = [Production].[Product].Name
WHERE [Production].[Product].Class IS NOT NULL AND [Production].[Product].Name LIKE '%front%' OR [Production].[Product].Name LIKE '%fork%'
ORDER BY RoundedStandardCost DESC;



--3.a.	List Product categories, their subcategories and their products.  Show the category name, 
--		subcategory name, product ID, and product name, in this order. Sort in alphabetical order on 
---		category name, subcategory name, and product name, in this order. Give each Name field a 
--		descriptive alias. For example, the Name field in the Product table will have the alias ProductName.
--		Hint:  To understand the relationships, create a database diagram with the following tables:
--		Production.ProductCategory
--		Production.ProductSubCategory
--		Production.Product

SELECT [Production].[ProductCategory].Name AS CategoryName, [Production].[ProductSubcategory].Name AS SubcategoryName, [Production].[Product].ProductID, [Production].[Product].Name AS ProductName
FROM (([Production].[Product] INNER JOIN [Production].[ProductSubcategory] ON [Production].[Product].ProductSubcategoryID = [Production].[ProductSubcategory].ProductSubcategoryID) INNER JOIN [Production].[ProductCategory] ON [Production].[ProductSubcategory].ProductCategoryID = [Production].[ProductCategory].ProductCategoryID)
ORDER BY [Production].[ProductCategory].Name, [Production].[ProductSubcategory].Name, [Production].[Product].Name


--3.b.	Copy/paste 3.a. to 3.b. then modify 3.b. to list only Products in product category 1.  
--		Show the category name, subcategory name, product ID, and product name, in this order. Sort in 
--		alphabetical order on category name, subcategory name, and product name. 
--		Hint: Add product category id field to select clause, make sure your results are correct, then 
--		remove or comment out the field.  Something to consider: Look at the data in the ProductName field. 
--		Could we find bikes by searching for 'bike' in the ProductName field?


SELECT [Production].[ProductCategory].Name AS CategoryName, [Production].[ProductSubcategory].Name AS SubcategoryName, [Production].[Product].ProductID, [Production].[Product].Name AS ProductName
FROM (([Production].[Product] INNER JOIN [Production].[ProductSubcategory] ON [Production].[Product].ProductSubcategoryID = [Production].[ProductSubcategory].ProductSubcategoryID) INNER JOIN [Production].[ProductCategory] ON [Production].[ProductSubcategory].ProductCategoryID = [Production].[ProductCategory].ProductCategoryID)
WHERE [Production].[ProductCategory].ProductCategoryID = 1
ORDER BY [Production].[ProductCategory].Name, [Production].[ProductSubcategory].Name, [Production].[Product].Name



--3.c.	Copy/paste 3.b. to 3.c. then modify 3.c. to list Products in product category 3. Make no other changes 
--		to the statement. Consider what kinds of products are in category 3. 


SELECT [Production].[ProductCategory].Name AS CategoryName, [Production].[ProductSubcategory].Name AS SubcategoryName, [Production].[Product].ProductID, [Production].[Product].Name AS ProductName
FROM (([Production].[Product] INNER JOIN [Production].[ProductSubcategory] ON [Production].[Product].ProductSubcategoryID = [Production].[ProductSubcategory].ProductSubcategoryID) INNER JOIN [Production].[ProductCategory] ON [Production].[ProductSubcategory].ProductCategoryID = [Production].[ProductCategory].ProductCategoryID)
WHERE [Production].[ProductCategory].ProductCategoryID = 3
ORDER BY [Production].[ProductCategory].Name, [Production].[ProductSubcategory].Name, [Production].[Product].Name


--4.a.	List Product models, the categories, the subcategories, and the products.  Show the model name, 
--		category name, subcategory name, product ID, and product name in this order. Give each Name field a   
--		descriptive alias. For example, the Name field in the ProductModel table will have the alias ModelName.
--		Sort in alphabetical order by model name.
--		Hint:  To understand the relationships, create a database diagram with the following tables:
--		Production.ProductCategory
--		Production.ProductSubCategory
--		Production.Product
--		Production.ProductModel
--		Choose a path from one table to the next and follow it in a logical order to create the inner joins

SELECT [Production].[ProductModel].Name AS ModelName, [Production].[ProductCategory].Name AS CategoryName, [Production].[ProductSubcategory].Name AS SubcategoryName, [Production].[Product].Name AS ProductName
FROM ((([Production].[Product] INNER JOIN [Production].[ProductSubcategory] ON [Production].[Product].ProductSubcategoryID = [Production].[ProductSubcategory].ProductSubcategoryID) INNER JOIN [Production].[ProductModel] ON [Production].[Product].ProductModelID = [Production].[ProductModel].ProductModelID) INNER JOIN [Production].[ProductCategory] ON [Production].[ProductCategory].ProductCategoryID = [Production].[ProductSubcategory].ProductCategoryID)
ORDER BY ModelName ASC



--4.b.	Copy/paste 4.a. to 4.b. then modify 4.b. to list those products in model ID 23 and  
--		contain black in the product name. Modify the sort to order only on Product ID. Hint: Add the 
--		product model id field to the select clause to check your results and then remove or comment it out.


SELECT [Production].[ProductModel].Name AS ModelName, [Production].[ProductCategory].Name AS CategoryName, [Production].[ProductSubcategory].Name AS SubcategoryName, [Production].[Product].Name AS ProductName
FROM ((([Production].[Product] INNER JOIN [Production].[ProductSubcategory] ON [Production].[Product].ProductSubcategoryID = [Production].[ProductSubcategory].ProductSubcategoryID) INNER JOIN [Production].[ProductModel] ON [Production].[Product].ProductModelID = [Production].[ProductModel].ProductModelID) INNER JOIN [Production].[ProductCategory] ON [Production].[ProductCategory].ProductCategoryID = [Production].[ProductSubcategory].ProductCategoryID)
WHERE [Production].[ProductModel].ProductModelID = 23 AND [Production].[Product].Name LIKE '%black%'
ORDER BY [Production].[Product].ProductID ASC


--5.	List all sales for clothing that were ordered during 2007.  Show sales order id, product ID, 
--		product name, order quantity, and line total for each line item sale. Make certain you are  
--		retrieving only clothing. There are multiple ways to find clothing. Show the results  
--		by sales order id and product name. Hint: Refer to the diagram you created in #5. 


SELECT [Sales].[SalesOrderDetail].SalesOrderID, [Production].[Product].ProductID, [Production].[Product].Name, [Sales].[SalesOrderDetail].OrderQty, [Sales].[SalesOrderDetail].LineTotal
FROM ((([Sales].[SalesOrderDetail] INNER JOIN [Production].[Product] ON [Sales].[SalesOrderDetail].ProductID = [Production].[Product].ProductID) INNER JOIN [Production].[ProductSubcategory] ON [Production].[Product].ProductSubcategoryID = [Production].[ProductSubcategory].ProductSubcategoryID) INNER JOIN [Production].[ProductCategory] ON [Production].[ProductCategory].ProductCategoryID = [Production].[ProductSubcategory].ProductCategoryID)
WHERE [Production].[ProductCategory].ProductCategoryID = 3
ORDER BY [Sales].[SalesOrderDetail].SalesOrderID, [Production].[Product].Name ASC

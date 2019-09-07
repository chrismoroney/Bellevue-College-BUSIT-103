-----------------------------------------------------------------------------------
------------- BUSIT 103 Midterm 02								--------------------
------------- PART 2 of 2										--------------------
------------- 18 points total (each question is worth 3 points)	--------------------
------------- Due as posted in Canvas							--------------------
------------------------------------------------------------------------------------


------------------------------------------------------------------- 
-- Use the AdventureWorks2012 database for the following questions.

-----------------------------------------------------------------------
-- 1.	List the product models that do not have illustrations.
--		Include the code you would write to determine the answer, 
--		and include a comment that lists the number of records.

use [AdventureWorks2012];


SELECT * 
FROM [Production].[ProductModel]
WHERE Instructions IS NULL;

-- Answer: 119 records

-----------------------------------------------------------------------
-- 2.	List all of the people who have credit cards listed.  
--		Include each person's ID, their first and last name, the type  
--		of credit card, and the month and year the credit card expires.
--		Sort by the type of card, last name, and then first name.  
--		Include the code you would write to determine the answer, 
--		and include a comment that lists the number of records.
		
use [AdventureWorks2012];

SELECT p.BusinessEntityID, p.FirstName, p.LastName, cc.CardType, cc.ExpMonth, cc.ExpYear
FROM [Sales].[CreditCard] AS cc INNER JOIN [Sales].[PersonCreditCard] AS pcc ON cc.CreditCardID = pcc.CreditCardID INNER JOIN [Person].[Person] AS p ON p.BusinessEntityID = pcc.BusinessEntityID
ORDER BY cc.CardType, p.LastName, p.FirstName ASC;

-- Answer: 19118 records


--------------------------------------------------------------------------
-- Use the RecipesExample database for the following question.

--------------------------------------------------------------------------
-- 3.	List any recipes that contain liquor (not beer or wine, just liquor).
--		Include the code you would write to determine the answer, 
--		and include a comment that lists the number of records.

use [RecipesExample];

SELECT r.RecipeTitle 
FROM [dbo].[Recipes] AS r INNER JOIN [dbo].[Recipe_Ingredients] AS ri ON r.RecipeID = ri.RecipeId INNER JOIN [dbo].[Ingredients] AS i ON ri.IngredientID = i.IngredientID INNER JOIN [dbo].[Ingredient_Classes] AS rc ON i.IngredientClassID = rc.IngredientClassID
WHERE rc.IngredientClassID = 24;

-- Answer: 1 record


--------------------------------------------------------------------------
-- Use the SchoolSchedulingExample database for the following questions.

-----------------------------------------------------------------------------------
-- 4.	List any faculty who are currently not scheduled to teach any classes.
--		List the faculty's ID, first name, and last name.
--		Include the code you would write to determine the answer, 
--		and include a comment that lists the number of records.


use [SchoolSchedulingExample];

SELECT DISTINCT s.StaffID, s.StfFirstName, s.StfLastname
FROM [dbo].[Staff] AS s LEFT OUTER JOIN [dbo].[Faculty_Classes] AS fc ON s.StaffID = fc.StaffID LEFT OUTER JOIN [dbo].[Classes] AS c ON fc.ClassID = c.ClassID
WHERE s.Position LIKE 'Faculty' AND fc.ClassID IS NULL
ORDER BY s.stfLastname, s.StfFirstName ASC;

-- Answer: 2 records



-- 5.	List all of the classrooms that are available, which is
--		defined as a classroom that does not yet have an assigned class.
--		Include the code you would write to determine the answer, 
--		and include a comment that lists the number of records.

use [SchoolSchedulingExample];


SELECT cr.ClassRoomID, cr.BuildingCode, cr.Capacity
FROM [dbo].[Class_Rooms] AS cr LEFT OUTER JOIN [dbo].[Classes] AS c ON cr.ClassRoomID = c.ClassRoomID
WHERE c.ClassID IS NULL 
ORDER BY cr.ClassRoomID, cr.BuildingCode, cr.Capacity ASC;

-- Answer: 13 records 



--------------------------------------------------------------------------
-- Use the BowlingLeagueExample database for the following question.

--------------------------------------------------------------------------------
-- 6.	List all of the bowlers and the name of their team, including  
--		any bowlers who have not yet been assigned to a bowling team.
--		Include each bowler's ID, firstname, lastname, team ID, and team name.
--		Include the code you would write to determine the answer, 
--		and include a comment that lists the number of records.

use [BowlingLeagueExample];

SELECT b.BowlerID, b.BowlerFirstName, b.BowlerLastName, t.TeamID, t.TeamName
FROM [dbo].[Bowlers] AS b LEFT OUTER JOIN [dbo].[Teams] AS t ON b.TeamID = t.TeamID
ORDER BY t.TeamID, t.TeamName, b.BowlerLastName, b.BowlerFirstName ASC;

-- Answer: 32 records


-------------------------------------------------------------------------
----- End of Assignment -------------------------------------------------
-------------------------------------------------------------------------

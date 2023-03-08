/*
Name:		Takudzwa Nyadenga
Session:	SQL Server Review Lab  
Date:		11/18/2022
*/

/*
	16.	Write a SQL statement to create a variable called Variable1 that can handle the value such as “Welcome to planet earth”.
*/
DECLARE			@Variable1 varchar(50)
SET 			@Variable1 =  'Welcome to Planet Earth'

/*
	17.	Write a SQL statement that constructs a table called Table1 with the following fields:
		a.	Field1 – this field stores numbers such as 1, 2, 3 etc.
		b.	Field2 – this field stores the date and time.
		c.	Field3 – this field stores the text up to 500 characters.
*/
CREATE TABLE 	Table1(Field1 int , Field2 datetime, Field3 varchar(500))

/*
	18.	Write a SQL statement that adds the following records to Table1:
*/
INSERT INTO 	Table1 (Field1, Field2, Field3)
VALUES			(34, '1/19/2012 08:00 AM', 'Mars Saturn'),
				(65, '2/15/2012 10:30 AM', 'Big Bright Sun'),
				(89, '3/31/2012 09:15 PM', 'Red Hot Mercury')

/*
	19.	Write a SQL statement to change the value for Field3 in Table1 to the value stored in Variable1 (From question 16),
			on the record that is 34.
*/
UPDATE 			Table1
SET 			Field3 =  @Variable1
WHERE			Field1 = 34

/*
	20.	Write a SQL statement for record 89 to return the total number of characters for Field3.
*/
SELECT 			LEN(Field3)
FROM			Table1
WHERE 			Field1 = 89

/*
	21.	Write a SQL statement for record 65 to return the first occurrence of a space in Field3
*/
SELECT 			CHARINDEX( ' ' , Field3)
FROM			Table1
WHERE			Field1 = 65 

/*
	22.	Write a SQL statement for record 65 to return the value “Bright” from Field3.
*/
SELECT 			SUBSTRING(Field3, 5, 6)
FROM			Table1
WHERE			Field1 = 65

/*
	23.	Write a SQL statement for record 34 to return the day from the Field2.
*/
SELECT			DATEPART(DD, Field2)
FROM			Table1
WHERE 			Field1 = 34

/*
	24.	Write a SQL statement for record 34 to return the first day of the month from the Field2.
*/
SELECT			DATEADD(mm,DATEDIFF(mm,0, Field2),0) AS FirstDayOfMonth
FROM			Table1
WHERE			Field1 = 34

/*
	25.	Write a SQL statement for record 34 to return the previous end of the month from the Field2.
*/
SELECT			DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,Field2),0)) AS LastDay_PreviousMonth
FROM			Table1
Where			Field1 = 34

/*
	26.	Write a SQL statement for record 34 to return the day of the week from the Field2.
*/
SELECT			DATENAME(WEEKDAY, Field2) as DayOfTheWeek
FROM			Table1
WHERE			Field1 = 34

/*
	27.	Write a SQL statement for record 34 to return the date as CCYYMMDD from the Field2.
*/
SELECT			CONVERT(CHAR(50), Field2, 112)
FROM			Table1
WHERE			Field1 = 34

/*
	28.	Write a SQL statement to add a new column, Field4 (data type can be of any preference), to Table1.
*/
ALTER TABLE		Table1
ADD				Field4 varchar(50)

/*
	29.	Write a SQL statement to remove record 65 from Table1.
*/
DELETE FROM		Table1
WHERE			Field1 = 65

/*
	30.	Write a SQL statement to wipe out all records in Table1.
*/
DELETE FROM		Table1

/*
	31.	Write a SQL statement to remove Table1.
*/
DROP TABLE		Table1	

/*
	Create a sql statement that returns the TerritoryName, SalesPerson (LastName Only) 
		ship method, credit card type (If no credit card, it should say cash), OrderDate and TotalDue for ALL Transactions  
		in the NorthWest Territory
*/
SELECT			ST.[Name] AS TerritoryName, P.[LastName] AS SalesPersonLastName, 
				SM.[Name] AS ShippingMethod,CASE 
											WHEN CC.[CardType] IS NULL THEN 'CASH'
											ELSE CC.[CardType]
											END AS CreditCardType_PaymentType, 
				SOH.[OrderDate], SOH.[TotalDue]
FROM			[Sales].[SalesTerritory] ST
JOIN			[Sales].[SalesPerson] SP
ON				ST.TerritoryID = SP.TerritoryID
JOIN			[Person].[Person] P
ON				SP.BusinessEntityID = P.BusinessEntityID
JOIN			[Sales].[SalesOrderHeader] SOH
ON				ST.TerritoryID = SOH.TerritoryID
JOIN			[Purchasing].[ShipMethod] SM
ON				SOH.ShipMethodID = SM.ShipMethodID
JOIN			[Sales].[CreditCard] CC
ON				SOH.CreditCardID = CC.CreditCardID
WHERE			ST.[Name] LIKE '%NorthWest%'
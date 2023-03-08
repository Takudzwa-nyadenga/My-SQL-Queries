/*
Name:		Takudzwa Nyadenga
Session:	SSRS Parameters Lab  
Date:		12/4/2022
*/

--Create 1 big dataset that will work for every report.

SELECT		Year(SOH.[OrderDate]) AS YearOrdered, DATEPART(MM,SOH.[OrderDate]) AS MonthOrdered, SUM(SOH.[TotalDue]) AS TotalDue,
			ST.[Group] AS TerritoryGroup, ST.[Name] AS TerritoryName,
			SP.[Name] AS [State],
			VSP.[FirstName] + ' ' + VSP.[LastName] as SalesRepFullName,
			E.[JobTitle]
FROM		[Sales].[SalesOrderHeader] SOH
JOIN		[Sales].[SalesTerritory] ST
ON			SOH.TerritoryID = ST.TerritoryID
JOIN		[Person].[Address] A
ON			SOH.ShipToAddressID = A.AddressID
JOIN		[Person].[StateProvince] SP
ON			A.StateProvinceID = SP.StateProvinceID
JOIN		vw_SalesPerson VSP
ON			SOH.SalesPersonID = VSP.BusinessEntityID
JOIN		[HumanResources].[Employee] E
ON			SOH.SalesPersonID = E.BusinessEntityID
WHERE		SP.[CountryRegionCode] = 'US'
GROUP BY	Year([OrderDate]), DATEPART(MM,[OrderDate]), ST.[Group], ST.[Name], SP.[Name], VSP.[FirstName] + ' ' + VSP.[LastName], E.[JobTitle]
ORDER BY	DATEPART(YY,[OrderDate]) ASC, DATEPART(MM,[OrderDate]) DESC, SUM(SOH.[TotalDue]) DESC




--The 1 big data set with the programed SSRS Parameters  
SELECT		Year(SOH.[OrderDate]) AS YearOrdered, DATEPART(MM,SOH.[OrderDate]) AS MonthOrdered, SUM(SOH.[TotalDue]) AS TotalDue,
			ST.[Group] AS TerritoryGroup, ST.[Name] AS TerritoryName,
			SP.[Name] AS [State],
			VSP.[FirstName] + ' ' + VSP.[LastName] as SalesRepFullName,
			E.[JobTitle]
FROM		[Sales].[SalesOrderHeader] SOH
JOIN		[Sales].[SalesTerritory] ST
ON			SOH.TerritoryID = ST.TerritoryID
JOIN		[Person].[Address] A
ON			SOH.ShipToAddressID = A.AddressID
JOIN		[Person].[StateProvince] SP
ON			A.StateProvinceID = SP.StateProvinceID
JOIN		vw_SalesPerson VSP
ON			SOH.SalesPersonID = VSP.BusinessEntityID
JOIN		[HumanResources].[Employee] E
ON			SOH.SalesPersonID = E.BusinessEntityID
WHERE		SP.[CountryRegionCode] = 'US'
AND		Year(SOH.[OrderDate]) IN(@OrderYear)
AND		ST.[Group] IN(@TerritoryGroup)
AND		ST.[Name] IN(@TerritoryName)
AND		VSP.[FirstName] + ' ' + VSP.[LastName] IN(@SalesRep)
AND		E.[JobTitle] IN(@JobTitle)
AND		SP.[Name] IN(@ShipState)
GROUP BY	Year([OrderDate]), DATEPART(MM,[OrderDate]), ST.[Group], ST.[Name], SP.[Name], VSP.[FirstName] + ' ' + VSP.[LastName], E.[JobTitle]
ORDER BY	DATEPART(YY,[OrderDate]) ASC, DATEPART(MM,[OrderDate]) DESC, SUM(SOH.[TotalDue]) DESC

--
SELECT Distinct		Year(SOH.[OrderDate]) AS YearOrdered, DATEPART(MM,SOH.[OrderDate]) AS MonthOrdered, SUM(SOH.[TotalDue]) AS TotalDue,
			ST.[Group] AS TerritoryGroup, ST.[Name] AS TerritoryName,
			SP.[Name] AS [State],
			VSP.[FirstName] + ' ' + VSP.[LastName] as SalesRepFullName,
			E.[JobTitle]
FROM		[Sales].[SalesOrderHeader] SOH
JOIN		[Sales].[SalesTerritory] ST
ON			SOH.TerritoryID = ST.TerritoryID
JOIN		[Person].[Address] A
ON			SOH.ShipToAddressID = A.AddressID
JOIN		[Person].[StateProvince] SP
ON			A.StateProvinceID = SP.StateProvinceID
JOIN		vw_SalesPerson VSP
ON			SOH.SalesPersonID = VSP.BusinessEntityID
JOIN		[HumanResources].[Employee] E
ON			SOH.SalesPersonID = E.BusinessEntityID
GROUP BY	Year([OrderDate]), DATEPART(MM,[OrderDate]), ST.[Group], ST.[Name], SP.[Name], VSP.[FirstName] + ' ' + VSP.[LastName], E.[JobTitle]
ORDER BY	DATEPART(YY,[OrderDate]) ASC, DATEPART(MM,[OrderDate]) DESC, SUM(SOH.[TotalDue]) DESC

SELECT DISTINCT JobTitle
FROM     HumanResources.Employee AS E
WHERE		JobTitle Like'%Sales%' 

SELECT * FROM  vw_SalesPerson VSP





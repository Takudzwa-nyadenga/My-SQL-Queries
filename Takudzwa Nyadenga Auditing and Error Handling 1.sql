/*
Name:		Takudzwa Nyadenga
Session:	Extract, Transformation and Load Basics Lab  
Date:		12/12/2022
*/

--Create LEarningSSIS Database and Employee Table 
USE LearningSSIS
CREATE TABLE Employee	(EmpID int, EmpName varchar(50), JobTitle varchar(50), Salary money)

SELECT	*
FROM	Employee

--2.	Create table tblEmp in LearningSIS2 database with the same schema as LearningSSIS..tblEmployee table 
--3.	(do not populate tblEmp)
USE LearningSSIS2
CREATE TABLE Emp	(EmpID int, EmpName varchar(50), JobTitle varchar(50), Salary money)

SELECT *
FROM	Emp

--5.	Create database Prospects
USE	Prospects

--6.	Create table tbl_stg_Prospects in Prospects  – (Refer to Project document)
CREATE TABLE	tbl_stg_Prospects ([Name] varchar(250) NULL, 
								   Title varchar(250) NULL, 
								   Company varchar(250) NULL,
								   [Location] varchar(250) NULL,
								   FirstName varchar(250) NULL,
								   LastName varchar(250) NULL,
								   Designation varchar(250) NULL,
								   Department varchar(250) NULL,
								   City varchar(250) NULL,
								   [State] varchar(250) NULL)

SELECT	*
FROM	[dbo].[tbl_stg_Prospects]
order by	[Name] asc

---	Truncate the tbl_stg_Prospects table before loading the Prospect_B.xls file.
TRUNCATE TABLE	tbl_stg_Prospects


SELECT	*
FROM	[dbo].[tbl_stg_Prospects]
WHERE	[Name] IS NULL OR Title IS NULL OR Company IS NULL OR [Location] IS NULL

--statment to copy into SSIS
UPDATE		[dbo].[tbl_stg_Prospects]
SET			FirstName = ?,		0
			LastName = ?,		1
			Title = ?,		2
			Designation = ?,		3
			Department = ?,		4
			Company = ?,		5
			[Location] = ?,		6
			City = ?,		7
			[State] = ?		8
WHERE		[Name] = ?		9

/*
Name:		Takudzwa Nyadenga
Session:	Auditing & Error Handling Lab  
Date:		12/16/2022
*/

--1.	Create dictionary tables in Prospects database for Title, Department, Company and Location – (Project document)
CREATE TABLE tbl_dictionary_Company (CompanyID int IDENTITY (10,10) PRIMARY KEY,
									 CompanyName varchar(250) NULL,
									 Active varchar(250) NULL,
									 CreateDate datetime NULL,
									 UpdateDate datetime NULL)

CREATE TABLE tbl_dictionary_Department (DepartmentID int IDENTITY (10,10) PRIMARY KEY,
										DepartmentName varchar(250) NULL,
										Active varchar(250) NULL,
										CreateDate datetime NULL,
										UpdateDate datetime NULL)

CREATE TABLE tbl_dictionary_Location (LocationID int IDENTITY (5,5) PRIMARY KEY,
									  LocationCity varchar(250) NULL,
									  LocationState varchar(250) NULL,
									  Active varchar(250) NULL,
									  CreateDate datetime NULL,
									  UpdateDate datetime NULL)

CREATE TABLE tbl_dictionary_Title (TitleID int IDENTITY (1,1) PRIMARY KEY,
								   TitleName varchar(250) NULL,
								   Active varchar(250) NULL,
								   CreateDate datetime NULL,
								   UpdateDate datetime NULL)

ALTER TABLE [dbo].[tbl_dictionary_Department] ADD DEFAULT (GETDATE()) FOR [CreateDate]
ALTER TABLE [dbo].[tbl_dictionary_Company] ADD DEFAULT (GETDATE()) FOR [CreateDate]
ALTER TABLE [dbo].[tbl_dictionary_Location] ADD DEFAULT (GETDATE()) FOR [CreateDate]
ALTER TABLE [dbo].[tbl_dictionary_Title] ADD DEFAULT (GETDATE()) FOR [CreateDate]

SELECT * FROM	[dbo].[tbl_dictionary_Title]
SELECT * FROM	[dbo].[tbl_dictionary_Location]
SELECT * FROM	[dbo].[tbl_dictionary_Department]
SELECT * FROM	[dbo].[tbl_dictionary_Company]

TRUNCATE TABLE [dbo].[tbl_dictionary_Title]
TRUNCATE TABLE [dbo].[tbl_dictionary_Location]
TRUNCATE TABLE [dbo].[tbl_dictionary_Department]
TRUNCATE TABLE [dbo].[tbl_dictionary_Company]

TRUNCATE TABLE [dbo].[AuditFileLoad]

--update command for company table
UPDATE [dbo].[tbl_dictionary_company]
SET	[Active] = ?, --0
	[UpdateDate] = GetDate() 
WHERE [CompanyName] = ? --1

--update command for department 
UPDATE [dbo].[tbl_dictionary_Department]
SET	[Active] = ?, --0
	[UpdateDate] = GetDate() 
WHERE [DepartmentName] = ? --1

--update command for title
UPDATE [dbo].[tbl_dictionary_Title]
SET	[Active] = ?, --0
	[UpdateDate] = GetDate() 
WHERE [TitleName] = ? --1

--update command for location
UPDATE [dbo].[tbl_dictionary_Location]
SET	[Active] = ?, --0
	[UpdateDate] = GetDate() 
WHERE [LocationCity] = ? --1
 AND [LocationState] = ? --2

 --Create Audit Table 
CREATE TABLE AuditFileLoad ([FileName] nvarchar(255), 
							FileProcessedBy nvarchar(255), 
							FileProcessedTime datetime, 
							IsArchived nvarchar(15) )
SELECT * FROM AuditFileLoad

--Stored Procedure 
GO
CREATE PROCEDURE usp_AuditFileLoad
(
 @FileName nvarchar(255),
 @PackageName nvarchar(255)
)
AS
BEGIN
	INSERT INTO [dbo].[AuditFileLoad]
		([FileName], [FileProcessedBy], [FileProcessedTime], [IsArchived])
	SELECT @FileName, @PackageName, GetDate(), 'Yes'
END
GO
;

--EXECUTE 
EXECUTE usp_AuditFileLoad @FileName = ?, --0
						  @PackageName = ? --1

--Create ErrorRecords table
Create TabLE [dbo].[ErrorRecords]
(
[Name] nvarchar(255),
[Title] nvarchar(255),
[Company] nvarchar(255),
[Location] nvarchar(255),
[FileName] nvarchar(255)
)

SELECT * FROM	[dbo].[ErrorRecords]

--Section 5
USE PROSPECTS
GO
;
/*
Author:			Tee
Create Date:	12-19-2022
Description:	This stored procedure send email from the database mail server to the recipients; can be called from an SSIS package or a stored procedure

Example: EXECUTE usp_DBSendMail @Profile = 'ColaberryEmailProfile', @EmailReciever = 'nyadengatakudzwa@gmail.com', @EmailSubject ='Test Email', @EmailBody = 'Hello, This is a Test'

*/
CREATE PROCEDURE usp_DBSendMail
(
	@Profile nvarchar(255),
	@EmailReciever nvarchar(255),
	@EmailSubject nvarchar(255),
	@EmailBody nvarchar(max)
)
AS
BEGIN
	EXECUTE [msdb].[dbo].[sp_send_dbmail] @profile_name = @Profile, @recipients =  @EmailReciever, @subject = @EmailSubject, @body = @EmailBody
END

EXECUTE [dbo].[usp_DBSendMail] @Profile = 'ColaberryEmailProfile', @EmailReciever = 'nyadengatakudzwa@gmail.com', 
							   @EmailSubject ='SSIS PAckage Compleated Successfuly ', @EmailBody = 'PLease check archive foldr to find successfully processed files '

--Create Prospects table 
CREATE TABLE [dbo].[tbl_Prospects]
(
	Contact_ID int PRIMARY KEY IDENTITY(1,1),
	Contact_FirstName varchar(250),
	Contact_LastName varchar(250),
	Title_ID int,
	Department_ID int,
	Company_ID int,
	Location_ID int,
	Active varchar(5),
	Create_Date datetime,
	Update_Date datetime
)
ALTER TABLE [dbo].[tbl_Prospects] ADD DEFAULT('Y') FOR [Active]
ALTER TABLE [dbo].[tbl_Prospects] ADD DEFAULT(GetDate()) FOR [Update_Date]
ALTER TABLE [dbo].[tbl_Prospects] ADD DEFAULT(GetDate()) FOR [Create_Date]

SELECT * FROM [dbo].[tbl_Prospects]
ORDER BY Contact_LastName asc

SELECT dc.CompanyName
from	[dbo].[tbl_dictionary_Company] dc
join	[dbo].[tbl_Prospects] p
on		dc.CompanyID = p.Company_ID
where CompanyID = 830

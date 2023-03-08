/*
Name:		Takudzwa Nyadenga
Session:	Package Design Conciderations Lab  
Date:		12/12/2022
*/


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
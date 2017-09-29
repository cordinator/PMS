CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](200) NOT NULL,
	[Password] [nvarchar] (200) NOT NULL,
	[FirstName] [nvarchar](200) NULL,
	[LastName] [nvarchar](200) NULL,
	[MobileNumber] [bigint] NULL,
	[EmailAddress] [nvarchar](500) NULL,
	[DOB] [date] NULL,
	[Gender] [nvarchar](10) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL)
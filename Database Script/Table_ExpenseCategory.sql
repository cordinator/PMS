USE [PMS]
GO

/****** Object:  Table [dbo].[ExpenseCategory]   Script Date: 10/08/2017 06:23:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ExpenseCategory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[ShortName] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
	Primary Key(ID))
GO

ALTER TABLE [dbo].[ExpenseCategory]  WITH CHECK ADD FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO

ALTER TABLE [dbo].[ExpenseCategory] ADD  DEFAULT ((1)) FOR [IsActive]
GO



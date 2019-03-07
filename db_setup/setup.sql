
CREATE DATABASE PlumaCMS
GO

USE PlumaCMS
GO

CREATE TABLE dbo.fragments (
	[key] varchar(50) NOT NULL,
	[value] varchar(max) NOT NULL,
	CONSTRAINT [PK_Fragments] PRIMARY KEY CLUSTERED ([key] ASC)
)
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE TABLE dbo.pages (
	[slug] varchar(50) NOT NULL,
	[title] varchar(255) NOT NULL,
	[content] varchar(max) NOT NULL,

	[menu] varchar(255) NOT NULL,
	[menuorder] smallint NOT NULL,
	[menustatus] bit NOT NULL DEFAULT (0),

	[author] VARCHAR(80) NOT NULL,
	[pubdate] smalldatetime NOT NULL,
	CONSTRAINT [PK_Pages] PRIMARY KEY CLUSTERED ([slug] ASC)
)
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE TABLE dbo.settings (
	[key] varchar(50) NOT NULL,
	[value] varchar(255) NOT NULL,
	CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([key] ASC)
)
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE TABLE [dbo].[users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Email] [varchar](80) NOT NULL,
	[Passhash] [varchar(32)], 
	[Deleted] [bit] NOT NULL,
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([ID] ASC)
)

WITH (DATA_COMPRESSION = PAGE)
GO

ALTER TABLE [dbo].[Users] ADD 
CONSTRAINT [DF_Users_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO





/* Highly similar to compressed data demo repository */

CREATE TABLE [dbo].[traffic](
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Traffic_C_CreateDate] DEFAULT GETDATE(),
	[EndPoint] [varchar](50) NOT NULL,
	[Verb] [varchar](10) NOT NULL,
	[IP_checksum] [int] NOT NULL,
	[User_Agent] [varchar](255) NOT NULL
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)

GO


/****** Object:  Index [CIX_CreateDate]    Script Date: 12/26/18 6:07:47 PM ******/
CREATE CLUSTERED INDEX [CIX_CreateDate] ON [dbo].[Traffic]
(
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER INDEX CIX_CreateDate ON dbo.Traffic REBUILD PARTITION = ALL  
WITH (DATA_COMPRESSION = PAGE);
GO


-----------------------------------------

CREATE VIEW [dbo].[vwTraffic] WITH SCHEMABINDING
AS

SELECT Endpoint, Verb, IP_checksum, CONVERT(date, CreateDate) AS CreateDate, COUNT_BIG(*) AS ID_Count
FROM dbo.Traffic
GROUP BY Endpoint, Verb, IP_checksum, CONVERT(date, CreateDate) 
GO



/****** Object:  Index [IX_view]    Script Date: 12/18/18 9:14:24 PM ******/
CREATE UNIQUE CLUSTERED INDEX [IX_view] ON [dbo].[vwTraffic]
(
	[CreateDate] ASC,
	[Endpoint] ASC,
	[Verb] ASC,
	[IP_checksum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER INDEX IX_view ON dbo.vwTraffic REBUILD PARTITION = ALL  
WITH (DATA_COMPRESSION = PAGE);
GO

-- Some access

USE [master]
GO
CREATE LOGIN [PlumaCMS_user] WITH PASSWORD='PlumaCMS_user', DEFAULT_DATABASE=[PlumaCMS], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE PlumaCMS
GO
CREATE USER [PlumaCMS_user] FOR LOGIN [PlumaCMS_user]
GO
ALTER ROLE [db_datareader] ADD MEMBER [PlumaCMS_user]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [PlumaCMS_user]
GO
ALTER ROLE [db_owner] ADD MEMBER [PlumaCMS_user]
GO


USE [ST_Daily]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_Experiment]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_Functional]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_Implement]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_Instructional]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_Release]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_Release_02]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_SPED]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_Stars]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_Train_90]
GO
DBCC SHRINKFILE (N'ST_Production_log' , 0, TRUNCATEONLY)
GO

USE [ST_UTILS]
GO
DBCC SHRINKFILE (N'ST_UTILS_log' , 0, TRUNCATEONLY)
GO

USE [tempdb]
GO
DBCC SHRINKFILE (N'templog' , 0, TRUNCATEONLY)
GO
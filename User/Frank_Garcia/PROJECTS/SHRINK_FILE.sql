USE [db_Transfers] 
GO

-- TRUNCATE TRANSACTION LOG --
DBCC SHRINKFILE(db_Transfers_log, 1)
BACKUP LOG db_Transfers WITH TRUNCATE_ONLY
DBCC SHRINKFILE(db_Transfers_log, 1)
GO

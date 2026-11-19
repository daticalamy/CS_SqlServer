DROP PROCEDURE IF EXISTS dbo.usp_GetTestWidgetByCode3;
GO

DROP VIEW IF EXISTS dbo.v_TestWidgets3;
GO

ALTER TABLE dbo.TestWidgets3 DROP COLUMN Category;
GO

DELETE FROM dbo.TestWidgets3 WHERE WidgetCode = 'WGT-003';
DELETE FROM dbo.TestWidgets3 WHERE WidgetCode = 'WGT-002';
DELETE FROM dbo.TestWidgets3 WHERE WidgetCode = 'WGT-001';
GO

DROP INDEX UX_TestWidgets3_WidgetCode ON dbo.TestWidgets3;
GO

DROP TABLE dbo.TestWidgets3;
GO

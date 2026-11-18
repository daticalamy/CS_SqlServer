CREATE TABLE dbo.TestWidgets (
    WidgetID   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TestWidgets PRIMARY KEY,
    WidgetCode VARCHAR(20)       NOT NULL,
    WidgetName NVARCHAR(100)     NOT NULL,
    Price      DECIMAL(10,2)     NOT NULL CONSTRAINT DF_TestWidgets_Price DEFAULT (0),
    CreatedAt  DATETIME2(0)      NOT NULL CONSTRAINT DF_TestWidgets_CreatedAt DEFAULT (SYSUTCDATETIME())
);
--rollbackSQL DROP TABLE dbo.TestWidgets;
GO

CREATE UNIQUE INDEX UX_TestWidgets_WidgetCode ON dbo.TestWidgets (WidgetCode);
--rollbackSQL DROP INDEX UX_TestWidgets_WidgetCode ON dbo.TestWidgets;
GO

INSERT INTO dbo.TestWidgets (WidgetCode, WidgetName, Price) VALUES ('WGT-001', N'Small Widget', 9.99);
--rollbackSQL DELETE FROM dbo.TestWidgets WHERE WidgetCode = 'WGT-001';
INSERT INTO dbo.TestWidgets (WidgetCode, WidgetName, Price) VALUES ('WGT-002', N'Large Widget', 24.50);
--rollbackSQL DELETE FROM dbo.TestWidgets WHERE WidgetCode = 'WGT-002';
INSERT INTO dbo.TestWidgets (WidgetCode, WidgetName, Price) VALUES ('WGT-003', N'Deluxe Widget', 99.00);
--rollbackSQL DELETE FROM dbo.TestWidgets WHERE WidgetCode = 'WGT-003';
GO

ALTER TABLE dbo.TestWidgets ADD Category NVARCHAR(50) NULL;
--rollbackSQL ALTER TABLE dbo.TestWidgets DROP COLUMN Category;
GO

CREATE OR ALTER VIEW dbo.v_TestWidgets AS
SELECT WidgetID, WidgetCode, WidgetName, Price, Category
FROM dbo.TestWidgets;
--rollbackSQL DROP VIEW IF EXISTS dbo.v_TestWidgets;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTestWidgetByCode
    @WidgetCode VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT WidgetID, WidgetCode, WidgetName, Price, Category
    FROM dbo.TestWidgets
    WHERE WidgetCode = @WidgetCode;
END;
--rollbackSQL DROP PROCEDURE IF EXISTS dbo.usp_GetTestWidgetByCode;
GO
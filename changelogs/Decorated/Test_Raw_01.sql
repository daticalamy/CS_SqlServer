-- liquibase formatted sql

-- changeset daticalamy:1 splitStatements:false
CREATE TABLE dbo.TestWidgets (
    WidgetID   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TestWidgets PRIMARY KEY,
    WidgetCode VARCHAR(20)       NOT NULL,
    WidgetName NVARCHAR(100)     NOT NULL,
    Price      DECIMAL(10,2)     NOT NULL CONSTRAINT DF_TestWidgets_Price DEFAULT (0),
    CreatedAt  DATETIME2(0)      NOT NULL CONSTRAINT DF_TestWidgets_CreatedAt DEFAULT (SYSUTCDATETIME())
);
-- rollback DROP TABLE dbo.TestWidgets;

-- changeset daticalamy:2 splitStatements:false
CREATE UNIQUE INDEX UX_TestWidgets_WidgetCode ON dbo.TestWidgets (WidgetCode);
-- rollback DROP INDEX UX_TestWidgets_WidgetCode ON dbo.TestWidgets;

-- changeset daticalamy:3 splitStatements:false
INSERT INTO dbo.TestWidgets (WidgetCode, WidgetName, Price) VALUES ('WGT-001', N'Small Widget', 9.99);
INSERT INTO dbo.TestWidgets (WidgetCode, WidgetName, Price) VALUES ('WGT-002', N'Large Widget', 24.50);
INSERT INTO dbo.TestWidgets (WidgetCode, WidgetName, Price) VALUES ('WGT-003', N'Deluxe Widget', 99.00);
-- rollback DELETE FROM dbo.TestWidgets WHERE WidgetCode = 'WGT-003';
-- rollback DELETE FROM dbo.TestWidgets WHERE WidgetCode = 'WGT-002';
-- rollback DELETE FROM dbo.TestWidgets WHERE WidgetCode = 'WGT-001';

-- changeset daticalamy:4 splitStatements:false
ALTER TABLE dbo.TestWidgets ADD Category NVARCHAR(50) NULL;
-- rollback ALTER TABLE dbo.TestWidgets DROP COLUMN Category;

-- changeset daticalamy:view.dbo.v_testwidgets splitStatements:false runOnChange:true
CREATE OR ALTER VIEW dbo.v_TestWidgets AS
SELECT WidgetID, WidgetCode, WidgetName, Price, Category
FROM dbo.TestWidgets;
-- rollback DROP VIEW IF EXISTS dbo.v_TestWidgets;

-- changeset daticalamy:procedure.dbo.usp_gettestwidgetbycode splitStatements:false runOnChange:true
CREATE OR ALTER PROCEDURE dbo.usp_GetTestWidgetByCode
    @WidgetCode VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT WidgetID, WidgetCode, WidgetName, Price, Category
    FROM dbo.TestWidgets
    WHERE WidgetCode = @WidgetCode;
END;
-- rollback DROP PROCEDURE IF EXISTS dbo.usp_GetTestWidgetByCode;


-- liquibase formatted sql

-- changeset daticalamy:1 splitStatements:false
CREATE TABLE dbo.TestWidgets2 (
    WidgetID   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TestWidgets2 PRIMARY KEY,
    WidgetCode VARCHAR(20)       NOT NULL,
    WidgetName NVARCHAR(100)     NOT NULL,
    Price      DECIMAL(10,2)     NOT NULL CONSTRAINT DF_TestWidgets2_Price DEFAULT (0),
    CreatedAt  DATETIME2(0)      NOT NULL CONSTRAINT DF_TestWidgets2_CreatedAt DEFAULT (SYSUTCDATETIME())
);
-- rollback DROP TABLE dbo.TestWidgets2;

-- changeset daticalamy:2 splitStatements:false
CREATE UNIQUE INDEX UX_TestWidgets2_WidgetCode ON dbo.TestWidgets2 (WidgetCode);
-- rollback DROP INDEX UX_TestWidgets2_WidgetCode ON dbo.TestWidgets2;

-- changeset daticalamy:3 splitStatements:false
INSERT INTO dbo.TestWidgets2 (WidgetCode, WidgetName, Price) VALUES ('WGT-001', N'Small Widget', 9.99);
INSERT INTO dbo.TestWidgets2 (WidgetCode, WidgetName, Price) VALUES ('WGT-002', N'Large Widget', 24.50);
INSERT INTO dbo.TestWidgets2 (WidgetCode, WidgetName, Price) VALUES ('WGT-003', N'Deluxe Widget', 99.00);
-- rollback DELETE FROM dbo.TestWidgets2 WHERE WidgetCode = 'WGT-003';
-- rollback DELETE FROM dbo.TestWidgets2 WHERE WidgetCode = 'WGT-002';
-- rollback DELETE FROM dbo.TestWidgets2 WHERE WidgetCode = 'WGT-001';

-- changeset daticalamy:4 splitStatements:false
ALTER TABLE dbo.TestWidgets2 ADD Category NVARCHAR(50) NULL;
-- rollback ALTER TABLE dbo.TestWidgets2 DROP COLUMN Category;

-- changeset daticalamy:view.dbo.v_testwidgets2 splitStatements:false runOnChange:true
CREATE OR ALTER VIEW dbo.v_TestWidgets2 AS
SELECT WidgetID, WidgetCode, WidgetName, Price, Category
FROM dbo.TestWidgets2;
-- rollback DROP VIEW IF EXISTS dbo.v_TestWidgets2;

-- changeset daticalamy:procedure.dbo.usp_gettestwidgetbycode2 splitStatements:false runOnChange:true
CREATE OR ALTER PROCEDURE dbo.usp_GetTestWidgetByCode2  
    @WidgetCode VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT WidgetID, WidgetCode, WidgetName, Price, Category
    FROM dbo.TestWidgets2       
    WHERE WidgetCode = @WidgetCode;
END;
-- rollback DROP PROCEDURE IF EXISTS dbo.usp_GetTestWidgetByCode2;


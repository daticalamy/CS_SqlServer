CREATE TABLE dbo.TestWidgets3 (
    WidgetID   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TestWidgets3 PRIMARY KEY,
    WidgetCode VARCHAR(20)       NOT NULL,
    WidgetName NVARCHAR(100)     NOT NULL,
    Price      DECIMAL(10,2)     NOT NULL CONSTRAINT DF_TestWidgets3_Price DEFAULT (0),
    CreatedAt  DATETIME2(0)      NOT NULL CONSTRAINT DF_TestWidgets3_CreatedAt DEFAULT (SYSUTCDATETIME())
);
GO

CREATE UNIQUE INDEX UX_TestWidgets3_WidgetCode ON dbo.TestWidgets3 (WidgetCode);
GO

INSERT INTO dbo.TestWidgets3 (WidgetCode, WidgetName, Price) VALUES ('WGT-001', N'Small Widget', 9.99);
INSERT INTO dbo.TestWidgets3 (WidgetCode, WidgetName, Price) VALUES ('WGT-002', N'Large Widget', 24.50);
INSERT INTO dbo.TestWidgets3 (WidgetCode, WidgetName, Price) VALUES ('WGT-003', N'Deluxe Widget', 99.00);
GO

ALTER TABLE dbo.TestWidgets3 ADD Category NVARCHAR(50) NULL;
GO

CREATE OR ALTER VIEW dbo.v_TestWidgets3 AS
SELECT WidgetID, WidgetCode, WidgetName, Price, Category
FROM dbo.TestWidgets3;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTestWidgetByCode3
    @WidgetCode VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT WidgetID, WidgetCode, WidgetName, Price, Category
    FROM dbo.TestWidgets3   
    WHERE WidgetCode = @WidgetCode;
END;
GO

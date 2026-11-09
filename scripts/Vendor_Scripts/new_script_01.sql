--liquibase formatted sql

--changeset asmith:vendor_script_01
CREATE TABLE dbo.Stores (
    StoreID INT IDENTITY(1,1) PRIMARY KEY,      -- Auto-increments starting at 1
    StoreCode VARCHAR(10) NOT NULL UNIQUE,      -- Unique short identifier (e.g., 'AUS-01')
    StoreName NVARCHAR(100) NOT NULL,           -- Store display name
    City NVARCHAR(50) NOT NULL,
    StateCode CHAR(2) NOT NULL,                 -- Two-letter state abbreviation
    ZipCode VARCHAR(10) NOT NULL,
    MonthlyRent DECIMAL(10, 2) NOT NULL,        -- Exact numeric for currency
    IsActive BIT NOT NULL DEFAULT 1,            -- 1 = Open/Active, 0 = Closed
    OpenedDate DATE NOT NULL DEFAULT GETDATE()  -- Defaults to current date
);
GO
--rollback drop table dbo.Stores

--changeset asmith:vendor_script_data_01
INSERT INTO dbo.Stores (StoreCode, StoreName, City, StateCode, ZipCode, MonthlyRent, IsActive, OpenedDate)
VALUES ('AUS-01', N'Downtown Flagship', N'Austin', 'TX', '78701', 12500.00, 1, '2024-05-15');
--rollback delete from dbo.Stores where StoreCode='AUS-01';
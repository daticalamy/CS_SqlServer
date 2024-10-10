--liquibase formatted sql
--changeset asmith:01 labels:POCEnv

CREATE VIEW [dbo].[table_01_vw]
AS 
SELECT ID, NAME
from [dbo].[table_01];

--rollback DROP VIEW dbo.table_01_vw
--liquibase formatted sql
--changeset asmith:01 labels:POCEnv

CREATE OR ALTER PROCEDURE dbo.test_proc_01
AS
SELECT '1' from dbo.table_01;
--rollback DROP PROCEDURE dbo.test_proc_01;
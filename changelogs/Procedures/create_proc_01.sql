--liquibase formatted sql

--changeset asmith:dept_proc_001
CREATE OR ALTER PROCEDURE dbo.dept_proc_001
AS
SELECT '1' from dbo.dept_proc_001;
--rollback DROP PROCEDURE dbo.dept_proc_001;
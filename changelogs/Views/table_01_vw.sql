--liquibase formatted sql

--changeset amy_smith:v_dept_001
CREATE OR ALTER VIEW dbo.v_dept_001 AS
SELECT 
    id AS DepartmentID,
    name AS DepartmentName,
    loc AS Location
FROM dbo.dept_001;
--rollback DROP VIEW IF EXISTS dbo.v_dept_001;
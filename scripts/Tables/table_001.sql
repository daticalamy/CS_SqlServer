--liquibase formatted sql

--changeset amy_smith:dept_001
create table dbo.dept_001 (
  id int, 
  name varchar(30),
  loc varchar(30) 
);
--rollback drop table dbo.dept_001
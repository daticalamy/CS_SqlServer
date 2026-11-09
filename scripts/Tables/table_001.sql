--liquibase formatted sql

--changeset amy_smith:dept_001
create table dbo.dept_001 (
  id int, 
  name varchar(30),
  loc varchar(30) 
);
--rollback drop table dbo.dept_001

--changeset amy_smith:dept_001_add_code_01
alter table dbo.dept_001 add code_01 varchar(10);
--rollback alter table dbo.dept_001 drop column code_01;
--liquibase formatted sql

--changeset amy_smith:dept_001 context:PROD
create table dbo.dept_001 (
  id int, 
  name varchar(30),
  loc varchar(30) 
);
--rollback drop table dbo.dept_001

--changeset amy_smith:dept_001_add_code_01 context:!DEV
alter table dbo.dept_001 add code_01 varchar(10);
--rollback alter table dbo.dept_001 drop column code_01;

--changeset amy_smith:dept_001_add_code_03 context:!DEV
alter table dbo.dept_001 add code_03 varchar(10);
--rollback alter table dbo.dept_001 drop column code_03;

--changeset amy_smith:dept_001_add_code_04
alter table dbo.dept_001 add code_04 varchar(10);
--rollback alter table dbo.dept_001 drop column code_04;
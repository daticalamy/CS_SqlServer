--liquibase formatted sql

--changeset amy_smith:01
--preconditions onFail:MARK_RAN 
--precondition-sql-check expectedResult:0 SELECT count(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'table_13'
create table dbo.table_13 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_13

--changeset asmith:drop_table13
drop table dbo.table_13;
--rollback create table dbo.table_13 (
--rollback   id int, 
--rollback   name varchar(50),
--rollback   sku varchar(30) 
--rollback );

--changeset asmith:create_table13.v2
create table dbo.table_13 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollbackSqlFile path:scripts/Rollbacks/table_13-rollback.sql
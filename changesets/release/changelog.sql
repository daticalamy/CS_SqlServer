--liquibase formatted sql

--changeset amy_smith:01 labels:POCEnv
create table dbo.table_01 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_01

--changeset amy_smith:02 labels:POCEnv
create table dbo.table_02 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_02

--changeset amy_smith:03
create table dbo.table_03 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_03

--changeset amy_smith:04
create table dbo.table_04 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_04
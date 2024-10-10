--liquibase formatted sql
--changeset amy_smith:01 labels:POCEnv

create table dbo.table_02 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_02
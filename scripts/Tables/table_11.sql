--liquibase formatted sql

--changeset amy_smith:01 context:!DEV
create table dbo.table_11 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_11


--liquibase formatted sql

--changeset amy_smith:01
create table dbo.table_14 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_14
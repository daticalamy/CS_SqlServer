--liquibase formatted sql
--changeset amy_smith:01 labels:POCEnv

create table cbae.table_01x (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table cbae.table_01x
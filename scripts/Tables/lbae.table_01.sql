--liquibase formatted sql
--changeset amy_smith:01 labels:pocenv

create table lbae.table_01x (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table lbae.table_01x
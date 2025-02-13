--liquibase formatted sql

--changeset amy_smith:01 labels:POCEnv
create table dbo.table_08 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_08

--changeset amy_smith:02 labels:POCEnv
CREATE UNIQUE INDEX table_08_sku
ON dbo.table_08 (sku);
--rollback DROP INDEX table_08_sku ON dbo.table_08;
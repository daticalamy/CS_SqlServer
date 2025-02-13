--liquibase formatted sql

--changeset amy_smith:01 labels:POCEnv
create table dbo.table_09 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_09

--changeset amy_smith:02 labels:hotfix1
CREATE UNIQUE INDEX table_09_sku
ON dbo.table_09 (sku);
--rollback DROP INDEX table_09_sku ON dbo.table_09;

--changeset amy_smith:03
ALTER TABLE dbo.table_09 
ADD column_b VARCHAR(20) NULL, column_c INT NULL ;
--rollback ALTER TABLE dbo.table_09 DROP COLUMN column_b; ALTER TABLE dbo.table_09 DROP COLUMN column_c;
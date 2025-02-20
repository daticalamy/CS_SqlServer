--liquibase formatted sql

--changeset amy_smith:01
create table dbo.table_10 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_10

--changeset amy_smith:02 labels:hotfix1
CREATE UNIQUE INDEX table_10_sku
ON dbo.table_10 (sku);
--rollback DROP INDEX table_10_sku ON dbo.table_10;

--changeset amy_smith:03
ALTER TABLE dbo.table_10 
ADD column_b VARCHAR(20) NULL;
--rollback ALTER TABLE dbo.table_10 DROP COLUMN column_b;


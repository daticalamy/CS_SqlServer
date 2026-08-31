--liquibase formatted sql

--changeset liquibase-docs:tagDatabase-v15
--tagDatabase: 'version_15.0.0'

--changeset amy_smith:01
create table dbo.table_15 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_15

--changeset amy_smith:01-alter
ALTER TABLE dbo.table_15
ADD status_01 char(1);
--rollback ALTER TABLE dbo.table_15 drop status_01;

--changeset amy_smith:02-alter
ALTER TABLE dbo.table_15
ADD status_02 char(1);

--changeset amy_smith:03-alter
ALTER TABLE dbo.table_15
ADD status_03 char(1);
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

--changeset amy_smith:05
create table dbo.table_05 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_05

--changeset amy_smith:01_cbae labels:cbae
create table cbae.table_01 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table cbae.table_01

--changeset amy_smith:01_lbae labels:lbae
create table lbae.table_01 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table lbae.table_01

--changeset amy_smith:01_pt labels:pt
create table property_tax.table_01 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table property_tax.table_01

--changeset amy_smith:02_pt labels:pt
create table property_tax.table_02 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table property_tax.table_02

--changeset amy_smith:03_pt context:!PROD
create table property_tax.table_03 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table property_tax.table_03

--changeset amy_smith:04_pt context:!PROD
create table property_tax.table_04 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table property_tax.table_04

--changeset amy_smith:05_pt
create table property_tax.table_05 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table property_tax.table_05

--changeset amy_smith:06_pt labels:hotfix2
create table property_tax.table_06 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table property_tax.table_06

--changeset amy_smith:07_pt
create table property_tax.table_07 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table property_tax.table_07

--changeset amy_smith:08_pt
create table property_tax.table_08 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table property_tax.table_08
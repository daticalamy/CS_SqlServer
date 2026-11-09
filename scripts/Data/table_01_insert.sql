--liquibase formatted sql

--changeset amy_smith:01 labels:pocenv
create table dbo.table_01 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_01

--changeset amy_smith:01-insert-01 labels:uat-457
insert into dbo.table_01 (1, 'name_01', 'sku_01');
--rollback delete from dbo.table_01 where id = 1;
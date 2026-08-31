--liquibase formatted sql

--changeset amy_smith:01 ignore:true
create table dbo.table_10 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_10

--changeset amy_smith:02
insert into dbo.table_10 (id, name, sku) values (1, 'Amy', '01');
--rollback delete from dbo.table_10  where id = 1;
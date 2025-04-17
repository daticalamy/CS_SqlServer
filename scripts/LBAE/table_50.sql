--liquibase formatted sql

--changeset amy_smith:01
--validCheckSum: 9:fe77003539661dff455ed59c976f0f71
create table ${schemaName}.table_50 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table ${schemaName}.table_50
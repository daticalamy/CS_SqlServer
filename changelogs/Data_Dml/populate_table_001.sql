--liquibase formatted sql

--changeset amy_smith:dept_001_insert_01
insert into dbo.dept_001 (id, name, loc) values (1, 'ACCOUNTING', 'NEW YORK');
--rollback delete from dbo.dept_001 where id = 1;
--liquibase formatted sql
--changeset asmith:01 labels:POCEnv

CREATE OR REPLACE PROCEDURE test_proc_01()
BEGIN
  DECLARE id STRING;
  SET id = GENERATE_UUID();
  INSERT INTO table_01 (id,name,location)
    VALUES(id, 'Amy','Test');
  SELECT FORMAT("Created row %s", id);
END
--rollback DROP PROCEDURE test_proc_01;
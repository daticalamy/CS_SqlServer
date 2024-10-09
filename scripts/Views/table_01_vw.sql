--liquibase formatted sql
--changeset asmith:01 labels:POCEnv

CREATE OR REPLACE VIEW TEST_SET_01.table_01_vw(id, name) AS (
  SELECT
    id, name
  FROM
    TEST_SET_01.table_01
  ORDER BY
    id, name DESC
);

--rollback DROP VIEW TEST_SET_01.table_01_vw
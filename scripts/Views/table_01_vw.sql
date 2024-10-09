--liquibase formatted sql
--changeset asmith:01 labels:POCEnv

CREATE OR REPLACE VIEW table_01_vw(id, name) AS (
  SELECT
    id, name
  FROM
    table_01
  ORDER BY
    id, name DESC
);

--rollback DROP VIEW table_01_vw
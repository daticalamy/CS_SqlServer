--liquibase formatted sql
--changeset amy_smith:01 labels:POCEnv

create table table_01
(
id string(32),
name  STRING(40),
location STRING(10),
GRANT_ID STRING(10),
PARTC_ID STRING(10),
AWRD_ID STRING(10),
DW_EFF_DT DATE,
DW_EXPR_DT DATE
)
;
--rollback drop table table_01
--liquibase formatted sql

--changeset amy_smith:01
--preconditions onFail:MARK_RAN 
--precondition-sql-check expectedResult:0 SELECT count(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'table_13'
create table dbo.table_13 (
  id int, 
  name varchar(50),
  sku varchar(30) 
);
--rollback drop table dbo.table_13


--changeset bziegler:ado-FA1-task0-1
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT count(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Brad_TestLiquibase'
CREATE TABLE dbo.Brad_TestLiquibase
(
    SSInstance_nme         varchar(120) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    Host_nme               varchar(125) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    SSDescription_txt      varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    SSInstanceInactive_dtm datetime     NULL,
    Environment_cde        char(3)      COLLATE SQL_Latin1_General_CP1_CI_AS CONSTRAINT ihin_Environment_cde_def DEFAULT 'DEV' NOT NULL,
    SSInstanceTier_nbr     smallint     CONSTRAINT DF__ihin_Host__SSIns__54CB950F DEFAULT 1 NULL,
    LicenseModel_txt       varchar(23)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    GenerateData_ind       char(1)      COLLATE SQL_Latin1_General_CP1_CI_AS CONSTRAINT DF__ihin_Host__Gener__55BFB948 DEFAULT 'Y' NULL,
    RowCreate_id           varchar(20)  COLLATE SQL_Latin1_General_CP1_CI_AS CONSTRAINT ihin_RowCreate_id_def DEFAULT user_name() NOT NULL,
    RowCreate_Dtm          datetime     CONSTRAINT ihin_RowCreate_dtm_def DEFAULT getdate() NOT NULL,
    RowModify_id           varchar(20)  COLLATE SQL_Latin1_General_CP1_CI_AS CONSTRAINT ihin_RowModify_id_def DEFAULT user_name() NULL,
    RowModify_Dtm          datetime     CONSTRAINT ihin_RowModify_dtm_def DEFAULT getdate() NOT NULL,
    SSErrorLogForce_ind    char(1)      COLLATE SQL_Latin1_General_CP1_CI_AS CONSTRAINT DF__ihin_Host__SSErr__39AD8A7F DEFAULT 'N' NULL,
    Gentax_ind             char(1)      COLLATE SQL_Latin1_General_CP1_CI_AS CONSTRAINT DF__ihin_Host__Genta__4C214075 DEFAULT 'N' NOT NULL,
    DBPerfDir_nme          varchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT Bradc01
    PRIMARY KEY CLUSTERED (SSInstance_nme)
)
go
--rollback DROP TABLE dbo.Brad_TestLiquibase;

 
--changeset bziegler:ado-FA1-task0-2
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 select count(*) from INFORMATION_SCHEMA.KEY_COLUMN_USAGE where CONSTRAINT_SCHEMA = 'dbo' and CONSTRAINT_NAME = 'Bradx02' and TABLE_Schema = 'FA1' and TABLE_NAME = 'Brad_TestLiquibase'
CREATE NONCLUSTERED INDEX Bradx02
    ON dbo.Brad_TestLiquibase(Host_nme)
  WITH (
        PAD_INDEX = OFF
       )
go
--rollback DROP INDEX Bradx02 ON dbo.Brad_TestLiquibase;

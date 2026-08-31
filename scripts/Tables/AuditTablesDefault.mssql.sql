-- liquibase formatted sql

-- changeset AmySmith:1788185493003-29 splitStatements:false ignore:true
CREATE TABLE AuditTablesDefault (TableID int IDENTITY (14, 1) NOT NULL, Owner sysname NOT NULL, TableName sysname NOT NULL, AuditTable bit NOT NULL, AuditInserts bit NOT NULL, AuditUpdates bit NOT NULL, AuditDeletes bit NOT NULL, AuditDeletesAll bit NOT NULL, UniqueKeyType char(1) NOT NULL, UserColumn sysname CONSTRAINT DF__AuditTabl__UserC__054F9C31 DEFAULT A NOT NULL);

-- changeset AmySmith:1788185493003-210 splitStatements:false ignore:true
ALTER TABLE AuditTablesDefault ADD CONSTRAINT PK_AuditTables2 PRIMARY KEY NONCLUSTERED (TableID);


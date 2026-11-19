# Rollbacks

Rollback files for changelogs in `changelogs/Decorated/`. The Decorate flow moves each
`raw_sql/<name>.rollback.sql` here, and the generated changelog points to it:

```
-- rollbackSqlFile path:changelogs/Rollbacks/<name>.rollback.sql
```

- Liquibase reads these files whenever a rollback runs, so keep them in the repo.
- Once a change is deployed, don't rename, move, or delete its rollback file.
- Never add this folder to `changelogs/changelog.yaml`. The SQL here would run as
  forward changes.

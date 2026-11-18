# raw_sql

Put plain SQL Server scripts here. The **Decorate** workflow turns them into
Liquibase changelogs with
[`decorate-sql`](https://docs.liquibase.com/secure/reference-guide-6-0-2/decorate-sql),
so you don't write any Liquibase syntax: no header and no `--changeset` lines.

## How it works

1. Add your script to `raw_sql/` on a feature branch (not `main`) and push.
2. The Decorate workflow runs `flowfiles/liquibase-decorate.flowfile.yaml`:
   - **Decorate** writes `changelogs/Decorated/<name>.sql` for each script.
   - **Archive** moves the raw scripts to `raw_sql/processed/`.
3. The workflow commits both changes back to your branch. Pull to get them.
4. Review the generated changelog in your pull request, run **Checks** and
   **Premerge**, then merge and run **Build**.

Build stops if any `.sql` file is still sitting directly in `raw_sql/`.

## Adding a rollback

Build and Premerge deploy, roll back, and redeploy every change, so each change
needs a rollback. There are two ways to supply one:

| Files | Rollback comes from |
|---|---|
| `<name>.sql` | `--rollbackSQL` markers inside the script |
| `<name>.sql` + `<name>.rollback.sql` | The `.rollback.sql` file |

A script with no markers and no `.rollback.sql` file still decorates, but its
changesets have no rollback, so Premerge and Build will fail on it.

### Option 1: markers in the script

Put a `--rollbackSQL` line directly after each statement:

```sql
CREATE TABLE dbo.Regions (
    RegionID   INT IDENTITY(1,1) PRIMARY KEY,
    RegionName NVARCHAR(50) NOT NULL
);
--rollbackSQL DROP TABLE dbo.Regions;
GO

INSERT INTO dbo.Regions (RegionName) VALUES (N'North');
--rollbackSQL DELETE FROM dbo.Regions WHERE RegionName = N'North';
GO
```

- Use a space after `--rollbackSQL`, not a colon.
- `-- rollback` (without `SQL`) is treated as an ordinary comment.

### Option 2: a separate rollback file

`20261118_1100_ABC-124_add_gadgets.sql`

```sql
CREATE TABLE dbo.Gadgets (
    GadgetID   INT IDENTITY(1,1) PRIMARY KEY,
    GadgetName NVARCHAR(50) NOT NULL
);
GO

CREATE OR ALTER VIEW dbo.v_Gadgets AS
SELECT GadgetID, GadgetName FROM dbo.Gadgets;
GO
```

`20261118_1100_ABC-124_add_gadgets.rollback.sql`

```sql
DROP VIEW IF EXISTS dbo.v_Gadgets;
GO

DROP TABLE IF EXISTS dbo.Gadgets;
GO
```

- The rollback file must undo the **whole** script, in reverse order.
- When a `.rollback.sql` file exists, `--rollbackSQL` markers in the main script
  are ignored.

## Rules

- **Name files so they sort in deploy order and are unique**, for example
  `YYYYMMDD_HHMM_<TICKET>_<description>.sql`. A name can only be used once,
  unless you're redoing a script that hasn't been deployed (see below).
- **Write for SQL Server.** Put `GO` on its own line.
- **Leave out transaction control** (`BEGIN TRAN`, `COMMIT`, `ROLLBACK`,
  `SAVE TRAN`). Liquibase runs each changeset in its own transaction.
- **Save files as UTF-8.**
- **Contexts aren't added.** Decorated changesets deploy to every environment. If a
  change should only deploy to some environments, add `context:` (for example
  `context:PROD`) to the changeset lines in the generated file before it's deployed.
- **Views and procedures you'll keep changing** are easier to maintain as formatted
  SQL in `changelogs/Views/` or `changelogs/Procedures/`, where you edit one
  definition in place.

## Changing a script

What you can change depends on whether the change has been **deployed**, meaning
Build (or Deploy) has run it against a real environment such as DEV. Premerge
doesn't count, because it uses a throwaway copy of DEV.

### Before it has been deployed: change anything

Nothing has been recorded in a database yet, so you're free to:

- **Edit the generated changelog** in `changelogs/Decorated/` directly, for example
  to fix SQL, adjust a rollback, or add a `context:`.
- **Rename or delete** files in `changelogs/Decorated/`.
- **Decorate the script again** from scratch:
  1. Delete the generated changelog: `changelogs/Decorated/<name>.sql`
  2. Delete the processed copy: `raw_sql/processed/<name>.sql`
     (and `raw_sql/processed/<name>.rollback.sql`, if there is one)
  3. Put the fixed script (and rollback file) back in `raw_sql/` and push.

  Both deletes are required. `decorate-sql` won't overwrite an existing changelog,
  and the Archive stage can't move a script onto a processed file of the same name.

### After it has been deployed: don't change it

Liquibase records every deployed changeset in the database by its **ID, author,
and file path**, plus a checksum of its SQL. After deployment:

- **Don't edit the SQL** in the generated changelog. Liquibase sees the checksum
  change and the next deployment fails.
- **Don't decorate the script again.** Most changesets are numbered in file order,
  so an edited script can get different IDs. Liquibase then fails on the checksum,
  or tries to run statements that already ran.
- **Don't rename or move** the file in `changelogs/Decorated/`. Liquibase would see
  its changesets as new and try to run them again.

To change something that's already deployed, **add a new script**.

One exception: a changeset that holds a single `CREATE OR ALTER` view or procedure
is named after the object and marked `runOnChange:true`. Editing it after deployment
simply redeploys the new definition.

## Reviewing the generated changelog

`decorate-sql` copies your SQL as written and doesn't check that it's valid. In the
pull request, check that:

- statements were split into changesets the way you expect,
- each changeset has the rollback you intended,
- contexts are right for where the change should deploy.

Then run **Premerge** to prove the change deploys and rolls back on a copy of DEV.

## Troubleshooting

| Problem | Fix |
|---|---|
| Decorate fails because the output file already exists | Use a new file name, or, if the earlier version was never deployed, follow the redo steps above |
| Archive fails on `git mv` | A script with that name was already processed. Use a new name, or delete the processed copy if it was never deployed |
| Decorate fails with a dialect error | Make sure the script is SQL Server syntax |
| Decorate fails with an encoding error | Re-save the script as UTF-8 |
| Premerge fails during rollback | Add markers or a `.rollback.sql` file and redo the script, or fix the rollback in `changelogs/Decorated/` |

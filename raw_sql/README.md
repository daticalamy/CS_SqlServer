# raw_sql: Best Practices for decorate-sql

Drop plain SQL Server scripts here when you don't want to hand-write Liquibase
formatted SQL. On a feature branch, the **Decorate** workflow
(`.github/workflows/decorate_action.yml`) runs
[`decorate-sql`](https://docs.liquibase.com/secure/reference-guide-6-0-2/decorate-sql)
on them, writes the changelog to `changelogs/Decorated/`, moves the raw script to
`raw_sql/processed/`, and commits both back to your branch. You then review the
generated changelog in your pull request like any other change.

```
feature branch                         pull request                main
──────────────                         ────────────                ────
push raw_sql/20261117_1030_ABC-123_add_regions.sql
        │
        ▼
Decorate workflow ── commits ──► changelogs/Decorated/<same name>.sql
                                 raw_sql/processed/<same name>.sql
                                        │
                                        ▼
                                 Checks (policy) + review  ──► merge ──► Build (DEV) ──► Deploy (QA/PROD)
```

Build refuses to run if any `.sql` file is still sitting directly in `raw_sql/`.

## The rules

### 1. One new file per change, never edit a decorated script

- Name files so they sort in deploy order and never collide:
  `YYYYMMDD_HHMM_<TICKET>_<short_description>.sql`, for example
  `20261117_1030_ABC-123_add_regions.sql`.
- Once a script is decorated, the changelog in `changelogs/Decorated/` is the
  source of truth. **Do not re-decorate it.** Changesets that aren't named after an
  object are numbered 1, 2, 3 in file order, so inserting a statement and
  decorating again renumbers everything after it and breaks the checksum check.
- To change something that's already decorated, add a **new** raw script.
- Never run `clear-checksums` to get past a checksum error caused by re-decorating.
- Never rename or move files in `changelogs/Decorated/`. The generated changelog
  has no `logicalFilePath`, so Liquibase identifies its changesets by their path.

The workflow enforces the "never overwrite" part: if the output or processed file
already exists, it fails and asks you to pick a new name.

### 2. Add a rollback for every statement

Build runs `update-testing-rollback`, which deploys, rolls back, and redeploys.
Raw SQL can't be inverted automatically, so every statement needs a marker on the
line **directly after it**:

```sql
CREATE TABLE dbo.Regions (RegionID INT PRIMARY KEY, RegionName NVARCHAR(50) NOT NULL);
--rollbackSQL DROP TABLE dbo.Regions;
```

- The keyword is `--rollbackSQL` (case-insensitive, `-- rollbackSQL` also works).
- Separate it from the SQL with a space, **not a colon**. `--rollbackSQL: DROP ...`
  captures nothing.
- `-- rollback DROP ...` is **not** a marker in raw SQL. It is kept as a comment.
- End each rollback statement with `;` before any trailing comment.
- Avoid string literals that end in a backslash (`'C:\'`, `ESCAPE '\'`). Use
  `'C:' + CHAR(92)` and `ESCAPE '!'` instead.

The Decorate workflow fails your branch if any generated changeset has no rollback,
so you find out before Build does.

### 3. Write it for SQL Server, the way sqlcmd would accept it

- `GO` on its own line ends a batch (a trailing `-- comment` is fine).
  `GO;` and `GO /* x */` do **not** end a batch.
- `GO 5` (a repeat count) is refused. Repeat the statements or use a loop.
  `GO 1` is fine.
- Oracle syntax (`CREATE OR REPLACE`, a `/` alone on a line) makes the run fail.
- Save files as UTF-8 (a BOM is fine).

### 4. Leave transaction control out

Each generated changeset runs in its own transaction.

| In your script | What happens |
|---|---|
| `BEGIN TRAN`, `COMMIT` | Removed automatically |
| `SAVE TRANSACTION`, `ROLLBACK` | **Run fails**, because the result would differ from your script |
| `SET TRANSACTION ISOLATION LEVEL` | Kept as its own changeset that runs on every deploy |

Remove `SAVE TRANSACTION` / `ROLLBACK` before you push. Our pipeline deliberately
does **not** pass `--allow-txn-control-loss`.

### 5. Know how statements become changesets

- Each DDL statement gets its own changeset.
- Back-to-back DML (`INSERT`/`UPDATE`/`DELETE`) is grouped into **one** changeset
  until another kind of statement interrupts it. If one statement in the group
  fails, Liquibase can't resume mid-group. Separate large or risky DML into its own
  script, or put a DDL statement between groups.
- A `GO` batch that declares a variable (`DECLARE @x`) stays together.
- A single `CREATE OR ALTER` view/procedure/function gets `runOnChange:true` and an
  ID named after the object (for example `view.dbo.v_regions`).

**Views and procedures you will keep changing** are usually better written directly
in `changelogs/Views/` or `changelogs/Procedures/` as formatted SQL, where you edit
the one definition in place.

### 6. Contexts, labels, and author

- `decorate-sql` adds no `context`, so decorated changesets deploy to **every**
  environment. If a change must be PROD-only (or similar), add `context:PROD` to the
  changeset line in the generated file during PR review, before it's deployed
  anywhere.
- The author on each changeset is the GitHub user who pushed the script.

### 7. Review the generated changelog in the PR

`decorate-sql` does not check that your SQL is valid. It copies each statement as
written. Before approving, check:

- statements were split and grouped where you expect,
- each changeset has the rollback you intended,
- contexts are right for where it should deploy,
- the Checks workflow's policy report is clean.

Then run **Premerge** to prove it deploys and rolls back on a clone of DEV.

## Example script

`raw_sql/20261117_1030_ABC-123_add_regions.sql`

```sql
CREATE TABLE dbo.Regions (
    RegionID   INT IDENTITY(1,1) PRIMARY KEY,
    RegionName NVARCHAR(50) NOT NULL
);
--rollbackSQL DROP TABLE dbo.Regions;
GO

INSERT INTO dbo.Regions (RegionName) VALUES (N'North');
--rollbackSQL DELETE FROM dbo.Regions WHERE RegionName = N'North';
INSERT INTO dbo.Regions (RegionName) VALUES (N'South');
--rollbackSQL DELETE FROM dbo.Regions WHERE RegionName = N'South';
GO

CREATE OR ALTER VIEW dbo.v_Regions AS
SELECT RegionID, RegionName FROM dbo.Regions;
--rollbackSQL DROP VIEW IF EXISTS dbo.v_Regions;
GO
```

This becomes three changesets: the table, the two inserts grouped together (their
rollbacks run in reverse order), and the view with `runOnChange:true`.

## Troubleshooting

| Error | Meaning | Fix |
|---|---|---|
| `LB-CMD-0003` / `LB-CMD-0032` | Output changelog already exists | Use a new file name. Don't overwrite. |
| `LB-CMD-0033` | Script isn't UTF-8 | Re-save as UTF-8 |
| `LB-CMD-0039` | Script is empty or comments only | Add SQL or remove the file |
| `LB-CHG-0040` | `--rollbackSQL` marker has no statement above it | Move it below the statement it undoes |
| `LB-CMD-0021` / `LB-CMD-0029` | Wrong dialect | This repo decorates as `mssql` |
| `LB-RLB-0001` (in Build) | A changeset has no rollback | Add a `-- rollback` line to that changeset in `changelogs/Decorated/` |

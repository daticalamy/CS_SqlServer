# Liquibase Secure GitHub Actions for SQL Server

This repository contains GitHub Actions workflows for managing SQL Server database changes with Liquibase Secure. The workflows cover a full database DevOps pipeline: building, policy checks, pre-merge validation in an ephemeral database, environment-targeted deployments with drift detection, rollbacks, and day-to-day utilities.

## Overview

Every workflow follows the same pattern:

1. Check out the repo.
2. Set up Java and Liquibase Secure (and optionally trust a private CA certificate for Liquibase Platform) with the `setup-liquibase` composite action.
3. Run a Liquibase [flow file](https://docs.liquibase.com/flow) that orchestrates the actual database operations.
4. Upload the generated reports as a GitHub Actions artifact with the `upload-reports` composite action.

All workflows are started manually (`workflow_dispatch`) and target a GitHub **environment** (for example DEV, QA, PROD). Environment-specific connection details come from that environment's variables and secrets, and the environment name is also used as the Liquibase **context filter**, so changesets only deploy to the environments their `context` allows.

Operation data is sent to Liquibase Platform (Change Intelligence), and database snapshots used for drift detection are stored in Azure Blob Storage.

## Repository Layout

```
.github/workflows/
  build_action.yml              # Build on the first environment (e.g. DEV)
  checks_action.yml             # Policy checks only
  deploy_action.yml             # Environment-targeted deployment
  premerge_action.yml           # Validation in an ephemeral database clone
  rollback_action.yml           # Rollback by tag, count, changeset, or update
  utilities_action.yml          # Ad hoc Liquibase utilities
  setup-liquibase/action.yml    # Composite: Java + Liquibase Secure + CA cert
  install-mssql-client-tools/action.yml  # Composite: go-sqlcmd
  upload-reports/action.yml     # Composite: upload reports artifact
certs/
  cs-ci-ca.cer                  # CA certificate trusted by the JDK
changelogs/
  changelog.yaml                # Root changelog
  Tables/  Procedures/  Views/  Vendor_Scripts/   # Formatted SQL changesets
flowfiles/
  liquibase-*.flowfile.yaml     # One flow file per workflow
policychecks/
  liquibase.checks-settings.conf  # Policy checks configuration
```

## Workflows

### 1. Build (`build_action.yml`)

Builds pending changes on the first database environment, typically DEV.

| Input | Type | Description |
|---|---|---|
| `environment` | environment | Target environment (default `DEV`) |
| `lb_tag` | string | Optional tag; defaults to the branch name |

Flow (`liquibase-build.flowfile.yaml`): validate → status (exits successfully if nothing is pending) → policy checks on pending changesets → tag → `update-testing-rollback` (deploys, rolls back, and redeploys to prove every changeset is rollback-safe) → history. A failing policy check stops the build.

### 2. Checks (`checks_action.yml`)

Runs policy checks against pending changesets without changing the database.

| Input | Type | Description |
|---|---|---|
| `environment` | environment | Environment whose pending changesets are checked (default `DEV`) |

Flow (`liquibase-checks.flowfile.yaml`): runs `checks run` with `changeset-filter: PENDING` and the environment's context filter. If any check returns exit code 2 or higher, the flow exits with a "requires manual approval" message. The workflow step uses `continue-on-error`, so the job itself still completes and the checks report is uploaded.

**Using Checks as a pull request requirement:** This workflow has been made a required status check so that pull requests cannot be merged until the pending changesets pass policy checks. To set this up, in the repository's branch protection rules (or rulesets) for the target branch, enable **Require status checks to pass before merging** and select the `database-checks` job.

### 3. Deploy (`deploy_action.yml`)

Deploys pending changesets to the selected environment.

| Input | Type | Description |
|---|---|---|
| `environment` | environment | Target environment |
| `lb_tag` | string | Optional tag; defaults to the branch name |
| `dry_run` | boolean | Generate SQL only; make no database changes (default `false`) |
| `check_drift` | boolean | Compare the database against its last snapshot first (default `true`) |

Flow (`liquibase-deploy.flowfile.yaml`):

1. **Drift detection** (if `check_drift`): diffs the database against `<ENV>-snapshot.json` in Azure Storage and fails on drift.
2. **Validate** the changelog.
3. **Status**: exits successfully if the database is already up to date.
4. **Policy checks** on pending changesets.
5. **Dry run** (if `dry_run`): `update-sql` to produce the SQL that would run.
6. **Tag and update** (if not `dry_run`): tags the database, then runs `update` with the environment's context filter.
7. **Always**: takes a fresh snapshot to Azure Storage (unless dry run) to serve as the baseline for the next drift check, then prints history.

### 4. Premerge (`premerge_action.yml`)

Validates changes against a throwaway copy of the DEV database before code is merged. A `pull_request` trigger is included but commented out.

Flow (`liquibase-premerge.flowfile.yaml`):

1. Validate, status, and policy checks.
2. Create an ephemeral clone (`<database>_eph`) with `DBCC CLONEDATABASE`, make it writable, and copy in the `DATABASECHANGELOG` rows from the source database.
3. Tag the clone and run `update-testing-rollback` against it, then print history.
4. **Always**: drop the ephemeral database.

Requires the `install-mssql-client-tools` action (for `sqlcmd`) and the premerge-specific secrets listed below.

### 5. Rollback (`rollback_action.yml`)

Rolls back changes in the selected environment.

| Input | Type | Description |
|---|---|---|
| `environment` | environment | Target environment |
| `rollback_type` | choice | `rollback_to_tag`, `rollback_count`, `rollback_one_changeset`, or `rollback_one_update` |
| `dry_run` | boolean | Generate rollback SQL only (default `false`) |
| `lb_tag` | string | Required for `rollback_to_tag` |
| `lb_count` | string | Required for `rollback_count` |
| `lb_changeset_id`, `lb_changeset_author`, `lb_changeset_path` | string | Required for `rollback_one_changeset` |
| `lb_deployment_id` | string | Optional for `rollback_one_update`; if blank, the most recent update is rolled back |

A small validation job runs first for the selected rollback type and fails fast if a required input is missing. The flow (`liquibase-rollback.flowfile.yaml`) then runs the matching rollback command (or its `-sql` variant for a dry run), takes a fresh snapshot to Azure Storage, and prints history.

### 6. Utilities (`utilities_action.yml`)

Runs a single Liquibase utility command against the selected environment.

| Input | Type | Description |
|---|---|---|
| `environment` | environment | Target environment |
| `utility` | choice | `changelog-sync`, `connect`, `diff`, `diff-changelog`, `generate-changelog`, `history`, `release-locks`, `snapshot`, `status` |
| `reference_snapshot` | choice | `DEV`, `QA`, or `PROD`; the snapshot to compare against for `diff` and `diff-changelog` |

Notes on specific utilities:

- `snapshot` saves `<ENV>-snapshot.json` to Azure Storage. Run it once per environment to create the baseline used by drift detection.
- `diff` compares the environment against the chosen reference snapshot and produces a drift report.
- `diff-changelog` and `generate-changelog` write SQL changelogs (one file per table) to `generatechangelogs/<ENV>/`, which are uploaded as a separate artifact.
- `changelog-sync` marks pending changesets (for the environment's context) as deployed without running them.

## Composite Actions

### Setup Liquibase (`setup-liquibase`)

- Installs Java 17 (Temurin).
- Installs Liquibase Secure 6.0.2 via `liquibase/setup-liquibase@v3`.
- Optionally imports a CA certificate into the JDK truststore (input `ca-cert-path`, alias `ca-cert-alias`). This is needed when the Liquibase Platform endpoint uses a private CA, because the JDK does not trust certificates from the operating system's store. All workflows pass `certs/cs-ci-ca.cer`.

### Install MSSQL Client Tools (`install-mssql-client-tools`)

Downloads the latest Windows amd64 release of [go-sqlcmd](https://github.com/microsoft/go-sqlcmd) and adds `sqlcmd` to the `PATH`. Used by the premerge workflow to clone and drop the ephemeral database.

### Upload Reports (`upload-reports`)

Uploads the `reports/` directory as an artifact named `REPORTS-<job-type>-<timestamp>-<run_id>.<run_number>`. With `upload-other: true` it also zips the reports for upload to another service.

## Changelog Structure

`changelogs/changelog.yaml` includes, in order:

| Folder | Notes |
|---|---|
| `Tables/` | Table DDL |
| `Procedures/` | Stored procedures |
| `Views/` | Views |
| `Data_Dml/` | Run with `sqlcmd`, labeled `DATA_DML` |
| `Vendor_Scripts/` | Run with `sqlcmd`, labeled `VENDOR` |

Changesets are Liquibase formatted SQL. Use `context:` on a changeset to control which environments it deploys to. Because every workflow passes the environment name as the context filter, a changeset marked `context:PROD` only deploys when the PROD environment is selected. Changesets with no context deploy everywhere.

## Policy Checks

Checks are configured in `policychecks/liquibase.checks-settings.conf` and include warnings for `GRANT`/`REVOKE`, `DROP TABLE`/`DROP COLUMN`, `TRUNCATE TABLE`, `SELECT *`, reserved keywords, object naming patterns, and more. `policychecks/python/check_column_count.py` is a custom Python check that warns when an `ALTER TABLE ... ADD` would push a table past a column-count limit. Custom scripts are enabled with `LIQUIBASE_COMMAND_CHECKS_RUN_CHECKS_SCRIPTS_ENABLED: true`.

## Configuration

### Runners

All jobs run on **self-hosted Windows runners**. The composite actions and several workflow steps use PowerShell, the premerge flow uses Windows command syntax, and the utilities job explicitly requests the `Windows` label. The `upload-reports` action uses a `bash` step, so Git Bash (or another `bash`) must be available on the runner.

### GitHub Environments

Create one GitHub environment per database (for example `DEV`, `QA`, `PROD`). Environment names should match the contexts used in your changesets and the snapshot names used for drift detection.

### Variables (per environment)

| Variable | Description |
|---|---|
| `LIQUIBASE_URL` | JDBC URL of the environment's database |
| `AZURE_CONTAINER` | Azure Storage container that holds snapshots |
| `LIQUIBASE_PLATFORM_CONNECTION_IDENTIFIER` | Liquibase Platform connection identifier |
| `LIQUIBASE_PLATFORM_CHANGELOG_IDENTIFIER` | Liquibase Platform changelog identifier |

### Secrets

| Secret | Used by | Description |
|---|---|---|
| `LIQUIBASE_LICENSE_KEY` | All | Liquibase Secure license key |
| `LIQUIBASE_COMMAND_USERNAME` | All | Database username |
| `LIQUIBASE_COMMAND_PASSWORD` | All | Database password |
| `LIQUIBASE_PLATFORM_API_KEY` | All | Liquibase Platform API key (also used for license tracking) |
| `AZURE_TENANT_ID` | All except premerge | Azure service principal tenant |
| `AZURE_CLIENT_ID` | All except premerge | Azure service principal client ID |
| `AZURE_CLIENT_SECRET` | All except premerge | Azure service principal secret |
| `LIQUIBASE_HOSTNAME` | Premerge | SQL Server host, for cloning |
| `LIQUIBASE_PORT` | Premerge | SQL Server port, for cloning |
| `LIQUIBASE_DATABASE_NAME` | Premerge | Source database to clone |

### Shared Settings

| Setting | Value |
|---|---|
| Azure Storage account | `cssnapshots` |
| Snapshot location | `az://<AZURE_CONTAINER>/gh_sqlserver_snapshots/<ENV>-snapshot.json` |
| Search path | `.,flowfiles,policychecks,changelogs` (plus the Azure snapshot folder for deploy, rollback, and utilities) |
| Changelog | `changelog.yaml` |
| Managed schemas | `DBO`, `Sales` |
| Tracking tables schema | Database default (the `LB` schema setting is present but commented out) |
| Reports | Written to `reports/` and uploaded as a GitHub artifact |
| Logging | `INFO` level, `JSON_PRETTY` format, written to `logs/log.json` |
| DATABASECHANGELOGHISTORY | Enabled |
| Liquibase Platform | Enabled; operations sent to `https://cs-ci.liquibase.net` |
| License tracking | Enabled |

## Typical Usage

**Development**

1. Add changesets under `changelogs/` on a feature branch.
2. Run **Checks** for quick policy feedback.
3. Run **Premerge** to prove the changes deploy and roll back cleanly on a copy of DEV.
4. Merge, then run **Build** to deploy to DEV.

**Promotion**

1. Run **Utilities → snapshot** once per environment to create the drift baseline (deploy and rollback refresh it automatically afterward).
2. Run **Deploy** with `dry_run: true` to review the SQL.
3. Run **Deploy** with `dry_run: false` to apply it. Protect higher environments such as PROD with GitHub environment required reviewers if you need an approval gate.

**Maintenance**

- **Utilities → diff** or **diff-changelog** to compare environments.
- **Utilities → status** or **history** to see what is pending or deployed.
- **Utilities → release-locks** if a run was interrupted and left a lock.
- **Rollback** to back out a tag, a number of changesets, a single changeset, or a single update.

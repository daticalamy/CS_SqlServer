# Liquibase Pro GitHub Actions

This repository contains a set of GitHub Actions workflows for managing database changes using Liquibase Secure. These workflows support a complete DevOps pipeline for database deployments with policy enforcement, drift detection, and rollback capabilities.

## Overview

All workflows use Liquibase Secure with secure connections, Azure Storage for reporting, and custom flow files for orchestrating database operations. The workflows are designed to work with SQL Server databases and support multiple environments (DEV, TEST, PROD).

## Workflows

### 1. Build Action (`lbp_build_action.yml`)
**Purpose**: Performs a build on the first database environment (typically DEV) with policy checks and deployment.

- **Trigger**: Manual workflow dispatch
- **Environment**: User-selectable (defaults to DEV)
- **Key Features**:
  - Runs Liquibase policy checks (allows build to continue even if checks fail)
  - Executes build flow using `liquibase-build.flowfile.yaml`
  - Supports optional tagging
  - Generates JSON-formatted logs and reports stored in Azure Storage
- **Use Case**: Initial development database builds and testing changes

### 2. Checks Action (`lbp_checks_action.yml`)
**Purpose**: Runs Liquibase Python policy checks without performing deployments.

- **Trigger**: Manual workflow dispatch
- **Environment**: User-selectable (defaults to DEV)
- **Key Features**:
  - Executes policy checks using `liquibase-checks.flowfile.yaml`
- **Use Case**: Standalone policy validation and compliance checking

### 3. Deploy Action (`lbp_deploy_action.yml`)
**Purpose**: Environment-targeted deployment with conditional manual approval based on policy check results.

- **Trigger**: Manual workflow dispatch
- **Environment**: User-selectable
- **Key Features**:
  - Three-stage process: Policy Checks → Manual Approval (if needed) → Deployment
  - Automatic deployment if policy checks pass
  - Manual approval gate if policy checks fail
  - Optional drift detection
  - Uses `liquibase-deploy.flowfile.yaml` for deployment execution
- **Use Case**: Production deployments with governance and approval workflows

### 4. Diff Action (`lbp_diff_action.yml`)
**Purpose**: Compares database schemas between two environments to detect differences and drift.

- **Trigger**: Manual workflow dispatch
- **Environments**: Source (any environment) and Target (DEV/TEST/PROD)
- **Key Features**:
  - Uses `liquibase-drift.flowfile.yaml` for drift detection
  - Compares multiple schemas (DBO, Sales)
  - Generates difference reports stored in Azure Storage
- **Use Case**: Environment synchronization validation and drift detection

### 5. Premerge Action (`lbp_premerge_action.yml`)
**Purpose**: Validates changes in an ephemeral database environment before allowing code merges.

- **Trigger**: Manual workflow dispatch (commented PR trigger available)
- **Environment**: DEV (creates ephemeral clone)
- **Key Features**:
  - Creates temporary database clone for testing
  - Runs policy checks and validation
  - Uses `liquibase-premerge.flowfile.yaml`
  - Includes MSSQL client tools installation
  - Destroys ephemeral environment after testing
- **Use Case**: Pre-merge validation and CI/CD integration

### 6. Rollback Action (`lbp_rollback_action.yml`)
**Purpose**: Rolls back database changes to a specific tag or label.

- **Trigger**: Manual workflow dispatch
- **Environment**: User-selectable
- **Key Features**:
  - Two rollback options: by tag or by label
  - User-specified rollback target
  - Uses `liquibase-rollback.flowfile.yaml`
  - Supports multiple schemas (DBO, Sales)
- **Use Case**: Emergency rollbacks and change reversions

### 7. Snapshot Action (`lbp_snapshot_action.yml`)
**Purpose**: Creates database snapshots for reference purposes and Drift Detection.

- **Trigger**: Manual workflow dispatch
- **Environment**: User-selectable
- **Key Features**:
  - Uses `liquibase-snapshot.flowfile.yaml`
  - Snapshots stored in Azure Storage
  - Supports multiple schemas (DBO, Sales)
- **Use Case**: Database state capture for backup, comparison, and audit purposes

## Reusable Actions

### Setup Liquibase (`setup-liquibase/action.yml`)
Composite action that sets up the Liquibase environment:
- Installs Java 17 (Temurin distribution)
- Sets up Liquibase Pro Secure edition v5.0.0
- Used by all main workflows

### Install MSSQL Client Tools (`install-mssql-client-tools/action.yml`)
Composite action that installs SQL Server command-line tools:
- Installs `sqlcmd` and ODBC drivers
- Required for workflows that need to interact directly with SQL Server
- Used by the premerge workflow for database cloning operations

## Environment Configuration

### Required Secrets
All workflows expect the following secrets to be configured:

**Azure Storage**:
- `AZURE_TENANT_ID`
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`

**Liquibase License**:
- `LIQUIBASE_PRO_LICENSE_KEY`

**Database Connection**:
- `LIQUIBASE_URL`
- `LIQUIBASE_USERNAME`
- `LIQUIBASE_PASSWORD`

**SQL Server Specific** (for premerge):
- `LIQUIBASE_HOSTNAME`
- `LIQUIBASE_PORT`
- `LIQUIBASE_DATABASE_NAME`

### Standard Configuration
- **Runner**: Self-hosted runners
- **Logging**: JSON format with INFO level
- **Schema Management**: Liquibase tracking tables stored in `LB` schema
- **Search Path**: `flows, checks, changelogs`
- **Changelog**: `changelog.yaml`
- **Schemas**: DBO and Sales schemas are managed

## Flow Files

Each workflow references specific Liquibase flow files that orchestrate the database operations:

- `liquibase-build.flowfile.yaml` - Build operations
- `liquibase-checks.flowfile.yaml` - Policy and compliance checks
- `liquibase-deploy.flowfile.yaml` - Deployment operations
- `liquibase-drift.flowfile.yaml` - Drift detection and comparison
- `liquibase-premerge.flowfile.yaml` - Pre-merge validation
- `liquibase-rollback.flowfile.yaml` - Rollback operations
- `liquibase-snapshot.flowfile.yaml` - Snapshot creation

## Usage

1. **Development Workflow**:
   - Use `lbp_build_action.yml` for initial development builds
   - Use `lbp_checks_action.yml` for policy validation
   - Use `lbp_premerge_action.yml` before merging changes

2. **Deployment Workflow**:
   - Use `lbp_deploy_action.yml` for environment promotions
   - Policy failures trigger manual approval requirements

3. **Maintenance Operations**:
   - Use `lbp_diff_action.yml` to detect environment drift
   - Use `lbp_snapshot_action.yml` for regular backups
   - Use `lbp_rollback_action.yml` for emergency rollbacks

All workflows generate comprehensive reports stored in Azure Storage at `az://reports/gh_sqlserver_reports` for audit and troubleshooting purposes.
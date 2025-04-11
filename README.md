# Liquibase Pro Implementation Runbook

## Creating a new project

### Step 1: Create the Repository
1. Log into GitHub and navigate template repository << ADD REPO NAME & URL HERE >>.
1. Click on **Use this template** to **Create a new repostiory**.
1. Provide a Repository Name (e.g., `liquibase-pro-implementation`).
1. Set repository visibility to Private.
1. Click **Create Repository**.

### Step 2: Setup the GitHub Runners
1. Open the repository on GitHub.
1. Go to **Settings** > **Actions** > **Runners**.
1. << STEPS FOR SETTING UP RUNNERS >>

### Step 3: Setup the GitHub Secrets
1. Open the repository on GitHub.
1. Go to **Settings** > **Secrets and variables** > **Actions**.
1. Click **New repository secret**.
1. You will need to add secrets for the below items:

| Secret        | Description
| ------------- | -------------
| LIQUIBASE_PRO_LICENSE_KEY | << Instructions on how to find >>
| LIQUIBASE_COMMAND_PASSWORD | << Instructions on how to find >>
| LIQUIBASE_PAT | << Instructions on how to find or generate >>
| AZURE_CREDENTIALS | << Instructions on how to find >>
| AZURE_CREDENTIALS_G67P | << Are both of these CREDS values necessary? >>
| AZURE_TENANT_ID | << Instructions on how to find >>
| AZURE_STORAGE_ACCOUNT | << Instructions on how to find >>

### Step 4: Setup the GitHub Variables
1. Open the repository on GitHub.
1. Go to **Settings** > **Secrets and variables** > **Actions**.
1. Click on **Variables** tab.
1. Click **New repository variable**.
1. You will need to add variables for the below items:

| Variable        | Description
| ------------- | -------------
| LIQUIBASE_COMMAND_SCHEMAS | Comma separated list
| LIQUIBASE_COMMAND_USERNAME | << Instructions on how to find >>
| LIQUIBASE_COMMAND_URL | Format: jdbc:sqlserver://hostname;portNumber=1433;databaseName=databaseName;integratedSecurity=true;
| LIQUIBASE_RUNNER | << Instructions on how to find >>

---

## Configuring Azure Blob Storage

### Step 1: Create an Azure Storage Account
1. Log into the [Azure Portal](https://portal.azure.com).
2. Navigate to **Storage accounts**.
3. Click **Create** and provide the required details.
4. Select **BlobStorage** as the account type.
5. Click **Review + Create**, then **Create**.

### Step 2: Create a Blob Container
1. Open the newly created storage account.
2. Go to **Containers** and click **+ Container**.
3. Name it (e.g., `liquibase-backups`) and set the appropriate access level.
4. Click **Create**.

### Step 3: Configure Connection String
1. Navigate to **Access keys** in the storage account.
2. Copy the **connection string**.
3. Store it in GitHub Secrets under `AZURE_STORAGE_CONNECTION_STRING`.

---

## Creating Initial Changelog

### Step 1: Run Generate Change Log
1.

### Step 2: Add generate changelog to Liquibase project
1.

### Step 3: Run ChangeLog Sync
1. 

---

## Syncing Environments

### Step 1: ....
1.

### Step 2: ....
1.

### Step 3: ....
1. 

---

## Upgrading Liquibase

### Step 1: ....
1.

### Step 2: ....
1.

### Step 3: ....
1. 

---

## Conclusion
This runbook provides a step-by-step guide for setting up and managing Liquibase Pro.


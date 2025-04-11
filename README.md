# Liquibase Pro Implementation Runbook

## Creating a new project

### Step 1: Create the Repository
1. Log into GitHub and navigate template repository << ADD REPO NAME & URL HERE >>.
1. Click on **Use this template** to **Create a new repostiory**.
1. Provide a Repository Name (e.g., `liquibase-pro-implementation`).
1. Set repository visibility to Private.
1. Click **Create Repository**.

### Step 2: Setup the GitHub Runners
1. Open the new repository on GitHub.
1. Go to **Settings** > **Actions** > **Runners**.
1. << STEPS FOR SETTING UP RUNNERS >>

### Step 3: Setup the GitHub Secrets
1. Open the new repository on GitHub.
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
1. Open the new repository on GitHub.
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
1. Navigate to **Storage accounts**.
1. Click **Create** and provide the required details.
1. Select **BlobStorage** as the account type.
1. Click **Review + Create**, then **Create**.

### Step 2: Create three Blob Containers
1. Open the newly created storage account.
1. Go to **Data storage** > **Containers** and click **+ Container**.
1. Create two containers: `snapshots`, `generatechangelogs`, and `generatechangelogs`
1. Click **Create** for each container to create it.

---

## Creating Initial Changelog

### Step 1: Run GenerateChangeLog
1. Open the new repository on GitHub.
1. Navigate to **Actions** > **Utility - GenerateChangeLog**.
1. Run the utility by selecting **Run Workflow**.
1. Select **Environment to perform Generate-Changelog** and click **Run Workflow**. 
1. Download the changelog logging in to [Azure Portal](https://portal.azure.com).
1. Navigate to **Storage accounts** and select the storage account you created in #Configuring Azure Blob Storage.
1. Select **Data storage** > **Containers** > **generatechangelogs**
1. Find the desired changelog, use the three **...**, and select **Download**.

### Step 2: Add newly generated changelog to your Liquibase project
1. Find the changelog in your **Downloads** folder.
1. Copy the contents to the << NAME OF DEFAULT CHANGELOG >> changelog in your repository on GitHub.

### Step 3: Run ChangeLogSync in each environment
The changes in this changelog already exist on the database. A ChangeLogSync needs to be run to tell Liquibase not to try and re-run the changes.  

1. Open the new repository on GitHub.
1. Navigate to **Actions** > **Utility - ChangelogSync**.
1. Run the utility by selecting **Run Workflow**.
1. Select **Environment to run changelog-sync** and click **Run Workflow**. 
1. Repeat for each Environment.
---

## Running Liquibase

### Step 1: Run Generate Change Log
1. Open the new repository on GitHub.
1. Go to **Actions** > **Utility - GenerateChangeLog**.


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


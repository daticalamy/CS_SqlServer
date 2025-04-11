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

### Step 2: Setup the Runners
1. Go to Settings, Actions.
2. << STEPS FOR SETTING UP RUNNERS >>
   ```sh
   git clone https://github.com/YOUR_ORG/liquibase-pro-implementation.git
   ```
3. Navigate into the cloned repository:
   ```sh
   cd liquibase-pro-implementation
   ```


### Step 3: Set Up Branches
1. Create development and feature branches:
   ```sh
   git checkout -b develop
   ```
2. Push the new branch:
   ```sh
   git push -u origin develop
   ```
3. Repeat for feature branches as needed.

---

## 2. Setting Up GitHub Secrets

### Step 1: Navigate to GitHub Secrets
1. Open the repository on GitHub.
2. Go to **Settings** > **Secrets and variables** > **Actions**.
3. Click **New repository secret**.

### Step 2: Add Required Secrets
Add the following secrets:
- **LIQUIBASE_LICENSE_KEY** – Your Liquibase Pro license key.
- **DB_URL** – The JDBC URL for your database.
- **DB_USERNAME** – The database username.
- **DB_PASSWORD** – The database password.
- **AZURE_STORAGE_CONNECTION_STRING** – Connection string for Azure Blob Storage.

### Step 3: Save and Verify Secrets
1. Ensure all secrets are correctly entered.
2. Test by accessing them in GitHub Actions workflows.

---

## 3. Creating the Liquibase Project Files

### Step 1: Initialize the Project
1. Inside the cloned repository, create a directory for Liquibase:
   ```sh
   mkdir liquibase && cd liquibase
   ```
2. Initialize Liquibase:
   ```sh
   liquibase init project
   ```

### Step 2: Configure the `liquibase.properties` File
1. Open `liquibase.properties` and add:
   ```properties
   liquibase.command.url=${DB_URL}
   liquibase.command.username=${DB_USERNAME}
   liquibase.command.password=${DB_PASSWORD}
   liquibase.licenseKey=${LIQUIBASE_LICENSE_KEY}
   changeLogFile=changelog.xml
   ```
2. Save the file.

### Step 3: Create a Changelog File
1. Generate a base changelog:
   ```sh
   liquibase generateChangeLog --outputFile=changelog.xml
   ```
2. Verify `changelog.xml` for correctness.

### Step 4: Commit the Files
1. Add Liquibase files to Git:
   ```sh
   git add liquibase/
   git commit -m "Added Liquibase configuration"
   git push origin develop
   ```

---

## 4. Configuring Azure Blob Storage

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

## 5. Training the End Users

### Step 1: Organize Training Sessions
1. Schedule training sessions for developers and database administrators.
2. Use a mix of presentations and hands-on exercises.

### Step 2: Cover Key Topics
- Introduction to Liquibase Pro.
- Writing and applying changelogs.
- Using GitHub Actions for database CI/CD.
- Storing database snapshots in Azure Blob Storage.
- Best practices and troubleshooting.

### Step 3: Provide Documentation
1. Create a user guide and store it in the GitHub repository.
2. Include FAQs and common error resolutions.

### Step 4: Conduct Follow-up Sessions
1. Address questions and gather feedback.
2. Provide additional resources or workshops as needed.

---

## Conclusion
This runbook provides a step-by-step guide for setting up and managing Liquibase Pro, ensuring a smooth implementation. Regular monitoring and training will help maintain a reliable database change management workflow.


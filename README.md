# About duck-pipeline-dev
This project contains the ETL (Extract, Transform, Load) pipeline for the Ducks data project. It is deployed as a **Cloud Run Service** and triggered via **Cloud Scheduler**.

## Architecture
- **Service:** Google Cloud Run (HTTP-based)
- **Trigger:** Cloud Scheduler (Cron)
- **Region:** `us-central1`
- **Networking:** Public Ingress (IAM-authenticated)

### Prerequisites
- Terraform >= 1.0.0
- Google Cloud SDK (gcloud)
  
### Project setup
- Permissions (for your personal account  or SA): `roles/run.admin`, `roles/cloudscheduler.admin`, `roles/iam.serviceAccountUser`
- Via web console, create a new Project and attach it to a Billing Account.
- Create a Bucket to be used as a *backed bucket* to store the Terraform status files.
- Replace this bucket name in the file */terraform/envs/dev/backend.tf*

### Connect Repository
1. Go to the *Cloud Build Triggers* page.
2. Click *Manage Repositories* -> *Connect Repository*.
3. Select *GitHub (Cloud Build GitHub App)*.
4. Follow the prompts to authorise your account and select your ducks-pipeline repository.

### Google Cloud connection

1. Choose the account you want to use for this configuration.
```bash
gcloud init```
2. Pick the cloud project to use
3. Log in to the cloud by following the link provided after executing the command below
```bash
gcloud auth login```
4. Select your Google account 
5. Allow Google Cloud to access your account by clicking *Allow*

## Configure Docker
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev```
  
## Deployment
### Steps
1. **Initialize Terraform:**
   ```bash
   terraform init```

2. **Plan the infrastructure**
   ```bash
   terraform plan -out=tfplan```

3. **Apply changes**
   ```bash
   apply -var="project_id=<YOUR_PROJECT_ID>" ```

## Local Reproduction
To test the ETL logic locally without deploying to Cloud Run:
1. Build the Docker image:
    ```bash
    docker build -t ducks-etl .```

2. Run the container:
    ```bash
    docker run -p 8080:8080 ducks-etl```

3. Trigger the process:
    ```bash
    curl localhost:8080```

## Scheduled Execution
1. The job is configured to run automatically via Cloud Scheduler.
```bash
    Job Name: daily-ducks-etl-job-dev
    Target URI: https://duck-pipeline-service-dev-248136157540.us-central1.run.app```

2. Manual Trigger. To manually invoke the production pipeline with authentication:
```bash
gcloud scheduler jobs run daily-ducks-etl-job-dev --location=us-central1```


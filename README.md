# About duck-pipeline-dev

This project used the *Ducks Unlimited API* to search for university chapters in the states of California, Oregon and Washington. The results are stored in a Postgress database instance.

## Local environment configuration

### Virtual environment (recommended)

pip install --upgrade pip
pip install -r requirements.txt

### Remote requirements

1. Create the project using the web console
2. Asociate the project to the billing account
2. Crete the backed bucket to store the Terraform status files. It can be created via web console or via command line by executing 
gcloud storage buckets create gs://ducks-pipeline-tfstate-dev-030326 --project=ducks-pipeline-dev-030326 --location=us-central1

### Google Cloud connection

1. Choose the account you want to use for this configuration.
gcloud init
2. Pick the cloud project to use
3. Login to the cloud by following the link provided after executing the command below
gcloud auth login 
4. Select your google account 
5. Allow Google cloud to access your account by clicking "Allow"

### Project provisioning

1. Execute terraform init

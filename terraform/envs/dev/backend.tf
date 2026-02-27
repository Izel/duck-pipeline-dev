terraform {
  backend "gcs" {
    bucket = "ducks-pipeline-dev-01-tfstate"
    prefix = "terraform/state"
  }
}

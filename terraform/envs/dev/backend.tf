terraform {
  backend "gcs" {
    bucket = "duck-pipeline-dev-01-tfstate"
    prefix = "terraform/state"
  }
}

terraform {
  backend "gcs" {
    bucket = "duck-pipeline-50978-terraform-state"
    prefix = "terraform/state"
  }
}

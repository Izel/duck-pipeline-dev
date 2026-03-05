terraform {
  backend "gcs" {
    bucket = "duck-pipeline-202603-terraform-state"
    prefix = "terraform/state"
  }
}

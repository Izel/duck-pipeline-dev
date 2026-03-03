provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "current" {
  project_id = var.project_id
}

module "api" {
  source     = "../../modules/api"
  project_id = var.project_id
}

module "networking" {
  source     = "../../modules/networking"
  vpc_name   = "${var.vpc_name}-${var.env_name}"
  region     = var.region
  depends_on = [module.api]
}

module "database" {
  source                  = "../../modules/database"
  project_id              = var.project_id
  region                  = var.region
  env_name                = var.env_name
  network_id              = module.networking.network_id
  db_instance_tier        = var.db_instance_tier
  db_server_instance_name = "${var.db_instance_name}-${var.env_name}"
  db_name                 = "${var.db_name}-${var.env_name}"
  db_user                 = "${var.db_user}-${var.env_name}"
  db_password             = var.db_password
  depends_on              = [module.api, module.networking]
}

module "iam" {
  source     = "../../modules/iam"
  project_id = var.project_id
  account_id = "${var.account_id}-${var.env_name}"
  env_name   = var.env_name
  depends_on = [module.api]
}

module "repository" {
  source                = "../../modules/repository"
  region                = var.region
  env_name              = var.env_name
  project_id            = var.project_id
  artifact_format       = var.artifact_format
  artifact_name         = "${var.artifact_name}-${var.env_name}"
  artifact_description  = var.artifact_description
  trigger_name          = "${var.trigger_name}-${var.env_name}"
  github_user           = var.github_user
  github_repo           = var.github_repo
  pipeline_service_name = "${var.pipeline_service_name}-${var.env_name}"
  cloudbuild_sa_email   = module.iam.cloudbuild_sa_email
  depends_on            = [module.api]
}

module "services" {
  source                      = "../../modules/services"
  project_id                  = var.project_id
  region                      = var.region
  pipeline_service_name       = "${var.pipeline_service_name}-${var.env_name}"
  image_name                  = var.image_name
  pipeline_sa_email           = module.iam.pipeline_sa_email
  db_user                     = "${var.db_user}-${var.env_name}"
  db_password                 = var.db_password
  db_name                     = "${var.db_name}-${var.env_name}"
  db_instance_connection_name = module.database.instance_connection_name
  connector_id                = module.networking.connector_id
  depends_on                  = [module.networking, module.iam, module.repository, module.database]
}



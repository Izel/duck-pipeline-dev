data "google_project" "current" {
  project_id = var.project_id
}

module "api" {
  source     = "../../modules/api"
  project_id = var.project_id
  providers = {
    google      = google
    google-beta = google-beta
  }
}

module "iam" {
  source                = "../../modules/iam"
  project_id            = var.project_id
  account_id            = "${var.account_id}-${var.env_name}"
  pipeline_service_name = "${var.pipeline_service_name}-${var.env_name}"
  region                = var.region
  env_name              = var.env_name
  depends_on            = [module.api, module.api.apis_ready] # WAIT FOR ROBOTS TO BE BORN
}

module "networking" {
  source     = "../../modules/networking"
  vpc_name   = "${var.vpc_name}-${var.env_name}"
  region     = var.region
  env_name   = var.env_name
  depends_on = [module.iam] # WAIT FOR PERMISSIONS
}

module "database" {
  source                  = "../../modules/database"
  project_id              = var.project_id
  region                  = var.region
  env_name                = var.env_name
  vpc_name                = module.networking.vpc_id
  db_instance_tier        = var.db_instance_tier
  db_server_instance_name = "${var.db_instance_name}-${var.env_name}"
  db_name                 = "${var.db_name}-${var.env_name}"
  db_user                 = "${var.db_user}-${var.env_name}"
  db_password             = var.db_password
  depends_on              = [module.networking]
}

module "build" {
  source                    = "../../modules/build"
  region                    = var.region
  env_name                  = var.env_name
  project_id                = var.project_id
  artifact_repo_format      = var.artifact_repo_format
  artifact_repo_name        = "${var.artifact_repo_name}-${var.env_name}"
  artifact_repo_description = var.artifact_repo_description
  trigger_name              = "${var.trigger_name}-${var.env_name}"
  github_user               = var.github_user
  github_repo               = var.github_repo
  pipeline_service_name     = "${var.pipeline_service_name}-${var.env_name}"
  cloudbuild_sa_email       = module.iam.cloudbuild_sa_email
  depends_on                = [module.api, module.iam] # WAIT FOR PERMISSIONS AND APIS
}

module "services" {
  source                = "../../modules/services"
  project_id            = var.project_id
  region                = var.region
  pipeline_service_name = "${var.pipeline_service_name}-${var.env_name}"
  image_path            = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo_name}-${var.env_name}/${var.artifact_name}:${var.artifact_commit_sha}"
  #image_path                  = "${var.artifact_name}:${var.artifact_commit_sha}"
  pipeline_sa_email           = module.iam.pipeline_sa_email
  db_user                     = "${var.db_user}-${var.env_name}"
  db_password                 = var.db_password
  db_name                     = "${var.db_name}-${var.env_name}"
  db_instance_connection_name = module.database.instance_connection_name
  connector_id                = module.networking.connector_id
  depends_on                  = [module.iam, module.networking, module.database, module.build]
}

module "job" {
  source                = "../../modules/job"
  project_id            = var.project_id
  region                = var.region
  env_name              = var.env_name
  pipeline_service_name = "${var.pipeline_service_name}-${var.env_name}"
  job_sa_email          = module.iam.scheduler_sa_email
  job_name              = "${var.job_name}-${var.env_name}"
  job_description       = var.job_description
  job_schedule          = var.job_schedule
  job_time_zone         = var.job_time_zone
  job_attempt_deadline  = var.job_attempt_deadline
  pipeline_service_uri  = module.services.pipeline_service_uri
  depends_on            = [module.iam, module.services]
}

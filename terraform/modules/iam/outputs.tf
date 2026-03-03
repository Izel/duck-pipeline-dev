output "pipeline_sa_email" {
  value = google_service_account.pipeline_sa.email
}
output "cloudbuild_sa_email" {
  value = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
output "scheduler_sa_email" {
  value = google_service_account.scheduler_sa.email
}

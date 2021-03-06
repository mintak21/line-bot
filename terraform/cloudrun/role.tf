resource google_service_account sa_for_cloud_run {
  account_id   = "sa-for-cloudrun-${var.service_name}"
  display_name = "Service Account For Cloud Run"
  description  = "Service Account For Cloud Run ${var.service_name}"
}

resource google_service_account_iam_member cloud_run_iam {
  service_account_id = google_service_account.sa_for_cloud_run.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_project.my_project.number}@cloudbuild.gserviceaccount.com"
}

resource google_project_iam_member cloud_run_secret_access_role {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.sa_for_cloud_run.email}"
}

data google_iam_policy noauth {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource google_cloud_run_service_iam_policy noauth {
  location = google_cloud_run_service.this.location
  project  = google_cloud_run_service.this.project
  service  = google_cloud_run_service.this.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

data google_project my_project {
}

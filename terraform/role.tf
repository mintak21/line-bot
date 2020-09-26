resource google_service_account sa_for_cloud_run {
  account_id   = "sa-for-cloudrun-${var.service_name}"
  display_name = "Service Account For Cloud Run"
  description  = "Service Account For Cloud Run ${var.service_name}"
}

resource google_project_iam_member cloud_run_admin_role {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.sa_for_cloud_run.email}"
}

resource google_project_iam_member cloud_run_sa_role {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
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

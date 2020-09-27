resource google_service_account sa_for_cloudfunctions {
  account_id   = "sa-for-functions-${var.service_name}"
  display_name = "Service Account For Cloud Functions"
  description  = "Service Account For Cloud Functions ${var.service_name}"
}

resource google_project_iam_custom_role role_for_cloudfunctions {
  role_id     = "role_for_functions_${var.service_name}"
  title       = "Custom Role For Cloud Functions"
  description = "Custom Role For Cloud Functions ${var.service_name}"
  permissions = [
    "cloudkms.cryptoKeyVersions.get",
    "cloudkms.cryptoKeyVersions.useToDecrypt",
    "resourcemanager.projects.get", # To Use KMS
  ]
}

data google_iam_policy cloudfunctions_policy {
  binding {
    role = google_project_iam_custom_role.role_for_cloudfunctions.name
    members = [
      "serviceAccount:${google_service_account.sa_for_cloudfunctions.email}",
    ]
  }
}

resource google_cloudfunctions_function_iam_policy policy {
  project        = google_cloudfunctions_function.this.project
  region         = google_cloudfunctions_function.this.region
  cloud_function = google_cloudfunctions_function.this.name
  policy_data    = data.google_iam_policy.cloudfunctions_policy.policy_data
}

resource google_cloudfunctions_function_iam_member invoker {
  project        = google_cloudfunctions_function.this.project
  region         = google_cloudfunctions_function.this.region
  cloud_function = google_cloudfunctions_function.this.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers" # Public Function
}

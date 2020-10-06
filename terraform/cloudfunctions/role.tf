resource google_service_account sa_for_cloudfunctions {
  account_id   = "functions-${var.service_name}"
  display_name = "CloudFunctions(${var.service_name}) service account"
  description  = "CloudFunctions(${var.service_name})にて使用するサービスアカウント"
}

resource google_project_iam_custom_role role_for_cloudfunctions {
  role_id     = "functions_${var.service_name}"
  title       = "${var.service_name} CloudFunctions"
  description = "Custom Role For Cloud Functions(${var.service_name})"
  permissions = [
    "cloudkms.cryptoKeyVersions.useToDecrypt",
  ]
}

resource google_project_iam_binding cloudfunctions_role {
  role = google_project_iam_custom_role.role_for_cloudfunctions.name
  members = [
    "serviceAccount:${google_service_account.sa_for_cloudfunctions.email}",
  ]
}

# For Public Access
data google_iam_policy invoker {
  binding {
    role = "roles/cloudfunctions.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource google_cloudfunctions_function_iam_policy public_cloudfunctions_policy {
  project        = google_cloudfunctions_function.this.project
  region         = google_cloudfunctions_function.this.region
  cloud_function = google_cloudfunctions_function.this.name
  policy_data    = data.google_iam_policy.invoker.policy_data
}

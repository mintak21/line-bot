resource google_project_service project {
  count = length(local.enable_services)

  project                    = var.project_id
  service                    = local.enable_services[count.index]
  disable_dependent_services = true
  disable_on_destroy         = false
}

locals {
  enable_services = [
    "iam.googleapis.com",               # Identity and Access Management (IAM) API
    "cloudfunctions.googleapis.com",    # Cloud Functions API
    "cloudkms.googleapis.com",          # Cloud Key Management Service (KMS) API
    "storage-component.googleapis.com", # Cloud Storage API
    "secretmanager.googleapis.com",     # Secret Manager API
  ]
}

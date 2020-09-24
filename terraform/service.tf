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
    "containerregistry.googleapis.com", # Container Registry API
    "run.googleapis.com",               # Cloud Run API
    "cloudbuild.googleapis.com",        # Cloud Build API
    "compute.googleapis.com",           # Compute Engine API
    "storage-component.googleapis.com", # Cloud Storage API
  ]
}

resource google_container_registry registry {
  project  = var.project_id
  location = "US"
}

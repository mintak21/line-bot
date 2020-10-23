resource google_project_service project {
  count = length(local.enable_services)

  project                    = data.google_project.project.project_id
  service                    = local.enable_services[count.index]
  disable_dependent_services = true
  disable_on_destroy         = false
}

locals {
  enable_services = [
    "iam.googleapis.com",               # Identity and Access Management (IAM) API
    "storage-component.googleapis.com", # Cloud Storage API
    "compute.googleapis.com",           # Compute Engine API
    "container.googleapis.com",         # Kubernetes Engine API
  ]
}

resource google_container_registry registry {
  location = "US"
}

data google_project project {
}

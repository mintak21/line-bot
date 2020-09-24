resource google_cloud_run_service this {
  name                       = var.service_name
  location                   = var.gcp_region
  autogenerate_revision_name = true

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        resources {
          limits = {
            "cpu"    = "1"
            "memory" = "128Mi"
          }
          requests = {
            "cpu"    = "1"
            "memory" = "128Mi"
          }
        }
      }
      timeout_seconds      = "30"
      service_account_name = google_service_account.sa_for_cloud_run.email
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "3"
        "run.googleapis.com/client-name"   = "terraform"
      }
    }
  }

  metadata {
    labels = {
      "environment" = "production"
      "tier"        = "backend"
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

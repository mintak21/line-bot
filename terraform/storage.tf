resource google_storage_bucket cloudbuild_bucket {
  name          = "${var.project_id}_cloudbuild"
  location      = "US-WEST1"
  storage_class = "STANDARD"
  force_destroy = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90
    }
  }
}

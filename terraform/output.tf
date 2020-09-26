output cloudbuild_bucket_storage_bucket_url {
  description = "CloudBuildのログ保存バケットURL"
  value       = google_storage_bucket.cloudbuild_bucket.url
}

output this_cloud_run_service_status {
  description = "CloudRunサービスの情報"
  value       = google_cloud_run_service.this.status
}

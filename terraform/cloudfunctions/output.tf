output cloudfunctions_bucket_storage_bucket_url {
  description = "CloudFunctionsのArchive保存バケットURL"
  value       = google_storage_bucket.cloudfunctions_bucket.url
}

output this_google_cloudfunctions_function_url {
  description = "CloudFunctions接続先URL"
  value       = google_cloudfunctions_function.this.https_trigger_url
}

output service_key_google_kms_crypto_key_id {
  description = "KMS KeyのID"
  value       = google_kms_crypto_key.service_key.id
}

resource google_cloudfunctions_function this {
  name                  = var.service_name
  description           = "Serverless Linebot Backend"
  runtime               = "python37" # Terraform Not Yet Support python38
  source_archive_bucket = google_storage_bucket.cloudfunctions_bucket.name
  source_archive_object = google_storage_bucket_object.source_archive.name
  service_account_email = google_service_account.sa_for_cloudfunctions.email

  available_memory_mb = 128
  ingress_settings    = "ALLOW_ALL"
  trigger_http        = true
  timeout             = 60
  entry_point         = "handle_cloudfunctions"

  environment_variables = {
    SECRET_TYPE          = "KMS_ENCRYPTED_ENV",
    KEY_ID               = google_kms_crypto_key.service_key.id,
    CHANNEL_SECRET       = google_kms_secret_ciphertext.channel_secret.ciphertext,
    CHANNEL_ACCESS_TOKEN = google_kms_secret_ciphertext.channel_access_token.ciphertext,
  }

  labels = {
    purpose = "${var.service_name}-backend"
  }
}

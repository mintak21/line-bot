resource google_kms_key_ring service_keyring {
  name     = "cloudfunction-keyring"
  location = var.gcp_region
}

resource google_kms_crypto_key service_key {
  name            = "${var.service_name}-key"
  key_ring        = google_kms_key_ring.service_keyring.id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "2592000s" # lotate every 30 days
  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "HSM"
  }
}

resource google_kms_secret_ciphertext channel_secret {
  crypto_key = google_kms_crypto_key.service_key.id
  plaintext  = var.plain_channel_secret
}

resource google_kms_secret_ciphertext channel_access_token {
  crypto_key = google_kms_crypto_key.service_key.id
  plaintext  = var.plain_channel_access_token
}

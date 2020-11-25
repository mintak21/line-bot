resource google_secret_manager_secret linebot_secret {
  count = length(local.linebot_secret_ids)

  secret_id = local.linebot_secret_ids[count.index]

  labels = {
    label = var.service_name
  }

  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }
}

resource google_secret_manager_secret_version plain_channel_secret {
  secret      = google_secret_manager_secret.linebot_secret[0].id
  secret_data = var.plain_channel_secret
}

resource google_secret_manager_secret_version plain_channel_access_token {
  secret      = google_secret_manager_secret.linebot_secret[1].id
  secret_data = var.plain_channel_access_token
}

locals {
  linebot_secret_ids = [
    "CHANNEL_SECRET",
    "CHANNEL_ACCESS_TOKEN",
  ]
}

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

locals {
  linebot_secret_ids = [
    "CHANNEL_SECRET",
    "CHANNEL_ACCESS_TOKEN",
  ]
}

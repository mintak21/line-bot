variable project_id {
  type        = string
  description = "プロジェクトID"
  default     = "mintak"
}

variable gcp_region {
  type        = string
  description = "リージョン"
  default     = "us-central1"
}

variable service_name {
  type        = string
  description = "サービス名"
  default     = "mintaklinebot"
}

variable channel_secret {
  type        = string
  description = "BOTのチャンネルシークレット(Encrypted)"
  default     = "dummy"
}

variable channel_access_token {
  type        = string
  description = "BOTのアクセストークン(Encrypted)"
  default     = "dummy"
}

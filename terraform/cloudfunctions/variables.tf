variable project_id {
  type        = string
  description = "プロジェクトID"
  default     = "mintak"
}

variable service_name {
  type        = string
  description = "サービス名"
  default     = "mintaklinebot"
}

variable plain_channel_secret {
  type        = string
  description = "BOTのチャンネルシークレット(Plain)"
  default     = "dummy" # Set By tfvars
}

variable plain_channel_access_token {
  type        = string
  description = "BOTのアクセストークン(Plain)"
  default     = "dummy" # Set By tfvars
}

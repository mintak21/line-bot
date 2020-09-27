variable project_id {
  type        = string
  description = "プロジェクトID"
  default     = "mintak"
}

variable gcp_region {
  type        = string
  description = "リージョン"
  default     = "us-west1"
}

variable service_name {
  type        = string
  description = "サービス名"
  default     = "mintaklinebot"
}

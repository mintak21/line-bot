variable service_name {
  type        = string
  description = "サービス名"
  default     = "mintaklinebot"
}

variable service_domain {
  type        = string
  description = "DNSへ登録するドメイン"
  default     = "mintak.work."
}

variable cluster_location {
  type        = string
  description = "GKEロケーション"
  default     = "us-central1"
}

variable machine_type {
  type        = string
  description = "ノードマシン種別"
  default     = "n1-standard-1"
}

variable master_ip_range {
  type        = string
  description = "マスターIPレンジ See.https://future-architect.github.io/articles/20191017/"
  default     = "192.168.0.0/28"
}

variable pod_ip_range {
  type        = string
  description = "PodIPレンジ"
  default     = "172.16.0.0/18"
}

variable service_ip_range {
  type        = string
  description = "ServiceIPレンジ"
  default     = "172.18.0.0/18"
}

variable vpc_subnetwork_primary_ip_range {
  type        = string
  description = "サブネットのプライマリIPレンジ"
  default     = "10.128.0.0/24"
}

variable ip_whitelists {
  type        = list(string)
  description = "接続許可するIPアドレスリスト"
  default = [
    "220.215.227.226/32",
    "111.239.191.38", # 渋谷のIP
  ]
}

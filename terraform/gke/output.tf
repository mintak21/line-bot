output cluster_id {
  value       = google_container_cluster.vpc_native_cluster.id
  description = "作成したクラスタのID"
}

output kubernetes_master_version {
  value       = google_container_cluster.vpc_native_cluster.master_version
  description = "作成したクラスタのマスターバージョン"
}

output nodepool_id {
  value       = google_container_node_pool.vpc_native_cluster_nodes.id
  description = "作成したノードプールのID"
}


output vpc_network_id {
  value       = google_compute_network.network.id
  description = "作成したVPCネットワークのID"
}

output vpc_subnetwork_id {
  value       = google_compute_subnetwork.subnetwork.id
  description = "作成したサブネットのID"
}

output external_ip_address {
  value       = google_compute_global_address.application_static_ip_address.address
  description = "静的IPアドレス"
}

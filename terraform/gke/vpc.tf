resource google_compute_network network {
  name                    = "${var.service_name}-network"
  description             = "VPC Network For Locating Private Google Kubernetes Cluster - ${var.service_name}"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource google_compute_subnetwork subnetwork {
  name                     = "${var.service_name}-subnet"
  network                  = google_compute_network.network.id
  description              = "VPC SubNetwork For Locating Private Google Kubernetes Cluster - ${var.service_name}"
  region                   = var.cluster_location
  ip_cidr_range            = var.vpc_subnetwork_primary_ip_range
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${var.service_name}-pod-ip-range"
    ip_cidr_range = var.pod_ip_range
  }
  secondary_ip_range {
    range_name    = "${var.service_name}-service-ip-range"
    ip_cidr_range = var.service_ip_range
  }

  depends_on = [
    google_compute_network.network,
  ]
}

resource google_compute_global_address application_static_ip_address {
  name        = "${var.service_name}-external-ip"
  description = "IP Address For Accessing Ingress"
  ip_version  = "IPV4"
}

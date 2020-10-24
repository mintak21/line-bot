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

resource google_dns_managed_zone public_dns_zone {
  name        = "${var.service_name}-zone"
  dns_name    = var.service_domain
  description = "Public DNS Zone for ${var.service_name}"
  visibility  = "public"
}

resource google_dns_record_set dns_a_record {
  name         = google_dns_managed_zone.public_dns_zone.dns_name
  managed_zone = google_dns_managed_zone.public_dns_zone.name
  type         = "A"
  ttl          = 180

  rrdatas = [google_compute_global_address.application_static_ip_address.address]
}

resource google_compute_ssl_policy ssl_policy {
  name            = "${var.service_name}-ingress-ssl-policy"
  description     = "SSL Policy for ${var.service_name}"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

resource google_compute_security_policy security_policy {
  name = "${var.service_name}-security-policy"

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Deny Except Specific IP Address"
  }

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.ip_whitelists
      }
    }
    description = "White IP Address Lists"
  }
}

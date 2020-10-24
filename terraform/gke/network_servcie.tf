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

resource google_compute_managed_ssl_certificate ingress_cert {
  provider = google-beta

  name        = "${var.service_name}-managed-cert"
  description = "Google Managed Certificate For ${var.service_name}"
  type        = "MANAGED"

  managed {
    domains = [var.service_domain]
  }
}

resource google_compute_address nat_address {
  count  = 1
  name   = "nat-manual-ip-${count.index}"
  region = google_compute_subnetwork.subnetwork.region
}

resource google_compute_router router {
  name    = "router-for-${var.service_name}"
  region  = google_compute_subnetwork.subnetwork.region
  network = google_compute_network.network.id
}

resource google_compute_router_nat nat_manual {
  name   = "cloudnat-for-${var.service_name}"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.nat_address.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnetwork.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

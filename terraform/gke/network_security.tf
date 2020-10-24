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

resource google_compute_ssl_policy ssl_policy {
  name            = "${var.service_name}-ingress-ssl-policy"
  description     = "SSL Policy for ${var.service_name}"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

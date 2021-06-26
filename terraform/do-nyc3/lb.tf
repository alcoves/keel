resource "digitalocean_loadbalancer" "bken" {
  name                     = "bken"
  region                   = "nyc3"
  droplet_tag              = "app"
  enable_backend_keepalive = true
  redirect_http_to_https   = true

  forwarding_rule {
    entry_port       = 443
    entry_protocol   = "https"
    target_port      = 80
    target_protocol  = "http"
    tls_passthrough  = false
    certificate_name = "bken.io"
  }

  healthcheck {
    path     = "/"
    port     = 80
    protocol = "http"
  }
}
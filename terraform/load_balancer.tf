
resource "hcloud_load_balancer" "main" {
  name               = "main"
  load_balancer_type = "lb11"
  location           = "ash"
}

resource "hcloud_load_balancer_network" "main" {
  load_balancer_id = hcloud_load_balancer.main.id
  network_id       = hcloud_network.main.id
  ip               = "10.0.2.1"
}

resource "hcloud_load_balancer_target" "app_workers" {
  load_balancer_id = hcloud_load_balancer.main.id
  type             = "label_selector"
  label_selector   = "app_worker"
}

resource "hcloud_load_balancer_service" "http" {
  load_balancer_id = hcloud_load_balancer.main.id
  protocol         = "http"
  listen_port      = 80
  destination_port = 9999
  proxyprotocol    = false

  health_check {
    retries  = 3
    interval = 10
    timeout  = 10
    protocol = "http"
    port     = "9998"

    http {
      path         = "/health"
      status_codes = ["2??", "3??", ]
    }
  }
}

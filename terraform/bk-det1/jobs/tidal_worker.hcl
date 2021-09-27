job "tidal" {
  priority    = 100
  datacenters = ["dc1"]
  type        = "service"

  group "services" {
    count = 20

    update {
      max_parallel     = 6
      canary           = 6
      auto_revert      = true
      auto_promote     = true
      healthy_deadline = "5m"
      min_healthy_time = "30s"
    }

    network {
      port "bken_tidal_port" { to = 3200 }
    }

    task "tidal_api" {
      driver = "docker"

      template {
        data = <<EOH
DO_API_KEY="{{key "secrets/DO_API_KEY"}}"
        EOH
        
        env         = true
        destination = "secrets/container/.env"
      }

      template {
        env         = true
        destination = "secrets/tidal/.env"
        data        = "{{ key \"secrets/tidal/.env.prod\" }}"
      }

      config {
        force_pull = true
        ports      = ["bken_tidal_port"]
        image      = "registry.digitalocean.com/bken/tidal:364baa97c463f5e7998c0a33f1a3a231f47bfe82"

        auth {
          username = "${DO_API_KEY}"
          password = "${DO_API_KEY}"
        }
      }

      resources {
        memory = 4000
        cpu    = 10000
      }
    }
  }
}
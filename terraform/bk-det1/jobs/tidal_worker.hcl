job "tidal" {
  priority    = 10
  datacenters = ["dc1"]
  type        = "service"

  affinity {
    attribute = "${unique.hostname}"
    value     = "r630-1"
    weight    = 100
  }

  group "services" {
    count = 20

    update {
      max_parallel     = 6
      auto_revert      = true
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
        image      = "registry.digitalocean.com/bken/tidal:6df5b3adb385c401a6623de92e46e4329830cf88"

        auth {
          username = "${DO_API_KEY}"
          password = "${DO_API_KEY}"
        }
      }

      resources {
        memory = 7000
        cpu    = 10000
      }
    }
  }
}
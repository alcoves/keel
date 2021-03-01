job "api" {
  priority    = 100
  datacenters = ["dc1"]
  type        = "service"

  constraint {
    attribute = "${attr.cpu.arch}"
    operator  = "="
    value     = "amd64"
  }

  group "services" {
    update {
      max_parallel     = 1
      canary           = 1
      auto_revert      = true
      auto_promote     = true
      healthy_deadline = "5m"
      min_healthy_time = "30s"
    }

    network {
      port "tidal_port" { to = 4000 }
    }

    task "api" {
      driver = "docker"

      template {
        data = <<EOH
          DO_API_KEY = "{{key "secrets/DO_API_KEY"}}"
        EOH
        
        env         = true
        destination = ".env"
      }

      config {
        force_pull = true
        ports      = ["tidal_port"]
        image      = "registry.digitalocean.com/bken/tidal:latest"

        auth {
          username = "${DO_API_KEY}"
          password = "${DO_API_KEY}"
        }
      }

      service {
        name = "tidal"
        port = "tidal_port"
        tags = ["urlprefix-/"]

        connect {
          sidecar_service {}
        }

        check {
          path     = "/"
          timeout  = "2s"
          interval = "10s"
          type     = "tcp"
          name     = "tidal_port alive"
        }
      }

      resources {
        memory = 100
        cpu    = 100
      }
    }
  }
}
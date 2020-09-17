job "hello" {
  datacenters = ["dc1"]
  type = "system"

  group "hello" {
    task "apache" {
      driver = "docker"
      config {
        image = "httpd:latest"
        port_map {
          http = 80
        }
      }

      resources {
        cpu    = 20
        memory = 20
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "apache-webserver"
        tags = ["urlprefix-/"]
        port = "http"
        check {
          name     = "alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
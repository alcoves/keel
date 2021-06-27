job "fabio" {
  datacenters = ["nyc3"]
  type        = "system"

  constraint {
    operator  = "regexp"
    value     = "[/app/]"
    attribute = "${attr.unique.hostname}"
  }

  group "fabio" {
    network {
      port "lb" { static = 80 }
      port "ui" { static = 9998 }
    }

    task "fabio" {
      driver = "docker"
      config {
        network_mode = "host"
        image        = "fabiolb/fabio"
        args         = [
          "-registry.consul.token",
          "token",
          "-proxy.addr",
          ":80;proto=http"
        ]
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }
  }
}
job "fabio" {
  datacenters = ["dc1"]
  type        = "system"

  group "fabio" {
    network {
      port "lb" { static = 9999 }
      port "ui" { static = 9998 }
    }

    task "fabio" {
      driver = "docker"
      config {
        network_mode = "host"
        ports        = ["lb", "ui"]
        image        = "fabiolb/fabio"
      }

      resources {
        cpu    = 100
        memory = 100
      }
    }
  }
}
job "fabio" {
  datacenters = ["dc1"]
  type        = "system"

  group "fabio" {
    network {
      port "ui" { static = 9998 }
      port "lb" { static = 9999 }
    }

    task "fabio" {
      driver = "docker"
      config {
        network_mode = "host"
        image        = "fabiolb/fabio"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }
  }
}
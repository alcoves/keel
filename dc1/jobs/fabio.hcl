job "fabio" {
  datacenters = ["dc1"]
  type        = "system"

  group "fabio" {
    network {
      mbits = 20
      port "lb" {
        static = 9999
      }
      port "ui" {
        static = 9998
      }
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
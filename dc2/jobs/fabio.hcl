job "fabio" {
  datacenters = ["dc1"]
  type        = "system"

  group "fabio" {
    task "fabio" {
      driver = "docker"
      config {
        network_mode = "host"
        image        = "fabiolb/fabio"
      }

      resources {
        cpu    = 50
        memory = 50
        network {
          mbits = 20
          port "lb" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
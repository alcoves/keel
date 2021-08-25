job "archive" {
  datacenters = ["dc1"]
  type        = "service"

  constraint {
    operator  = "="
    value     = "amd64"
    attribute = "${attr.cpu.arch}"
  }

  group "archive" {
    count = 0

    update {
      max_parallel = 5
    }

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    ephemeral_disk {
      size = 2000
    }

    network {
      port "warrior_ui" {
        to = 8001
      }
    }

    task "warrior" {
      driver = "docker"

      env {
        CONCURRENT_ITEMS = 6
        SELECTED_PROJECT = "auto"
        DOWNLOADER       = "rustyguts"
      }

      config {
        image = "atdr.meo.ws/archiveteam/warrior-dockerfile"
        ports = ["warrior_ui"]
      }

      resources {
        cpu    = 1000
        memory = 600
      }
    }
  }
}

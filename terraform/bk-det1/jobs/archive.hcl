job "archive" {
  datacenters = ["dc1"]
  type        = "service"

  constraint {
    operator  = "="
    value     = "amd64"
    attribute = "${attr.cpu.arch}"
  }

  group "archive" {
    count = 40

    update {
      max_parallel     = 4
      // auto_revert      = true
      // auto_promote     = true
      // healthy_deadline = "5m"
      // min_healthy_time = "30s"
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
        SELECTED_PROJECT = "youtube"
        DOWNLOADER       = "rustyguts"
      }

      config {
        image = "atdr.meo.ws/archiveteam/warrior-dockerfile"
        ports = ["warrior_ui"]
      }

      resources {
        cpu    = 500
        memory = 300
      }
    }
  }
}

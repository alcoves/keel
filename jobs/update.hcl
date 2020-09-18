job "update" {
  priority    = 100
  datacenters = ["dc1"]
  type        = "system"

  group "update" {
    task "update" {
      driver = "raw_exec"

      config {
        command = "/usr/bin/bash"
        args    = [
          "/root/keel/scripts/update.sh",
        ]
      }
    }
  }
}
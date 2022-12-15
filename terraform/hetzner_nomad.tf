# resource "nomad_job" "fabio" {
#   jobspec = file("${path.module}/../config/jobs/lb.hcl")
# }

# resource "nomad_job" "ping" {
#   jobspec = file("${path.module}/../config/jobs/ping.hcl")
# }

# resource "nomad_job" "fabio" {
#       - allocation_ids          = [
#           - "79104829-95ae-1450-26bd-a0ca5ffac1e9",
#           - "4e0302f4-bc9f-2794-fd8d-d845f3699b25",
#         ] -> null
#       - datacenters             = [
#           - "dc1",
#         ] -> null
#       - deregister_on_destroy   = true -> null
#       - deregister_on_id_change = true -> null
#       - detach                  = true -> null
#       - id                      = "fabio" -> null
#       - jobspec                 = <<-EOT
#             job "fabio" {
#               datacenters = ["dc1"]
#               type        = "system"

#               group "fabio" {
#                 network {
#                   port "lb" { static = 9999 }
#                   port "ui" { static = 9998 }
#                 }

#                 task "fabio" {
#                   driver = "docker"
#                   config {
#                     network_mode = "host"
#                     ports        = ["lb", "ui"]
#                     image        = "fabiolb/fabio"
#                   }

#                   resources {
#                     cpu    = 100
#                     memory = 100
#                   }
#                 }
#               }
#             }
#         EOT -> null
#       - modify_index            = "30" -> null
#       - name                    = "fabio" -> null
#       - namespace               = "default" -> null
#       - region                  = "global" -> null
#       - task_groups             = [
#           - {
#               - count   = 1
#               - meta    = {}
#               - name    = "fabio"
#               - task    = [
#                   - {
#                       - driver        = "docker"
#                       - meta          = {}
#                       - name          = "fabio"
#                       - volume_mounts = []
#                     },
#                 ]
#               - volumes = []
#             },
#         ] -> null
#       - type                    = "system" -> null
#     }

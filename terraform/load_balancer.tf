
# resource "hcloud_load_balancer" "load_balancer" {
#   name               = "my-load-balancer"
#   load_balancer_type = "lb11"
#   location           = "nbg1"

#   target {
#     type      = "server"
#     server_id = hcloud_server.myserver.id
#   }
# }

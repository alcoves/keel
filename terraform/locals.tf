locals {
  nyc1_ip_range          = "10.136.0.0/16"
  nyc3_ip_range          = "10.132.0.0/16"
  heztner_network_range  = "10.0.0.0/16"
  heztner_subnet_1_range = "10.0.1.0/24"
  heztner_subnet_2_range = "10.0.2.0/24"
  heztner_subnet_3_range = "10.0.3.0/24"

  server_counts = {
    leaders         = 2
    app_workers     = 2
    compute_workers = 2
  }
}

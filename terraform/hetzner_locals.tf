locals {
  heztner_network_range  = "10.0.0.0/16"
  heztner_subnet_1_range = "10.0.1.0/24"
  heztner_subnet_2_range = "10.0.2.0/24"
  heztner_subnet_3_range = "10.0.3.0/24"

  server_counts = {
    leaders                 = 1
    app_workers             = 1
    compute_workers         = 1
    compute_workers_cpx51   = 0
    compute_workers_cpx51_b = 0
    compute_workers_cpx51_c = 0
    compute_workers_cpx51_d = 0
    compute_workers_cpx51_e = 0
  }
}

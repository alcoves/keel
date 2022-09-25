resource "nomad_job" "fabio" {
  jobspec = file("${path.module}/../config/jobs/lb.hcl")
}

resource "nomad_job" "ping" {
  jobspec = file("${path.module}/../config/jobs/ping.hcl")
}

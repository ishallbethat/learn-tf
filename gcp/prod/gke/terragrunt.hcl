locals {
  # Automatically load account-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Extract the variables we need for easy access
  project_id = local.project_vars.locals.project_id
  region   = local.project_vars.locals.region
  primary_zone   = local.project_vars.locals.primary_zone
  credential_service_account = local.project_vars.locals.credential_service_account
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  backend "gcs" {}
}
EOF
}
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  source  = "git@github.com:terraform-google-modules/terraform-google-kubernetes-engine.git"
}


include {
  path = find_in_parent_folders()
}


inputs = {
  project_id                 = "${local.project_id}"
  name                       = "learn-gke"
  region                     = "${local.region}"
  regional                   = false
  zones                      = ["${local.region}-a", "${local.region}-b", "${local.region}-c"]
  network                    = "learn-vpc"
  subnetwork                 = "learn-vpc"
  ip_range_pods              = "learn-vpc-pod-ip-range"
  ip_range_services          = "learn-vpc-service-ip-range"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = false
  release_channel            = "STABLE"
  remove_default_node_pool   = true
  kubernetes_version         = "1.18.17-gke.1200"


  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "n1-standard-1"
      node_locations            = "${local.region}-a,${local.region}-b,${local.region}-c"
      min_count                 = 1
      max_count                 = 6
      local_ssd_count           = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "${local.credential_service_account}"
      preemptible               = true
      initial_node_count        = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

locals {
  # Automatically load account-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Extract the variables we need for easy access
  project_id = local.project_vars.locals.project_id
  region   = local.project_vars.locals.region
  primary_zone   = local.project_vars.locals.primary_zone
  tf_bucket = local.project_vars.locals.tf_bucket
  credentials = local.project_vars.locals.credentials
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  project     = "${local.project_id}"
  region      =  "${local.region}"
  credentials =  "${local.credentials}"
}
EOF
}
remote_state {
  backend = "gcs"
  config = {
    prefix      = "${path_relative_to_include()}"
    credentials = "${local.credentials}"
    location      = "${local.region}"
    project     = "${local.project_id}"
    bucket      = "${local.tf_bucket}"
  }
}
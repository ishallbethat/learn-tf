locals {
  # Automatically load account-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Extract the variables we need for easy access
  project_name = local.project_vars.locals.project_name
  region   = local.project_vars.locals.region
  primary_zone   = local.project_vars.locals.primary_zone
}

remote_state {
  backend = "gcs"
  config = {
    prefix      = "${path_relative_to_include()}"
    credentials = "/home/gabriel/.ssh/gabrielhome-admin.json"
    region      = "${local.region}"
    project     = "${local.project_name}"
  }
}
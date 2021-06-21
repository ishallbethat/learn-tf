locals {
  # Automatically load account-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Extract the variables we need for easy access
  project_name = local.project_vars.locals.project_name
  region   = local.project_vars.locals.region
  primary_zone   = local.project_vars.locals.primary_zone
}


terraform {
  # The configuration for this backend will be filled in by Terragrunt
  source  = "../../../modules/gcp/gcs_bucket"
}


include {
  path = find_in_parent_folders()
}


inputs = {
  bucket_name="tf-canbedelete"
  location=local.region
}
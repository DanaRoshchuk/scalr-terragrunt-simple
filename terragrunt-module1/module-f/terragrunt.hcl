terraform {
  source = "../../base/main.tf"
}

include "root" {
  path = find_in_parent_folders("../base/backend.hcl")
}


inputs = {
  module_name = "module-f"
  resource_id = "resource-003"
  unit_secret = "secret-terragrunt-module1-module-f"
}

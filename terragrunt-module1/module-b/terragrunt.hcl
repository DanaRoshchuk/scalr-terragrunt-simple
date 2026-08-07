include "root" {
    path = find_in_parent_folders("base/backend.hcl")
}

terraform {
  source = "../../base/main.tf"
}

inputs = {
  module_name = "module-b"
  resource_id = "resource-002"
  unit_secret = "secret-terragrunt-module1-module-b"
}

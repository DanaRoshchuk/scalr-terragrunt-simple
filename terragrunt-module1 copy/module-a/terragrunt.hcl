include {
  path = find_in_parent_folders("../base/backend.hcl")
}

terraform {
  source = "../../base/main.tf"
}



inputs = {
  module_name = "module-a"
  resource_id = "resource-001"
}


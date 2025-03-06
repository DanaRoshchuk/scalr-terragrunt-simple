terraform {
  source = "../../base/main.tf"
}

include {
  path = find_in_parent_folders("../base/backend.hcl")
}



inputs = {
  module_name = "module-e"
  resource_id = "resource-003"
}

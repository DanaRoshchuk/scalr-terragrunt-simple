terraform {
  source = "../../base/main.tf"
}

include {
  path = find_in_parent_folders("../base/backend.hcl")
}


inputs = {
  module_name = "module-fffffffff"
  resource_id = "resource-003"
}

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


/*dependency "module-a" {
  config_path = "../../terragrunt-module1/module-a"
  mock_outputs = {
    module_name = "module-b"
    resource_id = "resource-002"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  module_name = dependency.module-a.outputs.module_name
  resource_id = dependency.module-a.outputs.resource_id
}*/

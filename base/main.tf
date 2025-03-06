
/*terraform {
    required_providers {
        scalr = {
            source = "registry.scalr.io/scalr/scalr"
            version= "2.1.1"
        }
    }
}
data "scalr_current_account" "data_acc" {}

data "scalr_environment" "data_env" {
#account_id = data.scalr_current_account.data_acc
  id = "env-v0on0fdgvjdf8ljta"  # optional, can only use id or name for the environment filter, if both are used there will be a conflict.
}


resource "scalr_variable" "new_varAll" {
  count = 1
  key            = "varall" #-${count.index}
  value          = "TRACE"
  category       = "terraform"
  environment_id = data.scalr_environment.data_env.id
}

resource "scalr_variable" "var_newAll" {
  key            = "keyall"
  value          = "1"
  category       = "shell"
  environment_id = data.scalr_environment.data_env.id
}*/




variable "module_name" {
  description = "The name of the module"
  default = "test_module_name"
  type        = string
}

variable "resource_id" {
  description = "A unique identifier for the resource"
  type        = string
  default = "test_resource_id"
}

variable "dependency_info" {
  description = "Information from dependent modules"
  type        = map(string)
  nullable    = true
  default     = null
}

resource "null_resource" "random_sleep_example_shuf" {
  triggers = {
    force_recreation = timestamp()
  }
  provisioner "local-exec" {
    command = "sleep $(shuf -i 1-20 -n 1)"
  }
}

#resource "null_resource" "show_env" {
#  provisioner "local-exec" {
#    command = "env"
#  }
#}


resource "null_resource" "placeholder" {
  count = 1
  triggers = {
    module_name     = var.module_name
    resource_id     = var.resource_id
    dependency_data = jsonencode(var.dependency_info)
  }

  provisioner "local-exec" {
    command = "echo ${var.module_name} resource created with dependency info: ${jsonencode(var.dependency_info)}"
  }
}

resource "random_string" "example" {
  count = 1
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric  = true
}

output "resource_output" {
  value = {
    module_name = var.module_name
    resource_id = var.resource_id
  }
}

output "module_name" {
  description = "The name of the module"
  value = random_string.example[0].result
}

output "resource_id" {
  description = "A unique identifier for the resource"
  value = random_string.example[0].result
}

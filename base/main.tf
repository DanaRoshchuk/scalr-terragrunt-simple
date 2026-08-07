
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
variable "sensitive_var_module-w" {
  description = "A unique identifier for the resource"
  type        = string
  sensitive = true
  default = "test_sensitive_var"
}

variable "dependency_info" {
  description = "Information from dependent modules"
  type        = map(string)
  nullable    = true
  default     = null
}

/*resource "null_resource" "random_sleep_example_shuf" {
  triggers = {
    force_recreation = timestamp()
  }
  provisioner "local-exec" {
    command = "sleep $(shuf -i 1-20 -n 1)"
  }
}*/

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
  count = 2
  length  = 15
  special = false
  upper   = true
  lower   = false
  numeric  = false
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

# ---------------------------------------------------------------------------------------
# Sensitive values for plan-sanitizer testing (SCALRCORE-37162).
#
# Everything below is derived from var.module_name / var.unit_secret, so each Terragrunt unit
# produces its own distinct masked values and units can be told apart in the sanitized output.
#
# Values must be known at plan time to be visible as masked in Resource changes view. That rules
# out computed attributes such as random_password.result, which are null in the plan and so have
# nothing to mask. terraform_data with sensitive() keeps the values known. Requires Terraform 1.4+.
# ---------------------------------------------------------------------------------------

variable "unit_secret" {
  description = "Sensitive, set per unit so masked values differ between units."
  type        = string
  sensitive   = true
  default     = "unit-secret-default-updated"
}

# Sensitive resource attributes produce after_sensitive marks, which is what makes masked
# values show up in the per-unit Resource changes view.
resource "terraform_data" "secrets" {
  input = {
    public = "visible-${var.module_name}"
    secret = sensitive("resource-secret-${var.module_name}")
    nested = {
      plain = "visible-nested-${var.module_name}"
      deep  = { token = sensitive(var.unit_secret) }
    }
  }
}

output "sensitive_output" {
  description = "Must arrive masked in the per-unit sanitized plan."
  value       = "output-secret-${var.module_name}"
  sensitive   = true
}

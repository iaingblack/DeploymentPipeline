terraform {
  required_providers {
    octopusdeploy = {
      source = "OctopusDeployLabs/octopusdeploy"
      version = "0.7.40"
    }
  }
}

variable "octopus_api_key" {
  description = "Octopus API Key"
  type        = string
}

provider "octopusdeploy" {
  address = "https://rootisgod.octopus.app"
  api_key  = var.octopus_api_key
}

resource "octopusdeploy_project_group" "DeploymentPipelineProjectGroup" {
  name        = "Deployment Pipeline Group"
  description = "My Deployment Pipeline Project Group2"
}

resource "octopusdeploy_lifecycle" "DeploymentPipelineLifecycle" {
  name        = "DeploymentPipelineLifecycle"
  description = "DeploymentPipelineLifecycle description"
  release_retention_policy {
    quantity_to_keep = 30
    unit             = "Days"
  }

  depends_on = [octopusdeploy_project_group.DeploymentPipelineProjectGroup]
}

resource "octopusdeploy_project" "DeploymentPipelineProject" {
  name             = "DeploymentPipelineProject"
  description      = "DeploymentPipelineProject project2"
  lifecycle_id     = octopusdeploy_lifecycle.DeploymentPipelineLifecycle.id
  project_group_id = octopusdeploy_project_group.DeploymentPipelineProjectGroup.id

  depends_on = [octopusdeploy_project_group.DeploymentPipelineProjectGroup]
}

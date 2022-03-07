terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Authenticate to Kubernetes running locally in Docker Desktop
# using your local kubeconfig file and docker-desktop config
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

# Deploy a simple web app into the EKS cluster
module "simple_webapp" {
  source = "../../modules/services/k8s-app"

  name           = "simple-webapp"
  image          = "training/webapp"
  replicas       = 2
  container_port = 5000

  environment_variables = {
    PROVIDER = "Terraform"
  }
}

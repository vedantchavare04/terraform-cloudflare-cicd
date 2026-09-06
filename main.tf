terraform {

  cloud {
    organization = "vedant-devops"

    workspaces {
      name = "terraform-cloudflare-cicd"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~>5"
    }
  }
}

provider "cloudflare" {}

resource "cloudflare_worker" "hello_worker" {
  account_id = var.cloudflare_account_id
  name       = "terraform-hello-worker"

  subdomain = {
    enabled = true
  }
}

resource "cloudflare_worker_version" "hello_worker_version" {
  account_id = var.cloudflare_account_id
  worker_id  = cloudflare_worker.hello_worker.id

  main_module = "index.js"

  modules = [{
    name         = "index.js"
    content_file = "${path.module}/worker/index.js"
    content_type = "application/javascript+module"
  }]
}

resource "cloudflare_workers_deployment" "hello_worker_deployment" {
  account_id  = var.cloudflare_account_id
  script_name = cloudflare_worker.hello_worker.name

  strategy = "percentage"

  versions = [{
    version_id = cloudflare_worker_version.hello_worker_version.id
    percentage = 100
  }]
}
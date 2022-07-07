terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_ssh_key" "mbpsporka" {
  name = "mbpsporka"
}

variable "pvt_key" {}
variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}


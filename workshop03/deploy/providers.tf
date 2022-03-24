terraform {
    required_version = ">1.1.0"
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "2.18.0"
        }
        local = {
            source = "hashicorp/local"
            version = "2.2.2"
        }
    }
}

provider "digitalocean" {
    token = var.DO_TOKEN
}

provider "local" { }
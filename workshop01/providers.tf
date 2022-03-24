terraform {
    required_version = ">1.1.0"
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "2.16.0"
        }
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

provider "docker" {
    # Configuration options
    host = "unix:///var/run/docker.sock"
}

provider "digitalocean" {
    token = var.DO_TOKEN
}
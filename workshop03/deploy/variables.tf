variable DO_TOKEN {
    description = "Access token"
    type = string
    sensitive = true
}

variable private_key {
    type = string
    sensitive = true
}

variable droplet_size {
    type = string
    default = "s-1vcpu-1gb"
}

variable droplet_region {
    type = string
    default = "sgp1"
}

variable code_server_password {
    type = string
    sensitive = true
}

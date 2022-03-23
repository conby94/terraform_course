data digitalocean_ssh_key terraform-course-key {
    # resource name on digitalocean
    name = "terraform-course"
}

// Provision a droplet
resource digitalocean_droplet code-server {
    name = "workshop02"
    image = "ubuntu-20-04-x64"
    region = "sgp1"
    size = "s-1vcpu-2gb"
    ssh_keys = [ data.digitalocean_ssh_key.terraform-course-key.id ]

    connection {
        type = "ssh"
        user = "root"
        host = self.ipv4_address
        private_key = file(var.private_key)
    }
}

// Step 2 - Generate inventory.yaml
resource local_file inventory_yaml {
    filename = "inventory.yaml"
    content = templatefile("inventory.tpl", {
        code_server = digitalocean_droplet.code-server.name
        droplet_ip = digitalocean_droplet.code-server.ipv4_address
        private_key = var.private_key
    })
    file_permission = "0644"
}

resource local_file root_at_ip {
    filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
    content = ""
    file_permission = "0644"
}


output droplet_ip {
    value = digitalocean_droplet.code-server.ipv4_address
}

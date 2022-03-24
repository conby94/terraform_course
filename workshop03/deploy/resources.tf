data digitalocean_ssh_key terraform-course-key {
    # resource name on digitalocean
    name = "terraform-course"
}

data digitalocean_image mydroplet {
    name = "cowsGoesMoo"
}

// Provision a droplet
resource digitalocean_droplet code-server {
    name = "workshop03-code-server"
    image = data.digitalocean_image.mydroplet.id
    size = var.droplet_size
    region = var.droplet_region
    ssh_keys = [ data.digitalocean_ssh_key.terraform-course-key.id]
}

// Step 2 - Generate inventory.yaml
resource local_file inventory_yaml {
    filename = "inventory.yaml"
    content = templatefile("inventory.tpl", {
        code_server = digitalocean_droplet.code-server.name
        droplet_ip = digitalocean_droplet.code-server.ipv4_address
        private_key = var.private_key
        code_server_password = var.code_server_password
        code_server_domain = "code-${digitalocean_droplet.code-server.ipv4_address}.nip.io"
    })
    file_permission = "0644"

    provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yaml playbook.yaml"
    }
}

resource local_file root_at_ip {
    filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
    content = ""
    file_permission = "0644"
}

output droplet_ip {
    value = digitalocean_droplet.code-server.ipv4_address
}

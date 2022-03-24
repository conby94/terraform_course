data "digitalocean_ssh_key" "terraform-course" {
    # resource name on digitalocean
    name = "terraform-course"
}

// Step 2 - Generate nginx.conf
resource local_file nginx_conf {
    filename = "nginx.conf"
    content = templatefile("nginx.conf.tftpl", {
        docker_host_ip = var.docker_host_ip
        container_ports = [ for p in docker_container.dov-bear-container[*].ports[*]: elements(p, 0).external]
    })
    file_permission = "0644"
}

resource local_file root_at_ip {
    filename = "root@${digitalocean.droplet.nginx-droplet.ipv4_address}"
    content = ""
    file_permission = "0644"
}

// Step 3 provision droplet
resource digitalocean_droplet nginx-droplet {
    name = "nginx-droplet"  # can param this 
    image = "ubuntu-20-10-x64"
    region = "sgp1"
    size = "s-1vcpu-2gb"
    ssh_keys = [data.digitalocean_ssh_key.terraform-course.id]

    connection = {
        type = "ssh"
        user = "root"
        private_key = file("../.ssh/terraform_course")
        host = self.ipv4_address
    }

    provisioner remote-exec {
        inline = ["apt update", "apt install -y nginx"]
    }

    provisioner file {
        source = "./nginx.conf"
        destination = "/etc/nginx/nginx.conf"
    }

    provisioner remote-exec {
        inline = ["systemctl restart nginx"]
    }
}

resource docker_image dov-bear {
    name = "chukmunnlee/dov-bear:v2"
}

resource docker_container dov-bear-container {
    count = 3
    name  = "dov-${count.index}"
    image = docker_image.dov-bear.latest
    ports {
        internal = 3000
    }
    env = [
        "INSTANCE_NAME=moooooo-x${count.index}"
    ]
}


output dov_ports {
    # value = docker_container.dov-bear-container[*].ports[*].external
    value = join(",", [for p in docker_container.dov-bear-container[*].ports[*]: element(p,0).external])
}

output do_fingerprint {
    value = data.digitalocean_ssh_key.terraform-course.fingerprint
}

output nginx_ip {
    value = digitalocean_droplet.nginx.ipv4_address
}
all:
    hosts:
        ${code_server}:
            ansible_host: ${droplet_ip}
            ansible_user: root
            ansible_ssh_private_key_file: ${private_key}

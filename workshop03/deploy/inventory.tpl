all:
    hosts:
        ${code_server}:
            ansible_host: ${droplet_ip}
            ansible_user: root
            ansible_ssh_private_key_file: ${private_key}
            code_server_password: ${code_server_password}
            code_server_domain: ${code_server_domain}

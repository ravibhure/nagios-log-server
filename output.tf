output "nagurl" {
  value = "${digitalocean_droplet.nagios_log_server.ipv4_address}"
}


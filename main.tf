variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "ssh_keys" {}

# Specify the provider and access details

provider "digitalocean" {
  token = "${var.do_token}"
}

# NAGIOS_LOG_SERVER
resource "digitalocean_droplet" "nagios_log_server" {
  image = "${var.do_image_rhel}"
  name = "nagios-log-server"
  region = "${var.do_region}"
  size = "${var.do_size}"
  private_networking = true
  #count = 1
  ssh_keys = [
    "${var.ssh_keys}"
  ]

  connection {
    user = "${var.conn_user}"
    key_file = "${var.pvt_key}"
    type = "ssh"
    timeout = "2m"
  }
  provisioner "file" {
      source = "install_server.sh"
      destination = "/tmp/install_server.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/install_server.sh",
        "sudo bash /tmp/install_server.sh"
    ]
  }

}

# TOMCAT SERVER
resource "digitalocean_droplet" "tomcat" {
  image = "${var.do_image}"
  name = "tomcat${count.index}"
  region = "${var.do_region}"
  size = "${var.do_size}"
  private_networking = true
  count = 1
  ssh_keys = [
    "${var.ssh_keys}"
  ]

  connection {
    user = "${var.conn_user}"
    key_file = "${var.pvt_key}"
    type = "ssh"
    timeout = "2m"
  }

  provisioner "file" {
      source = "install_client.sh"
      destination = "/tmp/install_client.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/nstall_client.sh",
        "sudo bash install_client.sh ${digitalocean_droplet.nagios_log_server.ipv4_address}"
    ]

}

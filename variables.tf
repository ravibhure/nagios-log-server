variable "do_token" {}

variable "do_region" {
  description = "DO region to launch servers."
  default = "nyc2"
}

# curl -X GET "https://api.digitalocean.com/v2/images" -H "Authorization: Bearer ad8558eb4a043882c441dab29487dd006a8d0387933231216e98904cceffa553" | jq .
variable "do_image" {
  default = "ubuntu-14-04-x64"
}

variable "do_image_rhel" {
  default = "centos-6-5-x64"
}

variable "do_image_rhel7" {
  default = "centos-7-0-x64"
}

variable "do_size" {
  #default = "512mb"
  default = "2gb"
}

variable "conn_user" {
  default = "root"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = "ravi"
}

variable "ssh_fingerprint" {
  default = "e0:a4:1b:2b:b2:c6:3e:3d:f6:18:d6:0a:6b:ca:fc:08"
}

variable "ssh_keys" {
  default = "1857111"
}

variable "pub_key" {
  description = "Path to the public portion of the SSH key specified."
  default = "~/.ssh/id_rsa_do.pub"
}

variable "pvt_key" {
  description = "Path to the private portion of the SSH key specified."
  default = "~/.ssh/id_rsa_do"
}


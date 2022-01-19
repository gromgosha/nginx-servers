variable "devs" {
  type = list
  default = ["app-gromgosha", "app2-gromgosha"]
}

variable "rebrain_do_token" {
  type = string
  description = "Access token to DigitalOcean"
}

variable "local_ssh" {
  type = string
  description = "SSH public key for access from local machine"
}

variable "aws_access_key" {
  type = string
  description = "Access key to AWS"
}

variable "aws_secret_key" {
  type = string
  description = "Secret key to AWS"
}

variable "droplet_image" {
  default = "ubuntu-20-04-x64"
  type = string
  description = "The image of the Droplet. Get from DO documentation"
}

variable "droplet_region" {
  default = "ams3"
  type = string
  description = "The region of the Droplet. Get from DO documentation"
}

variable "droplet_name" {
  default = "test-vps"
  type = string
  description = "The name of the Droplet. Custom value"
}

variable "droplet_size" {
  default = "s-1vcpu-1gb"
  type = string
  description = "The size of instance. Get from DO documentation"
}

variable "droplet_tags" {
  default = ["module:devops", "email:gromgosha_at_gmail_com"]
  type = list
  description = "Tags for droplet. Custom value"
}

variable "aws_region" {
  default = "eu-north-1"
  type = string
  description = "The region of the Droplet. Get from AWS documentation"
}

variable "aws_dns_zone" {
  default = "devops.rebrain.srwx.net"
  type = string
  description = "Domain zone on AWS route53 service"
}

variable "path_to_private_ssh_key" {
  default = "/home/grom/.ssh/id_rsa"
  type = string
  description = "Path to private key for using in provisioner"
}

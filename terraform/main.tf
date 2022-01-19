terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "1.22.2"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "digitalocean_ssh_key" "rebrain_ssh" {
  name = "REBRAIN.SSH.PUB.KEY"
}

provider "digitalocean" {
    token = var.rebrain_do_token
}

resource "digitalocean_ssh_key" "local_key" {
  name = "Local ssh key"
  public_key = var.local_ssh
}

resource "random_password" "droplet_password" {
  length = 6
  special = true
  count = length(var.devs)
}

resource "digitalocean_droplet" "vps" {
  image   = var.droplet_image
  region = var.droplet_region
  name = var.droplet_name
  size = var.droplet_size
  ssh_keys = [ digitalocean_ssh_key.local_key.fingerprint, data.digitalocean_ssh_key.rebrain_ssh.fingerprint ]
  tags = var.droplet_tags
  count = length(var.devs)

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "root"
      private_key = file(var.path_to_private_ssh_key)
      host = self.ipv4_address
      timeout = "30s"
      }
      inline = [ "echo 'root:${random_password.droplet_password[count.index].result}' | chpasswd && echo 'Password changed successfully!'" ]
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

data "aws_route53_zone" "selected" {
  name = "devops.rebrain.srwx.net"
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  count = length(var.devs)
  name =  "${var.devs[count.index]}.${data.aws_route53_zone.selected.name}"
  ttl = 100
  type = "A"
  records = [ digitalocean_droplet.vps[count.index].ipv4_address ]
}

resource "template_file" "output" {
  template = file("${path.module}/data.tmpl")
  count = length(var.devs)
  vars = {
    IP = digitalocean_droplet.vps[count.index].ipv4_address
    NAME = aws_route53_record.domain[count.index].name
    COUNT = count.index + 1
    PASSWORD = random_password.droplet_password[count.index].result
  }
}

resource "local_file" "list_of_vps" {
  content = join("\n", [ for i in range(length(var.devs)): template_file.output[i].rendered ])
  filename = "${path.module}/list_of_vps.txt"
}

resource "local_file" "ansible_inventory" {
  content = "[servers]\n${join("\n",
    formatlist("%s ansible_host=%s",
    [ for i in range(length(var.devs)): aws_route53_record.domain[i].name ],
    [ for i in range(length(var.devs)): digitalocean_droplet.vps[i].ipv4_address ]))}"
  filename = "../ansible_inventory.yml"
}
